// VALIDATION TYPE FOR PATIENT CODE ///////////////////////////////////////
// Ext.form.VTypes['patcodeVal']  = /^\d{3}$/; 
// Ext.form.VTypes['patcodeMask'] = /\d/; 
Ext.form.VTypes['patcodeVal'] = /^[a-zA-Z0-9]{3}$/;
Ext.form.VTypes['patcodeMask'] = /[a-zA-Z0-9]/
Ext.form.VTypes['patcodeText'] = 'In-valid subject code.';
Ext.form.VTypes['patcode'] = function(v) {
	return Ext.form.VTypes['patcodeVal'].test(v);
}


var codeRegExp = /^\d{3}$/;
codeRegExp = /^[a-zA-Z0-9]{3}$/
Ext.apply(Ext.form.VTypes, {
	// mutual validation for subject code 	
	// subjCodeVal: /^\d{3}$/
	subjCodeVal: /^[a-zA-Z0-9]{3}$/,
	// subjCodeMask: /\d/,
	subjCodeMask: /[a-zA-Z0-9]/,
	subjCodeText: 'In-valid subject code.',

	subjCode: function(val, field) {
		if (codeRegExp.test(val)) { // test the regexp
			if (field.anotherCode) { // test against the other field
				var code = Ext.getCmp(field.anotherCode);
				return (val == code.getValue());
			}
			return true;
		} else return false;
	},


	// mutual validation for subject type combo (case/control)	
	subjType: function(val, field) {
		if (field.anotherType) {
			var theType = Ext.getCmp(field.anotherType);

			return (val == theType.getRawValue());
		}
		//		return false;
	},
});


// Initializing the JSON configuration object
var paramCfg = new Array();
paramCfg['what'] = 'appcfg';
var objCfg = utils.config(APPNAME + '/servlet/IntrvServlet', paramCfg, 'GET', false);



/**
 * Method which configures the performance
 * @param {String} thePerfId
 * @param {String} patcode
 */
var configPerf = function(thePerfId, patcode) {
		//	var myPerfid = jsonResp.perfId;
		var shortPerf;
		// if the questionnaire is tagged as shortable, then the checkbox has to be examined
		if (objCfg.shrt == 1) {
			var radioNormal = Ext.getCmp('radioNormal');
			// if radionormal is checked, shortPerf has to be 0
			shortPerf = radioNormal.getValue() ? 0 : 1;
		} else // if questionnaire is not shortable, shortPerf is always 0
		shortPerf = 0;

		Ext.Ajax.request({
			url: APPNAME + '/servlet/IntrvServlet',
			params: {
				what: 'perf_cfg',
				perfid: thePerfId,
				usrid: objCfg.usrid,
				patcode: patcode,
				shrtIntv: shortPerf
			},
			method: 'POST',

			callback: function(options, success, resp) {
				// raise a msg in the case of success is false and interview is marked as short
				//			if (!success && shrt == 1) {
				if (!success) {
					var msg = "History record for this SHORT interview could not be saved. ";
					msg += 'Unable to continue, try again and contact the ';
					msg += ' <a href="mailto:' + utils.ADMIN_MAIL + '">administrator</a> if problem continues';

					utils.raiseMsg(msg);
					return false;
				}
				// redirect to intrv.jsp
				window.location.href = 'intrv.jsp';

				var radioNormal = Ext.getCmp('radioNormal');
				if (radioNormal.getValue()) window.location.href = 'intrv.jsp';
				//				window.location.href = 'intrv.jsp?patcode='+patcode+'&intrv='+objCfg.intrvid+"&patcode="+patcode;
				else window.location.href = 'intrv.jsp';
			},
			// eo callback
			failure: function(resp, opts) {
				utils.raiseMsg("Writing history of interview failure: " + resp.responseText);
			}
		});

	}



	/**
	 * This method makes an AJAX call to the server in order to save a new patient
	 * and performance in the case of the subject is not on database and the
	 * interview can create subject
	 * @param {String} fullpatcode
	 */
