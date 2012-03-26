

/**
 * Methods to respond the new type action
 */
var NewTypeAjaxResponse = function () {
	var nTypeCtrl;
	var selectTypes;
	
	function onFail (o) {
// Access the response object's properties in the
		var msg = o.responseText;
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	}
	
	function onUpdateType (o) {
    overlay.hide();
		try {				
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;

			if (result == "1") {
				alert ("The type was succesfully updated");
			}
			else {
				alert ("There was an error when trying saving the item. Try again");
//				document.location.href="index.jsp?res=1&t=sec&op=upd&frmid="+resp.id;
			}
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	}
	
	
/**
 */	
	function onSaveType (o) {
    overlay.hide();
		try {				
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;		
			
			if (result == "1") {
				nTypeCtrl.reloadSelects();
        if (nTypeCtrl.isClon)
				  alert ("The type was succesfully updated");
        else
          alert ("The type was succesfully added");
			}	
			else {
        if (resp.msg)
          alert (resp.msg);
        else
				  alert ("There was an error when trying saving/updating the item. Try again");
			}
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	}
	
	
	
	
	function onDelType (o) {
    overlay.hide();
		try {				
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;
					
			if (result == "1") {
				nTypeCtrl.clear();
				nTypeCtrl.reloadSelects();
				alert ("The type was succesfully removed");
			}
			else if (result == "2") {
				nTypeCtrl.setMsg ('The type can not be delete: it has related questions');
				return;
			} 
			else {
				alert ("There was an error when trying removing the item. Try again");
			}
		}
		catch (exp) {
			alert("JSON Parse failed!:"+exp); 
	    return;
		}
	}
	
	
	
/**
 * Callback function for the ajax call to delete an entry in the enumerated type
 * @param {Object} o
 */
	function onDelItem (o) {
		overlay.hide();
		try {				
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;
					
			if (result == "1") {
				nTypeCtrl.clear();
				nTypeCtrl.reloadSelects();
				alert ("The entry was succesfully removed");
			}
			else if (result == "-1") {
				nTypeCtrl.del (true);
			}
			else
				nTypeCtrl.setMsg (resp.msg);
				
		}
		catch (exp) {
			alert("JSON Parse failed!:"+exp); 
	    return;
		}
	}
	
	
	function test () {
		alert ("prjFormCtrl.NewTypeAjaxResponse.test works ok");
	}
	
	
	
	// listTypes
	function init (nTCtrl) {
		nTypeCtrl=nTCtrl;
	}
	
	return {
		test: test,
		init: init,
		onSaveType: onSaveType,
		onUpdType: onUpdateType,
		onDelType: onDelType,
		onDelItem: onDelItem,
		onFail: onFail
		
	}
};
// END OF NEWTYPEAJAXRESPONSE "INNER CLASS" //////////////////////////////////////	



/**
 * this class send the operations to the server and, on response, synchronize
 * the lists in the types dialog window and on the main window itself.
 * This is the only class which accesses to the main window
 */
var ListAjaxResponse = function () {
	var listTypes; // list of types on the opener page (frmAnsTypes)
	var selectTypes; // the list of enum types on the types dialog
	var onChangeHandler;
	
	function onFail (o) {
// Access the response object's properties in the
		var msg = o.responseText;
		overlay.hide();
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	}
	
	
/**
 */	
	function onLoadTypes(o) {
    overlay.hide();
		try {
			// First, empty controls
			var emptySelect = function(selectCtrl) {
				for(var ri=selectCtrl.length-1;ri>=0;ri--) {
					selectCtrl.remove(ri);
				}				
			};
			emptySelect(listTypes);
			listTypes.selectedIndex=-1;
			
			var fillSelect=function(myList,tName,id) {
				var thedoc=myList.ownerDocument;
				var newOpt=thedoc.createElement('option');
				newOpt.text=tName;
				newOpt.value=id;
				myList.appendChild(newOpt);
			};
			
			// Second, populate controls!
			var resp = YAHOO.lang.JSON.parse(o.responseText);
			var listlength = resp.length;
			for(var typei=0;typei<listlength;typei++) {
				var id=resp[typei].id;
				var tName=resp[typei].name;
				fillSelect(listTypes,tName,id);
			}
		} catch (exp) {
			alert("JSON Parse failed!"+o.responseText); 
	    	return;
		}
	}
  
  
	
/**
 * this callback method just load the types for the current context 
 * (interview or app) in the enum-types combo box
 * @param {Object} o
 */  
	function onLoadEnumTypes(o) {
    overlay.hide();
		try {
			// Zero, deactivate control feedback
			if(onChangeHandler!==undefined) {
				try {
					selectTypes.removeEventListener('change',onChangeHandler,false);
				} catch(e) {
					// DoNothing(R)
				}
			}
      
// First, empty controls
			var emptySelect=function(selectCtrl) {
				for(var ri=selectCtrl.length-1;ri>=0;ri--) {
					selectCtrl.remove(ri);
				}				
			};
			emptySelect(selectTypes);
			selectTypes.selectedIndex=-1;
			
// inner function to fill the select with the option      
			var fillSelect = function(myList, tName, id) {
				var thedoc=myList.ownerDocument;
				var newOpt=thedoc.createElement('option');
				newOpt.text=tName;
				newOpt.value=id;
				myList.appendChild(newOpt);
			};
			
// Second, populate controls!
      if (intrvClonned == false)
        fillSelect(selectTypes,'---NEW---','-1');
      else
        fillSelect (selectTypes, '-- TRANSLATE --', '-1');
        
			var resp = YAHOO.lang.JSON.parse(o.responseText);
			var listlength = resp.length;
			for (var typei=0; typei<listlength; typei++) {
				var id=resp[typei].id;
				var tName=resp[typei].name;
				fillSelect(selectTypes,tName,id);
			}
			
			 // Third, reattach change events
			 if(onChangeHandler!=null)
			 	selectTypes.addEventListener('change',onChangeHandler,false);
		} catch (exp) {
			alert("JSON Parse failed!"+o.responseText); 
	    	return;
		}
	}
	
	function test () {
		alert ("prjFormCtrl.ListAjaxResponse.test works ok");
	}
	
	// listTypes
	function init (list,sels,onChange) {
		listTypes = list;
		selectTypes = sels;
		onChangeHandler=onChange;
	}
	
	return {
		test: test,
		init: init,
		onLoadTypes: onLoadTypes,
		onLoadEnumTypes: onLoadEnumTypes,
		onFail: onFail
		
	}
};
// END OF LISTAJAXRESPONSE "INNER CLASS" //////////////////////////////////////	





/**
 * The only useful method of this class is onFillForm(obj) which is the method
 * called on response to the change of the type on the select component 
 */
var FillFormAjaxResponse = function () {
	var nTypeCtrl;
	
	function onFail (o) {
// Access the response object's properties in the
		var msg = o.responseText;
    overlay.hide();
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	}
	
	
/**
 * 
 * @param {Object} o
 */	
	function onFillForm(o) {
    overlay.hide();
		try {
			// First, empty controls
			nTypeCtrl.clear();
			
			// Second, populate controls!
			var resp = YAHOO.lang.JSON.parse(o.responseText);
			if('name' in resp) {
				nTypeCtrl.setTypename(resp.name, resp.id);
				var listarr=resp.list;
				var listlength = listarr.length;
				for(var typei=0; typei<listlength; typei++) {
					nTypeCtrl.add (listarr[typei].name, listarr[typei].val);
				}
			}
			
// This one sets whether or not the requested type is already is use in any interview
			if ('used' in resp) {
				nTypeCtrl.setTypeUsed (resp.used);
/*
				var valueTxt = document.getElementById('typevalue');
				if (resp.used == 1)
					valueTxt.disabled = true;
				else
					valueTxt.disabled = false;
*/
			}
			else
				nTypeCtrl.setTypeUsed (0);
		} 
    catch (exp) {
			alert("JSON Parse failed!"+o.responseText+"\n"+exp); 
	    	return;
		}
	}
	
	
	function test () {
		alert ("prjFormCtrl.FillFormAjaxResponse.test works ok");
	}
	
	// listTypes
	function init (nTCtrl) {
		nTypeCtrl=nTCtrl;
	}
	
	return {
		test: test,
		init: init,
		onFillForm: onFillForm,
		onFail: onFail
		
	}
};
// END OF FILLFORMAJAXRESPONSE "INNER CLASS" //////////////////////////////////////	



/**
 * This class encapsulates the logic to control the answer types dialog in order
 * to allow CRUD operations on answer types for the current interview
 */
var NewTypeCtrl = function () {
	
// hold the selected element in the list of enumerated items
// this var holds a div DOM object
	var elementSelected;
	
	var ajaxResp;
	var listAjaxResp;
	var getTypeAjaxResp;
	
	var listTypes;
	var selectTypes;
	var currid;

// variables to represent the component boxes on the dialog
	var typename; 
	var typelist;
	var typekey; // textfield for the key of the enum item
	var typevalue; // textfield for the value for the enum item
  
  var intrvId;
  var isClon;
	var isAdmin;
	
// this switch will be 0 if the type is not in use in any interview
// and will be 1 if it was already used
	var typeused;
	
	var divMsg;
	
	var MAX_KEY_LENGTH = 1023;

	function sel (identified) {
   	divMsg.style.visibility = 'hidden';
    var element=document.getElementById(identified);
    var current = identified.split(':');
    if (elementSelected) {
      elementSelected.setAttribute('class','list');
    }
    element.setAttribute('class','elementSelected');
    elementSelected=element;
// alert ("sel("+current[0]+","+current[1]+")");     
    typekey.value = current[0];
    typevalue.value = current[1];
/*
	 if (typeused)
	 	typevalue.disabled = true;
	 else
	 	typevalue.disabled = false;
*/
	}
	
 
	
/****************************************************************************/	
/**
 * This method adds a new entry to the list of enumerated items or update an 
 * existent if either valkey or valvalue are already in the list
 * @param {Object} valkey
 * @param {Object} valvalue
 */
	function add(valkey, valvalue) {
    divMsg.style.visibility = 'hidden';
		
    if (valkey == undefined) {
      valkey = typekey.value;
      if (valkey.length > MAX_KEY_LENGTH) {
//        alert("El valor del campo key es demasiado largo");
        alert("Content is too long for the 'Key' field");
        return;
      }
    }
      
		if (valvalue == undefined) {
      valvalue = typevalue.value;
      if (valvalue.indexOf(" ") != -1) {
//        alert("El valor no puede contener espacios en blanco");
        alert ("Blank chars are not allowed for the 'Value' field");
        return;
      }
    }
      
    var identified=valkey+":"+valvalue;
    var valIdentified = valvalue;
		var labelIdentified = valkey;
    var elements=typelist.getElementsByTagName('div');
    var find=0
    var numRegExp = /\d+/;
    if (numRegExp.test(valIdentified) == false)
   	  find = 2;

// check the list of names:values (key:value) to see whether or not the 
// new pair is already in the list.
// As this method is called both when the type is loaded and when an item is
// modified or added to this type, the typeused checking has to be taken into account 
// theVal is the list element value on each iteration
		for (var i=0; i<elements.length && find == 0; i++) {
			var theVal = elements[i].id.split(":")[1];
			var theKey = elements[i].id.split(":")[0];
   		if (typeused && (theVal != valIdentified && theKey == labelIdentified)) {
        find = 3;
		  }
			
		}
	   
// we can create or update the new element
// find=0 means user wants to add a new key:value not in the list 
	  if (find==0) {
      var pair = (elementSelected)? elementSelected.getAttribute('id').split(':'):
                                    new Array ('','');
                                    
      if (pair[0] == valkey || pair[1] == valvalue) {
        elementSelected.innerHTML = valkey+" ("+valvalue+")";
        elementSelected.setAttribute ('id', identified);
        elementSelected.setAttribute('onclick',
                                    "newTypeCtrl.sel('"+identified+"');");
      }
      else { /* update
      	if (typeused) {
      		divMsg.style.visibility = 'visible';
					divMsg.innerText = 'Unable to update element: type is in use';
					return;
				} */
     		thedoc=typelist.ownerDocument;
        var element=thedoc.createElement("div");
        element.setAttribute('class','list');
        element.innerHTML=valkey+" ("+valvalue+")";
        element.setAttribute('id',identified);
        element.setAttribute('onclick',"newTypeCtrl.sel('"+identified+"');");
        typelist.appendChild(element);
        typekey.value='';
        typevalue.value='';
      }
	  }
	  else if (find == 1) {
//	     alert("ERROR:Pair key/value repeated or value repeated for different keys");
			typekey.value='';
      typevalue.value='';
			divMsg.style.visibility = 'visible';
			divMsg.innerHTML = "ERROR:Pair key/value, value or key repeated for this type";
	  }
	  else if (find == 2) {
			typekey.value='';
      typevalue.value=''; 
			divMsg.style.visibility = 'visible';
	  	divMsg.innerHTML = "Only numeric values are allowed";
		}
		else if (find == 3) {
			typekey.value='';
      typevalue.value=''; 
			divMsg.style.visibility = 'visible';
	  	divMsg.innerHTML = "Type is in use and the values can not be changed";
		}
	}
	
  
	
/**
 * Removes the elementSelected from the list of enumerated items. 
 * To do this, an ajax call should to be performed in order to check whether 
 * or not elementSelected
 * holds an element which has been used as answer for some question.
 * @param {Object} forced, remove the element from the list (not from database)
 * if force is true, bypassing the typeused guard. 
 */
	function del (forced) {
		
		if (typeused && (forced == false || forced == undefined)) {
			setMsg ("The type is in use: Unable to delete the entry");
			return false;
		}
		
	  var element;
	  if(elementSelected) {
	      element=typelist.removeChild(elementSelected);
				elementSelected = undefined;
				typevalue.value = '';
				typekey.value = '';
	  }
	  return element;
	}
	
  
	
	function up()	{
	   var elements=typelist.getElementsByTagName('div');
	   var pos=1;
	   for (i=0;i<elements.length;i++) {
       if (elements[i].id==elementSelected.id) 
         pos=i;
       
	   }
		 
	   if (pos>0) {
       pos--;
       var element;
			 if (elementSelected) 
	       element = typelist.removeChild(elementSelected);
	  	 
       typelist.insertBefore(element, elements[pos]);
	   }
	}
	
	
	function down() {
	   var elements=typelist.getElementsByTagName('div');
	   var pos=1;
	   for(i=0;i<elements.length;i++)
	   {
	       if(elements[i].id==elementSelected.id)
	       {
	           pos=i;
	       }
	   }
	   pos++;
	   var element=del();
	   typelist.insertBefore(element, elements[pos]);
	}
	
	
	
	function send() {
	   var elements=typelist.getElementsByTagName('div');
	   if(typename.value && elements.length>0) {
	      var params="typename="+encodeURIComponent(typename.value);
	      params+="&typeid="+encodeURIComponent((currid!=undefined)?currid:"-1");
        params+="&intrvId="+intrvId;
	      for (i=0;i<elements.length;i++) {
				  params += "&elements="+encodeURIComponent(elements[i].id);
	      }
//				if (confirm(params)) 
//	       	document.location.href="../jsp/ajax/newtype.jsp?"+params;

		    var xReq = new AjaxReq ();
				xReq.setUrl ("../jsp/ajax/newtype.jsp");
				xReq.setMethod ("POST");
				xReq.setPostdata(params);
				xReq.setCallback (ajaxResp.onSaveType, ajaxResp.onFail, ajaxResp, null);
				xReq.startReq(); 
//		}
	   } 
     else {
	       alert("Field 'Name' and list of elements can not be empty");
	   }
   } 
	
	
	
	
	function reloadSelects() {
		// Internal select (dialog combo)
		var xReq = new AjaxReq ();
    var params = "intrvId="+intrvId;
		xReq.setUrl ("../jsp/ajax/listenumtypes.jsp");
		xReq.setMethod ("POST");
		xReq.setPostdata(params);
		xReq.setCallback (listAjaxResp.onLoadEnumTypes, listAjaxResp.onFail, listAjaxResp, null);
		xReq.startReq(); 
		
		// External one (opener page)
		xReq = new AjaxReq ();
		xReq.setUrl ("../jsp/ajax/listtypes.jsp");
		xReq.setMethod ("POST");
		xReq.setPostdata('intrvId='+intrvId);
		xReq.setCallback (listAjaxResp.onLoadTypes, listAjaxResp.onFail, listAjaxResp, null);
		xReq.startReq();

		this.clear(); 
  } 
	
  
	
	
	
/**
 * Clean all boxes of the types dialog on selection of the first element of
 * the combobox (Translate or New)
 */  
	function clear() {
		divMsg.style.visibility = 'hidden';
		
		typename.value='';
		typekey.value='';
		typevalue.value='';
		var emptyDiv = function(container) {
			if(container) {
				var eraseme = container.firstChild;

				while(eraseme) {
					var toerase = eraseme;
					eraseme = eraseme.nextSibling;
					container.removeChild(toerase);
				}
			}
		}
		
		emptyDiv(typelist);
		elementSelected=undefined;
		currid=undefined;
		typename.disabled=false;
/*
    if (isClon && !isAdmin)
      typevalue.disabled = true;
*/
	}
	
  
/**
 * this method is called from the FillFormAjaxResponse.onFillForm to set the 
 * typename component with the proper values.
 * @param {Object} newname, the new name of the value
 * @param {Object} newid, the newid of the selected type
 */  
	function setTypename(newname,newid) {
/*		if (isClon || isAdmin)
      typename.disabled=true;
 */     
		typename.value=newname;
		currid=newid;
	}
	
	
	
/**
 * Sets the typeused member and resets the typevalue textfield component
 * @param {Object} used
 */
	function setTypeUsed (used) {
		typeused = used;
		typevalue.disabled = false;
	}
	
  
	
	
	function delItem () {
		if(currid==undefined) {
			clear();
		} 
    else {
			var params="what=del_en_it&typeid="+encodeURIComponent(currid);
			params += "&val="+elementSelected.id.split(':')[1];
			
			var xReq = new AjaxReq ();
			xReq.setUrl (APPNAME+"/servlet/QryServlet");
			xReq.setMethod ("POST");
			xReq.setPostdata(params);
			xReq.setCallback (ajaxResp.onDelItem, ajaxResp.onFail, ajaxResp, null);
			xReq.startReq();
		}
		
		
	}
	
	
  
	function delType() {
		if (typeused) {
			divMsg.style.visibility = "visible";
			divMsg.innerHTML = "Type is in use and it can not be removed";
			typekey.value = '';
			typevalue.value = '';
			return;
		}
		
		if(currid==undefined) {
			clear();
		} 
    else {
			var params="typeid="+encodeURIComponent(currid);
			var xReq = new AjaxReq ();
			xReq.setUrl ("../jsp/ajax/deltype.jsp");
			xReq.setMethod ("POST");
			xReq.setPostdata(params);
			xReq.setCallback (ajaxResp.onDelType, ajaxResp.onFail, ajaxResp, null);
			xReq.startReq();
		}
	}
	
  
	
/**
 * This is the event handler for onSelect event for the types list.
 * 
 * [Remark the action to create a new type when the selected index is 0 is 
 * executed only when isClon is false (only for original interviews)]
 */  
	function onSelectTypesChange () {   
		if(selectTypes.selectedIndex!=-1) {
			if(selectTypes.selectedIndex == 0) {
				clear();
				currid = undefined;
			}
      else {
				var futurecurrid = selectTypes.options[selectTypes.selectedIndex].value;
				var params="typeid="+encodeURIComponent(futurecurrid);
				var xReq = new AjaxReq ();
        
				xReq.setUrl ("../jsp/ajax/gettype.jsp");
				xReq.setMethod ("POST");
				xReq.setPostdata(params);
				xReq.setCallback (getTypeAjaxResp.onFillForm, getTypeAjaxResp.onFail, getTypeAjaxResp, null);
				xReq.startReq();
			} 
		}
	}
	
	
	
	
	function setMsg (msg) {
		typekey.value='';
    typevalue.value='';
		divMsg.style.visibility = "visible";
		divMsg.innerHTML = msg;
	}
		
    
	function init (theIntrvId, clonned, admin) {
//		alert ("initializing new type controller");
		listTypes = window.opener.document.getElementById('frmAnswerTypes');
		selectTypes = document.getElementById('typeSelect');
    typename = document.getElementById('typename');
		typelist = document.getElementById('typelist');
		typekey = document.getElementById('typekey');
		typevalue = document.getElementById('typevalue');
    divMsg = document.getElementById('divMsg');
		divMsg.style.visibility = 'hidden';
		
		elementSelected=undefined;
		intrvId = theIntrvId;
    isClon = clonned;
		isAdmin = admin;
    
    getTypeAjaxResp = new FillFormAjaxResponse();
    getTypeAjaxResp.init(this);
		
		ajaxResp = new NewTypeAjaxResponse ();
		ajaxResp.init(this);
    
		listAjaxResp = new ListAjaxResponse();
		listAjaxResp.init(listTypes, selectTypes, onSelectTypesChange);
    
		this.reloadSelects();
	}
	
	
	
	
	return {
		up: up,
		down: down,
		del: del,
		delType: delType,
		add: add,
		sel: sel,
		clear: clear,
		setTypename: setTypename,
		setTypeUsed: setTypeUsed,
		delItem: delItem,
		
		setMsg: setMsg,
		
		onSave: send,
		ajaxResp: ajaxResp,
		init: init,
		reloadSelects: reloadSelects,
    
    isClon: isClon
	} 
	
}

var newTypeCtrl;
var overlay;
var intrvClonned;

/**
 * Function run when the page is ready
 * @param {Object} intrvId
 * @param {Object} clonned, if the interview is a clon
 * @param {Object} admin, if the current user has admin role
 */
function onReady (intrvId, clonned, admin) {
  overlay = new Overlay();
  intrvClonned = clonned;
  
	newTypeCtrl = new NewTypeCtrl ();
	newTypeCtrl.init(intrvId, clonned, admin);
}