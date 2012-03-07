/*
var revealingModulePattern = function(){
  var privateVar = 1;
  function privateFunction(){
    alert('private');
  };
  var publicVar = 2;
  function publicFunction(){
    anotherPublicFunction();  
  };
  function anotherPublicFunction(){
    privateFunction();
  };
  // reveal all things private by assigning public pointers
  return {
    publicFunction:publicFunction,
    publicVar:publicVar,
    anotherPublicFunction:anotherPublicFunction
  }
}();
revealingModulePattern.publicFunction();

*/



var formCtrl; // object to instantiate as FormItemCtrl
var listCtrl; // object to instantiate as ListItemsCtrl


var AlertLog = {
	
	out:function(msg) {
		alert (msg);
	}
};


function onReady () {
	
	BrowserDetect.init();
// bad
//	bd = new BrowserDetect ();
//	bd.init ();
	
// alert (BrowserDetect.getBrowser());	
	listCtrl = new ListItemsCtrl ();
	formCtrl = new FormItemCtrl ();
	formCtrl.init();
	
//	formCtrl.test();
}
