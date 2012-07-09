var intrvFormCtrl;
var overlay;


/**
 * Constructor for the object
 * @param {Object} intrvId, the interview id
 * @param {Object} rt, real time switch (always 1)
 * @param {Object} preview, 1 for preview action, 0 for performing action
 * @param {Object} to, the timeout to automatically save current section answers
 * in the case of session expiration
 */
ControlForms = function(intrvId, rt, preview, to){
	//  this.overlay = new Overlay();
	this.ajaxResp = new IntrvAjaxResponse();
	
	// sign up as a listener for the events fired by the ajaxResp object
	//    ajaxResp.subscribeSecs (this.loadForm, this);
	//    ajaxResp.subscribeForm (this.loadSection, this);
	this.ajaxResp.subscribeSecs(this.testEvent, this);
	this.ajaxResp.subscribeForm(this.onFormComplete, this);
	
	this.intrvId = intrvId;
	this.numbersOk = true;
	this.realtime = rt;
	this.preview = preview == undefined? 0: preview;
	
	this.pauseIntrv = 0;
	this.lastSection = 1;
	
	this.timeout = to
	
	this.sending = false // this is a switch to avoid multiple simultaneous sends
//	setTimeout (this.endSession, this.timeout/2, this)
	
}


ControlForms.prototype.init = function (intrvId) {
//  this.intrvId = intrvId;
	this.sending = false
// console.info("ControlForms.init: sending is: "+this.sending)
	
	$("#toolDiv").css("visibility", "hidden");
	$("#listLabs").change (function () {
// alert ("binding change with intrvFormCtrl.changeGroup");

		return intrvFormCtrl.changeGroup ();
	});
}




ControlForms.prototype.endSession = function (thisObj) {
console.log ("ControlForms.prototype.endSession => end session...")
	var myForm = $('#sectionForm')[0];
	var endingSec = $('#currentsec')[0];

	if (myForm == undefined) {
		window.self.close();
		return;
	}
		
  myForm.elements['finish'].value = "1";
// creates a new hidden element to hold the last section visited
  var lastSec = document.createElement("input");
  lastSec.setAttribute("type", "hidden");
  lastSec.setAttribute("name", "frmLastSec");
  lastSec.setAttribute("value", endingSec);    
  myForm.appendChild (lastSec);
  
	thisObj.pauseIntrv = 1;
	
  return thisObj.send(myForm, 0, false);
	
}



/**
 * This is a method to response the change events over the list groups
 */
ControlForms.prototype.changeGroup = function () {
	var optSel = $("#listLabs option:selected");
	var grpId = $(optSel).val();
	
	var postdata;
  var xReq = new AjaxReq ();
	xReq.setMethod ("POST");
  
  xReq.setUrl (APPNAME+"/servlet/MngGroupsServlet");
 
  xReq.setPostdata("grpid="+grpId);
	xReq.setCallback (this.ajaxResp.onGrpChanged, this.ajaxResp.onFail,
										this.ajaxResp, null);
	xReq.startReq();
}



ControlForms.prototype.chkLabel = function (label) {
     
}


/**
 * Check a integer to be a correct answer in form and ranges
 * @param {Object} text, the value of the textfield
 * @param {Object} min, the minimum value allowed
 * @param {Object} max, the maximum value allowed
 * @param {Object} exc, the allowed exceptions
 * 
 * Return true if the text is a valid number
 */