var savePerformance = function(fullpatcode) {
		var msg = "Fail to create new interview for subject '" + fullpatcode;
		msg += "'. ";
		msg += 'Unable to continue, try again and contact the ';
		msg += ' <a href="mailto:' + utils.ADMIN_MAIL + '">administrator</a> if problem continues';

		// console.info("about to create new performance (and subject)");
		var savePerfTx = Ext.Ajax.request({
			url: APPNAME + '/servlet/IntrvServlet',
			params: {
				what: 'perf',
				usrid: objCfg.usrid,
				intrvid: objCfg.intrvid,
				patcode: fullpatcode
			},
			method: 'POST',

			callback: function(options, success, resp) {
				// raise a msg in the case of success is false and interview is marked as short
				if (!success) {
					utils.raiseMsg(msg);
				} else {
					var jsonResp = Ext.util.JSON.decode(resp.responseText);
					var myPerfId = jsonResp.perfid;
					configPerf(myPerfId, options.params.patcode);
				}
			},

			failure: function(resp, opts) {
				utils.raiseMsg("Writing interview for subject '" + fullpatcode + "' failure: " + resp.responseText);
			}

		});

		return savePerfTx;
	}



	/**
	 * This "method" make the actions regarded to the end of the questionnaire. These
	 * ones are creating performance (if required) and creating performance history
	 * entry to track the performances.
	 * There are so many controls to check:
	 * - possibility for creating new subjects
	 * - possibility for short interview
	 * - user already created...
	 * As this is a Ext.Ajax.request callback, the parameters are as documented on
	 * ExtJs 3.0 documentation.
	 * @param {Object} options
	 * @param {Object} success
	 * @param {Object} resp
	 */
var afterDlgComplete = function(options, success, resp) {
		var jsonResp = Ext.util.JSON.decode(resp.responseText);
		var msg = 'subject ' + jsonResp.patcode + ' ';
		var perfResult;

		if (success == true) {

			if (jsonResp.is == 0) { // subject not in db
				// console.info (msg+'is not in db');
				if (objCfg.crtSubj == 0) { // not allowed to create
					// console.info('Not allowed to create new subject');
					Ext.getCmp('typeCombo').markInvalid();
					Ext.getCmp('typeComboBis').markInvalid();
					Ext.getCmp('patcode').markInvalid();
					Ext.getCmp('patcodebis').markInvalid();

					var msg = 'It is not allowed to create new subjects for this ';
					msg += 'questionnaire. Please insert an existent subject identifier';
					utils.raiseMsg(msg);

				} else { // can create subject
					// save a (new) performance and perf history
					Ext.Msg.show({
						title: 'Create subject',
						msg: "Create subject with id '<b style=\"color:red\">" + jsonResp.patcode + "</b>'?",
						buttons: Ext.Msg.YESNO,
						icon: Ext.MessageBox.QUESTION,
						modal: true,
						minWidth: 300,

						fn: function(btnId, text, opts) {
							if (btnId == 'yes') {
								perfTxId = savePerformance(jsonResp.patcode);
							}
						}
					}); // msg.show
				} // eo else
			} else { // subject in db
				// console.info (msg+'is in db');
				// should retrieve the performance id to create the new entry on perf history
				Ext.Ajax.request({
					url: APPNAME + '/servlet/IntrvServlet',
					params: {
						what: 'perfchk',
						usrid: objCfg.usrid,
						intrvid: objCfg.intrvid,
						patcode: jsonResp.patcode
					},
					method: 'GET',

					callback: function(options, success, resp) {
						if (!success) {
							var msg = "Fail to retrieve performance for patient '" + options.params.patcode + "'. ";
							msg += 'Unable to continue, try again and contact the';
							msg += ' <a href="mailto:' + utils.ADMIN_MAIL + '">administrator</a> if ';
							msg += 'problem continues';

							utils.raiseMsg(msg);
						} else {
							var jsonResp = Ext.util.JSON.decode(resp.responseText);
							var myPerfId = jsonResp.perfid;
							configPerf(myPerfId, options.params.patcode);
						}
					},
					// eo callback
					failure: function(resp, opts) {
						utils.raiseMsg("Retrieving for subject '" + opts.patcode + "' failure: " + resp.responseText);
					}
				}); // eo AjaxRequest

			} // else subject is in db
		} // no success
		else {
			var msg = "The request could not be satisfied.";
			msg += 'Try again and, if problem persist, contact with the administrators';

			utils.raiseMsg(msg);
			return;
		}

	}



	// FORM BUTTONS STUFF /////////////////////////////////////////////////////
	/**
	 * Handler for button click. Primarily, it checks for subject existence and,
	 * then, make the operations regarded to create it or not depending on whether the
	 * questionnaire is allowed to create subjects
	 * @param {Object} btn
	 */
var btnHandler = function(btn) {
		var fullPatcode = '';
		//	var casectrl = typeCombo.getValue();
		var grp = Ext.getCmp('comboGrp').getValue();
		var casectrl = Ext.getCmp("typeCombo").getValue();
		var patcode = Ext.getCmp("patcode").getValue();
		fullPatcode += objCfg.prjcode + objCfg.grpcode + casectrl + patcode;

		if (btn.id == 'btnCancel') {
			window.close();
			return;
		}



		// 02.11: new check to report whether or not the subject is already in database
		Ext.Ajax.request({
			//		url: 'php/groups.php',
			url: APPNAME + '/servlet/IntrvServlet',
			params: {
				what: 'patcode',
				patcode: fullPatcode
			},
			method: 'GET',

			callback: afterDlgComplete,

			failure: function(resp, opts) {
				Ext.Msg.alert("Check for subject failure: " + resp.responseText);
			}
		});
	}


