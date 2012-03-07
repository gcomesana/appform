/**
 * AjaxResponses
 * This class encapsulates the response methods for the ajax requests...
 */

var AjaxResponses = {
	onFail: function (o) {
// Access the response object's properties in the
// same manner as listed in responseSuccess( ).
// Please see the Failure Case section and
// Communication Error sub-section for more details on the
// response object's properties.
		var msg = o.responseText;
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	},
	
	
/**
 * Ajax response handler
 */	
	onItems4Sec: function (o) {
		containers = document.forms[0].frmNewParent;
		
		try {
			var items = YAHOO.lang.JSON.parse(o.responseText);		
			
alert ("removing "+containers.options.length+" elems before adding...");			
			for (var i=containers.options.length; i>0; i--) {
				containers.remove(i);
			}
			
			for (i=0; i<items.length-1; i++) {
				itemId = items[i].id;
				itemCont = items[i].content;
				
				newOp = new Option (itemCont, itemId);
				containers.add (newOp, null);
			}
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	},
	
	
/**
 * Ajax resonse for the request of item deleting.
 * The response is a json string with the structure:
 * {"res":1,"frmid":234,"msg":"ok"}
 */	
	onDelItem: function (o) {
		try {
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var myId = resp.frmid;		
			var myForm = document.forms[0];
			var myList = myForm.elements['frmListItems'];
				
// just remove the element from the list elements...			
			for (var i=0; i<myList.length; i++) {
				if (myList.options[i].value == myId) {
					myList.remove(i);
					break;
				}
			}
			
			alert ("The element was deleted");
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	},
	
	
	
	onSaveitem: function (o) {
		alert ("saveitem was ok");
	}
	
};
// END OF AJAXRESPONSE ///////////////////////////////////////////////////