ControlForms.prototype.chkNumber = function (text, min, max, exc) {
// alert ("chkNumber: "+text.name);
  var numRegExp = /^\d*$/g;
  var res = text.value.search(numRegExp); 
	this.numbersOk = true;
	var exceptVal = false; // true if value is an exception, false otherwise
  
// check if text.value is a number   
  if (res == -1) {
    alert("A number has to be introduced instead "+text.value);
    text.value = "";
		this.onInputErr(text.name);
	
    this.numbersOk = false;
    return false;
  }
  var myVal = parseInt (text.value, 10);
   
// check if text.value is the exception or falls between min and max
  var exceptions = exc.split(',');
  var k;
  for (k=0; k<exceptions.length; k++) {
    var myExc = parseInt (exceptions[k]);
    if (isFinite(myExc)) {
      if (myVal == myExc) {
				exceptVal = true;
        break; // at least, the introduced value is the exception
//				return false;
			}
    }
  }
  
  var myMin = parseInt (min, 10);
  if (isFinite(myMin) && exceptVal == false) {
    if (myVal < myMin) {
      alert ("Value below range: "+myVal+" < "+myMin);
      text.value = "";
			this.onInputErr (text.name);
			
			this.numbersOk = false;
      return false;
    }
  }
  
  var myMax = parseInt (max, 10);
  if (isFinite(myMax) && exceptVal == false) {
    if (myVal > myMax) {
      alert ("Value over range: "+myVal+" > "+myMax);
      text.value = "";
			this.onInputErr (text.name);
			
			this.numbersOk = false;
      return false;
    }
  }
  
	if (this.numbersOk == true) {
		this.onBlur(text.name);
	}
	else {
		text.focus();
	}
	
	return true;
}



/**
 * Check a decimal to be a correct answer in form and ranges
 * @param {Object} text, the value of the textfield
 * @param {Object} min, the minimum value allowed
 * @param {Object} max, the maximum value allowed
 * @param {Object} exc, the allowed exceptions
 * 
 * Return true if the text is a valid decimal number
 */
ControlForms.prototype.chkDecimal = function (text, min, max, exc) {
  var numRegExp = /^[-+]?\d*\.?\d*$/g;
  var res = text.value.search(numRegExp);
	var exceptVal = false; // true if value is an ecxception, false otherwise
   
  if (res == -1) {
    alert("A decimal number has to be introduced instead "+text.value);
    text.value = "";
		this.onInputErr(text.name);
     
    return;
  }
  var myVal = parseFloat (text.value);
   
// check if text.value is the exception or falls between min and max
  var exceptions = exc.split(',');
  var k;
  for (k=0; k<exceptions.length; k++) {
    var myExc = parseFloat (exceptions[k]);
    if (isFinite(myExc)) {
      if (myVal == myExc) {
				exceptVal = true;
				break; // the value is the same as the exception
//				return false;
			}
    }
  }
  
  var myMin = parseFloat (min);
  if (isFinite(myMin) && exceptVal == false) {
    if (myVal < myMin) {
      alert ("Value below range: "+myVal+" < "+myMin);
      text.value = "";
			this.onBlur(text.name);
//      return;
			return false;
    }
  }
  
  var myMax = parseFloat (max);
  if (isFinite(myMax) && exceptVal == false) {
    if (myVal > myMax) {
      alert ("Value over range: "+myVal+" > "+myMax);
      text.value = "";
			this.onBlur(text.name);
//      return;
			return false;
    }
  }
  
	this.onBlur(text.name);
	return true;
}



/**
 * This method checks every mandatory question is answered.
 * Mandatory questions are rendered with the special attribute must="1"
 * Returns true if all mandatory items are answered; false otherwise
 */
ControlForms.prototype.chkMandatory = function () {
	var success = true;
	var mustElems = $('[must=1]');
	var myCtrlForms = this;
	
	if (this.preview == 0) {
		$(mustElems).each (function (index) {
			if (this.tagName.toLowerCase() == 'input' || 
					this.tagName.toLowerCase() == 'textarea') {
				if ($(this).val() == '') {
					// mark with red border
					myCtrlForms.onInputErr ($(this).attr('name'));
					success = false;
				}
			}
			else if (this.tagName.toLowerCase() == 'select') {
				if ($(this).val () == '9999') {
					myCtrlForms.onInputErr ($(this).attr('name'));
					success = false;
				}
			}
					
		});
	}
	
	return success;
}



