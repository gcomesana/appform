

var codesCtrl;
var codesHandler;
var overlay;


var AjaxRespHandler = function(){

	var onFail = function(o){
		overlay.hide();
		// Access the response object's properties in the
		// same manner as listed in responseSuccess( ).
		// Please see the Failure Case section and
		// Communication Error sub-section for more details on the
		// response object's properties.
		var msg = o.responseText;
		
		//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert(msg);
	};
	
	
	
	/**
	 * Callback method to retrieve the patient codes for the group
	 * The resulting ajax response will have the shape:
	 * {"codes": ["034236","239856","0984365","399198"]}
	 */
	var onGetCodes = function(o){
		var codes;
		var $divTot = $("#totalMsg");
		
    overlay.hide ();
		try {
      codes = YAHOO.lang.JSON.parse(o.responseText);
    }
    catch (x) {
			var msgErr = "There was an error while getting data<br/>Try again and";
			msgErr = " report the <a href=\"mailto:gcomesana@cnio.es\">administrator</a>";
			msgErr = " if the error persists";
			$("#containerDiv").css("text-align","center");
			$(divTot).html(msgErr);						
      
			alert("JSON Parse failed!");
      return;
    }
		
		var msg;
		
		var $divList = $("#codesUl");
		$divList.empty();
		if (codes.length == 0)
			msg = "No codes were found for this group";
		else
			msg = "Number of codes found: "+codes.length;
		
		$("#containerDiv").css("text-align","left");
		$divTot.text (msg);
		
		for (var i=0; i<codes.length; i++) {
			var liCode = "<li>"+codes[i].code+"</li>";
			
			$(liCode).appendTo ($divList);
		}
	}
	
	return {
		onFail: onFail,
		onGetCodes: onGetCodes
	}
}





// CONTROLCODES AJAX CLASS /////////////////////////////////////////////////
ControlCodes = function () {
	//  this.overlay = new Overlay();
	this.ajaxResp = new AjaxRespHandler ();
		
	this.pauseIntrv = 0;
}



ControlCodes.prototype.init = function (intrvId) {

}



/**
 * Build and perform the ajax call to retrieve the patient codes for the current
 * secondary active group.
 * @param {Object} intrvid
 * @param {Object} secGrpId
 */
ControlCodes.prototype.getPatCodes = function (intrvid, secGrpId) {
	var postdata = "what=cod";
//&intrvid="+intrvid+"&secgrpid="+userid;

	var xReq = new AjaxReq ();
	xReq.setUrl (APPNAME+"/servlet/QryServlet");
	xReq.setMethod ("GET");
	xReq.setPostdata(postdata);
	xReq.setCallback (this.ajaxResp.onGetCodes, this.ajaxResp.onFail,
										this.ajaxResp, null);
	
	xReq.startReq();
}



$(document).ready (function () {
	overlay = new Overlay ();
	
	codesHandler = new AjaxRespHandler ();
//	dispResp.init ();
	
	codesCtrl = new ControlCodes ();
	codesCtrl.getPatCodes ();
	
//	displayCtrl.init ();
})