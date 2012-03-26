

pendingAjaxReqs = [];


/* Please see the Success Case section for more
 * details on the response object's properties.
 * o.tId
 * o.status
 * o.statusText
 * o.getResponseHeader[ ]
 * o.getAllResponseHeaders
 * o.responseText
 * o.responseXML
 * o.argument
 */
 
/**
 * AjaxReq
 * This object encapsulates all logic necessary to perform an async request
 * The url, parameters and handlers for success and failure has to be set
 * using the related methods in order to work properly
 */
AjaxReq = function () {
	// Passing an example of array of arguments to both
	// the success and failure callback handlers.
	var args = ['foo','bar'];
	var postData = "";
	var method = "";
	var url = "";
  var theForm;

	var responseFailure;
	var responseSuccess;
	
	var callback;
	var successCallback, failureCallback;
	
	var connObject = null;
	
	var overlay;
	
	var callCount = 0;
	var resetCallCount = function () {
		callCount = 0
	}
	
	var getCallCount = function () {
		return callCount
	} 
	
	
	
	
/****************************************************************************
 * Start the request based on parameters
 */
	var startRequest = function(theOverlay) {
    YAHOO.util.Connect.initHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
    overlay = theOverlay
		
		if (pendingAjaxReqs.length > 0) { // a request is in progress
			pendingAjaxReqs.push(this)
			return
		}
		
		pendingAjaxReqs.push(this)
		if (theForm != null) {
      YAHOO.util.Connect.setForm(theForm);
      YAHOO.util.Connect.asyncRequest(method, url, callback);
    }
    else {
      if (method == "GET") {
        //			alert ("starting GET ajax request...");
        connObject = YAHOO.util.Connect.asyncRequest(method, url + "?" + postData, callback);
      }
      else if (method == "POST") {
          //			alert ("starting POST ajax request...");
        connObject = YAHOO.util.Connect.asyncRequest(method, url, callback, postData);
      }
      else 
        connObject = YAHOO.util.Connect.asyncRequest(method, url + "?" + postData, callback);
    }
		callCount++;
		
// by default, overlay is showed, if any argument is got then it is supossed
// to mean not to show the overlay
    if (arguments.length == 0)
			overlay.show();
  };
  
	
	
	
/****************************************************************************
 * Check whether or not the current request is finished
 */	
	var isRequestFinished = function (connObj) {
		var inProgress = YAHOO.util.Connect.isCallInProgress (connObj);
		
		return !inProgress;
	}
	
	
	
	

/**
 * This method gotta be called before sending a form. Besides, the setMethod()
 * method gotta be called with param "FORM"
 * @param {Object} formObj
 */
  var setForm = function (formObj) {
     theForm = formObj;
  };


	responseSuccess = function (o) {
  };	
	
/**
 * Method in the case of a server error
 */	
	responseFailure = function(o) {
// Access the response object's properties in the
// same manner as listed in responseSuccess( ).
// Please see the Failure Case section and
// Communication Error sub-section for more details on the
// response object's properties.
		var msg = o.responseText;
		
		document.getElementById("body").appendChild(document.createTextNode(msg));
	};
	


///////// CUSTOM "SETTER" METHODS TO UPDATE THE PARAMS
	var setUrl = function (theUrl) {
		url = theUrl;
	}	
	
	
	var setPostData = function (qString) {
		postData = qString;
	}
	
	
	var setMethod = function (sendMethod) {
		if (sendMethod != "get" && sendMethod != "GET" && 
				sendMethod != "post" && sendMethod != "POST")	
			method = "GET";
		else
			method = sendMethod.toUpperCase ();
	}


	var setSuccess = function (aFunc) {
alert ("setting success");		
		responseSuccess = aFunc;
	}
	
	
	var setFailure = function (aFunc) {
		responseFailure = aFunc;
	}


	var setCallBack = function (okFunc, failFunc, theScope, theArgs) {
		successCallback = okFunc;
		failureCallback = failFunc;

		callback = {
			success: onSuccess,
			failure: onFail,
			scope: theScope,
			argument: args
		}
	}
	


	var onSuccess = function (o) {
		var req = pendingAjaxReqs.shift()
		window.setTimeout (successCallback, 10, o)
		var newReq = pendingAjaxReqs.length > 0? pendingAjaxReqs[0]: null;
		
		if (newReq != null)
			newReq.startReq(overlay)
	}
	
	
	var onFail = function (o) {
		var req = pendingAjaxReqs.shift()
		window.setTimeout (failureCallback, 10, o)
		var newReq = pendingAjaxReqs.length > 0? pendingAjaxReqs[0]: null;
		
		if (newReq != null)
			newReq.startReq(overlay)
	}
	
	
	var getPostdata = function () {
		return postData;
	}
	
	
	
	return {
		callback: callback,
		startReq: startRequest,
		
		setUrl: setUrl,
		setPostdata: setPostData,
		setMethod: setMethod,
    setForm: setForm,
		setCallback: setCallBack,
		getPostdata: getPostdata,
		isRequestFinished: isRequestFinished,
		
		getCallCount: getCallCount
		
/*		
		setSuccess: setSuccess,
		setFailure: setFailure,
*/		
	}
};
//////////// END OF AjaxReq CLASS DEFINITION ///////////////////////////////


function onSuccess (o) {
	var itemString = new String (o.responseText);
/*		
		itemString = itemString.substring(1);
		var items = itemString.split(']'); // get every item separately
*/
	try {
		var items = YAHOO.lang.JSON.parse(o.responseText);		
		for (i=0; i<items.length-1; i++) {
			var p = document.createElement("p");
			var b = document.createElement("b");
			
//			var msg = items[i].split("|"); // get id and content for every item
			var content = i+".- "+items[i].id+"-"+items[i].content;
			
			p.appendChild (b.appendChild (document.createTextNode(content)));
			document.getElementById("body").appendChild(p);
		}
	}
	catch (exp) {
		alert("JSON Parse failed!"); 
    return;
	}
}


function onFail(o) {
// Access the response object's properties in the
// same manner as listed in responseSuccess( ).
// Please see the Failure Case section and
// Communication Error sub-section for more details on the
// response object's properties.
	var msg = o.responseText;
	
	document.getElementById("body").appendChild(document.createTextNode(msg));
};

/* Example...
function onReady () {
	theReq = new AjaxReq ();
	theReq.setUrl ("../ajax/items4sec.jsp");
	theReq.setMethod("GET");
	theReq.setPostdata ("t=sec&frmid=50");
	
	theReq.setCallback (onSuccess, onFail, null);
	theReq.startReq();	
	
}
*/