var formBtns = [{
	id: 'btnOk',
	text: 'Ok',
	style: 'margin: 0 5px',
	handler: btnHandler,
	//	disable: true
	formBind: true
}, {
	id: 'btnCancel',
	text: 'Cancel',
	style: 'margin: 0 0 0 5px',
	handler: btnHandler
}]
// FORM BUTTONS STUFF /////////////////////////////////////////////////////


// SUBJECT TYPE DATA STUFF ////////////////////////////////////////////////
var jsonType = {
	types: [{
		id: 1,
		name: 'Case',
		cod: '01'
	}, {
		id: 2,
		name: 'Control',
		cod: '02'
	}, {
		id: 3,
		name: 'Family',
		cod: '03'
	}]
}

var typeJsonSt = new Ext.data.JsonStore({
	// json reader config
	root: 'types',
	fields: ['id', 'name', 'cod'],
	idProperty: 'id',

	// this store config
	storeId: 'typeStore',
	data: jsonType,
	autoDestroy: true
});


var typeJsonStBis = new Ext.data.JsonStore({
	// json reader config
	root: 'types',
	fields: ['id', 'name', 'cod'],
	idProperty: 'id',

	// this store config
	storeId: 'typeStorebis',
	data: {
		types: [{
			id: 1,
			name: "Case",
			cod: "01"
		}, {
			id: 2,
			name: "Control",
			cod: "02"
		}, {
			id: 3,
			name: "Family",
			cod: "03"
		}]
	},
	autoDestroy: true
});
// SUBJECT TYPE DATA STUFF ////////////////////////////////////////////////

// SUBJECT DATA STUFF ////////////////////////////////////////////////
/*
var jsonSubj = [
	{id:1300, prj:"157", grp:"03", cc:"1", code:"024", subjcode:"157031024"},
	{id:2400, prj:"157", grp:"01", cc:"1", code:"035", subjcode:"157011035"}
]
var subjJsonSt = new Ext.data.JsonStore ({
// json reader config
	root: null,
	fields: ['id', 'prj', 'cod', 'grp', 'cc','code','subjcode'],
	idProperty: 'id',

// this store config
	storeId: 'subjStore',
	data: jsonSubj,
	autoDestroy: true,
	
	autoLoad: true
});
*/

var myJsonCodes = [{
	"code": "157031024"
}, {
	"code": "10398365"
}, {
	"code": "1570931003"
}, {
	"code": "157011035"
}]
var myJsonSt = new Ext.data.JsonStore({
	// json reader config
	root: null,
	fields: ['code'],
	idProperty: 'code',

	// this store config
	storeId: 'subjStore',
	data: myJsonCodes,
	autoDestroy: true,

	autoLoad: true
});


var subjJsonSt = new Ext.data.JsonStore({
	// json reader config
	root: null,
	fields: ['code'],
	idProperty: 'code',

	// this store config
	storeId: 'subjStore',
	proxy: new Ext.data.HttpProxy({
		url: APPNAME + '/servlet/QryServlet',
		method: 'GET',
	}),
	baseParams: {
		'what': 'cod'
	},

	autoDestroy: true
});
// EO SUBJECT DATA STUFF ////////////////////////////////////////////////

// GROUP DATA STUFF ///////////////////////////////////////////////////////
var grpData = {
	hospitals: [{
		id: 1,
		name: "Hostpital del Mar",
		cod: 102
	}, {
		id: 2,
		name: "Hospital de Sant Pau",
		cod: 50
	}, {
		id: 3,
		name: "Hostpital de Oviedo, Oviedo",
		cod: 104
	}, {
		id: 102,
		name: "Hospital Gregorio Marañón",
		cod: 112
	}, {
		id: 504,
		name: "Hospital General Universitario Facultativo de Orduña, Asturias",
		cod: 133
	}]
};

var grpJsonSt = new Ext.data.JsonStore({
	// json reader config
	root: 'groups',
	fields: ['id', 'name', 'cod'],
	idProperty: 'id',

	// this store config
	//	data: grpData,
	storeId: 'grpStore',
	proxy: new Ext.data.HttpProxy({
		url: APPNAME + '/servlet/MngGroupsServlet',
		method: 'GET',
	}),

	baseParams: {
		'what': 's',
		'usrid': objCfg.usrid
	},
	autoDestroy: true,
	//	autoLoad: true
});
// DATA STUFF //////////////////////////////////////////////////////////////