/**
 * Method associated to the onfocus event of a textfield component. Highlight the
 * textfield when it gets the focus
 * @param {Object} textName, the name of the textfield component
 */
ControlForms.prototype.onfocus = function (textName) {
	var text = document.getElementsByName(textName);
	text[0].style.border = "3px solid yellow"
	text[0].style.background = "white";
	text[0].style.color = "black";
	
	$("div#errMsg").text("");
}



/**
 * Method associated to the onblur event of a textfield component. Un-highlight the
 * textfield when it loses the focus
 * @param {Object} textName, the name of the textfield component
 */
ControlForms.prototype.onBlur = function (textName) {
	var text = document.getElementsByName(textName);
	text[0].style.border = "1px solid darkblue";
	text[0].style.background = "white";
	text[0].style.color = "black";
	
	var theVal = text[0].value;
}


/**
 * This method set an error color on a textbox with some previous input err
 * @param {Object} textName, the html component with the err
 */
ControlForms.prototype.onInputErr = function (textName) {
	var text = document.getElementsByName(textName);
	
	text[0].style.border = "3px solid red";
	text[0].style.background = "#FFCC99";
}





/**
 * A method to show a tooltip when mouse over a listbox component
 * @param {Object} option, an option element
 */
ControlForms.prototype.showTooltip = function (option) {
	var toolDiv = $("#toolDiv");
	var posx = getMouseCoord (null, x), posy = getMouseCoord (null, y);
	
	$(toolDiv).html("<b>"+option.text+"</b>");
	$(toolDiv).height(10);
	$(toolDiv).width(option.text.length()*5);
	
	$(toolDiv).position ({left:posx,top:posy});
	$(toolDiv).css ("visibility", "visible");
}



/**
 * Get the mouser coordinates
 * @param {Object} e, the event, which can be a window event
 * @param {Object} what, if return the x or y coordinates
 */
function getMouseCoord (e, what) {
  var posx = 0;
  var posy = 0;
	
  if (!e) 
    var e = window.event;
		
  if (e.pageX || e.pageY) {
    posx = e.pageX;
    posy = e.pageY;
  }
  else if (e.clientX || e.clientY) {
    posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
    posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
  }
//You have the coordinates in the posx and posY variables
//You can do whatever you want with them after this point

	return (what.toLowerCase() == 'x')? posx: posy;
}



/**
 * Control to validate the first section questionnaire of the interview
 * @param {Object} theForm, a reference to the form
 */
ControlForms.prototype.chkIntroForm = function (theForm) {
  var elems = theForm.elements;
   var i, patCodeElem;
// get the first textfield element, which will have to be the patient code     
   for (i=0; i<elems.length; i++) {
//     if (elems[i].getAttribute("type") == "select-one") {
		 if (elems[i].type == "select-one") {
       patCodeElem = i;
       break;
     }
   }
   
// check if the patient code is semantically correct
	 var hospCod = theForm.hospCod.value;
	 var caseControl = elems[i].value;
	 var subjCode = elems[i+1].value;
/*
	 var patCode1 = elems[i].value;
	 var caseControl = patCode1.substring(2,3);
	 patCode1 = patCode1.substring(0,2)
	 if (patCode1 != hospCod) {
	 	var msg = "Patient code incorrect. Two first HOSPITAL CODE digits wrong: ";
		msg += patCode1 + " (It should be "+hospCod+")";
		 
	 	alert (msg);
		return false;
	 }
*/	 
	 if (caseControl != 1 && caseControl != 2) {
	 	var msg = "Patient code incorrect. Third number has to be 1 (for cases) or ";
		msg += "2 (for controls)";
		 
	 	alert (msg);
		return false;
	 }	 
	 
	 if (subjCode.length != 3) {
	 	var msg = "Subjec code has to be exactly 3 character long";
		alert (msg);
		
		return false;
	 }
	 	
   if (elems[i].value != elems[i+2].value ||
	 		 elems[i+1].value != elems[i+3].value || 
       elems[i].value == -1 || elems[i+2].value == -1 ||
			 elems[i+1].value.length == 0 || elems[i+3].value.length == 0) {
     alert ("Both patient codes must match and they can not be empty");
     return false;
   }

   return true;
}
  


