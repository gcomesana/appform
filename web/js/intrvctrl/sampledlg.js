Ext.BLANK_IMAGE_URL = '../../js/lib/ext/resources/images/default/s.gif';

// declaring the namespace for all this mini-application
Ext.ns ('Sampledlg');


var IntroDlg = function () {
	
	var grpId; // the id of the current secondary active group
	var subjectValidated = false;
	
	
/**
 * Save a entry on performance history for the current interview. This is the 
 * callback function for the ajax call to save a perforrmance
 * @param {Object} options, the options object which was passed to the previous
 * ajax call to save the performance
 * @param {Object} success, result of the ajax call
 * @param {Object} resp, custom response from server
 */
	var samplePerfHist = function (options, success, resp) {
		if (!success) 
			utils.raiseMsg (msg);
			
		else {
			var jsonResp = Ext.util.JSON.decode (resp.responseText);
			var myPerfId = jsonResp.perfid;
			Ext.Ajax.request ({
				url: APPNAME+'/servlet/IntrvServlet',
				params: {
					what:'perf_cfg', 
					perfid: myPerfId, 
					usrid: IntroDlg.appCfg.usrid, 
					patcode: options.params.patcode,
				},
				method: 'POST',
				
				callback: function(options, success, resp) {
			// raise a msg in the case of success is false and interview is marked as short
		//			if (!success && shrt == 1) {
					if (!success) {
						var msg = "History record for this SHORT interview could not be saved. ";
						msg += 'Unable to continue, try again and contact the ';
						msg += ' <a href="mailto:'+utils.ADMIN_MAIL+'">administrator</a> if problem continues';
						
						utils.raiseMsg (msg);
						return false;
					}
					// redirect to intrv.jsp
					window.location.href = 'intrv.jsp';
					
				}, // eo callback
				
				failure: function (resp, opts) {
					utils.raiseMsg ("Writing history of interview failure: "+resp.responseText);
				}
				
			}); // eo ajax request
			
		} // eo else	
	}
	
	
/**
	* Handler for button click. Primarily, it checks for subject existence and,
	* then, make the operations regarded to create it or not depending on whether the
	* questionnaire is allowed to create subjects
	* @param {Object} btn
	*/
	var btnHandler = function (btn) {
	//	var casectrl = typeCombo.getValue();
		if (btn.id == 'btnCancel') {
			window.close ();
			return;
		}
		
		var samplecode = Ext.getCmp('samplecode').getValue().toUpperCase();
		var msg = "Fail to create new interview for sample '"+samplecode;
				msg += "'. ";
				msg += 'Unable to continue, try again and contact the ';
				msg += ' <a href="mailto:'+utils.ADMIN_MAIL+'">administrator</a> if problem continues';
					
	// console.info("about to create new performance (and subject)");
		var savePerfTx = Ext.Ajax.request ({
			url: APPNAME+'/servlet/IntrvServlet',
			params: {
				what:'perf',
				usrid: IntroDlg.appCfg.usrid, 
				intrvid: IntroDlg.appCfg.intrvid,
				type: 'sample', 
				patcode: samplecode
			},
			method: 'POST',
			
			callback: samplePerfHist,
			
			failure: function (resp, opts) {
				utils.raiseMsg ("Writing interview for subject '"+fullpatcode+"' failure: "+
							resp.responseText);
			}
		});
	
		return savePerfTx;
	}
	

/**
 * onChange the group combo a servlet has to be called to set the active 2grp!!
 * Both group code -to build the full patient code- and group id -to set the
 * active group for session- has to be considered
 * @param {Object} combo, the item which raised the event
 * @param {Object} record, the entry of the combo which was selected
 * @param {Object} index, the index of the element selected
 */
	var onChangeGrp = function (combo, record, index) {
		var msg = 'ComboId "'+combo.getId()+'" selected val: ';
		msg += record.data.id + '. '+record.data.name + ' (' + record.data.cod +')';
// console.info (msg);		
		
		if (combo.getId() == 'comboGrp') {
			Ext.Ajax.request ({
				url: APPNAME+'/servlet/MngGroupsServlet',
				method: 'POST',
				params: {intrvid: IntroDlg.appCfg.intrvid, grpid:record.data.id},
				
				callback: function (options, success, resp) {
					var jsonResp = Ext.util.JSON.decode(resp.responseText);
					if (success == true) {
						// console.debug (jsonResp.msg);
// add secondary active group parameters to configuration object
						IntroDlg.appCfg.grpid = record.data.id;
						IntroDlg.appCfg.grpcode = record.data.cod;
					}
				},  // eo callback
				
				failure: function (resp, opts) {
					Ext.Msg.alert ("request failure: "+resp.responseText);
				}
			});
		}
	

	}
	
	
	
/*
 * This is the public method to check if the sample code as input in the textfield
 * by hand match in the first nine digits with the patient code has to be associated with
 *	
var checkSampleCode = function () {
	
	if (subjectValidated) {
		var txtSample = Ext.getCmp ('samplecode')
		
		var grpCombo = Ext.getCmp('comboGrp');
		var comboType = Ext.getCmp('typeCombo');
		var subjCode = Ext.getCmp('subjCode');
		
	}
	
	
}
*/

	
	
/**
 * This is the public method to check if the subject composed by group combo, 
 * case/control combo and subject code is registered on database
 */
	var checkSubject = function () {
// if grpCombo is valid and type is valid and code is valid => ajax
		Ext.getCmp('btnOk').disable();

		var grpCombo = Ext.getCmp('comboGrp');
		var comboType = Ext.getCmp('typeCombo');
		var subjCode = Ext.getCmp('subjCode');
		
		if (grpCombo.isValid() && comboType.isValid() && subjCode.isValid() &&
				!subjectValidated) {
			var type = comboType.getValue ();	
			var fullcode = IntroDlg.appCfg.prjcode + IntroDlg.appCfg.grpcode + type + subjCode.getValue();
			
			Ext.Ajax.request ({
				url: APPNAME+'/servlet/IntrvServlet',
				params: {what:'patcode', patcode:fullcode},
				method: 'GET',
				
				callback: function (options, success, resp) {
					var jsonResp = Ext.util.JSON.decode(resp.responseText);
					if (success == true) {
						if (jsonResp.is == 0) {
							subjectValidated = false;
							var msg = 'The subject is not registered on the application'
							utils.raiseMsg (msg);
							
							comboType.markInvalid();
//							comboType.clearValue();
							subjCode.markInvalid();
							
							Ext.getCmp('samplecode').disable();
							Ext.getCmp('btnOk').disable();
						}
						else { // subject is in db
							if (type == Sampledlg.FAMILY_TYPE) {
								var sampleTxt = Ext.getCmp('samplecode')
								var codeSizeFam = Sampledlg.SUBJ_TYPE_SIZE + Sampledlg.HOSP_SIZE +
											Sampledlg.SUBJ_CODE_SIZE+Sampledlg.FAM_XTRA_SIZE
								 
								var regexFamStr = "\\w{3}\\d{"+codeSizeFam+"}"
								var regexFam = new RegExp (regexFamStr)
								sampleTxt.regex = regexFam
// console.info ("sampleTxt.regex: "+regexFam)								
								sampleTxt.minLength = Sampledlg.FULL_SUBJ_CODE_SIZE + Sampledlg.FAM_XTRA_SIZE
								sampleTxt.maxLength = Sampledlg.FULL_SUBJ_CODE_SIZE + Sampledlg.FAM_XTRA_SIZE
							}
								
								
							subjectValidated = true;
							comboType.clearInvalid();
							Ext.getCmp('samplecode').enable();
						}
					}
					
				},  // eo callback,
				
				failure: function (resp, opts) {
					Ext.Msg.alert ("Check for subject failure: "+resp.responseText);
				}
			});
			
		} // eo if are valid
		
	}
	


/**
 * This is the callback method called back by the three subject components when
 * any of them goes to invalid
 * @param {Object} comp
 * @param {Object} msg
 */	
	var onInvalid = function (comp, msg) {
		subjectValidated = false;
		Ext.getCmp('btnOk').disable();
		
		if (comp.getName() != 'samplecode')
			Ext.getCmp('samplecode').disable();
	}
	 	
	
/**
 * This is the callback method for valid/invalid events on the sample code 
 * textfield. The value in the textfield has to match with the patient code
 * in the first 9 digits. Last 2 digits are arbitrary
 * @param {Object} valid
 */
	var chkSampleCode = function (textfield, msg) {
//		if (textfield.disabled == false)
		Ext.getCmp('btnOk').disable();
// console.info("chkSamplecode")
		var grpCombo = Ext.getCmp('comboGrp');
		var comboType = Ext.getCmp('typeCombo');
		var subjCode = Ext.getCmp('subjCode');
		
		if (grpCombo.isValid() && comboType.isValid() && subjCode.isValid() &&
				!subjectValidated) {
			var type = comboType.getValue ();
			var grp = grpCombo.getValue();	
//			var fullcode = IntroDlg.appCfg.prjcode + IntroDlg.appCfg.grpcode + type + subjCode.getValue();

			var patcode = IntroDlg.appCfg.prjcode + grp + type + subjCode.getValue()
			var sampleValue = textfield.getValue().toUpperCase()
			var subjectSample = sampleValue.substr (0, 9);
			
//			console.info (subjectSample+" vs "+patcode);
			if (subjectSample == patcode)		
				Ext.getCmp('btnOk').enable();
				
			else {
				textfield.markInvalid ("Sample code and subject code don't match");
//				textfield.setValue ("Sample code and subject code don't match")
				Ext.getCmp('btnOk').disable();
			}
								
		}	
			
		
	}


/**
 * This is the callback function on event load for the groups store class. This
 * callback is intended just to set the current secondary group already selected
 * on the combobox
 * @param {Object} store
 * @param {Object} records
 * @param {Object} options
 */
	var setSecGrp = function (store, records, options) {
		var grpCombo = Ext.getCmp('comboGrp');
		
		if (IntroDlg.appCfg.grpcode != undefined) {
	// console.info ('setting grpcode: '+IntroDlg.appCfg.grpcode);
			grpCombo.setValue(IntroDlg.appCfg.grpcode);
		}
	}
	

	var clearInvalid = function (comp) {
		comp.clearInvalid();
	}
	

// NOTE ////////////////////////////////////////////////////////////////////	
/* This one returns a DOM element without methods (they are not dom objects)
			var tagUsridNode = Ext.DomQuery.selectNode ('input[name=usrid]');
			var tagGrpidNode = Ext.DomQuery.selectNode('input[name=grpact]');

 	Ext.get() method returns a Element object, such that methods can be applied
			var tagUsrid = Ext.get("usrid");
			var tagGrpid = Ext.get("grpact");
			usrid = tagUsrid.getValue (true);
*/
	
/**
 * Methods to make public 
 */
	var introWin;
	return {
		appCfg: utils.jsonConfig(APPNAME+'/servlet/IntrvServlet', 
												 {"what":"appcfg"}, 'GET', false),
		
		init: function () {
			/*
			var paramCfg = new Array();
			paramCfg['what'] = 'appcfg';
			IntroDlg.appCfg = utils.config (APPNAME+'/servlet/IntrvServlet', 
															paramCfg, 'GET', false);
			*/
			introWin = new Sampledlg.Dialog ();
			
			var txtSample = Ext.getCmp ('samplecode');
		},
		
		
		display: function (domEl) {
			introWin.show ();
		},
		

		onChangeGrp: onChangeGrp,
		subjectValid: checkSubject,
		setSecondaryGrp: setSecGrp,
		clearInvalid: clearInvalid,
		goInvalid: onInvalid,
		
		btnHandler: btnHandler,
		chkSample: chkSampleCode
	}
	
}();



Ext.onReady (function () {
//	var anElem = Ext.get('container').applyStyles ("border: 2px dashed blue;margin: 50px");
	Ext.QuickTips.init();
	
//	IntroDlg.config();
//	var store = new Sampledlg.GrpStore ({storeId: 'secGrps', usrid: 101});
	IntroDlg.init ();
	IntroDlg.display ();
});




