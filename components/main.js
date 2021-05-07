   /*
    * Funções Genéricas
    */

   function pasta_salva(strNR_PASTA)
   {
      if (strNR_PASTA == 'New' || strNR_PASTA.length == 0)
      {
         alert('A Pasta não está salva');
         return false;
      } else
         return true;
   }

   function excluir(strReg)
   {
           if (strReg.length != 0 && strReg != 'New')
           {
              if (confirm('Deseja excluir permanentemente o Registro ['+strReg+']?'))
                      return true;
              else
                      return false;
           }
           else
              return false;
   }

   function window_open(strURL,strNAME)
   {
      window.open(strURL,strNAME,'width=10,height=10,top=10,left=10,location=no,toolbar=no,status=yes,scrollbars=yes')
   }

   function show_hide()
   {
     var i,p,v,obj,args=show_hide.arguments;
     for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
       if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
       obj.visibility=v; }
   }

   function MM_findObj(n, d)
   {
     var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
       d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
     if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
     for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
     if(!x && document.getElementById) x=document.getElementById(n); return x;
   }

   function set_class(id_obj,nm_class)
   {
      document.getElementById(id_obj).className=nm_class;
   }

   function valida_hora(cHORA, cHORA2)
   {
           if (cHORA.charAt(2)!=':') {alert('A Hora digitada não é válida!');return false}
           var hora1  = parseInt(cHORA.charAt(0));
           var hora2  = parseInt(cHORA.charAt(1));
           var minuto1 = parseInt(cHORA.charAt(3));
           var minuto2 = parseInt(cHORA.charAt(4));
           if (hora1 < 0 || hora1 > 2 || isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           if (hora2 < 0 || hora2 > 9 || isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           if (minuto1 < 0 || minuto1 > 5|| isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           if (minuto2 < 0 || minuto2 > 9|| isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}

           if (cHORA2.charAt(2)!=':') {alert('A Hora digitada não é válida!');return false}
           var hora1  = parseInt(cHORA2.charAt(0));
           var hora2  = parseInt(cHORA2.charAt(1));
           var minuto1 = parseInt(cHORA2.charAt(3));
           var minuto2 = parseInt(cHORA2.charAt(4));
           if (hora1 < 0 || hora1 > 2 || isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           if (hora2 < 0 || hora2 > 9 || isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           if (minuto1 < 0 || minuto1 > 5|| isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           if (minuto2 < 0 || minuto2 > 9|| isNaN(hora1))
              {alert('A Hora digitada não é válida!');return false}
           return true;
   }

   function valida_data(cDATA,cDATA2)
   {
           if (cDATA.charAt(2)!='/' && cDATA.charAt(5)!='/' ) {alert('A Data digitada não é válida!'); return false}
           var dia = parseInt(cDATA.substring(0,2));
           var mes  = parseInt(cDATA.substring(3,5));
           var ano = parseInt(cDATA.substring(6,10));

           if (dia > 31 || dia < 1 || isNaN(dia))
              {alert('A Data inicial digitada não é válida!');return false}
           if (mes > 12 || mes < 1 || isNaN(mes))
              {alert('A Data inicial digitada não é válida!');return false}
           if (ano < 2002 || isNaN(ano))
              {alert('A Data inicial digitada não é válida!');return false}

           if (cDATA2.charAt(2)!='/' && cDATA2.charAt(5)!='/' ) {alert('A Data digitada não é válida!'); return false}
           var dia2 = parseInt(cDATA2.substring(0,2));
           var mes2  = parseInt(cDATA2.substring(3,5));
           var ano2 = parseInt(cDATA2.substring(6,10));

           if (dia2 > 31 || dia2 < 1 || isNaN(dia2))
              {alert('A Data Final digitada não é válida!');return false}
           if (mes2 > 12 || mes2 < 1 || isNaN(mes2))
              {alert('A Data inicial digitada não é válida!');return false}
           if (ano2 < 2002 || isNaN(ano2))
              {alert('A Data inicial digitada não é válida!');return false}

           return true;
   }

   function userdel(cLOGIN)
   {
           if (confirm('Deseja excluir permanentemente o Usuário ['+cLOGIN+'] do Sistema?'))
                   return true;
           else
                   return false ;
   }

   function groupdel(cGROUP)
   {
           if (confirm('Deseja excluir permanentemente o Grupo ['+cGROUP+'] do Sistema?'))
                   return true;
           else
                   return false ;
   }

   function rm_program(cProg)
   {
           if (confirm('Deseja excluir permanentemente o Programa ['+cProg+'] deste Grupo?'))
                   return true;
           else
                   return false ;
   }

   function ltrim(str)
   {
      var whitespace = new String(" \t\n\r");
      var s = new String(str);

      if (whitespace.indexOf(s.charAt(0)) != -1) {
         var j=0, i = s.length;

         while (j < i && whitespace.indexOf(s.charAt(j)) != -1)
            j++;
         s = s.substring(j, i);
      }
      return s;
   }
   function rtrim(str)
   {
      var whitespace = new String(" \t\n\r");
      var s = new String(str);

      if (whitespace.indexOf(s.charAt(s.length-1)) != -1) {
         var i = s.length - 1;       // Get length of string

         while (i >= 0 && whitespace.indexOf(s.charAt(i)) != -1)
            i--;
         s = s.substring(0, i+1);
      }
      return s;
   }

   function alltrim(str)
   {
      return rtrim(ltrim(str));
   }

   function valida_nr_processo() {
      strNR_PROCESSO = new String(document.mntform.NR_PROCESSO.value);
      var erro = 0;
      for (var ii=0; ii <= (strNR_PROCESSO.length -1); ii++) {
         if (isNaN(parseInt(strNR_PROCESSO.substring(ii,ii+1)))) erro ++ ;
      }
      if (erro > 0) {
            alert('Número de Processo Inválido!');
            document.mntform.NR_PROCESSO.focus();
            document.mntform.NR_PROCESSO.select();
            return false;
      }
   }

//=============================================================================
//                          Search de Cores
//=============================================================================

function sch_color(nm_field,objevent) {
   var obj = document.getElementById('div_color');
   var coratual = eval(nm_field+'.value');
   var acolors = [['00FF00','00FF33','00FF66','00FF99','00FFCC','00FFFF','00CC00','00CC66','00CC66','00CC99','00CCCC','00CCFF','009900','009933','009966','009999','0099CC','0099FF'],
                  ['33FF00','33FF33','33FF66','33FF99','33FFCC','33FFFF','33CC00','33CC33','33CC66','33CC99','33CCCC','33CCFF','339900','339933','339966','339999','3399CC','3399FF'],
                  ['66FF00','66FF33','66FF66','66FF99','66FFCC','66FFFF','66CC00','66CC33','66CC66','66CC99','66CCCC','66CCFF','669900','669933','669966','669999','6699CC','6699FF'],
                  ['99FF00','99FF33','99FF66','99FF99','99FFCC','99FFFF','99CC00','99CC33','99CC66','99CC99','99CCCC','99CCFF','999900','999933','999966','999999','9999CC','9999FF'],
                  ['CCFF00','CCFF33','CCFF66','CCFF99','CCFFCC','CCFFFF','CCCC00','CCCC33','CCCC66','CCCC99','CCCCCC','CCCCFF','CC9900','CC9933','CC9966','CC9999','CC99CC','CC99FF'],
                  ['FFFF00','FFFF33','FFFF66','FFFF99','FFFFCC','FFFFFF','FFCC00','FFCC33','FFCC66','FFCC99','FFCCCC','FFCCFF','FF9900','FF9933','FF9966','FF9999','FF99CC','FF99FF'],
                  ['006600','006633','006666','006699','0066CC','0066FF','003300','003333','003366','003399','0033CC','0033FF','000000','000033','000066','000099','0000CC','0000FF'],
                  ['336600','336633','336666','336699','3366CC','3366FF','333300','333333','333366','333399','3333CC','3333FF','330000','330033','330066','330099','3300CC','3300FF'],
                  ['666600','666633','666666','666699','6666CC','6666FF','663300','663333','663366','663399','6633CC','6633FF','660000','660033','660066','660099','6600CC','6600FF'],
                  ['996600','996633','996666','996699','9966CC','9966FF','993300','993333','993366','993399','9933CC','9933FF','990000','990033','990066','990099','9900CC','9900FF'],
                  ['CC6600','CC6633','CC6666','CC6699','CC66CC','CC66FF','CC3300','CC3333','CC3366','CC3399','CC33CC','CC33FF','CC0000','CC0033','CC0066','CC0099','CC00CC','CC00FF'],
                  ['FF6600','FF6633','FF6666','FF6699','FF66CC','FF66FF','FF3300','FF3333','FF3366','FF3399','FF33CC','FF33FF','FF0000','FF0033','FF0066','FF0099','FF00CC','FF00FF'],
                  ['FFFFFF','F9F9F9','F1F1F1','DDDDDD','CCCCCC','C0C0C0','C0C0C0','C9C9C9','999999','969696','808080','666666','646464','4B4B4B','333333','242424','222222','000000'],
                  ['FAFAFA','EDEEEF','C7D0D9','9CABBA','FFF5EE','FFF0F5','FFE4E1','006400','2E8B57','8FBC8F','66CDAA','8B7D6B','CDB79E','EED5B7','FFE4C4','EEDFCC','FFEFDB','FFF5EE']];

   var content ='<table border="0" cellpadding="0" cellspacing="1" bgcolor="#000000">\n';
   content +='<tr><td align="right" colspan="'+acolors[1].length+'"><a style="text-decoration:none;color:#FFFFFF;" href="javascript:kill()">fechar</a></td></tr>';
   for (var ii = 0; ii <= (acolors.length -1); ii++) {
      content +='<tr>\n';
      for (var xx = 0; xx <= (acolors[ii].length -1); xx++) {
         content +='<td width="12" height="12"'+
                   ' title="#'+acolors[ii][xx]+'"'+
                   ' onclick="javascript:'+nm_field+'.value=\''+acolors[ii][xx]+'\';kill()"'+
                   ' onmouseover="javascript:document.getElementById(\'corselecionada\').innerHTML=\'#'+acolors[ii][xx]+'\';"'+
                   ' bgcolor="#'+acolors[ii][xx]+'">\n'+
                   ' </td>\n';
      }
      content +='</tr>\n';
   }
   content +='<tr><td colspan="18">';
   content +='<table cellpadding="0" cellspacing="0" width="100%"><tr>';
   content +='<td height="12"><font color="#FFFFFF">Cor atual: #'+coratual+'</font><span id="coratual" style="padding-right:24px;background-color:#'+coratual+'"></td>';
   content +='<td align="right"><font color="#FFFFFF"><span id="corselecionada"></span></font></td>';
   content +='</tr></table>';
   content +='</td></tr>';
   content += '</table>';

   obj.style.top        = objevent.clientY - 100;
   obj.style.left       = objevent.clientX - 110;
   obj.innerHTML        = content;
   obj.style.visibility = 'visible';
}
function kill() {
   var obj = document.getElementById('div_color');
   obj.style.visibility = 'hidden';
}

/* Calendário Dinâmico */
/* Varáveis Globais */
var objdate;
var now = new Date();
var year = now.getYear();
if (year < 1000) year+=1900;
var month = now.getMonth();

function leapYear(year) {
   if (year % 4 == 0)
      return true ;
   return false ;
}

function getDays(month, year) {
   var ar = new Array(12);
   ar[0] = 31;
   ar[1] = (leapYear(year)) ? 29 : 28;
   ar[2] = 31;
   ar[3] = 30;
   ar[4] = 31;
   ar[5] = 30;
   ar[6] = 31;
   ar[7] = 31;
   ar[8] = 30;
   ar[9] = 31;
   ar[10] = 30;
   ar[11] = 31;
   return ar[month];
}

function getMonthName(month) {
var ar = new Array(12);
ar[0] = "Janeiro";
ar[1] = "Fevereiro";
ar[2] = "Março";
ar[3] = "Abril";
ar[4] = "Maio";
ar[5] = "Junho";
ar[6] = "Julho";
ar[7] = "Agosto";
ar[8] = "Setembro";
ar[9] = "Outubro";
ar[10] = "Novembro";
ar[11] = "Dezembro";

return ar[month]
}

function next_month() {
  month ++;
  if (month > 11) {
     month = 0;
     year ++;
  }
  setcall();
}

function prev_month() {
  month -- ;
  if (parseInt(month)<0) {
     month = 11;
     year --;
  }
  setcall();
}

function setcall() {
   var monthName = getMonthName(month);
   var date = now.getDate();
   //now = null

   var firstDayInstance = new Date(year, month, 1);
   var firstDay = firstDayInstance.getDay();
   firstDayInstance = null;

   var days = getDays(month, year);

   drawCal(firstDay + 1, days, date, monthName, year);
}

function drawCal(firstDay, lastDate, date, monthName, year) {
   var text = "";
   text += '<table class="wcal" bgcolor="#ffffff" border="0" cellspacing="0">';
   text += '<tr class="wcal_mes">'
   text += '<td align="left"><input class="wcal_button" type="button" value="<" onclick="prev_month()"></td>';
   text += '<td colspan=4 align="center">';
   text += monthName + ' ' + year
   text += '</TD>';
   text += '<td align="right"><input class="wcal_button" type="button" value=">" onclick="next_month()"></td>';
   text += '<td align="right"><input class="wcal_button" type="button" value="x" onclick="kill_call()"></td>';
   text +='</tr>';

   var openCol = '<TD WIDTH="30" HEIGHT="20">';
   var closeCol = '</FONT></TD>';

   var weekDay = new Array(7);
   weekDay[0] = "Dom";
   weekDay[1] = "Seg";
   weekDay[2] = "Ter";
   weekDay[3] = "Qua";
   weekDay[4] = "Qui";
   weekDay[5] = "Sex";
   weekDay[6] = "Sab";

   text += '<TR class="wcal_semana" ALIGN="center" VALIGN="center">';
   for (var dayNum = 0; dayNum < 7; ++dayNum) {
      text += openCol + weekDay[dayNum] + closeCol ;
   }
   text += '</TR>';

   var digit = 1;
   var curCell = 1;

   for (var row = 1; row <= Math.ceil((lastDate + firstDay - 1) / 7); ++row) {
      text += '<TR ALIGN="right" VALIGN="top">';
      for (var col = 1; col <= 7; ++col) {
         if (digit > lastDate) break;
         if (curCell < firstDay) {
            text += '<TD></TD>';
            curCell++
         } else {
            if (digit < 10)
               wday = '0'+digit
            else
               wday = digit;
            if (month < 9)
               wmonth = '0'+(month+1)
            else
               wmonth = month+1;

            datecell = wday +'/'+wmonth+'/'+year ;

            if (digit == date) {
               text += '<TD style="color:0000FF;font-weight:bold;" onmouseout="this.className=\'wcal_dia\'" onmouseover="this.className=\'wcal_diaover\'" HEIGHT="20" onclick="javascript:chdate(\''+datecell+'\')">';
               text += digit;
               text += '</TD>';
            } else {
               text += '<TD class="wcaldia" onmouseout="this.className=\'wcal_dia\'" onmouseover="this.className=\'wcal_diaover\'" HEIGHT="20" onclick="javascript:chdate(\''+datecell+'\')">'
               if (col==1 || col==7)
                  text += '<font color="#FF0000">'+digit+'</font>'
               else
                  text += digit;

               text += '</b></TD>'
            }
            digit++
         }
      }
      text += '</TR>'
   }

   text += '</TABLE>'
   document.getElementById('calendario').innerHTML = text;
   document.getElementById('calendario').style.visibility = 'visible';
}


function sch_cal(obj,objevent) {
   document.getElementById('calendario').style.top = (objevent.clientY + 12) + document.body.scrollTop;
   document.getElementById('calendario').style.left = (objevent.clientX - 100) + document.body.scrollLeft;
   objdate = obj;
   setcall();
}

function chdate(str) {
   objdate.value = str;
   kill_call();
}

function kill_call() {
   document.getElementById('calendario').innerHTML = '';
   document.getElementById('calendario').style.visibility = 'hidden';
}