var intrvFormCtrl;
var overlay;



var ControlForms = function () {
	
  var ajaxResp;
  
  var totalSection;
  var http_request_loadSection;
  var http_request_loadForm;
	var json_section=0;
	var index_json_section=0;
  	
  var myIntrvId;
  
    
   function chkLabel (label) {
     
   } 
   
   
/**
 * chkNumber
 * Check if the parameter actually is a number
 * @param {Object} number
 */   
   function chkNumber (text) {
     var numRegExp = /^\d*$/i;
     var res = numRegExp.test(text.value);

     if (!res) {
       alert("Debe introducirse un numero");
       text.value = "";
       
       return;
     }
   }
   
   
   
   function chkIntroForm (theForm) {
     var elems = theForm.elements;
     var i, patCodeElem;
// get the first textfield element, which will have to be the patient code     
     for (i=0; i<elems.length; i++) {
       if (elems[i].getAttribute("type") == "text") {
         patCodeElem = i;
         break;
       }
     }
     
     
     if (elems[i].value != elems[i+1].value || 
         elems[i].value.length == 0 ||
         elems[i+1].value.length == 0) {
       alert ("El codigo de paciente tiene que coincidir y no puede ser vacio");
       return false;
     }
/*     
     if (theForm.elements['patcode'].value != theForm.patcodebis.value ||
         theForm.elements['patcode'].value.length == 0 ||
         theForm.patcodebis.value.length == 0) {
       alert ("El codigo de paciente tiene que coincidir y no puede ser vacio");
       return false;
     }
*/
/*     
     if (theForm.place.value.length == 0) {
       alert ("Se debe introducir el lugar de la entrevista");
       return false;
     }*/
     return true;
   }
   
   
   function outForm (theForm) {
     var i=0;
     var params;
     
     for (i = 0; i < theForm.elements.length; i++) {
       params += theForm.elements[i].name + "=" + theForm.elements[i].value + "\n";
     }
       
     alert(params);  
     
   }
   
   
/**
 * send method
 * Sends the forms to the server scrips doing a check in advance.
 * @param {Object} theForm, the reference to the form in the web page
 */    
  function send(theForm) {
  
    var xReq = new AjaxReq();
    xReq.setMethod("POST");
    
    if (theForm.name.toUpperCase() == "INTROFORM") {
      var res = chkIntroForm(theForm);
      if (res) 
        xReq.setUrl("ajaxjsp/saveintro.jsp");
      else 
        return;
    }
    else 
      if (theForm.name.toUpperCase() == "SECTIONFORM") {
        //      outForm (theForm);
        xReq.setUrl("ajaxjsp/saveform.jsp");
      }
      
      else 
        xReq.setUrl("ajaxjsp/saveform.jsp");
    
    //		xReq.setPostdata("frmid="+intrvId);
    // alert ("Sending and applying theForm");
    if (confirm("Are you sure to confirm these data?")) {
      xReq.setForm(theForm);
      ajaxResp.reqComplete = 0;
      xReq.setCallback(ajaxResp.onSaveForm, ajaxResp.onFail, ajaxResp, null);
      xReq.startReq();
    }
  }
  
   
   
  function prevForm (secId, patId) {
    var postdata;
    var xReq = new AjaxReq ();
		xReq.setMethod ("GET");
    
    xReq.setUrl("ajaxjsp/prevform.jsp");
   
    xReq.setPostdata("secId="+secId+"&patId="+patId);
		xReq.setCallback (ajaxResp.onPrevForm, ajaxResp.onFail,
											ajaxResp, null);
		xReq.startReq();
  }
    
    
   
/**
 * getForm method
 * Makes an ajax petition to get the form for the section with id secId
 * @param {Object} secId, the id of the section which contains the form
 */    
  function getForm(idSec) {
    
    var xReq = new AjaxReq ();
		xReq.setMethod ("GET");
    
    
//      outForm (theForm);
    xReq.setUrl("ajaxjsp/items4sec.jsp");
   
//		xReq.setPostdata("frmid="+intrvId);
// alert ("Sending and applying theForm");
    xReq.setPostdata("frmid="+secId);
		xReq.setCallback (ajaxResp.onGetForm, ajaxResp.onFail,
											ajaxResp, null);
		xReq.startReq();
      
    
//    loadSection ("");
    
/*    
    var url = 'formlayout.html';
    var callback = {
      success: Success,
      failure: Failure
    };
    
    var myForm = document.getElementsByTagName('form')[0]; */
//    YAHOO.util.Connect.setForm(myForm, false);
    
//    var request = YAHOO.util.Connect.asyncRequest('POST', url, callback);
  }
  
  
/**************************************************************************
 * Finish the interview for this season. To do that, all session variables 
 * (except) the user, gotta be invalidated
 * @param {Object} theForm
 */  
  function finish (theForm) {
/*    
    var theDoc = theForm.ownerDocument;
    var endHidden = theDoc.createElement('input');
    endHidden.type = 'hidden ';
    endHidden.name = 'finish';
    endHidden.value = '1';
    theForm.appendChild (endHidden);
*/
    if (confirm("Are you sure to finish/interrupt this interview?")) {
      theForm.elements['finish'].value = "1";
      send(theForm);
    }
  }
  
  
  function Success() {
    index_json_section++;
    if (index_json_section < totalSection) {
      var objSection = document.getElementById(json_section[index_json_section].orden);
      objSection.setAttribute('href', '#');
      loadForm(json_section[index_json_section].id);
    }
  }
  
  
  function Failure () {
  }
  
  
/**
 * loadSection ()
 * Makes an ajax request to get the all sections for this interview template.
 */  
  function loadSection(intrvId) {
alert ("loadSection: this.intrvId="+this.myIntrvId);    
    var xReq = new AjaxReq ();
		xReq.setUrl ("ajaxjsp/secs4intrv.jsp");
		xReq.setMethod ("GET");    
		xReq.setPostdata("frmid="+this.myIntrvId);
		xReq.setCallback (ajaxResp.onSecs4Intrv, ajaxResp.onFail,
											ajaxResp, null);
		xReq.startReq();
  }
  	
  	
	
	function loadForm (secId)	{
		/*	if(BrowserDetect.browser=='Explorer' && BrowserDetect.version==6)
		{
			var http_request_loadForm = new ActiveXObject("MSXML2.XMLHTTP.3.0");
		}
		else
		{*/
      var xReq = new AjaxReq ();
  		xReq.setUrl ("ajaxjsp/items4sec.jsp");
  		xReq.setMethod ("GET");
  		xReq.setPostdata("frmid="+secId);
  		xReq.setCallback (ajaxResp.onItems4Sec, ajaxResp.onFail,
  											ajaxResp, null);
  		
  		xReq.startReq();
	}
	
	
  function getNextForm (intrvId, secId) {
    loadSection (intrvId);
    loadForm (secId);
  }
  
  
  function testEvent (type, args, me) {
//    alert ("testEvent: eventType: "+ type + " msg: "+args);
  }
	
	
	var getPatCodes = function () {
		var urlPage = "mycodes.html";
		var feats = "width=230,height=520,resizable=false,minimizable=false";
//    feats += ",resizable=false";
		
		window.open(urlPage, "patCodesWin", feats);
		return;
	} 
	
  
/****************************************************************************
 * init ()
 * initialization stuff
 */  
  function init (intrvId) {
    overlay = new Overlay();
    ajaxResp = new IntrvAjaxResponse ();
    
    this.myIntrvId = intrvId;
// sign up as a listener for the events fired by the ajaxResp object
//    ajaxResp.subscribeSecs (this.loadForm, this);
//    ajaxResp.subscribeForm (this.loadSection, this);
    ajaxResp.subscribeSecs (this.testEvent, this);
    ajaxResp.subscribeForm (this.loadSection, this);
  }
  
  
	return {
		getNextForm: getNextForm,
		loadForm: loadForm,
    prevForm: prevForm,
		getPatCodes: getPatCodes,
//    getDataSec: getDataSection,
    loadSection: loadSection,
    send: send,
    finish: finish,
    testEvent: testEvent,
    
    chkLabel: chkLabel,
    chkNumber: chkNumber,
    
    init: init
	}

}
///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////// 
  
/**
 * Initialize the javascript application by loading init form and sections
 * @param {Object} intrvId
 * @param {Object} secId
 * @param {Object} preview
 */
function onReady (intrvId, secId, preview) {
  intrvFormCtrl = new ControlForms ();
  intrvFormCtrl.init (intrvId);
  
  intrvFormCtrl.loadSection (intrvId);
  intrvFormCtrl.loadForm (secId);
  
// for the class which duplicates elements
  ctrl = new FormManager ();
  ctrl.init();
  
}
