var formCtrl; // object to instantiate as FormItemCtrl
var listCtrl; // object to instantiate as ListItemsCtrl
var secFormCtrl; // object to instantiate as SecFormCtrl
var intrFormCtrl; // object to instantiate as IntrFormCtrl
var prjFormCtrl; // object to instantiate as PrjFormCtrl
var supernote;
var overlay;

var AlertLog = {
	
	out:function(msg) {
		alert (msg);
	}
};


function compareIntrv() {
	var urlPage = "../display/index.html";
	var feats = "width=848,height=680,resizable=false,minimizable=false";
//    feats += ",statusbar=false,toolbar=false,menubar=false";
	
	window.open(urlPage, "compIntrvWin", feats);
	return;
}



/**
 * This is actually a function to response the 'onunload' event. The 'weird'
 * name is to avoid collision names with onunload. (The sintax 
 * 'document.form.formName.property/method(params)' is supossed to be 
 * allowed for all navs (by May 2010)
 */
function onRemovePage () {
// alert ("onRemovePage: "+listCtrl)
	if (listCtrl != undefined) {
		
		if (document.forms['formSecs'] != undefined)
			listCtrl.onRearrange(document.forms['formSecs'].frmListSecs, 'sec');
		
		if (document.forms['formListItem'] != undefined)
			listCtrl.onRearrange(document.forms['formListItem'].frmListItems, 'ele');
		
	}
}



function onReady () {
	
	BrowserDetect.init();
// bad
//	bd = new BrowserDetect ();
//	bd.init ();
  thisBrowser = BrowserDetect.getBrowser();
// alert ("thisBrowser.identity: "+thisBrowser.identity);
	if (thisBrowser.toLowerCase() != 'firefox') {
		alert ("You must use Mozila Firefox 2.x or later to use this application");
		return false;
	}
	
	
	if (isListItemCtrlLoaded) {
		listCtrl = new ListItemsCtrl ();
		listCtrl.init ();
	}
	
	if (isFormItemCtrlLoaded) {
		formCtrl = new FormItemCtrl ();
//		formCtrl.AjaxResponse.test();
		formCtrl.init();
		formCtrl.ajaxResp;
	}
	
	if (isSecFormCtrlLoaded) {
		secFormCtrl = new SecFormCtrl ();
		secFormCtrl.init ();
	}
	
	if (isprjFormCtrlLoaded) {
		prjFormCtrl = new PrjFormCtrl ();
		prjFormCtrl.init ();
	}
	
	if (isintrFormCtrlLoaded) {
		intrFormCtrl = new IntrFormCtrl ();
		intrFormCtrl.init ();
	}
  
  overlay = new Overlay();
  
//alert (BrowserDetect.getBrowser());
//	formCtrl.test();
}
