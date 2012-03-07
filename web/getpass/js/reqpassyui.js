
var list;

var PasswdReqAjaxResp = function () {
		
	var onFail = function (o) {
    overlay.hide();
// Access the response object's properties in the
		var msg = o.responseText;
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert (msg);
	};
	
	
/**
* Handle the server response
* @param {Object} responseText, the server response in a json format
* @param {Object} statusText
*/
//	var onSuccess = function (responseText, statusText) {
	var onSuccess = function (resp) {
// alert ("Successsssssss!!!!");
//			$("#divMsg").html("resp: "+responseText.res+":"+responseText.msg);
//			$("#divMsg").css ("color", "red");

		try {
			var jsonObj = YAHOO.lang.JSON.parse(resp.responseText);
			
			$("#divMsg").text(jsonObj.msg);
			$("#divMsg").css("visibility", "visible");
		}
		catch (exp) {
			alert("Server answer failed!"); 
	    return;
		}
		
		return false;
	}
	

	var onFail = function (xReq, statusText, errThrown) {
		alert (statusText);
		
		return false;
	}
	
	
	var test = function () {
		alert ("GroupDlgAjaxResp.AjaxResponse.test works ok");
	}
	
	
	return {
		test: test,
		onSuccess: onSuccess,
		onFail: onFail
	}
};
// END OF AJAXRESPONSE "INNER CLASS" //////////////////////////////////////	
///////////////////////////////////////////////////////////////////////////





/**
 * This class displays a jquery ui dialog with the appropiate form embedded
 * and decorations
 */
var PasswdReqCtrl = function () {
	
	var ajaxResp;
	var POST_ACTION = APPNAME+"/users/getpasswd";
	var grpType;
	
// This is a switch to discriminate the redirection on Cancel click. 
// If this page is reached form a explicit click, that means the user has 
// a previous active group and it can go back to the referer place
	var comesFromClick;
	
	var myDlg;
	
/**
 * This is a method to initialize the class
 * @param {Object} grp, the group type
 * @param {Object} clicked, true if this one was reached through a click; false 
 * if this page was reached automatically
 */
	var init = function () {
	
	console.info ("init - APPNAME: "+POST_ACTION)
		ajaxResp = new PasswdReqAjaxResp ();

		myDlg = new YAHOO.widget.Dialog("myDlg", 
												{ width : "480px",
													heigth: "320px", 
									        fixedcenter : true, 
									        visible : false,  
													hideAfterSubmit: false,
													modal: true,
									        constraintoviewport : true, 
									        buttons : [ { text:" Send ", handler: passwdReq.handleSubmit, isDefault:true }, 
									                    { text:" Cancel ", handler: passwdReq.handleCancel } ] 
									      }); 

		
		myDlg.validate = function () {
			var data = this.getData();
			
			return chkForm (data);
		}
		
// Callback functions to response the ajax requests 
		myDlg.callback = {success: ajaxResp.onSuccess,
											failure: ajaxResp.onFail};
		myDlg.render ();
		myDlg.show ();
	}
	
	

	var handleSubmit = function () {
		$("#frmPasswdReq").attr("action", POST_ACTION);
		this.submit ();
	}
	
	
	var handleCancel = function () {
		window.location.href = APPNAME+"/jsp/index.jsp";
	}
	
	

/**
 */
//	var chkForm = function (formData, jqForm, options) {
	var chkForm = function (formData) {
		
		var mail = formData.frmemail, mailBis = formData.frmemailbis;
		var username = formData.frmusername;
		var captchaBox = formData.j_captcha_response;

		var isMailOk = (mail != "") && (mailBis != "") && (mail == mailBis);
		var isCaptchaFilled = (captchaBox != "");
		var isUserOk = (username != "");
								
		if (isMailOk == false) {
			$("#divMsg").text("The Email textfields have to be the same");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else if (isCaptchaFilled == false) {
			$("#divMsg").text("The captcha (image) textfield has to be filled");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else if (isUserOk == false) {
			$("#divMsg").text("You have to fill the Username textfield");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else
			$("#divMsg").css ("visibility", "hidden");
			
		return true;
	}
	
	
	
	var refreshCaptcha = function () {
		$('#divMsg').text ('');
		var randomNum = Math.floor(Math.random()*100000001);
		var imgCaptcha = $("#captchaImg");
		imgCaptcha[0].src = APPNAME+"/jcaptcha#"+randomNum;
	}
	
	
	var goItems = function (selName, type) {
				
	};
	
	return {
		init: init,
		goItem: goItems,
		refresh: refreshCaptcha,
		handleSubmit: handleSubmit,
		handleCancel: handleCancel,
		chkForm: chkForm
	}
	
}



isPasswdReqCtrlLoaded = true;
var passwdReq;
var sndDlg;

/*
$(document).ready(function () {
  grpDialog = new GroupDlgFormCtrl ();
	grpDialog.init();
});
*/

 
function onReady (param) {
// alert ("onReady param: "+param);
/*
	sndDlg = new YAHOO.widget.Dialog("myDlg",  
            { width : "300px", 
	              fixedcenter : true, 
	              visible : false,  
	              constraintoviewport : true, 
	              buttons : [ { text:"Submit", handler:handleSubmit, isDefault:true }, 
	                          { text:"Cancel", handler:handleCancel } ] 
	             } );
*/

	passwdReq = new PasswdReqCtrl ();
	passwdReq.init();
}
