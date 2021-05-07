
   /*
   * Fun��es para manipula��o de Objeto Listbox
   */

   function selectUnselectMatchingOptions(obj,regex,which,only) {
   	if (window.RegExp) {
   		if (which == "select") {
   			var selected1=true;
   			var selected2=false;
   			}
   		else if (which == "unselect") {
   			var selected1=false;
   			var selected2=true;
   			}
   		else {
   			return;
   			}
   		var re = new RegExp(regex);
   		for (var i=0; i<obj.options.length; i++) {
   			if (re.test(obj.options[i].text)) {
   				obj.options[i].selected = selected1;
   				}
   			else {
   				if (only == true) {
   					obj.options[i].selected = selected2;
   					}
   				}
   			}
   		}
   	}
   
   function selectMatchingOptions(obj,regex) {
   	selectUnselectMatchingOptions(obj,regex,"select",false);
   	}
   
   function selectOnlyMatchingOptions(obj,regex) {
   	selectUnselectMatchingOptions(obj,regex,"select",true);
   	}
   
   function unSelectMatchingOptions(obj,regex) {
   	selectUnselectMatchingOptions(obj,regex,"unselect",false);
   	}
   
   function sort_select(obj) {
   	var o = new Array();
   	if (obj.options==null) { return; }
   	for (var i=0; i<obj.options.length; i++) {
   		o[o.length] = new Option( obj.options[i].text, obj.options[i].value, obj.options[i].defaultSelected, obj.options[i].selected) ;
   		}
   	if (o.length==0) { return; }
   	o = o.sort(
   		function(a,b) {
   			if ((a.text+"") < (b.text+"")) { return -1; }
   			if ((a.text+"") > (b.text+"")) { return 1; }
   			return 0;
   			}
   		);
   
   	for (var i=0; i<o.length; i++) {
   		obj.options[i] = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
   		}
   	}
   
   function select_all_options(obj) {
   	for (var i=0; i<obj.options.length; i++) {
   		obj.options[i].selected = true;
   		}
   	}
   
   function move_selected_options(from,to) {
   	// Unselect matching options, if required
   	if (arguments.length>3) {
   		var regex = arguments[3];
   		if (regex != "") {
   			unSelectMatchingOptions(from,regex);
   			}
   		}
   	// Move them over
   	for (var i=0; i<from.options.length; i++) {
   		var o = from.options[i];
   		if (o.selected) {
   			to.options[to.options.length] = new Option( o.text, o.value, false, false);
   			}
   		}
   	// Delete them from original
   	for (var i=(from.options.length-1); i>=0; i--) {
   		var o = from.options[i];
   		if (o.selected) {
   			from.options[i] = null;
   			}
   		}
   	from.selectedIndex = -1;
   	to.selectedIndex = -1;
   	}
   
   function copy_selected_options(from,to) {
   	var options = new Object();
   	for (var i=0; i<to.options.length; i++) {
   		options[to.options[i].value] = to.options[i].text;
   		}
   	for (var i=0; i<from.options.length; i++) {
   		var o = from.options[i];
   		if (o.selected) {
   			if (options[o.value] == null || options[o.value] == "undefined" || options[o.value]!=o.text) {
   				to.options[to.options.length] = new Option( o.text, o.value, false, false);
   				}
   			}
   		}
   	if ((arguments.length<3) || (arguments[2]==true)) {
   		sort_select(to);
   		}
   	from.selectedIndex = -1;
   	to.selectedIndex = -1;
   	}
   
   function move_all_options(from,to) {
   	select_all_options(from);
   	if (arguments.length==2) {
   		move_selected_options(from,to);
   		}
   	else if (arguments.length==3) {
   		move_selected_options(from,to,arguments[2]);
   		}
   	else if (arguments.length==4) {
   		move_selected_options(from,to,arguments[2],arguments[3]);
   		}
   	}
   
   function copy_all_options(from,to) {
   	select_all_options(from);
   	if (arguments.length==2) {
   		copy_selected_options(from,to);
   		}
   	else if (arguments.length==3) {
   		copy_selected_options(from,to,arguments[2]);
   		}
   	}
   
   function swap_options(obj,i,j) {
   	var o = obj.options;
   	var i_selected = o[i].selected;
   	var j_selected = o[j].selected;
   	var temp = new Option(o[i].text, o[i].value, o[i].defaultSelected, o[i].selected);
   	var temp2= new Option(o[j].text, o[j].value, o[j].defaultSelected, o[j].selected);
   	o[i] = temp2;
   	o[j] = temp;
   	o[i].selected = j_selected;
   	o[j].selected = i_selected;
   	}
   
   function move_option_up(obj) {
   	for (i=0; i<obj.options.length; i++) {
   		if (obj.options[i].selected) {
   			if (i != 0 && !obj.options[i-1].selected) {
   				swap_options(obj,i,i-1);
   				obj.options[i-1].selected = true;
   				}
   			}
   		}
   	}
   
   function move_option_down(obj) {
   	for (i=obj.options.length-1; i>=0; i--) {
   		if (obj.options[i].selected) {
   			if (i != (obj.options.length-1) && ! obj.options[i+1].selected) {
   				swap_options(obj,i,i+1);
   				obj.options[i+1].selected = true;
   				}
   			}
   		}
   	}
   
   function remove_selected_options(from) {
   	for (var i=(from.options.length-1); i>=0; i--) {
   		var o=from.options[i];
   		if (o.selected) {
   			from.options[i] = null;
   			}
   		}
   	from.selectedIndex = -1;
   	}
   
   function remove_all_options(from) {
   	for (var i=(from.options.length-1); i>=0; i--) {
   		from.options[i] = null;
   		}
   	from.selectedIndex = -1;
   	}
   
   function add_option(obj,text,value,selected) {
   	if (obj!=null && obj.options!=null) {
   		obj.options[obj.options.length] = new Option(text, value, false, selected);
   		}
   	}
   
   function select2comma(from)
   {
      if (from.length > 0)
      {
         var str = from.options[0].text;
         for (var x = 1; x <= (from.length - 1); x++)
         {
            str += ',' + from.options[x].text;
         }
         return str;
      }
      else
         return '';
   }
