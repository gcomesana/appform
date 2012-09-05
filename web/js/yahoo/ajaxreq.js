

if (!Date.now) {
  Date.now = function now() {
    return +(new Date);
  };
}


var AjaxReq = (function () {
	
// private-static properties (static in the C sense:
// their values are shared across all instances)

	var callback;
//	var successCallback, failureCallback;
	
//	var connObject = null;
	var callCount = 0;
	var requestQueue = [];

// private methods ////////////////////////////////////////////////////////////

	var getOverlay = function () {
		return this.overlay != 0
	}

// CUSTOM "SETTER" METHODS TO UPDATE THE PARAMS ///////////////////////////////
	var setUrl = function (theUrl) {
		this.url = theUrl;
	}


	var setPostData = function (qString) {
		this.postData = qString;
	}


	var setMethod = function (sendMethod) {
		if (sendMethod != "get" && sendMethod != "GET" &&
				sendMethod != "post" && sendMethod != "POST")
			this.method = "GET";
		else
			this.method = sendMethod.toUpperCase ();
	}


/**
 * Set a form in order to submit all its fields when the asynchronous request
 * is started
 * @param aForm, the id of a html form
 */
	var setForm = function (aForm) {
		if (typeof aForm === 'string')
			this.postData = aForm
		else
			this.theForm = aForm
	}


	var setCallBack = function (okFunc, failFunc, theScope, theArgs) {
		this.successCallback = okFunc;
		this.failureCallback = failFunc;

		this.callback = {
			success: __onSuccessCallback,
			failure: __onFailureCallback,
			scope: theScope,
			argument: theArgs
		}
	}


/**
 * Default handler for the success callback.
 * This callbacka makes a further call to the actual callback, which is successCallback
 * @param o, the object response
 */
//	var __onSuccessCallback = function (o) {
	function __onSuccessCallback (o) {
		var lastReq = requestQueue.shift()

		setTimeout (function (o) { lastReq.successCallback (o) }, 10, o)

		var newReq = requestQueue.length > 0? requestQueue[0]: null;
		if (lastReq.overlay == 1)
			overlay.hide() 
			
		if (newReq != null) {
			newReq.startReq(newReq.overlay)
		}
	}


/**
 * Default handler for the success callback.
 * This callbacka makes a further call to the actual callback, which is successCallback
 * @param o, the object response
 */
	// var __onFailureCallback = function (o) {
	function __onFailureCallback (o) {
		var lastReq = requestQueue.shift()

		setTimeout(lastReq.failureCallback, 10, o)

		var newReq = requestQueue.length > 0? requestQueue[0]: null;
		if (lastReq.overlay == 1)
			overlay.hide()
			
		if (newReq != null)
			newReq.startReq(newReq.overlay)
	}


	var setCallbackSuccess = function (successFunc) {
		this.callback.success = successFunc
	}



/**
 * Start an asynchronous request; insert this request in the request queue; if
 * request queue has a pending request, this one is not run
 * @param theOverlay, set the overlay in the proper application
 */
	var startRequest = function(theOverlay) {
		YAHOO.util.Connect.initHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
		this.overlay = theOverlay === undefined? 1: theOverlay
		
// by default, overlay is showed, if any argument is got then it is supossed
// to mean not to show the overlay
    if (arguments.length == 0 || this.overlay != 0) {
			overlay.show();
// alert ('after showing display, visibility: ' + document.getElementById("overlay").style.visibility)
		}
			
// access to private members is allowed as this (named) closure has access to
// their outer functions variables and params

// depending on the caller, this request has to be enqueued: 
// it won't be enqueued if the caller is the callback method '__on\w*Callback'
		var callerName = startRequest.caller.toString().match(/__on\w*Callback/)
		if (callerName == null) {
			if (requestQueue.length > 0) {
				requestQueue.push (this)
				return
			}
			else // requestQueue.length == 0
				requestQueue.push(this)
		}

		if (this.theForm != null) {
      YAHOO.util.Connect.setForm(this.theForm);
      this.connObject = YAHOO.util.Connect.asyncRequest(this.method, this.url, this.callback);
    }
    else {
      if (this.method == "GET") {
        this.connObject =
					YAHOO.util.Connect.asyncRequest(this.method, this.url + "?" + this.postData, this.callback);
      }
      else if (this.method == "POST") {
        this.connObject = YAHOO.util.Connect.asyncRequest(this.method, this.url, this.callback, this.postData);
      }
      else
        this.connObject = YAHOO.util.Connect.asyncRequest(this.method, this.url + "?" + this.postData, this.callback);
    }
		callCount++;

// by default, overlay is showed, if any argument is got then it is supossed
// to mean not to show the overlay
/*
    if (arguments.length == 0 || this.overlay != 0)
			overlay.show();
*/
  }




/**
 * Constructor function, which will be returned
 */
	var ajaxreq = function () {

		if (arguments.length == 0) {
			this.overlay = 1 // overlay=1 => show overlay!!
			this.postData = null
			this.method = 'GET'
			this.url = null
		}
		else {
			this.overlay = arguments[0]['overlay'] == undefined? 0: arguments[0]['overlay']
			this.postData = arguments[0]['postdata'] == undefined? null: arguments[0]['postdata']
			this.method = arguments[0]['method'] == undefined? 'GET': arguments[0]['method']
			this.url = arguments[0]['url'] == undefined? null: arguments[0]['url']
		}
		this.theForm = null
		this.connObject = null

// callback: by default, callback will contain the timeout and
// the default success and failure callbacks (private members)
		this.callback = {
			timeout: 5000,
			success: __onSuccessCallback, // always have to be so
			failure: __onFailureCallback
		}

// successCallback and failureCallback will be the actual callback functions!!!
		var argsDefined = typeof arguments[0] !== 'undefined'
		
		var callbackParam = argsDefined? arguments[0]['callback']: undefined
		this.successCallback = callbackParam !== undefined? callbackParam.success: undefined
		this.failureCallback = callbackParam !== undefined? callbackParam.failure: undefined

		var strRightNow = (Math.random()).toString()
		var mySha = new jsSHA (strRightNow)
		var shaString = mySha.getHash('SHA-384', 'HEX')

		this.hashId = shaString
	}


/**
 * Static privileged method. Use it as AjaxReq.getQueueLen()
 * Get the length of the requests queue (= number of requests enqueued)
 */
	ajaxreq.getQueueLen = function () {
		return requestQueue.length
	}


/**
 * Static privileged method (privileged: access to private members).
 * Remove all elements from the request queue
 */
	ajaxreq.clearQueue = function () {
		requestQueue = []
	}


/**
 * Returns the whole queue
 */
	ajaxreq.getPendingReqs = function () {
		return requestQueue
	}


/**
 * Returns the i-th element from the request queue
 * @param i, the index (zero based) for the element
 */
	ajaxreq.getRequest = function (i) {
		return requestQueue[i]
	}


//// prototype API
	ajaxreq.prototype = {
		constructor: ajaxreq, // reference to ajaxreq function above: constructor determines what is the constructor function
		toString: function () {
//			console.log ("say something")
		},

//		getNumOfCalls: getCallCount,
//		incCalls: incCallCount,
		isOverlay: getOverlay,
		setPostdata: setPostData,
		setMethod: setMethod,
		setForm: setForm,
		setCallback: setCallBack,
		setSuccess: setCallbackSuccess,
		setUrl: setUrl,
		startReq: startRequest

// at the beginning, theCallCount == callCount
// but, as callCount is increased, theCallCount is NOT updated
//		theCallCount: callCount
	}
	return ajaxreq
})()


