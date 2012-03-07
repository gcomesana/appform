

/*
var Dom = {
  get: function(el) {
    if (typeof el === 'string') {
      return document.getElementById(el);
    } else {
      return el;
    }
  },
  
  add: function(el, dest) {
    var elem = this.get(el);
    var dest = this.get(dest);
    dest.appendChild(elem);
  },
  
  remove: function(el) {
    var el = this.get(el);
    el.parentNode.removeChild(el);
  }
};
*/

var AjaxResponse =function() {
		
		var onFail = function (o) {
      overlay.hide();
// Access the response object's properties in the
			var msg = o.responseText;
			
//		document.getElementById("body").appendChild(document.createTextNode(msg));
			alert (msg);
		};
		
		var onUpdateSec = function (o) {
      overlay.hide();
			try {
				var resp = YAHOO.lang.JSON.parse(o.responseText);		
				var result = resp.res;
				
				if (result == "1") {
//					var urlLoc = "index.jsp?res=1&t=sec&op=upd&frmid="+resp.frmid;
					var urlLoc = "index.jsp?res=1&op=det&t=int&frmid="+resp.spid;
//					op=det&t=int&frmid=158
					alert ("The section was succesfully updated");
					document.location.href=urlLoc;
				}
				else {
					alert ("There was an error when trying saving the item. Try again");
	//				document.location.href="index.jsp?res=1&t=sec&op=upd&frmid="+resp.id;
				}
			}
			catch (exp) {
				alert("JSON Parse failed!"); 
			}
		};
		
		
		
	/**
	 */	
		var onSaveSec = function (o) {
      overlay.hide();
			try {
				var resp = YAHOO.lang.JSON.parse(o.responseText);
				var result = resp.res;
				if (result == "1") {
//					var urlLoc = "index.jsp?res=1&t=sec&op=new&frmid="+resp.frmid;
					var urlLoc = "index.jsp?op=det&t=int&frmid="+resp.spid;
					alert ("The section was succesfully created");
					document.location.href=urlLoc;
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
		};
		


/**
	 */	
		var onDelSec = function (o) {
      overlay.hide();
			try {
				var resp = YAHOO.lang.JSON.parse(o.responseText);		
				var myId = resp.frmid;		
				var myForm = document.forms[0];
				var myList;
				for (var i=0; i<myForm.elements.length; i++) {
					if (myForm.elements[i].name.indexOf ("List", 0) != -1) {
						myList = myForm.elements[i];
						break;
					}
				}	
	// just remove the element from the list elements...			
				for (var i=0; i<myList.length; i++) {
					if (myList.options[i].value == myId) {
						myList.remove(i);
						break;
					}
				}
				
// This is to rearrange the sections after removing one of them
				xReq = new AjaxReq ();
  			xReq.setMethod("POST");
				
				var postData = "t=sec&newOrder=";
				for (i=0; i<myList.options.length; i++) {
					postData += myList.options[i].value+",";
				}
		
				postData = postData.substring(0, postData.length-1);
		// alert(postData);
		//		document.location.href = "ajax/rearrange.jsp?"+postData;	
			 	xReq.setUrl ("ajax/rearrange.jsp");
				xReq.setMethod ("POST");
				xReq.setPostdata(postData);
				xReq.setCallback (onArrangeAfterDel, onFail,	null, null);
		
				xReq.startReq();
				
				
				alert ("The section was deleted");
			}
			catch (exp) {
				alert("JSON Parse failed!"); 
		    return;
			}
		};
		
		
		
		var onArrangeAfterDel = function (o) {
			overlay.hide();
		}
		
		
		var test = function () {
//			alert ("SecFormCtrl.AjaxResponse.test works ok");
		}
		
		return {
			test: test,
			onSaveSec: onSaveSec,
			onDelSec: onDelSec,
			onUpdateSec: onUpdateSec,
			onFail: onFail
		}
	};
// END OF AJAXRESPONSE "INNER CLASS" //////////////////////////////////////	


var SecFormCtrl = function () {

	var ajaxResp;
	var myForm;
// variable to keep the url string which is gonna be sent using ajax
	var postData = ""; 

	var TXTAREA_DEF = "Statement text...";	
	
	
/****************************************************************************
 * This method is intended to be run when dom is loaded in order to initialize
 * some form elements properly
 */	
	var init = function () {
		myForm = document.forms[0];  
		
		ajaxResp = new AjaxResponse ();
		ajaxResp.test();
		
//		testResp = new TestResponse ();
	};
	

	
	var listSections = function (theForm, option, spid) {
		var list;
		var idSec, nameSec;
			
		list = theForm.elements['frmListSecs'];
		
		if (option == 'NEW') {
			document.location.href = 'index.jsp?t=sec&op=new&spid='+spid;
	//		document.location.href = 'saveitem.jsp?t=sec&op=new';
		}
		
		else if (option == 'UPD') {
			if (list.selectedIndex >= 0 &&
					list.options[list.selectedIndex].value != -1) {
				idSec = list.options[list.selectedIndex].value;
	/*
				var postData = "t=sec&op=upd&frmid="+idSec; 
				var xReq = new AjaxReq ();
				xReq.setMethod ("POST");
				xReq.setUrl ("ajax/upditem.jsp");
				xReq.setCallback (ajaxResp.onUpdateSec, ajaxResp.onFail, 
													ajaxResp, null);
				xReq.setPostdata (postData);
				xReq.startReq ();		*/
				document.location.href = 'index.jsp?t=sec&op=upd&frmid='+idSec+'&spid='+spid;
			}
			else {
				alert ("An item must be selected");
				return;
			}
		}
		
		else if (option == 'DEL') {
			if (list.options[list.selectedIndex].value != -1) {
				idSec = list.options[list.selectedIndex].value;
				nameSec = list.options[list.selectedIndex].text;
	//alert ("selection for deleting: id:"+idSec+", name:"+nameSec);			
				
				if (window.confirm ('Are you sure to delete section '+nameSec+'?')) {
/*					var postData = "t=sec&op=del&frmid="+idSec; 
					var xReq = new AjaxReq ();
					xReq.setMethod ("POST");
					xReq.setUrl ("ajax/delitem.jsp");
					xReq.setCallback (ajaxResp.onDelSec, ajaxResp.onFail, 
														ajaxResp, null);
					xReq.setPostdata (postData);
					xReq.startReq ();*/
					var postData = 't=sec&op=del&frmid='+idSec;
							
					var xReq = new AjaxReq ();
					xReq.setMethod ("POST");
					xReq.setUrl ("ajax/delitem.jsp");
					xReq.setCallback (ajaxResp.onDelSec, ajaxResp.onFail, 
														ajaxResp, null);
					xReq.setPostdata (postData);
// alert (postData);
					xReq.startReq();
					
//					document.location.href = 'ajax/delitem.jsp?t=sec&op=del&frmid='+idSec;
				}
			}
			else {
				alert ("An item must be selected");
				return;
			}
		}
	};



/**
 * This is a validation method to check after a section edition
 */
	var chkNewSec = function (form) {
		var nelems, elemSet;
		var operation;
		
		if (window.confirm("Are you sure to update this section?")) {
			
			nelems = form.elements.length;
			elemSet = form.elements; /*
			for (var i=0; i<nelems; i++) {
		//		alert (elemSet[i].name+":"+elemSet[i].value);
				if (form.elements[i].type != "button")
					form.elements[i].value = encodeURIComponent(elemSet[i].value);
			}*/
			operation = form.op.value;
			var name = encodeURIComponent(form.elements['frmName'].value);
			var desc = encodeURIComponent(form.elements['frmDesc'].value);
			var idSec = encodeURIComponent(form.elements['frmid'].value);
			var intrId = form.elements['spid'].value;
			
			var xReq = new AjaxReq ();
			xReq.setMethod ("POST");
			var postData;
			if (operation == 'upd' || operation == 'UPD') {
				
				postData = "t=sec&op=upd&frmid="+idSec;
				postData += "&frmName="+name+"&frmDesc="+desc;
				
				xReq.setUrl ("ajax/upditem.jsp");
				xReq.setCallback (ajaxResp.onUpdateSec, ajaxResp.onFail, 
													ajaxResp, null);
				xReq.setPostdata (postData);
			}
//				form.action = "ajax/upditem.jsp";
				
			if (operation == 'new' || operation == 'NEW') {
				postData = "t=sec&op=upd&spid="+intrId;
				postData += "&frmName="+name+"&frmDesc="+desc;
				xReq.setUrl ("ajax/saveitem.jsp");
				xReq.setCallback (ajaxResp.onSaveSec, ajaxResp.onFail, 
													ajaxResp, null);
				xReq.setPostdata (postData);
			}
			
//			if (confirm (postData))
				xReq.startReq();
				
/*			form.action = "ajax/saveitem.jsp";
				
			form.submit();
			*/
		}
	};
	
	
/**
 * Event handler for doubleclick on a item from a list. It can be a list of 
 * sections of items. There is difference if the type of element is section or
 * an item: for a section, the details (item children) are displayed; for an
 * element, the editelem.jsp page is displayed in order to be able to update the
 * element 
 */	
	var goItemProps = function (theId, type) {
		var goTo;
		
		if (type == 'sec')
			goTo = 'index.jsp?op=det&t='+type+'&frmid='+theId;
		
		else
	// here op=upd is used in order to display the editelem.jsp
	// with all item properties
			goTo = 'index.jsp?op=upd&t='+type+'&frmid='+theId;
			
//		if (confirm (goTo));
			document.location.href = goTo; 	
	};
	
	
	
	var goItems = function (selName, type) {
		var sel = document.getElementById(selName);
		if (sel.selectedIndex == undefined ||
        sel.selectedIndex < 0) {
        alert ("You must select one element");
        return;
    }
        
		var selectedVal = sel.options[sel.selectedIndex].value;
		
		if (type == 'sec')
			goTo = './index.jsp?op=det&t='+type+'&frmid='+selectedVal;

		document.location.href = goTo;
//		alert ('redirect to -> '+selectedVal);		
	};
	
	
	
/**
 * 
 */	
	var onCancelEdit = function (theForm) {
		if (confirm ("Are you sure you want to cancel the edition?"))
//			self.history.back();
			document.location.href = "index.jsp?t=int&op=det&frmid="+theForm.spid.value;
	};
	
	
/**
 * Emit an ajax call in order to rearrange the sections within the interview
 */	
	var onRearrange = function (theList) {
		var postData = "t=sec&newOrder=";
		
		for (i=0; i<theList.options.length; i++) {
			postData += theList.options[i].value+",";
		}

		postData = postData.substring(0, postData.length-1);
// alert(postData);
		document.location.href = "ajax/rearrange.jsp?"+postData;		
	};
	
/**
 * move the selected item in the list one position down
 */	
	var moveDown = function (theList) {
alert (theList.options[theList.selectedIndex].value);		
	};
	

/**
 * move the selected item in the list one position up
 */		
	var moveUp = function (theList) {
alert (theList.options[theList.selectedIndex].value);		
	};
	
	
	return {
		ajaxResp: AjaxResponse,
		
		goItemProps: goItemProps,
		chkNewSec: chkNewSec,
		listSections: listSections,
    
    onCancelEdit: onCancelEdit,
    onRearrange: onRearrange,
    moveDown: moveDown,
    moveUp: moveUp,
    goItem: goItems,
		
		init: init
	}
	
	
}


isSecFormCtrlLoaded = true;