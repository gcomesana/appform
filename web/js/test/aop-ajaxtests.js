/*
jQuery.aop.before ({target: AjaxReq, method: 'startReq'}, 
	function () {
		console.log ('before: on startReq: '+this)
	}
)
*/

jQuery.aop.before ({target: Overlay, method: 'show'}, 
	function () {
		console.info ("before Overlay.show")
		console.trace	()
	}
)

/*

jQuery.aop.before ({target: overlay, method: 'show'}, 
	function () {
		console.info ("before overlay.show")
		console.trace	()
	}
)

*/


jQuery.aop.before ({target: ControlForms, method: 'send'},
	function () {
		console.log ("suck my fucking cock")		
	}
)
