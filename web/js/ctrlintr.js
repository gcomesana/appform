
var list;

var IntrAjaxResponse = function () {
		
		var onFail = function (o) {
// Access the response object's properties in the
			var msg = o.responseText;
			
//		document.getElementById("body").appendChild(document.createTextNode(msg));
			alert (msg);
		};
		
		var onUpdateIntr = function (o) {
      overlay.hide();
			try {				
				var resp = YAHOO.lang.JSON.parse(o.responseText);		
				var result = resp.res;

				if (result == "1") {
//					var urlLoc = "index.jsp?res=1&t=int&op=upd&frmid="+resp.frmid;
					var urlLoc = "index.jsp?op=det&t=prj&frmid=";
          var theId;
          theId = resp.spid? resp.spid: resp.frmid;
					
					alert ("The interview was succesfully updated");
					document.location.href=urlLoc+theId;
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
		var onDelIntr = function (o) {
      overlay.hide();
			try {				
				var resp = YAHOO.lang.JSON.parse(o.responseText);		
				var myId = resp.frmid;		
				var myForm = document.forms[0];
//				var myList = myForm.elements['frmListItems']; 
				var myList;
				for (var i=0; i<myForm.elements.length; i++) {
					if (myForm.elements[i].name.indexOf ("List", 0) != -1) {
						myList = myForm.elements[i];
						break;
					}
				}				
	// just remove the element from the list elements...			
				for (var i=0; i<list.length; i++) {
					if (myList.options[i].value == myId) {
						myList.remove(i);
						break;
					}
				}
				
				alert ("The project was deleted");
			}
			catch (exp) {
				alert("JSON Parse failed!"); 
		    return;
			}
		};
		
		
	/**
	 */	
		var onSaveIntr = function (o) {
      overlay.hide();
			try {
				var resp = YAHOO.lang.JSON.parse(o.responseText);
				var result = resp.res;
//	alert (resp.res);			
				if (result == "1") {
//					var urlLoc = "index.jsp?res=1&t=int&op=new&frmid="+resp.spid;
					var urlLoc = "index.jsp?op=det&t=prj&frmid=";
					var theId;
          theId = resp.spid? resp.spid: resp.frmid;
					alert ("The interview was succesfully created");
					document.location.href=urlLoc+theId;
				}
				else {
					alert ("There was an error when trying creating the item. Try again");
	//				document.location.href="index.jsp?res=1&t=sec&op=upd&frmid="+resp.id;
				}
			}
			catch (exp) {
				alert("JSON Parse failed!"); 
		    return;
			}
		};
		

		
		var test = function () {
			alert ("prjFormCtrl.AjaxResponse.test works ok");
		}
		
		
		return {
			test: test,
			onSaveIntr: onSaveIntr,
			onDelIntr: onDelIntr,
			onUpdateIntr: onUpdateIntr,
			onFail: onFail
		}
	};
// END OF AJAXRESPONSE "INNER CLASS" //////////////////////////////////////	


/**
 * This class is used to control the project list in order to manage 
 * the projects
 */

var IntrFormCtrl = function () {
	
	var ajaxRespIntr;
	var shortStatus;
	
	var init = function () {
		ajaxRespIntr = new IntrAjaxResponse ();
		
	}
	
	var listInterviews = function (theForm, option) {
		var idprj, nameprj;
			
//		list = theForm.elements['frmListprjs'];
		for (var i=0; i<theForm.elements.length; i++) {
			if (theForm.elements[i].name.indexOf ("List", 0) != -1) {
				list = theForm.elements[i];
				break;
			}
		}
		
		if (option == 'NEW') {
			document.location.href = 'index.jsp?t=int&op=new';
	//		document.location.href = 'saveitem.jsp?t=int&op=new';
		}
		
		else if (option == 'UPD') {
			if (list.options[list.selectedIndex].value != -1) {
				var idIntr = list.options[list.selectedIndex].value;
			
				document.location.href = 'index.jsp?t=int&op=upd&frmid='+idIntr;
			}
			else {
				alert ("An item must be selected");
				return;
			}
		}
		
		else if (option == 'DEL') {
			if (list.options[list.selectedIndex].value != -1) {
				var idintr = list.options[list.selectedIndex].value;
				nameprj = list.options[list.selectedIndex].text;
	//alert ("selection for deleting: id:"+idprj+", name:"+nameprj);
				
// be aware if a project must be delete all items related or not...				
				if (window.confirm ('Are you sure to delete section '+nameprj+'?'))
//					document.location.href = 'ajax/delitem.jsp?t=int&op=del&frmid='+idprj;
					
					var xReq = new AjaxReq ();
					xReq.setUrl ("ajax/delitem.jsp");
					xReq.setMethod ("POST");
					xReq.setPostdata("t=int&frmid="+idintr);
					xReq.setCallback (ajaxRespIntr.onDelIntr, ajaxRespIntr.onFail,
														ajaxRespIntr, null);
		
					xReq.startReq();
			
			}
			else {
				alert ("An item must be selected");
				return;
			}
		}
	};



/**
 * This is a validation method to check after a project edition
 */
	var chkNewIntr = function (form) {
		var nelems, elemSet;
		var operation;
		var frmName, frmDesc, frmId;
		var postData;
		
		/*	
			nelems = form.elements.length;
			elemSet = form.elements;
			for (var i=0; i<nelems; i++) {
		//		alert (elemSet[i].name+":"+elemSet[i].value);
				if (form.elements[i].type.indexOf (0, "text") != -1)
					form.elements[i].value = encodeURIComponent(elemSet[i].value);
			}
			*/
		frmName = encodeURIComponent(form.elements['frmintrName'].value);
		frmDesc = encodeURIComponent(form.elements['frmDesc'].value);
		frmId = encodeURIComponent(form.elements['frmid'].value);
		spId = form.elements['spid'].value;
		operation = form.op.value;
		
		var xReq = new AjaxReq ();
		xReq.setMethod ("POST");
		postData = "t=int";
		if (frmId != "")
			postData += "&frmid="+frmId;
		
		else 
			postData += "&spid="+spId;
			
		postData += "&frmDesc="+frmDesc+"&frmName="+frmName;
		postData += "&chkShort="+form.elements['chkShort'].checked;
		postData += "&chkCrtSubj="+form.elements['chkCrtSubj'].checked;
		postData += "&chkSample="+form.elements['chkSample'].checked;

		if (operation == 'upd' || operation == 'UPD') {
			if (confirm("Are you sure to update this interview?")) {
				xReq.setUrl ("ajax/upditem.jsp");
				xReq.setCallback (ajaxRespIntr.onUpdateIntr, ajaxRespIntr.onFail,
													ajaxRespIntr, null);
			}
		}
		
		if (operation == 'new' || operation == 'NEW') {
			if (confirm("Are you sure to create this interview?")) {
				xReq.setUrl ("ajax/saveitem.jsp");
				xReq.setCallback (ajaxRespIntr.onSaveIntr, ajaxRespIntr.onFail,
													ajaxRespIntr, null);
			}
		}
												
		xReq.setPostdata (postData);
//		if (confirm(postData))
			xReq.startReq();
			
/*			
			if (operation == 'upd' || operation == 'UPD')
				form.action = "ajax/upditem.jsp";
				
			if (operation == 'new' || operation == 'NEW')
				form.action = "ajax/saveitem.jsp";
			
			form.submit();*/
		
	};
	
	
/****************************************************************************
 * Event handler for doubleclick on a item from a list. It can be a list of 
 * prjtions of items. There is difference if the type of element is prjtion or
 * an item: for a prjtion, the details (item children) are displayed; for an
 * element, the editelem.jsp page is displayed in order to be able to update the
 * element 
 */	
	var goItemProps = function (theId, type) {
		var goTo;
		
		if (type == 'int')
			goTo = 'index.jsp?op=det&t='+type+'&frmid='+theId;
/*		
		else
	// here op=upd is used in order to display the editelem.jsp
	// with all item properties
			goTo = 'index.jsp?op=upd&t='+type+'&frmid='+theId;
*/			
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
		
		if (type == 'int')
			goTo = './index.jsp?op=det&t='+type+'&frmid='+selectedVal;
/*		
		else
	// here op=upd is used in order to display the editelem.jsp
	// with all item properties
			goTo = 'index.jsp?op=upd&t='+type+'&frmid='+theId;
*/			
//		if (confirm (goTo));
			document.location.href = goTo;
//		alert ('redirect to -> '+selectedVal);		
	};
	
	
/**
 * 
 */	
	var onCancelEdit = function (theForm) {
		if (confirm ("Are you sure you want to cancel the interview edition?"))
			document.location.href = "index.jsp?t=prj&op=det&frmid="+theForm.spid.value;
//      self.history.back();
	};
	
	
	
	var onCheckSample = function (theForm) {
		var subjChk = theForm.elements['chkCrtSubj'];
		var shortChk = theForm.elements['chkShort'];
		var thisChk = theForm.elements['chkSample'];
		
		subjChk.disabled = thisChk.checked? true: false;
		shortChk.disabled = thisChk.checked? true: false;
		
		shortStatus = thisChk.checked? shortChk.checked: shortStatus;
		shortChk.checked = thisChk.checked? false: shortStatus;
	}
	
	
/**
 * Emit an ajax call in order to rearrange the prjtions within the interview
 */	
	var onRearrange = function (theList) {
		var postData = "t=int&newOrder=";
		
		for (i=0; i<theList.options.length; i++) {
			postData += theList.options[i].value+",";
		}

		postData = postData.substring(0, postData.length-1);
//alert(postData);
		document.location.href = "ajax/rearrange.jsp?"+postData;		
	};
	
	
/**
 * move the selected item in the list one position down
 */	
	var moveDown = function (theList) {
// alert (theList.options[theList.selectedIndex].value);		
	};
	

/**
 * move the selected item in the list one position up
 */		
	var moveUp = function (theList) {
//alert (theList.options[theList.selectedIndex].value);		
	};
	
	
	return {
		init: init,
		goItemProps: goItemProps,
		goItem: goItems,
		listInterviews: listInterviews,
		onCancelEdit: onCancelEdit,
		chkNewIntr: chkNewIntr,
		chkSample: onCheckSample
	}
	
}


isintrFormCtrlLoaded = true;