/**
 * Somethingx more...
 * This method sends the item value to be processed by a servlet. It is the 
 * real time answer sending implementation. First the method check the value
 * of the item and, if it is ok, send them to servlet for processing
 * @param {Object} type, sets the type (number or decimal) for the item. The
 * convention for the values of this parameter is:<br/>
 * <ul>
 * <li>D (for decimal)</li>
 * <li>N (for number)</li>
 * </ul> 
 * @param {Object} item, the item just answered
 * @param {Object} min, minimum value for this item, if applicable
 * @param {Object} max, maximum value for this item, if applicable
 * @param {Object} exc, exception value(s) for this item, if applicable
 */
ControlForms.prototype.sendItem = function (type, item, min, max, exc) {
	var valOk = true;
	var xReq  = new AjaxReq ();
	var postdata = "";
	var itemName, itemVal;
	
	if (item.getAttribute("type") == "text") {
		if (type == "D")
			valOk = this.chkDecimal(item, min, max, exc);
		
		if (type == "N")
			valOk = this.chkNumber(item, min, max, exc);
			
		itemVal = item.value;
	}
	else { // this would be a select
		itemVal = item.options[item.selectedIndex].value;
// alert ("<select>: "+item.getAttribute('name')+": "+itemVal);
	}
	
	if (valOk) {
		var patId = $('#patId').val();
		itemName = item.getAttribute('name');
		
		postdata = "what=perf&q=" + itemName + "&val=" + itemVal;
		postdata += "&patid=" + patId;
		
		xReq.setMethod("POST");
		xReq.setUrl(APPNAME+"/servlet/AjaxUtilServlet");
		
// qString has the form 'what=perf&q=qNNNN-O-G&val=23556&patid=2356'
		xReq.setPostdata(postdata);
		xReq.setCallback(this.ajaxResp.onSaveItem, this.ajaxResp.onFail, this.ajaxResp, null);
		xReq.startReq(0); // no overlay in this case
		

		this.onBlur(item.getAttribute('name'));
	}
	
}




/**
 * Send the content of the justification textarea component to server when on
 * autosaving mode
 * @param {Object} txtarea
 */
ControlForms.prototype.sendJustification  = function (txtarea, patid, intrvid) {
	
	if (txtarea.value != '') {
		var postdata;
		
		var xReq = new AjaxReq ();
		xReq.setMethod ("POST");
		xReq.setUrl (APPNAME+"/servlet/IntrvServlet");
		
		postdata = "what=save_just&txt=";
		postdata += encodeURIComponent(txtarea.value);
		postdata += "&patid="+patid+"&intrvid="+intrvid;
		xReq.setPostdata (postdata);
		xReq.setCallback(this.ajaxResp.onSaveItem, this.ajaxResp.onFail, this.ajaxResp, null);
		
		xReq.startReq (0);
		
//		this.onBlur (item.getAttribute('name'));
	}		
}



/**
 * send method
 * Sends the forms to the server scripts doing a check in advance.
 * @param {Object} theForm, the reference to the form in the web page
 * @param {Integer} fromSectionClick, optional parameter to indicate if
 * the send comes from a click in a section or from a page unload event
 * @param {Boolean} showDlg, sets if the dialog to confirm saving data is raised or not
 * 
 * @return true if the everygthing is ok and the request is sent to server;
 * otherwise the method return false
 */
