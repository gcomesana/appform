// Include "js/xmlHandler.js"
// dhtmlLoadScript( "js/xmlHandler.js" );

DynJsLoad = function() {
	var dhtmlBulkLoadScript = function(urls,/* optional */basehref, 
																		thedoc, thelastscript, urlsi) {
		if (!thedoc) {
			thedoc = document;
		}
		var head = thedoc.getElementsByTagName("head")[0];

		if (urlsi == undefined)
			urlsi = 0;
			
// Browser detection
		if (!basehref) {
			basehref = '';
		}
		
		if (urlsi < urls.length) {
			var e = thedoc.createElement("script");
			e.type = "text/javascript";
			var helper;

			if (urlsi + 1 != urls.length) {
				helper = function() {
					dhtmlBulkLoadScript(urls, basehref, thedoc, thelastscript, urlsi+1);
				};
			} 
			else if (typeof thelastscript == 'function') {
				helper = thelastscript;
			}
			
			if (helper) {
				e.onreadystatechange = function() {
					if (this.readyState == 'loaded'	|| this.readyState == 'complete') {
						e.onreadystatechange = function() { };
						helper();
					}
				};
				
				e.onload = function() {
					e.onload = function() {	};
					helper();
				};
			}

			e.src = basehref + urls[urlsi];
			head.appendChild(e);
		} 
		else if (typeof thelastscript == 'function') {
			try {
				thelastscript();
			} 
			catch (we) {
				// IgnoreIT!!!(R)
			}
		}
	};

	// Dynamic html load
	var dhtmlLoadScript = function(url) {
		var e = document.createElement("script");
		e.src = url;
		e.type = "text/javascript";
		document.getElementsByTagName("head")[0].appendChild(e);
	};

	return {
		loadScript : dhtmlLoadScript,
		loadBulkScript : dhtmlBulkLoadScript
	}
};
