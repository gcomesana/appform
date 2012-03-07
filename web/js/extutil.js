

// Ext.ns ('application.utils');

// application.utils.misc = new function NewMisc () {}

var utils = new function () {
	
	var getAjax = function () {
		if (window.XMLHttpRequest) { 
			try { 
				req = new XMLHttpRequest(); 
			} 
			catch(e) { 
				req = null; 
			} 
			// branch for IE/Windows ActiveX version 
		} 
		else if (window.ActiveXObject) { 
			try { 
				req = new ActiveXObject('Msxml2.XMLHTTP'); 
			} 
			catch(e) { 
				try { 
					req = new ActiveXObject('Microsoft.XMLHTTP'); 
				}	 
				catch(e) {
					raiseMsg ("Your browser don't support AJAX/SJAX"); 
					req = null; 
				} 
			} 
		}
		
		return req;
	}
	
	
	return {
		ADMIN_MAIL: 'contacto@inab.org',
		
/**
 * Raise a preconfigured dialog with a message and a custom handler. Default 
 * width to 350
 * @param {Object} msg
 * @param {Object} btnHandler
 */
		raiseMsg: function (msg, btnHandler) {
			var myHandler;
			if (btnHandler != undefined)
				myHandler = btnHandler;
			else
				myHandler = function (btnId, txt, opt) {
					return;
				};
				
			Ext.MessageBox.show ({
				buttons: Ext.MessageBox.OK,
				icon: Ext.MessageBox.INFO,
				title: 'Info message',
				msg: msg,
				width: 350,
				fn: myHandler 
			});
		},
		
		
		
	
/**
 * Raise a dialog with two buttons (yes-no) in order to set a question.
 * Callback function should be customized 
 */
	raiseYesNoDlg: function (msg, btnHandler) {
		var myHandler;
			if (btnHandler != undefined)
				myHandler = btnHandler;
			else
				myHandler = function (btnId, txtMsg) {
					return;
				};
				
			Ext.MessageBox.show ({
				buttons: Ext.MessageBox.YESNO,
				icon: Ext.MessageBox.QUESTION,
				title: 'Warning!',
				msg: msg,
				width: 350,
				fn: myHandler 
			});
	},
	
	
	
	
		
/**
 * This method is an absoulutely ad-hoc method to get config options from server 
 * and return an JSON object with the configuration params 
 * @param {String} paramUrl
 * @param {Array} paramArr, an array object with the parameters
 * @param {String} method
 * @param {Boolean} sync
 * @return {Object} a object with the (undefined) configuration parameters 
 */
		config: function (paramUrl, paramArr, method, sync) {
			var jsonOut = null;
			var req = getAjax ();
			
			if (req != null) {
				var qryString = '';
				for (var paramName in paramArr) {
					if (typeof paramArr[paramName] == "number" ||
							typeof paramArr[paramName] == "string" ||
							typeof paramArr[paramName] == "boolean")
					qryString += paramName+'='+paramArr[paramName]+'&';
				}
					
				qryString = qryString.substr(0, qryString.length-1);
				
				req.open (method, paramUrl+'?'+qryString, sync);
				req.send (null);
				var resp = req.responseText;
				
				jsonOut = Ext.util.JSON.decode (resp);
			}
			return jsonOut;
		},
			
			
			
		
		
	/**
	 * Same than config but the parameters for the call are in JSON format
	 * @param {Object} paramUrl
	 * @param {Object} paramJson, a JSON object with the parameters to send to the
	 * server. It should be (for tight organization):
	 * {"what":"appcfg","items":[{"name":1,"name2":"two"}]}
	 * <b>Note</b>: currently only supports {"what":"appcfg","item1":"val1","item2":"val2",...}
	 * @param {Object} method
	 * @param {Object} sync
	 */
		jsonConfig: function (paramUrl, paramJson, method, sync) {
			var jsonOut = null;
			var req = getAjax ();
			
			if (req != null) {
				var qryString = '';
				for (var paramName in paramJson) {
					if (typeof paramJson[paramName] == "number" ||
							typeof paramJson[paramName] == "string" ||
							typeof paramJson[paramName] == "boolean")
					qryString += paramName+'='+paramJson[paramName]+'&';
				}
					
				qryString = qryString.substr(0, qryString.length-1);
				
				req.open (method, paramUrl+'?'+qryString, sync);
				req.send (null);
				var resp = req.responseText;
				
				jsonOut = Ext.util.JSON.decode (resp);
			}
			return jsonOut;
		} // eo jsonConfig
		
	} // eo return
	
} // eo class
	
