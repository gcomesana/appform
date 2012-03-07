/*
 * Global Ajax Response from Register server
 */



var AdmFormCtrl = function () {
  
  var ajaxResp;
  var txtUsrName, txtPass1, txtPass2;
  var comboRole, listGrp, listPrj;
// These two variables represents the left side project and group lists  
  var prjStore, grpStore;
  
  var listUsers;
  
	
  
	
/**
 * This method run through all user fields to gather the data and send it to
 * the server to register the new user or update it
 * [or update an existing user]
 */
  var getUserParameters = function () {
		
		var usrId = $('#frmUsrId').val();
		
    // Get username
    var sUsername = document.getElementById('username').value;
    if (sUsername == '') {
      alert("Please, fill the 'username' field");
      return null;
    }
    sUsername = encodeURIComponent(sUsername);
    
    // Get passwords
    var sPassword = document.getElementById('password').value;
    var sRePassword = document.getElementById('re-password').value;
    if (sPassword == '') {
      alert("Please, fill the 'password' field");
      return null;
    }
    else {
      if (sPassword != sRePassword) {
        alert("password are not equal. Write them again");
        return null;
      }
    }
    sPassword = encodeURIComponent(sPassword);
		
		
		var firstname = document.getElementById('firstname').value;
    if (firstname == '') {
      alert("Please, fill the 'First name' field");
      return null;
    }
    firstname = encodeURIComponent(firstname);
		
		var lastname = document.getElementById('lastname').value;
    if (lastname == '') {
      alert("Please, fill the 'Last name' field");
      return null;
    }
    lastname = encodeURIComponent(lastname);
		
		
    // Get list of selected role
    var sRoles = '', nameRole = '';
    var aRoleList = document.getElementById('selected_role').options;
    for (var iIndex = 0; iIndex < aRoleList.length; iIndex++) {
			sRoles += aRoleList[iIndex].value + ";";/*
      if (aRoleList[iIndex].selected) {
        sRole += aRoleList[iIndex].value+';';
        nameRole = aRoleList[iIndex].text;
      }*/
    }
    if (sRoles == '') {
      alert("Please, at least one role must be selected");
      return null;
    }
		sRoles = sRoles.substring(0, sRoles.length-1);
    
// Get list of selected groups
    var sGroupList = '';
    var aSelectedGroupList = document.getElementById('selected_group').options;
    for (var iIndex = 0; iIndex < aSelectedGroupList.length; iIndex++) {
      sGroupList += aSelectedGroupList[iIndex].value + ";";
    }
    if (sGroupList == '') {
      alert("Please, at least one group must be selected");
      return null;
    }
    sGroupList = sGroupList.substring(0, sGroupList.length - 1);// Delete last ';'
    
// Get list of selected project
    var sProjectList = '';
    var aSelectedProjectList = document.getElementById('selected_project').options;
    for (var iIndex = 0; iIndex < aSelectedProjectList.length; iIndex++) {
      sProjectList += aSelectedProjectList[iIndex].value + ";";
    }
    if (sProjectList == '' && nameRole != 'admin') {
      alert("Please, at least one project should be selected");
      return null;
    }
    sProjectList = sProjectList.substring(0, sProjectList.length - 1);// Delete last ';'
    
		var sUserField = "username=" + sUsername +  "&pwd=" +  sPassword +
    "&roles=" +  sRoles +  "&group=" +  sGroupList +  "&project=" +
    sProjectList+"&firstname="+firstname+"&lastname="+lastname+
		"&userId="+usrId;
    
    return sUserField;
  };
  
	
	
/**
 * Method to make an ajax request on the event to submit a new role
 */
	var newRole = function () {
		if ($('#frmRoleName').val() == '') {
			alert ('A role name has to be introduce');
			$('#frmRoleName').css('border', '2px dashed red');
			return;
		}
		
		var postData = "frmRoleName="+encodeURIComponent(txtGrp.value);
    postData += "&what=ROL";
    
    var xReq = new AjaxReq();
    xReq.setUrl("addelem.jsp");
    xReq.setMethod("POST");
    xReq.setPostdata(postData);
    xReq.setCallback(ajaxResp.onNewRole, ajaxResp.onFail, ajaxResp, null);
    xReq.startReq();
	}


  
  var newGroup = function () {
    var txtGrp = document.getElementById('frmGrpName');
    var grpTypeSel = document.getElementById('frmGrpType');
    
    if (txtGrp.value.length == 0 || txtGrp.value == 'New group name') {
      alert ("A Group name has to be introduced");
			$('#frmGrpName').css('border', '2px dashed red');
      return;
    }
    
    if (grpTypeSel.selectedIndex == 0 || grpTypeSel.selectedIndex == undefined) {
      alert ("A Group Type has to be selected");
			$('#frmGrpType').css('border', '2px dashed red');
      return;
    }
    
    var postData = "frmGrpName="+encodeURIComponent(txtGrp.value)+"&frmGrpType=";
    postData += grpTypeSel.options[grpTypeSel.selectedIndex].value;
    postData += "&what=GRP";
    
    var xReq = new AjaxReq();
    xReq.setUrl("addelem.jsp");
    xReq.setMethod("POST");
    xReq.setPostdata(postData);
    xReq.setCallback(ajaxResp.onNewGrp, ajaxResp.onFail, ajaxResp, null);
  alert (postData);
    xReq.startReq();
    
  };
  
  

  
  var newProject = function () {
    var txtPrj = document.getElementById('frmPrjName');
    var prjDesc = document.getElementById('frmPrjDesc');
    
    if (txtPrj.value.length == 0 || txtPrj.value == 'New project name') {
      alert ("A Project name has to be introduced");
			$('#frmPrjName').css('border', '3px dashed red');
      return;
    }
    
    var postData = "frmPrjName="+encodeURIComponent(txtPrj.value)+"&frmPrjDesc=";
    postData += encodeURIComponent(prjDesc.value);
    postData += "&what=PRJ";
    
    var xReq = new AjaxReq();
    xReq.setUrl("addelem.jsp");
    xReq.setMethod("POST");
    xReq.setPostdata(postData);
    xReq.setCallback(ajaxResp.onNewPrj, ajaxResp.onFail, ajaxResp, null);
    xReq.startReq();
    
  };
  
	
  
/**
 * Ajax submit to register form
 */
  var submitRegisterForm = function () {
    // Get user parameters
    var sUserField = getUserParameters();
    
    if (sUserField != null) {
      // insert fields via ajax...
      var xReq = new AjaxReq();
      xReq.setUrl("admin.jsp");
      xReq.setMethod("POST");
      xReq.setPostdata(sUserField);
      xReq.setCallback(ajaxResp.onResponse, ajaxResp.onFail, ajaxResp, null);
      xReq.startReq();
    }
		else
			resetRegisterForm ();
  };
  
  
	
/**
 * Reset parameters from register form
 */
  var resetRegisterForm = function () { 
    document.getElementById('username').value = '';
    document.getElementById('password').value = '';
    document.getElementById('re-password').value = '';
    $("#firstname").val('');
		$("#lastname").val('');
		$("#frmUsrId").val('');
    
//		document.getElementById('registered_role').options[0].selected = true;
		
// reset group lists    
    var aSelectedGroupList = document.getElementById('selected_group').options;
    for (var iIndex = 0; iIndex < aSelectedGroupList.length; iIndex++) {
      aSelectedGroupList[iIndex].selected = true;
    }
    moveOptions(document.getElementById('selected_group'), 
                document.getElementById('registered_group'));
    
// reset project lists
    var aSelectedProjectList = document.getElementById('selected_project').options;
    for (var iIndex = 0; iIndex < aSelectedProjectList.length; iIndex++) {
      aSelectedProjectList[iIndex].selected = true;
    }
    moveOptions(document.getElementById('selected_project'), 
                document.getElementById('registered_project'));
                
// reset role lists
		var aSelectedRoleList = document.getElementById('selected_role').options;
    for (var iIndex = 0; iIndex < aSelectedRoleList.length; iIndex++) {
      aSelectedRoleList[iIndex].selected = true;
    }
    moveOptions(document.getElementById('selected_role'), 
                document.getElementById('registered_role'));
								
    document.getElementById('frmGrpName').value = 'New group name';
    document.getElementById('frmPrjName').value = 'New project name';
		
		$('input#btnSend').val("register");
  };
  
	
  
/**
 * Gets the data related to the user selected in the list of users
 */  
  var displayUsr = function (opt) {
    var postData;
		var usrId = opt.value;
    postData = "what=usr&frmid="+usrId;
    
		$('#listUsrs > option').each (function () {
			$(this).css('font-weight', 'normal');
		})
		
// Disable some components if the user is disabled. This can be changed
		var disabled = $("#listUsrs > option['value="+usrId+"']").attr("disabled");
		var strDis = "";
		if (disabled != null)
			$("input").attr("disabled", "disabled");
			
		var xReqPrjs = new AjaxReq ();
		xReqPrjs.setUrl("/appform/servlet/AjaxUtilServlet");
    xReqPrjs.setMethod("GET");
    xReqPrjs.setPostdata("what=prj");
    xReqPrjs.setCallback(ajaxResp.onGetPrjs, ajaxResp.onFail, ajaxResp, null);
    xReqPrjs.startReq();
		
		var xReqRoles = new AjaxReq ();
		xReqRoles.setUrl("/appform/servlet/AjaxUtilServlet");
    xReqRoles.setMethod("GET");
    xReqRoles.setPostdata("what=rol");
    xReqRoles.setCallback(ajaxResp.onGetRols, ajaxResp.onFail, ajaxResp, null);
    xReqRoles.startReq();

		var xReqGrps = new AjaxReq ();
		xReqGrps.setUrl ("/appform/servlet/AjaxUtilServlet");
    xReqGrps.setMethod("GET");
    xReqGrps.setPostdata("what=grp");
    xReqGrps.setCallback(ajaxResp.onGetGrps, ajaxResp.onFail, ajaxResp, null);
    xReqGrps.startReq();
		
    var xReq = new AjaxReq();
    xReq.setUrl("getdata.jsp");
    xReq.setMethod("GET");
    xReq.setPostdata(postData);
    xReq.setCallback(ajaxResp.onGetUserData, ajaxResp.onFail, ajaxResp, null);
    xReq.startReq();
// alert (postData);
  }
  
  
  
  var delUsr = function () {
    var postData;
    
    if ($(listUsers).attr('selectedIndex') == -1) {
      alert ("An user has to be selected from the list of Regsitered Users");
      return;
    }
    
		var myListUsers = $(listUsers)[0];
    postData = "what=usr&frmid="+myListUsers.options[myListUsers.selectedIndex].value;
    postData += "&frmname="+myListUsers.options[myListUsers.selectedIndex].text;
    
    var xReq = new AjaxReq();
    xReq.setUrl("deldata.jsp");
    xReq.setMethod("POST");
    xReq.setPostdata(postData);
    xReq.setCallback(ajaxResp.onDelUser, ajaxResp.onFail, ajaxResp, null);
    xReq.startReq();
  }
  
  
  var init = function () {
    ajaxResp = new AjaxResponse ();
    
    txtUsrName = document.getElementById('username');
    txtPass1 = document.getElementById('password');
    txtPass2 = document.getElementById('re-password');
    
    listGrp = document.getElementById('selected_group');
    listPrj = document.getElementById('selected_project');
    comboRole = document.getElementById('registered_role'); 
    
    prjStore = document.getElementById('retistered_project');
    grpStore = document.getElementById('registered_group');
    
//    listUsers = document.getElementById('listUsrs');
		listUsers = $('#listUsrs');
		userOpts = $('#listUsrs > option');
		$(userOpts).click (function (ev) {
			var opt = ev.target;
			displayUsr(opt);
//			sayHello ($(opt)[0].text);
		})
		
		$('input#btnSend').click(function(ev) {
			$(this).val("register");
			resetRegisterForm();
		})
		
		$('input#frmPrjName').focus(function (ev) {
			$(this).css('border', '1px solid darkblue');
		})
	
  }
  
	
	var sayHello = function (str) {
		if (!str)
			alert ("sayHello");
			
		else
			alert (str);
	}
  
  
  return {
    getUserParameters: getUserParameters,
    submitRegisterForm: submitRegisterForm,
		newRole: newRole,
    newGroup: newGroup,
    newProject: newProject,
    resetRegisterForm: resetRegisterForm,
    displayUsr: displayUsr,
    delUsr: delUsr,
    
    init:init
  }
  
}



var overlay, admCtrl;
$(document).ready(function () {
	overlay = new Overlay ();
	admCtrl = new AdmFormCtrl();
	admCtrl.init ();
});


/*
var overlay;
var admCtrl;
function onReady () {
  overlay = new Overlay();
  admCtrl = new AdmFormCtrl ();
  admCtrl.init();
  
//  ajaxResp = new AjaxResponse();
}
*/