ControlForms.prototype.send = function (theForm, fromSectionClick, showDlg) {
// console.info ("ControlForms.send: sending is "+this.sending)
	if (this.sending == true)
		return;
		
// this.sending = true
	
	if (this.chkMandatory() == false) {
		alert ("There are items (red higlighted) which have to be answered");
		return false;
	}
	
	if (this.numbersOk == true) {
		var xReq = new AjaxReq();
		xReq.setMethod("POST");
		
		xReq.setUrl("ajaxjsp/saveintro.jsp");
		
		if (theForm.name.toUpperCase() == "INTROFORM") {
			xReq.setUrl("ajaxjsp/saveintro.jsp");
		}
		else if (theForm.name.toUpperCase() == "SECTIONFORM") {
				//      outForm (theForm);
			xReq.setUrl("ajaxjsp/saveform.jsp");
		}
			
		else // default
			xReq.setUrl("ajaxjsp/saveform.jsp");
		
		
		xReq.setForm(theForm);
		xReq.setCallback(this.ajaxResp.onSaveForm, this.ajaxResp.onFail, this.ajaxResp, null);
		if (showDlg) {
			var msgDlg = ""
			msgDlg = fromSectionClick? "Confirm these data before going to clicked section?":
																"Are you sure to confirm these data?"
/*																
			if (fromSectionClick)
				msgDlg = "Confirm these data before going to clicked section?";
			else
				msgDlg = "Are you sure to confirm these data?"
*/						

			if (confirm (msgDlg)) {
				xReq.startReq();
				this.sending = true
				return true;
			}
			else
				return false;
		} // EO if showDlg
		else {
			this.sending = true
			xReq.startReq()
		}
		
		
// This is to be aware when the interview is paused or finished in order to be
// able to change the group
		if (this.pauseIntrv == 1) {
			var spanTag = $('#grpSpan');
//			$('#grpSpan').add("a").attr("href", "setprimarygrp.jsp?typegroup=SEC").add('id', 'linkGrp');
			var spanLnk = '<a href="setsecondarygrp.jsp?typegroup=SEC" id="linkGrp">'+
										$(spanTag).html()+'</a>';
			$(spanTag).html(spanLnk);
		}
		
		return false;
	}
}




/**************************************************************************
 * This method just finish this interview and gets another one but
 * without saving any data as it is intended to be used when some coordinator
 * is checking interviews
 * @param {Object} theForm
 */
ControlForms.prototype.nextCheck = function () {
	var postdata;
  var xReq = new AjaxReq ();
	xReq.setMethod ("GET");
  
  xReq.setUrl("ajaxjsp/nextcheck.jsp");
 
  xReq.setPostdata("");
	xReq.setCallback (this.ajaxResp.onSaveForm, this.ajaxResp.onFail,
										this.ajaxResp, null);
	xReq.startReq();
}




/**************************************************************************
 * Finish the interview for this session. To do that, all session variables 
 * except the user, the interview and groups, have to be invalidated
 * @param {Object} theForm
 */  
ControlForms.prototype.finish = function (theForm, lastSec) {
/*    
    var theDoc = theForm.ownerDocument;
    var endHidden = theDoc.createElement('input');
    endHidden.type = 'hidden ';
    endHidden.name = 'finish';
    endHidden.value = '1';
    theForm.appendChild (endHidden);
*/

	if (theForm == undefined) {
		window.self.close();
		return;
	}
		
	if (this.chkMandatory() == false) {
		alert ("There are items (red higlighted) which have to be answered");
		return false;
	}
	
  if (confirm("Are you sure to finish/interrupt this interview?")) {
		
    theForm.elements['finish'].value = "1";
// creates a new hidden element to hold the last section visited
    var lastSec = document.createElement("input");
    lastSec.setAttribute("type", "hidden");
    lastSec.setAttribute("name", "frmLastSec");
    lastSec.setAttribute("value", lastSec);    
    theForm.appendChild (lastSec);
    
		this.pauseIntrv = 1;
		
    return this.send(theForm, 0, true);
  }
}




