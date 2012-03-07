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
	var onSuccess = function (responseText, statusText) {
//			$("#divMsg").html("resp: "+responseText.res+":"+responseText.msg);
//			$("#divMsg").css ("color", "red");

		var rt = $("input#rt").val();
		var redirPage = "index.jsp?intrv="+responseText.intrv+"&rt="+rt;
		
//			alert (responseText.msg);
		$("#divMsg").html(responseText.msg);
		$("#divMsg").css("visibility", "visible");
		
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
	var POST_ACTION = "/appform/users/getpasswd";
	var grpType;
	
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
	/* Using jquery.validate plugin to make validation of the boxes
	$("#frmPasswdReset").validate({
		rules: {
			frmusername: {
				required: true
			},
			frmpass: {
				required: true,
				minlength: 8
			},
			frmpassbis: {
				required: true,
				minlength: 8,
				equalTo: "#frmpass"
			}
		}
		messages: {
			frmusername: {
				required: "This field has to be filled"
			},
			frmpass: {
				required: "This field has to be filled",
				minlength: "Minimum number of characters for this field is 8"
			},
			frmpassbis: {
				required: "This field has to be filled",
				minlength: "Minimum number of characters for this field is 8",
				equalTo: "Password boxes do not match"
			}
		}
	});
	
// check if confirm password is still valid after password changed
	$("#frmpass").blur(function() {
		$("#frmpassbis").valid();
	});
	*/
	
	$('input[type=checkbox]').attr('checked', false);
	
// Options object for the ajaxForm
	var formOptions = {
		beforeSubmit: chkForm,
		success: ajaxResp.onSuccess,
		error: ajaxResp.onFail,
		type: "POST",
		dataType: "json",
		url: POST_ACTION
	};
	
	
/* initialization for the dialog itself */
		$(function() {
			$("#dialog").dialog({
				autoOpen: true,
				buttons: {
					"Send": function () {
						$('#frmPasswdReset').ajaxSubmit(formOptions);
						
						return false;
					},
					
					"Cancel": function () {
						$(this).dialog("close");
						window.location.href = "/appform/index.jsp";
					} 
				},
				draggable: false,
				modal: true,
				overlay: {
					opacity: 0.7,
					background: "black",
				},
				height: 370,
				width: 700,
				resizable: false,
				title: "Password recovery dialog",
			}); // dialog "constructor" function
		}); // function
		
		
// Message layer initialization
//		$("#divMsg").css("visibility", "hidden");
		$("#divMsg").css("font-size", "11px");
		$("#divMsg").css("color", "red");
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
	var chkForm = function (formData, jqForm, options) {
//alert ("grpDialog.chkForm: check the form before submitting");
		
		var myForm = jqForm[0];
		var captchaBox = $("#j_captcha_response").val();
		var mail = $("#frmpass").val(), mailBis = $("#frmpassbis").val();

		var isCaptchaFilled = (captchaBox != "");
		
// check whether or not all restrictions are accomplished								
		if (!(hasLcase && hasNumber && hasUcase)) {
			$("#divMsg").text("All restrictions have to be accomplished");
			$("#divMsg").css("visibility", "visible");
			
			return false;
		}
		else
			$("#divMsg").css ("visibility", "hidden");
		
// alert ($('#frmpass').val() +' vs '+ $('#frmpassbis').val()+"... so "+$('#frmpass').val() != $('#frmpassbis').val());
		if ($('#frmpass').val() != $('#frmpassbis').val()){
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
	};
	
	
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
		imgCaptcha[0].src = "/appform/jcaptcha#"+randomNum;
	}
	
	
	var goItems = function (selName, type) {
				
	};
	
	return {
		init: init,
		goItem: goItems,
		refresh: refreshCaptcha,
		onKeyUp: onKeyUp,
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
		window.location.href = "/appform/index.jsp";
	}
	
		
	passwdCtrl = new PasswdResetCtrl ();
	passwdCtrl.init();
}
