
var displayCtrl;
var hint;

var DisplayCtrl = function(){

//	var ajaxResp;
	var outVar;
	
	var selPrjId;
	var selPrjName;
	
	var init = function(){
		outVar = 2;
		
//		ajaxResp = new DisplayResponses ();
//		ajaxResp.init ();

// init page objects
		$("#comboPrj").change (function () {
			selPrjName = $("#comboPrj > option:selected").text();
			selPrjId = $("#comboPrj > option:selected").val();
		})
		
// initial ajax call to fill the projects combo
		$.ajax ({
			url: APPNAME+'/servlet/QryServlet',
			type: 'GET',
			data: 'what=prj',
			dataType: "json",
//			success: ajaxResp.onAjaxGetPrjs,
//			error: ajaxResp.onAjaxError
			success: dispResp.onAjaxGetPrjs,
			error: dispResp.onAjaxError
		});
		
// set the button onclick event
		$("#btnGo").click (function () {
			if ($("#comboPrj > option:selected").val() == -1) {
				alert("A Project must be selected")
				return false;
			}
			
			if ($("#frmIntrvName").val() == "") {
				alert ("A (partial) name of an interview has to be provided");
				return false;
			}
//			displayCtrl.goIntrv();
//			var postData = 'what=intrv&parentid='+selPrjId+"&intrvname=";
			var postData = 'what=search&parentid='+selPrjId+'&intrvname=';
			postData += $("#frmIntrvName").val();
			
			$.ajax ({
				url: APPNAME+'/servlet/QryServlet',
				type: 'GET',
				data: postData,
				dataType: "json",
//				success: ajaxResp.onAjaxGetIntrvs,
//				error: ajaxResp.onAjaxError
				success: dispResp.onAjaxGetIntrvs,
				error: dispResp.onAjaxError
			});	
		});
			
	}
	
	
	var goIntrv = function () {
		var postData = 'what=intrv&parentid='+selPrjId+"&intrvname=";
		postData += $("#frmIntrvName").val();
alert (postData);
		
		$.ajax ({
			url: APPNAME+'/servlet/QryServlet',
			type: 'GET',
			data: postData,
			dataType: "json",
			success: ajaxResp.onAjaxGetIntrvs,
			error: ajaxResp.onAjaxError
		});

	}
	
	
	
	
	var test = function(){
		alert(outVar);
	}
	
	return {
//		ajaxResp: DisplayResponses,
		
		goIntrv: goIntrv,
		theTest: test,
		init: init
	}
}



$(document).ready(function () {
	dispResp = new DisplayResponses ();
	dispResp.init ();
	
	displayCtrl = new DisplayCtrl ();
	displayCtrl.init ();
})