ControlForms.prototype.prevForm = function (secId, patId) {
  var postdata;
  var xReq = new AjaxReq ();
	xReq.setMethod ("GET");
  
  xReq.setUrl("ajaxjsp/prevform.jsp");
 
  xReq.setPostdata("secId="+secId+"&patId="+patId);
	xReq.setCallback (this.ajaxResp.onPrevForm, this.ajaxResp.onFail,
										this.ajaxResp, null);
	xReq.startReq();
}



/**
 * getForm method
 * Makes an ajax petition to get the form for the section with id secId
 * @param {Object} secId, the id of the section which contains the form
 */    
ControlForms.prototype.getForm = function (idSec) {
    
    var xReq = new AjaxReq ();
		xReq.setMethod ("GET");
    
//      outForm (theForm);
    xReq.setUrl("ajaxjsp/items4sec.jsp");
   
//		xReq.setPostdata("frmid="+intrvId);
// alert ("getForm - Sending and applying theForm: realtime="+this.realtime);
    xReq.setPostdata("frmid="+secId+"&rt="+this.realtime);
		xReq.setCallback (this.ajaxResp.onGetForm, this.ajaxResp.onFail,
											this.ajaxResp, null);
		xReq.startReq();
}



/**
 * loadSection ()
 * Makes an ajax request to get the all sections for this interview template.
 */
ControlForms.prototype.loadSection = function (intrvId) {
  var xReq = new AjaxReq ();
	xReq.setUrl ("ajaxjsp/secs4intrv.jsp");
	xReq.setMethod ("GET");
	xReq.setPostdata("frmid="+intrvId);
	xReq.setCallback (this.ajaxResp.onSecs4Intrv, this.ajaxResp.onFail,
										this.ajaxResp, null);
	xReq.startReq();
}



ControlForms.prototype.onFormComplete = function (type, args, me) {
// console.info ("controlForms.onFormComplete, before calling loadSec: sending is: "+me.sending) 
	me.sending = false 
  me.loadSection (me.intrvId);
}



/**
 * This method is called after clicking a section on the left of the interview
 * performance page.
 * saveform.jsp devuelve un res:0 si falla y el form if ok
 * @param {Object} myForm
 * @param {Object} secId
 */
ControlForms.prototype.saveOnSectionChange = function (myForm, theSecId, ctrlForms) {

//	console.info ("save values from form "+myForm.name) ;
//	return
	
	var onOk = function (o) {
		try {
			var result = YAHOO.lang.JSON.parse (o.responseText);
			if (result.res == 1)
				ctrlForms.loadRequestedForm (theSecId);
				
			else if (result.res == 0)
				alert ("Fail to save questions answers when selecting a section from left side");
		}
		catch (x) {
			alert ("Err: "+o.responseText);
		}
	}
	
	var xReq = new AjaxReq ()
	xReq.setUrl ("ajaxjsp/save-on-sectionchange.jsp")
	xReq.setMethod ("POST")
	xReq.setForm(myForm);
	xReq.setCallback(onOk, this.ajaxResp.onFail, this.ajaxResp, null);
	
	xReq.startReq();
}




ControlForms.prototype.loadRequestedForm = function (secId) {
	var xReq = new AjaxReq ();
	xReq.setUrl ("ajaxjsp/items4sec.jsp");
	xReq.setMethod ("GET");
// alert ("loadForm - Sending and applying theForm: realtime="+this.realtime);
	xReq.setPostdata("frmid="+secId+"&rt="+this.realtime);
	xReq.setCallback (this.ajaxResp.onItems4Sec, this.ajaxResp.onFail,
										this.ajaxResp, null);
	
	xReq.startReq();
}



/**
 * Makes an Ajax request to get all items for the section identified by secId.
 * In addition and previously, the data in the current form is set to server
 * in order to save the (potential) new data into the database
 * @param {Object} secId
 */
