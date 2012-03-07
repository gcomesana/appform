/**
 * This script provides dynamic behaviour and client checking to the reset
 * password form. Checks the content of the password reset boxes, controls
 * dynamic components and make the ajax request to post the new password
 */


var list;

var PasswdResetAjaxResp = function () {
		
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
	var onSuccess = function (response) {
//			$("#divMsg").html("resp: "+responseText.res+":"+responseText.msg);
//			$("#divMsg").css ("color", "red");

		try {
			var jsonObj = YAHOO.lang.JSON.parse(response.responseText);
			
	//			alert (responseText.msg);
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
var PasswdResetCtrl = function () {
	
	var ajaxResp;
	var POST_ACTION = APPNAME+"/users/getpasswd";
	var dialog;
	
	var hasNumber, hasUcase, hasLcase, has8Chars;
	
// This is a switch to discriminate the redirection on Cancel click. 
// If this page is reached form a explicit click, that means the user has 
// a previous active group and it can go back to the referer place
	var comesFromClick;
	
	
/**
 * This is a method to initialize the class
 * @param {Object} grp, the group type
 * @param {Object} clicked, true if this one was reached through a click; false 
 * if this page was reached automatically
 */
	var init = function () {
		ajaxResp = new PasswdResetAjaxResp ();
	
		hasNumber = false;
		hasUcase = false;
		hasLcase = false;
		has8Chars = false;
		$('input[type=checkbox]').attr('checked', false);
	
		dialog = new YAHOO.widget.Dialog("dialog", 
												{ width : "700px",
													heigth: "320px", 
									        fixedcenter : true, 
									        visible : false,  
													hideAfterSubmit: false,
													modal: true,
									        constraintoviewport : true, 
									        buttons : [ { text:" Send ", handler: passwdCtrl.handleSubmit, isDefault:true }, 
									                    { text:" Cancel ", handler: passwdCtrl.handleCancel } ] 
									      }); 

		
		dialog.validate = function () {
			var data = this.getData();
			
			return chkForm (data);
		}
		
// Callback functions to response the ajax requests 
		dialog.callback = {success: ajaxResp.onSuccess,
											failure: ajaxResp.onFail};
		dialog.render ();
		dialog.show ();
	
		$("#divMsg").css("font-size", "11px");
		$("#divMsg").css("color", "red");
	}
	
	
	var handleSubmit = function () {
		$("#frmPasswdReset").attr("action", POST_ACTION);
		this.submit ();
	}
	
	
	var handleCancel = function () {
		window.location.href = APPNAME+"/jsp/index.jsp";
	}
	

/**
 * Validate the captcha for the password reset form.
 * The password constraints for minimum number of characters and equality are
 * checked by using the onKeyUp method to check in real time
 * @param {Object} formData, array of objects (in json format) with the form:
 * [{name: paramName1, value: paramValue1},
 * 	{name: paramName1, value: paramValue1}]
 * @param {Object} jqForm, a jquery object wrapping the form dom object
 * @param {Object} options
 */
//	var chkForm = function (formData, jqForm, options) {
	var chkForm = function (formData) {
//alert ("grpDialog.chkForm: check the form before submitting");
		
		var captchaBox = formData.j_captcha_response;
		var passwd = formData.frmpass, passwdBis = formData.frmpassbis;

		var isCaptchaFilled = (captchaBox != "");
		
// check whether or not all restrictions are accomplished								
		if (!(hasLcase && hasNumber && hasUcase)) {
			$("#divMsg").text("All restrictions on the left have to be accomplished");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else
			$("#divMsg").css ("visibility", "hidden");
		
// alert ($('#frmpass').val() +' vs '+ $('#frmpassbis').val()+"... so "+$('#frmpass').val() != $('#frmpassbis').val());
		if (passwd != passwdBis) {
			$("#divMsg").text("Both passwords have to be similar");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else
			$("#divMsg").css ("visibility", "hidden");
			
			
// check whether or not the captchas is filled
		if (isCaptchaFilled == false) {
			$("#divMsg").text("The captcha (image) textfield has to be filled");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else
			$("#divMsg").css ("visibility", "hidden");
			
		return true;
	}
	
	
	
/**
 * This method checks the strength of the password and whether or not 
 * it is allowed 
 * @param {Object} newPasswd
 */
	var onKeyUp = function (newPasswd) {
		var score = 0;
// change styles as the restrictions are accomplished
		if (newPasswd.match(/[a-z]/)) {
			//			$("intput#lcasechars").attr("checked", true);
			$('input[name=lcasechars]').attr('checked', true);
			hasLcase = true;
			score++;
		}
		else {
			$("#lcasechars").attr("checked", false);
			hasLcase = false;
		}
	
//if newPasswd has uppercase
		if (newPasswd.match(/[A-Z]/)) {
			$("#ucasechars").attr("checked", true);
			hasUcase = true;
			score++;
		}
		else {
			$("#ucasechars").attr("checked", false);
			hasUcase = false;
		}
		
//if newPasswd has number
		if (newPasswd.match(/\d+/)) {
			$("#numberchars").attr("checked", true);
			hasNumber = true;
			score++;
		}
		else {
			$("#numberchars").attr("checked", false);
			hasNumber = false;
		}
		
// password length
		if (newPasswd.length > 7) {
			$("#eightchars").attr("checked", true);
			has8Chars = true;
			score++;
		}
		else {
			has8Chars = false;
			$("#eightchars").attr("checked", false);
		}	
			
		$("#passwordStrength").attr("class", "strength"+score);
					
	}
	
	
	var refreshCaptcha = function () {
		$('#divMsg').text('');
		
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
		onKeyUp: onKeyUp,
		
		handleCancel: handleCancel,
		handleSubmit: handleSubmit,
		
		chkForm: chkForm
	}
	
}



ispasswdResetCtrlLoaded = true;
var passwdCtrl;


/*
$(document).ready(function () {
  grpDialog = new GroupDlgFormCtrl ();
	grpDialog.init();
});
*/



 
function onReady (username) {
// alert ("gropudlg onReady function");
	if (username == '-1') {
		alert ("User '"+username+"' was not found and reset password has been aborted");
		window.location.href = APPNAME+"/index.jsp";
	}
	
		
	passwdCtrl = new PasswdResetCtrl ();
	passwdCtrl.init();
}
