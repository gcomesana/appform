
var list;

var GroupDlgAjaxResp = function () {
		
		var onFail = function (o) {
      overlay.hide();
// Access the response object's properties in the
			var msg = o.responseText;
			
//		document.getElementById("body").appendChild(document.createTextNode(msg));
			alert (msg);
		};
		
		
/**
 * Handle the server response
 * @param {Object} responseText, the server response already is in *JSON* format
 * @param {Object} statusText
 */
		var onSuccess = function (responseText, statusText) {
			$("#divMsg").html("resp: "+responseText.res+":"+responseText.msg);
			$("#divMsg").css ("color", "red");
			$("#divMsg").css ("visibility", "visible");

			alert ("statusText: "+ statusText+"\n\nresp: "+responseText.res+":"+
							responseText.msg);							
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
var GroupDlgFormCtrl = function (){
	
	var ajaxResp;
//	var POST_ACTION = "respjson.jsp";
	var POST_ACTION = "/appform/servlet/MngGroupsServlet";
	
	var init = function () {
		ajaxResp = new GroupDlgAjaxResp ();
			
		// initialization for the form itself by using the jquery form plugin
		var formOptions = {
			beforeSubmit: chkForm,
			success: ajaxResp.onSuccess,
			type: "POST",
			dataType: "json",
			url: POST_ACTION
		};	
		
/* initialization for the dialog itself */
		$(function() {
			$("#formDlg").dialog({
				autoOpen: true,
				buttons: {
					"Send": function (event) {
						var $myBtn = $(event.target);
						$("#testform").ajaxSubmit (formOptions);

						return false;
					},
					
					"Cancel": function (event) {
						$(this).dialog("close");
					} 
				},
				draggable: false,
				
				modal: true,
				overlay: {
					opacity: 0.5,
					background: "black",
				},
				
				resizable: false,
				title: "Group chooser...",
				autoResize : true,
				
				height: 250,
				width: 350

			}); // dialog "constructor" function
		});
		
//		$("#testform").ajaxForm (formOptions);
/*
		$("#btnSubmit").click(function (event) {
			$("#testform").ajaxSubmit(formOptions);
			return false;
		});		
*/						

// Message layer initialization
		$("#divMsg").css("visibility", "hidden");
		$("#divMsg").css("font-size", "10px");
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
		var theForm = jqForm[0];
		var myVal = theForm['villages'].value;

alert ("myVal: "+myVal);		
		if (myVal == -1)
			return false;
	};
	
	
	
	var goItems = function (selName, type) {
				
	};
	
	
	
	return {
		init: init,
		goItem: goItems,
		chkForm: chkForm
    
	}
	
}


isGrpDlgCtrlLoaded = true;
var grpDialog;
function onReady () {
	grpDialog = new GroupDlgFormCtrl ();
	grpDialog.init();
}






