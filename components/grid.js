
   /*
   * Funções para Grid Dinâmica
   */
   var clrHilight = '#FFCC99';
   var strBlankImage = '<tt>&nbsp;&nbsp;</tt>';
   var strUpImage = '<tt>^&nbsp;</tt>';
   var strDownImage = '<tt>v&nbsp;</tt>';
   var objLastClick = -1;
   var txtOld = "";
   var intTotalWidth = 0;
   var blnMouseOver = false;  
   var objDivToMove = null;
   var intColCount = 0;
   var objRowSelected = null;
   var element = null;

   function init (tableName)
   {
      window.onerror = handleError;

      isIE = (navigator.appVersion.indexOf ("MSIE") != -1);
      isNS4 = (document.layers) ? true : false;
      isNS6 = (!document.layers) && (navigator.userAgent.indexOf ('Netscape')!=-1);

      if ((isNS4) && (!isNS6)) alert ("Currently only supports NN 6 and above");

      if (document.getElementById)
         element = document.getElementById (tableName);
      else  //TODO: Need to test this piece of code still. Happens only in NN4 so far 
         eval (element = "document." + tableName);

      if (element == null)
         return alert ("Error: Not able to get table element ");

      if (element.tagName != 'TABLE')
         return alert ("Error: Not able to control element " + element.tagName);

      initNNFunctions ();

      element.attachEvent ('onmouseover', selectRow);
      element.attachEvent ('onclick', onClickCell);

      //Need this fix for IE only .. so element.focus is stubbed in NN
      element.focus ();
   
      initSortImages ();
      initDiv ();
      initAbout ();
   }

   function removeTextNodes (t)
   {
      for (var i = 0; t.childNodes[i] ; i++)
      {
         if (!t.childNodes[i].tagName)
         {
             t.childNodes[i].parentNode.removeChild (t.childNodes[i]);
         }
         else
         {
            for (var j = 0; t.childNodes[i].childNodes[j] ; j++)
            {
               if (!t.childNodes[i].childNodes[j].tagName) 
                  t.childNodes[i].childNodes[j].parentNode.removeChild (t.childNodes[i].childNodes[j]);
            }
         }
      }

   }

   function initSortImages ()
   {
      if (!element.tHead) return;
      removeTextNodes (element.tHead);
      var theadrow = element.tHead.childNodes[0]; //Assume just one Head row

      //theadrow.style.cursor = "pointer";

      removeTextNodes (theadrow.parentNode);
      intColCount = theadrow.childNodes.length;

      for (var i = 0; i < intColCount; i++) 
      {
         objImg = document.createElement ("SPAN");
         objImg.innerHTML = strBlankImage;

         clickCell = theadrow.childNodes[i];
         clickCell.selectIndex = i;
         clickCell.insertAdjacentElement ("afterBegin", objImg);
         clickCell.style.width = clickCell.width;
      }
   }
      
   function initDiv ()
   {
      var objLast = element, objDiv;
      removeTextNodes (element.tBodies[0]);

      for (var i = 1; i <= intColCount; i++)
      {  
         objDiv = document.createElement ("DIV");
         objDiv.setAttribute ('id', "DragMark" + (i - 1));
         objDiv.setAttribute ('name',  i);      //Used to track the TDs that have to be moved
         objDiv.style.position = "absolute";
         objDiv.style.top = 0; 

         var objTD = element.tHead.childNodes[0].childNodes[i - 1];
         if (!objTD || objTD.tagName != "TD") return;

         var intColWidth = (getRealPos (objTD) - 0) + (objTD.width - 0);

         objDiv.style.left = intColWidth - 3 ;
         objDiv.style.width = 6 + parseInt(element.border);
         objDiv.style.height = (element.tBodies[0].childNodes.length + 1) * objTD.offsetHeight;

         if (navigator.appVersion.indexOf ("MSIE 6.0") != -1)
            objDiv.style.cursor = "col-resize";
         else
            objDiv.style.cursor = "crosshair";

         objDiv.attachEvent ('onmouseover', flagTrue);
         objDiv.attachEvent ('onmousedown', captureMouse);
         objDiv.attachEvent ('onmousemove', resizeColoumn);
         objDiv.attachEvent ('onmouseup', releaseMouse);
         objDiv.attachEvent ('onmouseout', flagFalse);

         objLast.insertAdjacentElement ("afterEnd", objDiv);
         objLast = objDiv;
      }
   }

   function flagTrue ()
   {
      blnMouseOver = true;
   }

   function captureMouse ()
   {
      if (blnMouseOver)
      {
         objDivToMove = window.event.srcElement;
         objDivToMove.setCapture ();
      }
   }

   function resizeColoumn ()
   {
      //If mouse button is down, objDivToMove will be valid... we can move/resize
      if (!objDivToMove) return;

      var intTDNum = objDivToMove.name - 1;
      var thead = element.tHead;

      if (!thead) return;

      var objTD = thead.childNodes[0].childNodes[intTDNum];

      if (!objTD || objTD.tagName != "TD") return;

      var intCurWidth = objTD.offsetWidth;
      var newX = window.event.clientX;
      //var newX = window.event.x;
      var intNewWidth = newX - objTD.offsetLeft;

      //TODO: who decided that the minimum col widhth is 50px?
      if (intNewWidth < 50) return;
      //Check to see if the table widht is more than the width of the window
      //Need that 20px buffer in IE to prevent scroll bars from appearing
      if (element.document.body.offsetWidth - 20 < element.offsetWidth - intCurWidth + intNewWidth) return;

      objTD.style.width = intNewWidth;

      var objDiv = objDivToMove;
      //Will be ± 1 depending on which side the mouse moved
      //will be used to move all the DIVs remaining on the right
      var intDivMove = newX - objDiv.offsetLeft;
      objDiv.style.left = newX;

      //Move all the remaining DIVs on the right
      for (var i = 1; i < intColCount - intTDNum; i++)
      {           
         objDiv = objDiv.nextSibling;
         objDiv.style.left = objDiv.offsetLeft + intDivMove ;
      }
   }

   /*\
   |*| This function will be fired onmouseup
   |*| Release all the mouse events of the DIV
   \*/
   function releaseMouse ()
   {
      objDivToMove.releaseCapture ();
      objDivToMove = null;
   }

   function flagFalse ()
   {
      blnMouseOver = false;
   }

   function initAbout ()
   {
      objDiv = window.document.createElement ("DIV");
      objDiv.id = "About";
      objDiv.style.position = "absolute";
      objDiv.style.top = 0; 
      objDiv.style.left = 0 ;
      objDiv.align = "center";
      //element.document.body.offsetWidth ==> width of the IFRAME in IE
      objDiv.style.width = element.document.body.offsetWidth;
      objDiv.style.height = element.document.body.offsetHeight;
      objDiv.style.backgroundColor = "#0000FF";
      objDiv.style.color = "#FFFF00";
      objDiv.style.visibility = "hidden";
      objDiv.insertAdjacentText ("afterBegin", "DHTML Grid ver 0.92\n\n" + "");

      var objInput = document.createElement ("INPUT");
      objInput.id = "cmdAbout";
      objInput.title = "Ok";
      objInput.value = "Ok";
      objInput.align = "center";
      objInput.valign = "middle";
      objInput.style.height = "20px";
      objInput.style.width = "102px";
      objInput.type = "button";
      objInput.attachEvent ("onclick", about);

      objDiv.insertAdjacentElement ("beforeEnd", objInput);
      element.insertAdjacentElement ("afterEnd", objDiv);
   }

   function selectRow ()
   {
      var srcElem = getEventRow ();

      if (srcElem.tagName != "TR") return;
      if (objRowSelected)
      {
         objRowSelected.style.backgroundColor = '';
         objRowSelected = null;
      }
      if (srcElem.rowIndex > 0)
      {
         //srcElem.style.cursor = 'pointer';
         srcElem.style.backgroundColor = clrHilight;
         objRowSelected = srcElem;
      }
      //element.focus ();
   }

   function onClickCell ()
   {
      var srcElem = getEventRow ();

      if (srcElem.tagName != "TR") return;
      if (srcElem.rowIndex == 0) sort ();
      //else onEdit ();    
   }

   function cleanup ()
   {
      element.detachEvent ('onmouseover', selectRow);
      element.detachEvent ('onclick', onClickCell);
      cleanupDiv ();
      cleanupAbout ();
   }

   function cleanupDiv ()
   {
      var objDiv;
      for (var i = 1; i <= intColCount; i++)
      {  
         objDiv = element.document.getElementById ("DragMark" + (i - 1));
         objDiv.detachEvent ('onmouseover', flagTrue);
         objDiv.detachEvent ('onmousedown', captureMouse);
         objDiv.detachEvent ('onmousemove', resizeColoumn);
         objDiv.detachEvent ('onmouseup', releaseMouse);
         objDiv.detachEvent ('onmouseout', flagFalse);
         objDiv.removeNode (true);
      }
   }

   function cleanupAbout ()
   {
      element.document.getElementById ("About").removeNode (true);
   }

   function insertionSort (t, iRowEnd, fReverse, iColumn)
   {
      var textRowInsert, textRowCurrent, eRowInsert, eRowWalk;
      removeTextNodes (t);
      for (var iRowInsert = 1 ; iRowInsert <= iRowEnd ; iRowInsert++)
      {
         if (iColumn)
         {
            if (typeof (t.childNodes[iRowInsert].childNodes[iColumn]) != "undefined")
               textRowInsert = t.childNodes[iRowInsert].childNodes[iColumn].innerText;
            else
               textRowInsert = "";
         }
         else
         {
            textRowInsert = t.childNodes[iRowInsert].innerText;
         }

         for (var iRowWalk = 0 ; iRowWalk < iRowInsert ; iRowWalk++)
         {
            if (iColumn)
            {
               if (typeof (t.childNodes[iRowWalk].childNodes[iColumn]) != "undefined")
                  textRowCurrent = t.childNodes[iRowWalk].childNodes[iColumn].innerText;
               else
                  textRowCurrent = "";
            }
            else
            {
               textRowCurrent = t.childNodes[iRowWalk].innerText;
            }
            if ((!fReverse && textRowInsert < textRowCurrent) || (fReverse && textRowInsert > textRowCurrent))
            {
               eRowInsert = t.childNodes[iRowInsert];
               eRowWalk = t.childNodes[iRowWalk];
               t.insertBefore (eRowInsert, eRowWalk);
               iRowWalk = iRowInsert; // done
            }
         }
      }
   }

   function sort ()
   {
      var srcElem = getEventCell ();
      if (srcElem.tagName != "TD") return;

      var thead = element.tHead; 
      // clear the sort images in the head
      var imgcol = thead.getElementsByTagName ("SPAN");
      for (var x = 0; x < imgcol.length; x++)
      {
       //imgcol[x].setAttribute('src', strBlankImage);
       imgcol[x].innerHTML = strBlankImage;
      }

      if (objLastClick == srcElem.selectIndex)
      {
         if (reverse == false)
         {
            //srcElem.childNodes[0].setAttribute ('src', strDownImage);
            srcElem.childNodes[0].innerHTML = strDownImage;
            reverse = true;
         }
         else 
         {
            //srcElem.childNodes[0].setAttribute ('src', strUpImage);
            srcElem.childNodes[0].innerHTML = strUpImage;
            reverse = false;
         }
      }
      else
      {
         reverse = false;
         objLastClick = srcElem.selectIndex;
         //srcElem.childNodes[0].setAttribute ('arc', strUpImage);
         srcElem.childNodes[0].innerHTML = strUpImage;
      }
      tbody = element.tBodies [0];
      insertionSort (tbody, tbody.rows.length-1, reverse, srcElem.selectIndex);
   }

   function addRow ()
   {
      var objTR = document.createElement ("TR");
      var objTD = document.createElement ("TD");

      for (var i = 0; i < addRow.arguments.length; i++) 
      {
         objTD = document.createElement ("TD");
         objTD.appendChild (document.createTextNode ((arguments[i]=="")?"null":arguments[i]));
         objTR.insertAdjacentElement ("beforeEnd", objTD);
      }

      objTBody = element.tBodies [0];
      objTBody.insertAdjacentElement ("beforeEnd", objTR);

      resizeDivs ();
   }
   

   function deleteLastRow ()
   {
      removeTextNodes (element.tBodies[0]);
      this.deleteRow (element.tBodies[0].childNodes.length - 1);
   }

   function about ()
   {
      if (element.document.getElementById ("About").style.visibility == "hidden")
         element.document.getElementById ("About").style.visibility = "visible";
      else
         element.document.getElementById ("About").style.visibility = "hidden";
   }

   function getRealPos (elm)
   {
      intPos = 0;
      elm = elm.previousSibling;
      while ((elm!= null) && (elm.tagName!="BODY"))
      {
         intPos += elm.width - 0;
         elm = elm.previousSibling;
      }
      return intPos;
   }

   function getEventRow ()
   {
      var srcElem = window.event.srcElement;
      //crawl up to find the row
      while (srcElem.tagName != "TR" && srcElem.tagName != "TABLE")
      {
         srcElem = srcElem.parentNode;
      }
      return srcElem;
   }

   function getEventCell ()
   {
      var srcElem = window.event.srcElement;
      //crawl up the tree to find the table col
      while (srcElem.tagName != "TD" && srcElem.tagName != "TABLE")
      {
         srcElem = srcElem.parentNode;
      }
      return srcElem;
   }

   function resizeDivs ()
   {
      for (var i = 0; i < intColCount; i++)
      {  
         var objDiv = element.document.getElementById ("DragMark" + (i));
         var objTD = element.tHead.childNodes[0].childNodes[i];

         if ((!objDiv) || (!objTD) || (objTD.tagName != "TD")) return;
         objDiv.style.height = (element.tBodies[0].childNodes.length + 1) * (objTD.offsetHeight - 1);
      }
   }

   function handleError (err, url, line)
   {
       /*
       alert ('Oops, something went wrong.\n' +
          'Please contact yinti AT users DOT sourceforge DOT net with the following text\n' + 
          'Error text: ' + err + '\n' + 
          'Location  : ' + url + '\n' +
          'Line no   : ' + line + '\n');
          */
       return true; // let the browser handle the error */
   }

   function initNNFunctions ()
   {
      if ((self.Node) && (self.Node.prototype))
      {
         Node.prototype.removeNode = NNRemoveNode;

         Element.prototype.insertAdjacentText = NNInsertAdjacentText;
         Element.prototype.insertAdjacentElement = NNInsertAdjacentElement;
         Element.prototype.insert__Adj = NNInsertAdj;
         Element.prototype.attachEvent = NNAttachEvent;
         Element.prototype.detachEvent = NNDetachEvent;
         Element.prototype.setCapture = NNSetCapture;
         Element.prototype.releaseCapture = NNReleaseCapture;
         Element.prototype.__defineGetter__('document', NNDocumentGetter);

         HTMLElement.prototype.focus = NNNullFunction;
         HTMLElement.prototype.attachEvent = NNAttachEvent;
         HTMLElement.prototype.detachEvent = NNDetachEvent;
         HTMLElement.prototype.__defineGetter__('innerText', NNInnerTextGetter);
         HTMLElement.prototype.__defineSetter__('innerText', NNInnerTextSetter);

         HTMLDocument.prototype.attachEvent = NNAttachEvent;
         HTMLDocument.prototype.detachEvent = NNDetachEvent;

      }
   }

   function NNRemoveNode (a1)
   {
      var p = this.parentNode;
      if (p&&!a1)
      {
         var df = document.createDocumentFragment ();
         for (var a = 0; a < this.childNodes.length; a++)
         {
            df.appendChild (this.childNodes[a])
         }
         p.insertBefore (df , this)
      }
      return p?p.removeChild (this):this;
   }

   function NNInsertAdjacentText (a1 , a2)
   {
      var t = document.createTextNode (a2||"")
      this.insert__Adj (a1 , t);
   }

   function NNInsertAdjacentElement (a1 , a2)
   {
      this.insert__Adj (a1 , a2);
      return a2;
   }

   function NNInsertAdj (a1 , a2)
   {
      var p = this.parentNode;
      var s = a1.toLowerCase ();
      if (s == "beforebegin"){p.insertBefore (a2 , this)}
      if (s == "afterend"){p.insertBefore (a2 , this.nextSibling)}
      if (s == "afterbegin"){this.insertBefore (a2 , this.childNodes[0])}
      if (s == "beforeend"){this.appendChild (a2)}
   }

   function NNAttachEvent (strEvent, funcHandle)
   {
      var shortTypeName = strEvent.replace (/on/, "");
      funcHandle._ieEmuEventHandler = function (e)
      {
         window.event = e;
         window.event.srcElement = e.target;
         return funcHandle ();
      };
      this.addEventListener (shortTypeName, funcHandle._ieEmuEventHandler, false);
   }

   function NNDetachEvent (strEvent, funcHandle)
   {
      var shortTypeName = strEvent.replace (/on/, "");
      if (typeof funcHandle._ieEmuEventHandler == "function")
         this.removeEventListener (shortTypeName, funcHandle._ieEmuEventHandler, false);
      else 
         this.removeEventListener (shortTypeName, funcHandle, true);
   }

   function NNSetCapture ()
   {
      //TODO: FIX THIS FIRST BEFORE ANYTHING ELSE!! MAJOR HACK FOR NOW
      document.attachEvent ('onmousemove', resizeColoumn);
      document.attachEvent ('onmouseup', releaseMouse);
   }

   function NNReleaseCapture ()
   {
      //TODO: FIX THIS SECOND THEN GO TO EVERYTHING ELSE! 
      document.detachEvent ('onmousemove', resizeColoumn);
      document.detachEvent ('onmouseup', releaseMouse);
   }

   function NNNullFunction () { /*Nothing here*/ }

   function NNInnerTextGetter ()
   {
      return this.innerHTML.replace (/<[^>]+>/g,"");
   }

   function NNInnerTextSetter (txtStr)
   {
      var parsedText = document.createTextNode (txtStr);
      this.innerHTML = "";
      this.appendChild (parsedText);
   }

   function NNDocumentGetter ()
   {
      return this.ownerDocument;
   }
   
   