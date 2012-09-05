/***************************************************************************
 *************************************************************************** 
 * AJAXRESPONSE INNERCLASS TO RESPONDE THE AJAX REQUESTS TO PERFORM
 * CRUD OPERATIONS
 */	

var ElemAjaxResponse = function () {
	
	var onFail = function (o) {
    overlay.hide();
// Access the response object's properties in the
// same manner as listed in responseSuccess( ).
// Please see the Failure Case section and
// Communication Error sub-section for more details on the
// response object's properties.
		var msg = o.responseText;
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	};
	

/**
 * Ajax response handler
 */	
	var onItems4Sec = function (o) {
    overlay.hide ();
		var containers = document.getElementById("frmNewSec");
		
		try {
			var items = YAHOO.lang.JSON.parse(o.responseText);		
			
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
	};

/****************************************************************************
 * Ajax response for the requesto of item updating
 */	
	var onUpdateItem = function (o) {
    overlay.hide();
		try {
//alert ("responseTxt "+o.responseText);      
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;
			
			if (result == "1") {
				var urlLoc = "index.jsp?res=1&t=sec&op=det&frmid="+resp.frmid;
				urlLoc += "&spid="+resp.spid;
				
				alert ("The item was succesfully updated");
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



/****************************************************************************
 * Ajax resonse for the request of item saving or updating.
 * The response is a json string with the structure:
 * {"res":[0|1],"frmid":234,"msg":"[ok|exception]","secid":secId}
 */	
	var onSaveItem = function (o) {
    overlay.hide();
		try {
			var resp = YAHOO.lang.JSON.parse(o.responseText);
			var result = resp.res;
// alert (resp.frmid);			
			if (result == "1") {
//				var urlLoc = "index.jsp?res=1&t=ele&op=new&frmid="+resp.frmid;
				var urlLoc = "index.jsp?op=det&t=sec&frmid="+resp.spid;
				alert ("The item was succesfully created");
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
	
	
	
	
/****************************************************************************
 * Ajax resonse for the request of item deleting.
 * The response is a json string with the structure:
 * {"res":1,"frmid":234,"msg":"ok"[,"sons":"235,238,2999"]}
 */	
	var onDelItem = function (o) {
    
    overlay.hide();
		try {
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var myId = resp.frmid;
      var sons = resp.sons;
//      if (sons != undefined && sons != null)
  //      sons = sons.split(",");
        		
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
//					break;
				}
        if (sons != undefined && sons != null)
          if (sons.indexOf (myList.options[i].value) != -1)
            myList.options[i].setAttribute('class', '');
			}
			
			alert ("The element was deleted");
		}
		catch (exp) {
			alert("JSON Parse failed!"); 
	    return;
		}
	};
  
  
	
/***************************************************************************
 * Response handler to delete an item from the items list
 */	
	var onArrangeItems = function (o) {
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
	
	
	
	var onCheckQCode = function (o) {
		try {
			var resp = YAHOO.lang.JSON.parse(o.responseText);		
			var result = resp.res;
			var samecode = resp.samecode;
//alert ("result:"+result+"; samecode: "+samecode+"; samecode==1?"+(samecode==1));
			var compSize = document.getElementById('frmCodQues').size;
			
			var msgStr = 'This questionnaire is a <b style="color:red">clon</b> '; 
			msgStr += 'from an <b style="color:red">original</b>';
			msgStr += " questionnaire.";
			msgStr += "This <b>Question code</b> should <b>NOT</b> be changed but ";
			msgStr += " it is up to the editor to keep it";
			
			if (result == 1 && samecode == 0)
				Tip(msgStr, TITLE, 'Question Code Warning', WIDTH, 300, SHADOW, true, 
					STICKY, 1, CLOSEBTN, true, CLICKCLOSE, true, 
					FIX, ['frmCodQues', compSize, 0]);
/*
			else {
				msgStr = "The question code appears to be wrong. It will be reverted";
				Tip(msgStr, TITLE, 'Question Code Warning', WIDTH, 300, SHADOW, true, 
					STICKY, 1, CLOSEBTN, true, CLICKCLOSE, true, 
					FIX, ['frmCodQues', compSize, 0]);
			}
*/
		}
		catch (exp) {
			msgStr = "The question code appears to be wrong. It will be reverted";
				Tip(msgStr, TITLE, 'Question Code Warning', WIDTH, 300, SHADOW, true, 
					STICKY, 1, CLOSEBTN, true, CLICKCLOSE, true, 
					FIX, ['frmCodQues', compSize, 0]);
//			alert("JSON Parse failed!"); 
	    return;
		}
	}
	

	var test = function () {
//		alert ("FormItemCtrl.AjaxResponse.test works ok");
	};
	
	
	return {
		test: test,
		onSaveItem: onSaveItem,
		onDelItem: onDelItem,
		onUpdItem: onUpdateItem,
		onCheckQCode: onCheckQCode,
		
		onArrangeItems: onArrangeItems,
		onItems4Sec: onItems4Sec,
		onFail: onFail
	}
	
};
/// AJAXRESPONSE /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////






/*****************************************************************************
 *****************************************************************************
 * FormItemCtrl
 * Controls the form for item edition in the editelem.jsp page
 */
 
var FormItemCtrl = function () {

// a "constant" with the name of the main form for item edition/composition	
	var FORM_NAME = "frmItem";
	
// a private member to represent the form which we're working with
	var myForm;  
	
// the list with the answer types retrieved from db
	var sourceList;
	
// the list with the current answers for this item
	var targetList;
	
// the button to copy answer types
	var btnCopy;
	
// the button to remove answer types from the answer types for this item
	var btnRmv;

 	var ajaxResp;

// member to hold the current number of type Number answers for the elem
  var numberCount;
  
// variable to keep the url string which is gonna be sent using ajax
	var postData = "";
  
	var TXTAREA_DEF = "Statement text...";	
	
// Two components to implement modal dialog:
// - warnDlg, object dialog itself
// - msgDlg, this is just a convenient variable to hold the message on the dlg
	var warnDlg;
	var msgDlg;
	var dlgBtns;
	
// this is to hold if the button clicked was yes (1) or no (0, default)
	var warnDlgRes = 0; 
	
/*****************************************************************************
 * This method is intended to be run when dom is loaded in order to initialize
 * some form elements properly
 */	
	var init = function () {
		myForm = document.forms[0];  
		
		sourceList = myForm.frmAnswerTypes;
		targetList = myForm.frmAnswers;
		btnCopy = myForm.btnAddType;
		btnRmv = myForm.btnRmvType;
		
//		typeChange (myForm);
		
//		myForm.frmOptional[1].checked = true;
		firstTextarea = true;
		
		ajaxResp = new ElemAjaxResponse ();
		ajaxResp.test();
    
		numberCount = setNumberCount ();
//		testResp = new TestResponse ();

// Init the warning dialog. In the case it is needed, just call warnDlg.show ()
		msgDlg = "<span style=\"text-align:center\">Unable to change type of item ";
		msgDlg +="(<b>Question</b> instead <b>Text</b> or opposite).";
		msgDlg += " But the rest of changes will be updated.</span>";
		msgDlg += "<p align=\"center\"> Continue?</p>"
		
	 	msgDlg = "Unable to change type of item ";
		msgDlg +="(Question instead Text or opposite).";
		msgDlg += " But the rest of changes will be updated.";
		msgDlg += " Continue?"
		
		warnDlg = new YAHOO.widget.SimpleDialog("dlg", {  
	    width: "400px",  
	    fixedcenter:true, 
	    modal:true, 
	    visible:false, 
	    draggable:false
		}); 
			
		warnDlg.setHeader("Warning!"); 
		warnDlg.setBody(msgDlg); 
		warnDlg.cfg.setProperty("icon",YAHOO.widget.SimpleDialog.ICON_WARN); 
		
		var myButtons = [ { text:"Yes", handler: dlgHandleYes }, 
		                  { text:"No", handler: dlgHandleNo, isDefault:true } ]; 

		warnDlg.cfg.queueProperty("buttons", myButtons);

	};
	
  var dlgHandleYes = function() { 
//user confirms
//this method would perform that action; 
//when ready, hide the SimpleDialog: 
	 warnDlgRes = 1;
	 this.hide(); 
	}
	 
	var dlgHandleNo = function() { 
//user cancels item deletion;  
//handle the cancellation of the process. 
//when ready, hide the SimpleDialog:
	 warnDlgRes = 0; 
	 this.hide(); 
	}
	
  
  var activateSelected = function (theSelect) {
    var optSel = theSelect.options[theSelect.selectedIndex];
    var rangeNumbers = new Array ();
    var selRange = -1;         
// Getting the current order for the Number rows in rangeNumbers and
// selRange stores the current Number selected if so     


    for (var j = 0; j < theSelect.options.length; j++) {
      var optText = theSelect.options[j].text;
      
      if (optText.indexOf('Number') != -1) {
        var idxNumber = optText.search(/\d/);
        var ordNumber = optText.charAt(idxNumber);
        rangeNumbers.push(ordNumber);
        
        if (theSelect.options[j].selected) 
          selRange = ordNumber;
      }
			
			if (optText.indexOf('Decimal') != -1) {
        var idxNumber = optText.search(/\d/);
        var ordNumber = optText.charAt(idxNumber);
        rangeNumbers.push(ordNumber);
        
        if (theSelect.options[j].selected) 
          selRange = ordNumber;
      }
    }
      
//    if (theSelect.options[theSelect.selectedIndex].text.indexOf('Number') != -1) {
    for (var i = 0; i < rangeNumbers.length; i++) {
      var trRange = document.getElementById('trRange' + rangeNumbers[i]);
      
      if (trRange && trRange != null) {
        if (rangeNumbers[i] == selRange) 
          trRange.setAttribute('style', 'background-color:grey');
        else 
          trRange.setAttribute('style', 'background-color:white');
      }
    }
      
  }
  
  
/*****************************************************************************
 * RANGE STUFF
 * Three functions involved: 
 * - setNumberCount(), to set the next number to identify the ranges with the
 * corresponding type
 * - addRange(), to add all html stuff necessary to add a range
 * - removeRange (), remove all html stuff added with the previous function or
 * from the html rendering
 * 
 * This is just to visual stuff.
 */  
  
/**
 * Gets the number of type Number answers for the element being edited 
 * currently.
 */  
  var setNumberCount = function () {
    var mins = YAHOO.util.Selector.query('input[name^=frmmin]');
    var maxNumber = 0; 
    if (mins != null && mins != undefined) 
      maxNumber = mins.length;
      
    return maxNumber;
  }
  
  
  
/**
 * Private method to add the set of boxes to set a range number up
 */  
  function addRange () {
// creates the row and columns    
    var tableTypes = document.getElementById('tblTypes');
    
    var trRange = document.createElement('tr');
    trRange.setAttribute ('id', 'trRange'+numberCount);
    
    var firstTd = document.createElement('td');
    firstTd.setAttribute('colspan', 2);
    
    var sndTd = document.createElement('td');
    sndTd.setAttribute('colspan', 2);
    sndTd.setAttribute ('valign', 'bottom');
// create the labels and boxes with the proper name    
    var rangeTxt = document.createTextNode('('+numberCount+') Range ');
    var excTxt = document.createTextNode(' Exception ');
    var hyphen = document.createTextNode (' - ');
    var colon = document.createTextNode (' : ');
    
    var inputMin = document.createElement('input');
    inputMin.setAttribute ('type', 'text');
    inputMin.setAttribute ('name', 'frmmin'+numberCount);
    inputMin.setAttribute ('id', 'frmmin'+numberCount);
    inputMin.setAttribute ('size', '5');
    inputMin.setAttribute ('maxlength', '16');
    
    var inputMax = document.createElement('input');
    inputMax.setAttribute ('type', 'text');
    inputMax.setAttribute ('name', 'frmmax'+numberCount);
    inputMax.setAttribute ('id', 'frmmax'+numberCount);
    inputMax.setAttribute ('size', '5');
    inputMax.setAttribute ('maxlength', '16');
    
    var inputExc = document.createElement('input');
    inputExc.setAttribute ('type', 'text');
    inputExc.setAttribute ('name', 'frmexc'+numberCount);
    inputExc.setAttribute ('id', 'frmexc'+numberCount);
    inputExc.setAttribute ('size', '5');
    inputExc.setAttribute ('maxlength', '32');
// append first the components to the specific cell
// then the td's are added to the row   
    sndTd.appendChild(rangeTxt);
    sndTd.appendChild(inputMin);
    sndTd.appendChild(hyphen);
    sndTd.appendChild(inputMax);
    sndTd.appendChild(colon);
    sndTd.appendChild(excTxt);
    sndTd.appendChild(inputExc);
    
    trRange.appendChild (firstTd);
    trRange.appendChild (sndTd);
// the row is added to the table    
    tableTypes.appendChild(trRange);
  }
  



/**
 * Private method to remove the row with the range and exception values
 * @param {Object} index
 */  
  var removeRange = function (index) {
    var trRange = document.getElementById('trRange'+index);
    if (trRange != null && trRange != undefined) {
      var parentTr = trRange.parentNode;
      parentTr.removeChild (trRange);
    }
  }
    
  
  var chkNumber = function (what, num) {
// alert ('chkNumber('+what+','+num+')');
 		var numLabel, numRegExp;
  	if (what == 'D') {
  		numRegExp = /^[-+]?\d*\.?\d*$/g;
  		numLabel = 'Decimal';
  	}
  	else {
  		numRegExp = /^\d*$/g;
  		numLabel = 'Number';
  	}
// alert('chkNumber.numLabel='+numLabel+';numRegExp='+numRegExp);
  	var res = num.search(numRegExp);
  	return res;
  }
  
    
/**
	This method check if the number set as a range for an element is valid
	regarding to the type of the element
*/
  var chkRange = function (what, elem) {
  	var numRegExp, numLabel;
  	var excPrefix = "frmexc";
  	var res;
		
		numLabel = (what == 'D')? 'Decimal': 'Number';
// alert ('chkRange ('+what+','+elem.getAttribute('name')+')');
// This is for exceptions, which can be more then one number comma separated		
		if (elem.getAttribute('name').indexOf(excPrefix) != -1) {
			var arrayExcs = elem.value.split(',');
			
			for (i = 0; i < arrayExcs.length; i++) {
				res = chkNumber(what, arrayExcs[i]);
				if (res == -1) 
					break;
			}
			if (res == -1) {
				alert(numLabel + "s have to be introduced separated by commas" +
							" instead " +	elem.value);
				elem.value = "";
				
				return;
			}
		}
		else { // for a minimum or maximum values
			res = chkNumber(what, elem.value);
// alert ("res after checking: "+res);
			if (res == -1) {
				alert("A "+numLabel + " has to be introduced" +
							" instead " +elem.value);
				elem.value = "";
				
				return;
			}
		} 
  }
  
	
	
	
//	var chkQue stionCode = function (comp, oldQCode, isClon, intrvId) {
/**
 * Ajax-checks if the question code was changed compared to the value on database
 * @param {Object} comp, the component
 * @param {Object} qid, the question id set in the component
 * @param {Object} isClon, true if this interview is a clon; false otherwise
 * @param {Object} intrvId, the interview identifier
 * @return nothing
 */
	var chkQuestionCode = function (comp, qid, isClon, intrvId) {
		var newVal = comp.value;
		var postData;
		postData = "";
		
		if (isClon) {
			postData = "what=qcode&intrvid="+intrvId+"&qid="+qid+"&newcode="+newVal;
			
			var xReq = new AjaxReq('no-overlay');
			xReq.setUrl(APPNAME+"/servlet/QryServlet");
			xReq.setMethod("GET");
			xReq.setPostdata(postData);
			xReq.setCallback(ajaxResp.onCheckQCode, ajaxResp.onFail, ajaxResp, null);
			
			xReq.startReq();
		}
		
		
/*		
		if (isClon && (newVal != oldQCode)) {
			var msgStr = 'This questionnaire is a <b style="color:red">clon</b> '; 
			msgStr += 'from an <b style="color:red">original</b>';
			msgStr += " questionnaire.";
			msgStr += "This <i>question code</i> should <b>NOT</b> be changed but it is up to ";
			msgStr += " the editor to keep it";
			
			Tip(msgStr, TITLE, 'Question Code Warning', WIDTH, 300, SHADOW, true, 
					STICKY, 1, CLOSEBTN, true, CLICKCLOSE, true, 
					FIX, ['frmCodQues', comp.size, 0]);
		}
*/
	}
	
	
/****************************************************************************
 * add a type from the list of types to the types applicable for this question
 * this is because the question can be several answer types...
 */	
	function addType (theForm) {
		var source = theForm.frmAnswerTypes;
		var target = theForm.frmAnswers;
		var i, newOpt;
		for (i=0; i<source.options.length; i++) {
			if (source.options[i].selected) {
        if (source.options[i].text == "Number" || 
            source.options[i].text == "Decimal") {
          numberCount++;
          newOpt = new Option(source.options[i].text+' ('+numberCount+')', 
                              source.options[i].value);
        }
        else
          newOpt = new Option(source.options[i].text, source.options[i].value);
              
				target.add(newOpt, null);
// target.add(newOpt); for IE	or even the same than Mozilla
        break;			
			}
		}
    
    if (source.options[i].text == 'Number' || 
        source.options[i].text == 'Decimal')
      addRange ();
    
    
	};
	
	
/****************************************************************************
 * Respond to the new section in the combobox...
 * Besides, it makes an ajax call to fill the items combo with the elements
 * contained in that section
 */	
	function sectionChanged () {
		var sections = myForm.frmNewSec;
		var containers = myForm.frmNewParent;
		
		if (sections.selectedIndex != 0) 
			containers.disabled = false;
			
		else
			containers.disabled = true;

		var secId = sections.options[sections.selectedIndex].value;
// get the questions via ajax...	
		var xReq = new AjaxReq ();
		xReq.setUrl ("ajax/items4sec.jsp");
		xReq.setMethod ("POST");
		xReq.setPostdata("t=sec&frmid="+secId);
		xReq.setCallback (ajaxResp.onItems4Sec, ajaxResp.onFail,
											ajaxResp, null);
		
		xReq.startReq();
	};
	
	
  
	
/****************************************************************************
 * remove an item answer from the answer list.
 * (there is a fault in this method: it removes all items but one...
 */	
	function rmvAnswer (theForm) {
		var theList = theForm.frmAnswers;
    var nameType;
		for (var i=0; i<theList.length; i++) {
			if (theList.options[i].selected) {
        nameType = theList.options[i].text;
				theList.remove(i);
			}
		}
    
    if (nameType != undefined) {
      if (nameType.indexOf('Number') != -1 || 
          nameType.indexOf('Decimal') != -1) {
        var idxNumber = nameType.search (/\d/);
        if (idxNumber != -1) {
          var ordNumber = nameType.charAt(idxNumber);
          removeRange(ordNumber);
        }
      }
    }
	};
	
	
	
/****************************************************************************
 * change the disabled property of those fields related to question depending
 * on the selection of the "Just text" checkbox
 */	
	function typeChange (theForm) {
		var chkBtn = theForm.frmChkTxt;
		var chkMandatory = theForm.frmMandatory;
		var chkRep = theForm.frmChkRep;
// switch to indicate whether or not this is a text		
		var theSwitch = chkBtn.checked;

// update the type lists
		sourceList.disabled = theSwitch;
		targetList.disabled = theSwitch;
		btnCopy.disabled = theSwitch;
		btnRmv.disabled = theSwitch;
		
// update the other checkbuttons: if text is selected no mandatory
		if (theSwitch) {
			chkMandatory.checked = false;
		}
		chkMandatory.disabled = theSwitch;
		
//    theForm.elements['frmCodQues'].disabled = theSwitch;
//		chkMult.disabled = theSwitch;
//		chkRep.disabled = theSwitch;
    
		/*
		for (var i=0; i<theForm.frmOptional.length; i++)
			theForm.frmOptional[i].disabled = theSwitch; */
	};
	
	
	function clear (theTextarea) {
// AlertLog.out (theTextarea.value +" vs "+TXTAREA_DEF);
		if (theTextarea.value == TXTAREA_DEF) 		
			theTextarea.value = "";
	};
	
	
	
	function clickCancel (theForm) {
//		document.location.href = "index.jsp";
    var urlRef = document.referrer;
    document.location.href = urlRef;
//		self.history.back(); // to go back the sections page, as clicking back btn
	};
	
	
/****************************************************************************
 * "Private" function to validate the form of the editelem.jsp page
 * It checks the value of the range fields. To do that, every group of range
 * fields is checked based on its type, which can be number or decimal. In order
 * to do this, a counter for the answer options and another for the range fields
 * are kept. The range fields counter goes from 1 to 3, the options counter
 * is increased every time the range counter comes back to one, which is done 
 * when the last range field is processed. So, the options counter loop through
 * the answer options and, every time a Number or Decimal is found, the range
 * counter starts increasing until reaching 3, time for increase the options 
 * counter and start again. This is the heaviest check
 * More controls to match questions with answers and text are done, which are
 * softer than the previous one.
 */	
	var preValidate = function (theForm) {
// set the postData by walking through the form and selecting the appropiate
// elements to include in the postData...
//  var postData = "";
		var theElems = theForm.elements;
		var confirmMsg;
		var isText = false;
		var validated = true;
		var i;
// This two current* vars are intended to synchronize ranges with types    
    var currentRange=1;
    var currentOpt=0;
    
    var myRegExp;
    var frmmin, frmmax;
		
// First I check whether or not the type of element was changed (Q->T or T->Q)
// using jquery...
		var hiddenType = document.getElementById('itemType');
		var checkboxType = document.getElementById('frmChkTxt');
		
		if ((checkboxType.checked && hiddenType.value != 'T') ||
				(checkboxType.checked == false && hiddenType.value == 'T')) {
//			warnDlg.render (document.body);
//			warnDlg.show ();		
			if (confirm(msgDlg))
				return validate (theForm);	
		}
		else 
			return validate (theForm);
			
	};
	
	
	
	
	var validate = function (theForm) {
		// set the postData by walking through the form and selecting the appropiate
// elements to include in the postData...
//  var postData = "";
		var theElems = theForm.elements;
		var confirmMsg;
		var isText = false;
		var validated = true;
		var i;
// This two current* vars are intended to synchronize ranges with types    
    var currentRange=1;
    var currentOpt=0;
    
    var myRegExp;
    var frmmin, frmmax;
		
		for (i=0; i<theElems.length; i++) {
			var anElem = theElems[i];
			
			if (anElem.type.indexOf("text") != -1 ||
          anElem.type == "hidden") { // for input=text, textarea & hidden
        postData += (postData.length > 0 &&
        					postData.lastIndexOf('&') != postData.length - 1) ? "&" : "";
        postData += anElem.name + "=" + encodeURIComponent(anElem.value);
        
        // Check the range boxes not to allow shit
        if (anElem.getAttribute('name').search(/frmmin/) != -1 ||
            anElem.getAttribute('name').search(/frmmax/) != -1 ||
            anElem.getAttribute('name').search(/frmexc/) != -1) {
          //alert (anElem.getAttribute('name')+":"+anElem.value.match(/^[-+]?\d*\.?\d*$/g));
          
          if (currentRange == 1) {
            for (j = currentOpt; j < theForm.frmAnswers.options.length; j++) {
              currentElem = theForm.frmAnswers.options[j];
              
              if (currentElem.text.match(/Number/) != null) {
                myRegExp = /^[-+]?\d*$/g;
                break;
              }
              if (currentElem.text.match(/Decimal/) != null) {
                myRegExp = /^[-+]?\d*\.?\d*$/g;
                break;
              }
            } // loop over the answer items select
          }
          
// Check the value of the ranges. When the 3rd range value (exception) is got
// it is possible to check the min and max range values. The function returns
// inmediately if frmmin is greather than frmmax          
          if (currentRange == 3) {
            if (frmmin > frmmax) {
              postData = "";
              validated = false;
              alert("Range values mismatching: minimun "+frmmin+" > maximum "+frmmax);
              return validated;
            }
            else {
              currentRange = 1;
              frmmin = null;
              frmmax = null;
            }
          }
          else
            currentRange++;

//          currentRange = (currentRange == 3) ? 1 : currentRange + 1;
          currentOpt = (currentRange == 1) ? currentOpt + 1 : currentOpt;
          
// Semantic checks: first we try with exceptions because can be several
// Then with min and max range values          
          if (anElem.getAttribute('name').search(/frmexc/) != -1) {
            var exceps = anElem.value.split(',');
            for (k=0; k<exceps.length; k++) {
              if (exceps[k].match(myRegExp) == null)  {
                postData = "";
                validated = false;
                alert("Exception values must match with Number or Decimal types");
                return validated;
              }    
            }
          }
          else if (anElem.value.match(myRegExp) == null) {
            postData = "";
            validated = false;
            alert("Range values must match with Number or Decimal types");
            return validated;
          }
          else {
            if (anElem.getAttribute('name').search(/frmmin/) != -1)
              frmmin = parseFloat(anElem.value);
              
            if (anElem.getAttribute('name').search(/frmmax/) != -1)
              frmmax = parseFloat(anElem.value);
          }

        } // if an range element is being processed
      } // if a hidden or text element is being processed
      
			
			if (anElem.getAttribute("type") == "checkbox" || 
					anElem.getAttribute("type") == "radio") { // for checkbox and radio
				if (anElem.checked) {
					postData+=(postData.length > 0 && 
										 postData.lastIndexOf('&') != postData.length-1)? "&": "";
					postData+=anElem.name+"="+anElem.value; // here value will be "on"
					
					if (anElem.name == "frmChkTxt") 
						isText = true;
				} 
			}
			

// This is the control for every select element on the element edition page			
			if (anElem.type.indexOf("select") != -1) { // for lists
				if (anElem.name == "frmAnswers" && !isText) {
					postData+=(postData.length > 0 && 
										 postData.lastIndexOf('&') != postData.length-1)? "&": "";
//					postData += anElem.name+"=";
				
// this loop is because frmAnswers list is multiple selection
					var auxData = "";
					for (var k=0; k<anElem.options.length; k++) {
						var anOpt = anElem.options[k];
//						auxData += (auxData.length != 0)?",":"";
						auxData += anElem.name+"="+anOpt.value+"&";
					}
// This is to check that the question has at leas one answeritem
// To highlight the error we can change the style of the lists
					if (auxData.length == 0 && !isText) {
						alert ("You must choose at least 1 type of answer");
						validated = false;
					}
					
// Viceversa... when the item is a text, discard the lists data
					if (auxData.length > 0 && isText) 
						alert ("The type of answers selected won't be considered");
					
					postData += auxData;
				}
				
// Check the parent section
// This can be change because i dont know whether or not is gonna be possble
// to create an item without section				
				if (anElem.getAttribute("name") == "frmNewSec") {
					if (anElem.options[anElem.selectedIndex].value != -1) {
						postData+=(postData.length > 0 && 
											 postData.lastIndexOf('&') != postData.length-1)? "&": "";
						postData+=anElem.name+"="+anElem.value;
					}
				}
				
				if (anElem.getAttribute("name") == "frmNewParent") {
					if (anElem.options[anElem.selectedIndex].value != -1) {
						postData+=(postData.length > 0 && 
											 postData.lastIndexOf('&') != postData.length-1)? "&": "";
						postData+=anElem.name+"="+anElem.value;
					}
				}
			} // if type is select
			
			
// This is for the hidden field for the current sections
			if (anElem.getAttribute("name") == "frmCurSec") {
 // try getting the current section
				if (theForm.frmCurSec.value != "") {
					postData+=(postData.length > 0 && 
									 	postData.lastIndexOf('&') != postData.length-1)? "&": "";
					postData+=theForm.frmCurSec.name+"="+theForm.frmCurSec.value;
				}
			}			
			
// Code for items, mandatory for questions
			if (anElem.getAttribute('name') == "frmCodQues") {
				if ((isText == false) && anElem.value == "") {
			 		if (!confirm ("Do you want to create this question without Question Code?"))				
			 			validated = false;
			 	}
			}
			
		} // form loop to walk through the elems
// alert (postData);		
		return validated;
	}
	
	

	
/***************************************************************************
 * Response method on click the update button
 */	
	function onClickUpdate (theForm) {
		postData = "";
		var validated = preValidate (theForm);
		
		if (validated) {
			var xReq = new AjaxReq ();
			xReq.setMethod ("POST");
			
	// this is update...		
			if (theForm.frmid) { 
				postData+=(postData.length > 0 && 
									postData.lastIndexOf('&') != postData.length-1)? "&": "";
				postData+="frmid="+theForm.frmid.value;
				confirmMsg = "Do you want to update the element with these data?";
				
			}
// alert (postData);			
			if (confirm (confirmMsg)) {
	// do an ajax request to save item, and, on failure keep this page (if 
	// there was error) and on success redirect to detailsec.jsp
				xReq.setUrl ("ajax/upditem.jsp");
				xReq.setCallback (ajaxResp.onUpdItem, ajaxResp.onFail, ajaxResp, null);
				xReq.setPostdata (postData);

				xReq.startReq ();

//				document.location.href = "ajax/upditem.jsp?"+postData;
			}
		}/*
		else
			alert ("validated: "+validated); */
		
	};
	
	
/***************************************************************************
 * Response method on click the save button
 */		
	function onClickSave (theForm) {
		postData = "";
		var validated = validate (theForm);

		if (validated) {
			var xReq = new AjaxReq ();
			xReq.setMethod ("POST");
			
	// just save
			confirmMsg = "Do you want to create a new element with these data?";
			xReq.setUrl ("ajax/saveitem.jsp");
			xReq.setCallback (ajaxResp.onSaveItem, ajaxResp.onFail, ajaxResp, null);
			
			if (confirm (confirmMsg)) {
	// do an ajax request to save item, and, on failure keep this page (if 
	// there was error) and on success redirect to detailsec.jsp
				
				xReq.setPostdata (postData);
	// alert (xReq.getPostdata());			
				xReq.startReq ();
		
			}
		}/*
		else
			alert ("validated: "+validated); */
	};
	
	
/***************************************************************************
 * Open a window with the new form type
 */	
	var openTypeWin = function (intrvId) {
//		var urlPage = "../html/newtype.html";
		var pathNewType = "../html/";
    var urlPage = pathNewType+"newtypedlg.jsp?intrvId="+intrvId;
		var feats = "width=510,height=230,resizable=false,minimizable=false";
    feats += ",resizable=false";
		
		window.open(urlPage, "newTypeWin", feats);
		
	}	

// REARRANGING METHODS //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/**
 * Emit an ajax call in order to rearrange the sections within the interview
 */	
	var onRearrange = function (theList, type) {
		var postData = "t="+type+"&newOrder=";
		
		for (i=0; i<theList.options.length; i++) {
			postData += theList.options[i].value+",";
		}

		postData = postData.substring(0, postData.length-1);
// alert(postData);
//		document.location.href = "ajax/rearrange.jsp?"+postData;	
		xReq = new AjaxReq ();
  	xReq.setMethod("POST");
	 	xReq.setUrl ("ajax/rearrange.jsp");
		xReq.setMethod ("POST");
		xReq.setPostdata(postData);
		xReq.setCallback (ajaxResp.onArrangeItems, ajaxResp.onFail,
											ajaxResp, null);

		xReq.startReq();	
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
			}
		}
	}  

	
////////////////////////////////////////////////////////////////////////////	
	var test = function () {
		var xReq = new AjaxReq ();
		xReq.setMethod ("POST");
		
// just save
		xReq.setUrl ("ajax/testajax.jsp");
		xReq.setCallback (testResp.onSaveItem, testResp.onFail, testResp, null);
		
		if (confirm (confirmMsg)) {
//		alert (postData);
// do an ajax request to save item, and, on failure keep this page (if 
// there was error) and on success redirect to detailsec.jsp
			postData = "t=ele&frmStmt=A%20continuaci%C3%B3n%20se%20interrogar%C3%A1%20sobre%20gustos%20sesuales&frmMandatory=1&frmAnswers=51&frmAnswers=102&frmNewSec=100";
			xReq.setPostdata (postData);
			
			xReq.startReq ();
		}
	};
	
	
	return {
		ajaxResp: AjaxResponse,
		clearTextarea: clear,
		test: test,
//		testResp: testResp, // just for testing purposes
		activateSelected: activateSelected,
    
		addType: addType,
		rmvAnswer: rmvAnswer,
		typeChange: typeChange,
		chkRange: chkRange,
		chkQuestionCode: chkQuestionCode,
//		secChanged: sectionChanged,
		
		onSave: onClickSave,
		onUpdate: onClickUpdate,
		onCancel: clickCancel,
		
		onRearrange: onRearrange,
  	moveDown: moveDown,
  	moveUp: moveUp,
		
		newType: openTypeWin,
		init: init
	}
	
}
// END OF FORMLISTCTRL ////////////////////////////////////////////////////////

isFormItemCtrlLoaded = true;
