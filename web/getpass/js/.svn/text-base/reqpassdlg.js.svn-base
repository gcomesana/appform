
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
var PasswdReqCtrl = function () {
	
	var ajaxResp;
	var POST_ACTION = "/appform/users/getpasswd";
	var grpType;
	
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
		ajaxResp = new PasswdReqAjaxResp ();
	
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
						$('#frmPasswdReq').ajaxSubmit(formOptions);
						
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
				height: 340,
				width: 500,
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
 * Validate the form through the jquery plugin form
 * @param {Object} formData, array of objects (in json format) with the form:
 * [{name: paramName1, value: paramValue1},
 * 	{name: paramName1, value: paramValue1}]
 * @param {Object} jqForm, a jquery object wrapping the form dom object
 * @param {Object} options
 */
	var chkForm = function (formData, jqForm, options) {
//alert ("grpDialog.chkForm: check the form before submitting");
		
		var myForm = jqForm[0];
		var mail = $("#frmemail").val(), mailBis = $("#frmemailbis").val();
		var username = $("#frmusername").val();
		var captchaBox = $("#j_captcha_response").val();
		

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
	};
	
	
	var refreshCaptcha = function () {
		$('#divMsg').text ('');
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
		chkForm: chkForm
	}
	
}



isPasswdReqCtrlLoaded = true;
var passwdReq;


/*
$(document).ready(function () {
  grpDialog = new GroupDlgFormCtrl ();
	grpDialog.init();
});
*/

 
function onReady () {
// alert ("gropudlg onReady function");
	passwdReq = new PasswdReqCtrl ();
	passwdReq.init();
}