ControlForms.prototype.loadForm = function (secId) {

	// alert ("loadForm: About to get form for secId: "+secId+"!!!");
	if (this.chkMandatory() == false) {
		alert ("There are items (red higlighted) which have to be answered");
		return false;
	}

	var theForm = document.getElementsByTagName("form")
	if (theForm[0] != undefined) {
//		console.info ("this is the fucking form: "+theForm[0].name)
		this.saveOnSectionChange (theForm[0], secId, this)
	}
	else
		this.loadRequestedForm (secId)

	
/*		
  var xReq = new AjaxReq ();
	xReq.setUrl ("ajaxjsp/items4sec.jsp");
	xReq.setMethod ("GET");
// alert ("loadForm - Sending and applying theForm: realtime="+this.realtime);
	xReq.setPostdata("frmid="+secId+"&rt="+this.realtime);
	xReq.setCallback (this.ajaxResp.onItems4Sec, this.ajaxResp.onFail,
										this.ajaxResp, null);
	
	xReq.startReq();
*/
}





/**
 * It opens a new window to show the codes of the subjects who were interviewed
 * and belong to the current hospital
 */
ControlForms.prototype.getPatCodes = function () {
	var urlPage = "mycodes.jsp";
	var feats = "width=300,height=350,resizable=false,minimizable=false";
//    feats += ",resizable=false";
	
	window.open(urlPage, "patCodesWin", feats);
	return;
}




ControlForms.prototype.myCodes = function (intrvid, secGrpId) {
	var postdata = "what=cod&intrvid="+intrvid+"&secgrpid="+userid;

	var xReq = new AjaxReq ();
	xReq.setUrl ("mycodes.html");
	xReq.setMethod ("GET");
	xReq.setPostdata(postdata);
	xReq.setCallback (this.ajaxResp.onGetCodes, this.ajaxResp.onFail,
										this.ajaxResp, null);
	
	xReq.startReq();
}



ControlForms.prototype.testEvent = function (type, args, me) {
//  alert ("ControlForms.testEvent: eventType: "+ type + " msg: "+args);
}


/**
 * Not used
 * @param {Object} rbutton
 */
ControlForms.prototype.onShortClick = function (rbutton) {
	var textarea = "<textarea name=\"txtComment\" id=\"txtComment\" cols=\"50\" "; 
	textarea += "rows=\"5\"></textarea>";
	
	var btnId = rbutton.id;
	var divTxt = $('#divTxtArea');
	var txt = $('textarea');
	
	if (btnId == 'rbShort') {
		$(divTxt).css('visibility', 'visible');
		$(divTxt).after(textarea);
	}
	else {
		$(divTxt).css ('visibility', 'hidden');
		$('div textarea').remove ();
	}
}



  
///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////// 
  
/**
 * Initialize the javascript application by loading init form and sections
 * @param {Object} intrvId
 * @param {Object} secId
 * @param {Object} preview
 * @param {int} rt, real time (deprecated, as always it is realtime)
 * @param {int} timeout, the session timeout. Used to automatically save
 * the current section values if session expires. It is reset every time a
 * new page is loaded
 */
function onReady (intrvId, secId, preview, rt, timeout) {
  overlay = new Overlay();
// alert ("onReady("+intrvId+","+secId+","+preview+","+rt+")");  
  intrvFormCtrl = new ControlForms (intrvId, rt, preview, timeout);
// alert ("after ControlForms ("+intrvId+","+rt+"): this.realtime="+intrvFormCtrl.realtime);
  intrvFormCtrl.init (intrvId);
  
  intrvFormCtrl.loadSection (intrvId);
  intrvFormCtrl.loadForm (secId);
	
// FormManager is the js class to control the active elements on the web page
	ctrl = new FormManager ();
  ctrl.init(preview);
  
	window.onbeforeunload = function () {
		var theForm = $('form');
		var lastsec = $('#currentsec');
		
		if ((preview == undefined || preview == 0) && intrvFormCtrl.pauseIntrv != 1)
 			return intrvFormCtrl.finish ($(theForm)[0], $(lastsec).val());
		else	
			return true;
		
	}
	
}
