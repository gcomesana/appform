
/****************************************************************************
 **************************************************************************** 
 * AJAXRESPONSE INNERCLASS TO RESPONDE THE AJAX REQUESTS TO PERFORM
 * CRUD OPERATIONS
 */	

var ListAjaxResponse = function () {
	
/****************************************************************************
 * Response handler on error state
 */	
	var onFail = function (o) {
    overlay.hide ();
// Access the response object's properties in the
// same manner as listed in responseSuccess( ).
// Please see the Failure Case section and
// Communication Error sub-section for more details on the
// response object's properties.
		var msg = o.responseText;
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	};
	
	
	
/***************************************************************************
 * Response handler to delete an item from the items list
 */	
	var onArrangeItems = function (o) {
// alert ("ListAjaxResponse.onArrangeItems before overlay.hide()");    
    overlay.hide ();
		try {
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;
			
			if (result == 1)
				alert ("Reordering was successful");
			else
				alert ("Reordering could not be performed");
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	};
	
	
	
	
/**
 * This is the callback method to get back the server answer upon request for
 * removing an item
 * @param {Object} o
 */
	var onChkRmvItem = function (o) {
		overlay.hide();
		try {				
			var resp = YAHOO.lang.JSON.parse(o.responseText);
      if (resp.res == 3) // no permission to delete
        alert(resp.msg);
				
			else if (resp.res == 1) // items already deleted
				onDelItem (o);
			
			else { // is admin but the item has answers, so confirm deletion
				if (confirm (resp.msg)) {
					var xReq = new AjaxReq ();
					
					var postdata = "what=rmvElem&frmid="+resp.frmid;
					xReq.setUrl (APPNAME+"/servlet/AjaxUtilServlet");
					xReq.setMethod("POST");
					xReq.setPostdata(postdata);
					xReq.setCallback (onDelItem, onFail, this, null);
		
		// alert ("listitemctrl.delitem: "+xReq.getPostdata());			
					xReq.startReq();
					
				} // EO if confirm
			} // EO else
		} // EO try
		catch (exp) {
			alert ("JSON Parse failed!");
			return;
		}
	}
	
	
	
	
	var onDelItem = function (o) {
    overlay.hide();
		try {				
			var resp = YAHOO.lang.JSON.parse(o.responseText);
      if (resp.res == 0) 
        alert(resp.msg);
      
      else {
        var myId = resp.frmid;
        var sons = null;
        var myForm = document.forms[0];
        //				var myList = myForm.elements['frmListItems']; 
        var myList;
        
        if (resp.sons != undefined)
          sons = resp.sons;
        for (var i = 0; i < myForm.elements.length; i++) {
          if (myForm.elements[i].name.indexOf("List", 0) != -1) {
            myList = myForm.elements[i];
            break;
          }
        }
// alert("just remove the element from the list elements...");		
					
        for (var i = 0; i < myList.length; i++) {
          if (myList.options[i].value == myId) {
            myList.remove(i);
//            break;
          }
          if (sons != undefined && sons != null)
            if (sons.indexOf (myList.options[i].value) != -1)
//              myList.options[i].setAttribute('class', '');
							myList.remove(i);
        }
				
        alert(resp.msg);
      }
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	};
	
	
	return {
		onFail: onFail,
		onArrangeItems: onArrangeItems,
		onDelItem: onDelItem,
		onChkRmvItem: onChkRmvItem
	}
	
};






/****************************************************************************
 ****************************************************************************/
/****************************************************************************
 * ListItemsCtrl class
 * This class controls the list of items in detailsec.jsp
 */
var ListItemsCtrl = function () {
  var submitAction = "index.jsp";
  var submitMethod = "POST";
  var submitParams = "";
  
  var ajaxResp; // the ajax response handler
  var xReq; // the ajax connection manager "class"
  
// this is a switch to check if the items have been moved	
	var itemMove = 0; // 0, nothing was moved; otherwise is 1
	
	
	  
/****************************************************************************
 * Response method on button update clicked
 */	  
  function updItem (theForm, type, secId) {
  	var listItems = theForm.frmListItems;
  	var itemId = -1;
  	var urlUpd = "index.jsp?t="+type+"&op=upd&spid="+secId;
		
	  for (var i=0; i < listItems.options.length; i++) {
	  	if (listItems.options[i].selected) {
	  		itemId = listItems.options[i].value;
	  		break;
	  	}
	  }
	  
	  if (itemId == -1) {
	  	alert ("An element from the list must be selected");
	  	return;
	  }
	  
	  urlUpd += "&frmid="+itemId;
		document.location.href = urlUpd;
	  
/*  	
    theForm.action = "upditem.jsp";
  	theForm.method = submitMethod;
  	
  	selIndex = theForm.frmListItems.selectedIndex;
  	theForm.op.value = "upd";
		theForm.frmid.value = theForm.frmListItems.options[selIndex].value;
alert ("goUpdItem: id="+theForm.frmid.value);
		theForm.submit();
*/		
  };
  
  
  
/****************************************************************************
 *	go for an item creation
 */  
  function newItem (theForm, type, secId) {
// ahora aqua y en el del hay que incluir la seccion de alguna manera
// y el contenedor tambien...
  	document.location.href = "index.jsp?t="+type+"&op=new&spid="+secId;  	
  };
  
  
	
	
/****************************************************************************
 * go for an item deletion
 */  
  function xdelItem (theForm, type) {
  	
  	if (confirm("Are you sure you want to delete the element?")) {
	  	listItems = theForm.frmListItems;
	  	itemId = listItems.options[listItems.selectedIndex].value;
	  	
	 
			xReq.setUrl ("ajax/delitem.jsp");
			xReq.setPostdata("t="+type+"&frmid="+itemId);
			xReq.setCallback (ajaxResp.onDelItem, ajaxResp.onFail, ajaxResp, null);

// alert ("listitemctrl.delitem: "+xReq.getPostdata());			
			xReq.startReq();
  	}
  	
  }
	
	
	
	
	function delItem (theForm, type) {
		if (type != "ele")
			xdelItem (theForm, type);
			
		else {
			if (confirm("Are you sure you want to delete the element?")) {
		  	listItems = theForm.frmListItems;
		  	itemId = listItems.options[listItems.selectedIndex].value;
		  	
		 
				xReq.setUrl (APPNAME+"/servlet/AjaxUtilServlet");
				xReq.setMethod("POST");
				xReq.setPostdata("what=chkRmvElem&t="+type+"&frmid="+itemId);
				xReq.setCallback (ajaxResp.onChkRmvItem, ajaxResp.onFail, ajaxResp, null);
	
	// alert ("listitemctrl.delitem: "+xReq.getPostdata());			
				xReq.startReq();
	  	}
		}
	}
  
  
/**
 * Event handler for doubleclick on a item from a list. It can be a list of 
 * sections of items. There is difference if the type of element is section or
 * an item: for a section, the details (item children) are displayed; for an
 * element, the editelem.jsp page is displayed in order to be able to update the
 * element 
 */	
	var goItemProps = function (theId, type) {
		var goTo = 'index.jsp?op=det&t='+type+'&frmid='+theId;
/*		
		if (type == 'sec')
			goTo = 'index.jsp?op=det&t='+type+'&frmid='+theId;
		
		else
	// here op=upd is used in order to display the editelem.jsp
	// with all item properties
			goTo = 'index.jsp?op=upd&t='+type+'&frmid='+theId;
*/			
			document.location.href = goTo; 	
	}  
  
  
  
  var goItems = function (selName, type) {
		var sel = document.getElementById(selName);
		if (sel.selectedIndex == undefined ||
        sel.selectedIndex < 0) {
        alert ("An element from the list must be selected");
        return;
    }
        
		var selectedVal = sel.options[sel.selectedIndex].value;
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
 * Emit an ajax call in order to rearrange the sections within the interview
 */	
	var onRearrange = function (theList, type) {
		// no rearrange if nothing was moved
		if (itemMove == 0)
			return
			
		var postData = "t="+type+"&newOrder=";
		for (i=0; i<theList.options.length; i++) {
			postData += theList.options[i].value+",";
		}

		postData = postData.substring(0, postData.length-1);
//		document.location.href = "ajax/rearrange.jsp?"+postData
	 	xReq.setUrl ("ajax/rearrange.jsp");
		xReq.setMethod ("POST");
		xReq.setPostdata(postData);
		xReq.setCallback (ajaxResp.onArrangeItems, ajaxResp.onFail,
											ajaxResp, null);

		xReq.startReq();
// reset the itemMove as all items are to be arranged after this method			
		itemMove = 0;
	}
	
	
	
	
/**
 * move the selected item in the list one position down
 */	
	var moveDown = function (theList) {
// alert (theList.selectedIndex);
		
		if (theList.selectedIndex < theList.options.length && 
				theList.selectedIndex >= 0 && theList.options.length > 1) {
			
			var selIndex = theList.selectedIndex;
			if (selIndex < theList.options.length) {
				var elem = theList.options[selIndex];
				var aux = theList.options [selIndex+2];
 				
 				theList.remove (selIndex);
 				if (BrowserDetect.getBrowser() == "Firefox")
 					theList.add (elem, aux);
 				else if (BrowserDetect.getBrowser() == "Explorer")
 					theList.add(elem, selIndex+1); // for ie
 					
				itemMove = 1;
			}
		}
	}
	
	
/**
 * move the selected item in the list one position up
 */		
	var moveUp = function (theList) {
		if (theList.selectedIndex < theList.options.length && 
				theList.selectedIndex >= 0 && theList.options.length > 1) {
			var selIndex = theList.selectedIndex;
			
			if (selIndex > 0) {
				var elem = theList.options[selIndex];
				var aux = theList.options [selIndex-1];
				
				theList.remove (selIndex);
				if (BrowserDetect.getBrowser () == "Firefox")
					theList.add(elem, aux);
				else if (BrowserDetect.getBrowser() == "Explorer")
 					theList.add(elem, selIndex+1); // for ie
 					
				itemMove = 1;
			}
		}
	}  
  
  


  var moveGrpUp = function (theList) {
    if (theList.selectedIndex < theList.options.length && 
				theList.selectedIndex >= 0 && theList.options.length > 1) {
      if (theList.selectedIndex > 0) {
  			var minSel = theList.selectedIndex;
        var maxSel = minSel;
        while (theList.options[maxSel].selected && maxSel < theList.length-1)
          maxSel++;
        
        var prevOpt = theList.options[minSel-1];
        var firstOpt = theList.options[minSel];
        var lastOpt = theList.options[maxSel];
        
        theList.remove (minSel-1);
        if (BrowserDetect.getBrowser () == "Firefox") {
  				if (maxSel == theList.length)
            theList.add(prevOpt, null);
          else
            theList.add(prevOpt, lastOpt);
          
        }
  			else if (BrowserDetect.getBrowser() == "Explorer") {
          if (maxSel == theList.length)
            theList.add (prevOpt);
          else
  				  theList.add(prevOpt, maxSel); // for ie
  			}
				
				itemMove = 1;
  		}
      
    }
  }
  
  
  
  var moveGrpDown = function (theList) {
    if (theList.selectedIndex < theList.options.length && 
				theList.selectedIndex >= 0 && theList.options.length > 1) {
			if (theList.selectedIndex < theList.options.length-1) {
        var minSel = theList.selectedIndex;
        var maxSel = minSel;
        while (theList.options[maxSel].selected && maxSel < theList.length-1)
          maxSel++;
        
  //      var prevOpt = theList.options[minSel-1];
        var firstOpt = theList.options[minSel];
        var lastOpt = theList.options[maxSel];
        
        
        if (BrowserDetect.getBrowser () == "Firefox")
  				theList.add(lastOpt, firstOpt);
  			else if (BrowserDetect.getBrowser() == "Explorer")
  				theList.add(lastOpt, minSel-1); // for ie
  //      theList.remove (maxSel);
	
				itemMove = 1;
      }
    }
    
  }
  
	
/**
 * Open a new window interview from the Perform/Preview interview on the left
 * side of the web page. The window is opened from here to be able to set
 * the real time switch if applicable
 */
	var raiseLeftIntrv = function (idintrv, sim) {
		var url = "intrv/index.jsp?intrv="+idintrv+"&grpdlg=1";
		var chkRT = document.getElementById('chkRT');
    if (sim == 1)
      url += "&sim=1";
      
		if (chkRT != undefined && chkRT.checked && sim != 1)
			url += "&rt=1";
			
//      self.open (url, "WinInterview");
		window.open(url, "WinInterview");
    return;
	}
  
	

/**
 * Open a new window navigator with the perview or the performance for the 
 * selected interview from the interview list
 * @param {Object} theList, the list of the interviews
 * @param {Object} sim, simulation flag: if 1, open a preview window; otherwise
 * open a window to perform an interview
 */  
  var raiseIntrv = function (selName, sim) {
    var theList = document.getElementById(selName);
		var chkRT = document.getElementById('chkRT');
        
    if (theList.selectedIndex >= 0) {
      var idIntrv = theList.options[theList.selectedIndex].value;
      var url = "intrv/index.jsp?intrv="+idIntrv+"&grpdlg=1";
      if (sim == 1)
        url += "&sim=1";
        
			if (chkRT != undefined && chkRT.checked && sim != 1)
				url += "&rt=1";
				
//      self.open (url, "WinInterview");
			window.open(url, "WinInterview");
      return;
    }
    else {
      alert ("An element from the list must be selected");
      return;
    }
      
  }
  
  
/***************************************************************************
 * This method functions as a constructor. Mainly, it is used to initialize
 * the ajax response handler
 */  
  var init = function () {
  	xReq = new AjaxReq ();
  	xReq.setMethod("POST");
  	
  	ajaxResp = new ListAjaxResponse ();
  }
  
  
  
/**
 * go for an item deletion
 *
  function delItem (theForm) {
  	theForm.action = "delitem.jsp";
  	theForm.method = submitMethod;
  	
  	selIndex = theForm.frmListItems.selectedIndex;
  	theForm.op.value = "del";
		theForm.frmid.value = theForm.frmListItems.options[selIndex].value;
alert ("goDelItem: id="+theForm.frmid.value);
		theForm.submit();
  };
*/  
  
  return {
// public: private
  	goNewItem: newItem,
  	goUpdItem: updItem,
  	goDelItem: delItem,
  	
  	onRearrange: onRearrange,
//  	moveDown: moveDown,
//  	moveUp: moveUp,
    moveUp: moveGrpUp,
    moveDown: moveGrpDown,
  	
    raiseIntrv: raiseIntrv,
		raiseLeftIntrv: raiseLeftIntrv,
  	goItemProps: goItemProps,
  	goItem: goItems,
  	init: init
  }

};


isListItemCtrlLoaded = true;