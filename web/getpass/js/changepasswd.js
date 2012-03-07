/**
 * This file displays two textfields inside a fieldset with a button
 * to change the password
 * 
 */

var passBar = new Ext.ProgressBar ({
	height: '15px',
	id: 'pbar'
})

var chkBoxLen = new Ext.form.Checkbox({
	fieldLabel: 'Is 8 characters long',
	id: 'chkBoxLength',
	autoWidth: true
})

var chkNumber = new Ext.form.Checkbox({
	fieldLabel: 'Contains number',
	id: 'chkBoxNum',
	autoWidth: true
})

var chkUcase = new Ext.form.Checkbox({
	fieldLabel: 'Contains uppercase characters',
	id: 'chkBoxUcase',
	autoWidth: true
})

var chkLcase = new Ext.form.Checkbox({
	fieldLabel: 'Contains lowercase characters',
	id: 'chkBoxLcase',
	autoWidth: true
})

var passwdItems = [chkBoxLen, chkNumber, chkUcase, chkLcase, passBar]

var PassResetWin = function () {
	
	var score = 0;
	var hasLcase=false;
	var hasUcase=false;
	var has8Chars=false;
	var hasNumber=false;
	
	
	var onSuccess = function (form, action) {
		Ext.MessageBox.show ({
			buttons: Ext.MessageBox.OK,
			icon: Ext.MessageBox.INFO,
			title: 'Password changed',
			msg: action.result.msg,
			width: 350,
			fn: function (btnId, txt, opt) {
				window.location.href = "../jsp/index.jsp";
				return;		
			}
		})
		
	}
	
	var onFail = function (form, action) {
		switch (action.failureType) {
      case Ext.form.Action.CLIENT_INVALID:
          Ext.Msg.alert('Failure', 'Form fields may not be submitted with invalid values');
          break;
      case Ext.form.Action.CONNECT_FAILURE:
          Ext.Msg.alert('Failure', 'Ajax communication failed');
          break;
      case Ext.form.Action.SERVER_INVALID:
         	Ext.Msg.alert('Failure', action.result.msg);
   	}
		
		Ext.MessageBox.show ({
			buttons: Ext.MessageBox.OK,
			icon: Ext.MessageBox.ERROR,
			title: 'Error',
			msg: action.result.errormsg,
			width: 350
		})
		
		var txtPass = Ext.getCmp ('frmpass');
		var txtPassBis = Ext.getCmp ('frmpass_bis');
		txtPass.setRawValue ('');
		txtPassBis.setRawValue ('');
	}
	
	
	
	
	var btnHandler = function (btn) {
// Ext.Msg.alert ('Button '+btn.getText()+' was clicked');
		var container = btn.ownerCt;
		var theForm = container.getForm();
		var formFields = theForm.getValues ();
		var errMsg = 'Both passwords have to be the same'
		
		if (formFields['frmpass'] != formFields['frmpass_bis']) {
			Ext.MessageBox.show ({
				buttons: Ext.MessageBox.OK,
				icon: Ext.MessageBox.ERROR,
				title: 'Error',
				msg: errMsg,
				width: 400
			})
			return;
/*	theForm.markInvalid ([{id:'frmpass',msg:errMsg},
														{id:'frmpass_bis',msg:errMsg}])*/
		}
		
		if (!(has8Chars && hasLcase && hasNumber && hasUcase)) {
			errMsg = 'Password has to fit the constraints on the left'
			Ext.MessageBox.show ({
				buttons: Ext.MessageBox.OK,
				icon: Ext.MessageBox.ERROR,
				title: 'Error',
				msg: errMsg,
				width: 350
			})
			return;
		}
		
		btn.ownerCt.getForm().submit({
//			clientValidation: true,
			url: APPNAME+'/users/getpasswd',
			success: onSuccess,
			failure: onFail
		})
	}
	
	
	
	var cancelHandler = function (btn) {
		Ext.MessageBox.show ({
			buttons: Ext.MessageBox.OK,
			icon: Ext.MessageBox.WARNING,
			title: 'Password change',
			msg: 'You have to change your password in order to continue using the application',
			width: 350
		})
		return;
	}
	
	
/**
 * This method checks the strength of the password and whether or not 
 * it is allowed 
 * @param {Ext.ProgressBar} the progress bar
 * @param {Object} newPasswd
 */
	var onKeyUp = function (pb, newPasswd) {
		var score = 0;
		
//		Ext.Msg.alert ('passwd so far:' +newPasswd);
//		pb.updateProgress (counter, 'Progress: '+(counter*10));
		
// change styles as the restrictions are accomplished

// if newPasswd has lowercase
		if (newPasswd.match(/[a-z]/)) {
			chkLcase.setValue (true);
			hasLcase = true;
			score++;
		}
		else {
			chkLcase.setValue(false);
			hasLcase = false;
		}
	
//if newPasswd has uppercase
		if (newPasswd.match(/[A-Z]/)) {
			chkUcase.setValue (true);
			hasUcase = true;
			score++;
		}
		else {
			chkUcase.setValue(false);
			hasUcase = false;
		}
		
//if newPasswd has number
		if (newPasswd.match(/\d+/)) {
			chkNumber.setValue(true);
			hasNumber = true;
			score++;
		}
		else {
			chkNumber.setValue(false);
			hasNumber = false;
		}
		
// password length
		if (newPasswd.length > 7) {
//			$("#eightchars").attr("checked", true);
			chkBoxLen.setValue(true);
			has8Chars = true;
			score++;
		}
		else {
			has8Chars = false;
			chkBoxLen.setValue(false);
		}	
			
//		$("#passwordStrength").attr("class", "strength"+score);
		passBar.updateProgress (score/4, '');
	}



	var formBtns = [{
		text: 'Ok',
		style: 'margin: 8px 5px 0 0',
		handler: btnHandler
	}, {
		text: 'Cancel',
		style: 'margin: 8px 0 0 5px',
		handler: cancelHandler
	}]


// Fieldset holding the checkbuttons and the progress bar to report the progress
	var fsProgress = {
		xtype: 'fieldset',
		columnWidth: 0.5,
		collapsible: false,
		autoHeight: true,
		title: 'Password strength',
		bodyStyle: 'padding: 0 4px',
		labelWidth: 200,
		defaults: {
			anchor: '-10',
			disabled: true
		},
		
		items: passwdItems
	}


/**
 * This is the fieldset with the two textfilds in the fieldset
 */
	var fsForm = {
		xtype: 'fieldset',
		columnWidth: 0.5,
		collapsible: false,
		autoHeight: true,
		title: 'Input new password',
		defaultType: 'textfield',
//		border: true,
		
		defaults: {
			anchor: '-20',
			enableKeyEvents: true,
			allowBlank: false
		},
		
		items: [{
			xtype: 'hidden',
			name: 'source',
			id: 'source',
			value: 'extjs'
		}, {
			fieldLabel: 'New password',
			inputType: 'password',
			name: 'frmpass',
			id: 'frmpass',
			
			listeners: {
				keyup: function (txtbox, ev) {
					ev.preventDefault ();
					onKeyUp (passBar, txtbox.getRawValue());
				}
			}
		}, {
			fieldLabel: 'Repeat password',
			inputType: 'password',
			name: 'frmpass_bis',
			id: 'frmpass_bis',
			
			listeners: {
				keyup: function (txtbox, ev) {
					ev.preventDefault ();
					onKeyUp (passBar, txtbox.getRawValue());
				}
			}
		}] // eo items
	}
	
	
	var passwdForm = {
		xtype: 'form',
		autoHeight: true,
		autoWidth: true,
		header: false,
//		url: 'http://localhost:8080/appform/test-ext.jsp',
//		title: 'Login',
//		labelAlign: 'right',
		buttonAlign: 'center',
		layout: 'column',
//		labelWidth: 200,
		
		defaults: {
			layout: 'form', 
			border: false,
			bodyStyle: 'padding: 2px 2px 2px 2px'
		},
		items: [fsForm, fsProgress],
		buttons: formBtns
	};
	
	
	var passwdWin;
	return {
		init: function () {
			passwdWin = new Ext.Window ({
				id: 'mainWin',
				frame: true,
				closable: false,
				resizable: false,
//				height: 350,
				autoHeight: true,
				width: 600,
				title: 'Password change',
				modal: true,
				draggable: false,
				
				defaults: {frame:true, autoHeight: true},
				items: [passwdForm]
			})
		},
		
		display: function (domEl) {
			passwdWin.show ();
		}
		
	}
	
}();

var scriptDef;
Ext.onReady (function () {
	if (scriptDef == 1)
		return;
	else
		scriptDef = 1;
		
//	var anElem = Ext.get('container').applyStyles ("border: 2px dashed blue;margin: 50px");
	var anElem = Ext.get('container').applyStyles("visibility:hidden");
	Ext.QuickTips.init();
	
	PassResetWin.init ();
	PassResetWin.display (anElem);
});
 
 
 