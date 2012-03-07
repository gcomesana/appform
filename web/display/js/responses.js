var dispResp;

var DisplayResponses = function () {
	
	var viewport;
	var scroller;
	
// this property stores the sections combo which an onchange event was triggered from	
	var secCombo;
	
// current interview whose section want to be displayed
	var currIntrv;
	
	
// array with the names of the sections combo for each interview
// every name is as 'sectionsNNN', where NNN is the id of the interview
// just after this components, there is a div for the list of items, whose 
// generic name is 'divItemsNNN', having NNN the same meaning as before
	var namesComboSecs;
	
// This member holds the sections which are going to be compared. They dont have
// to be the "same" (position) section on every questionnaire selected
	var listSecIds;
	
	var init = function () {
//		tblContent = $("#vpcontent");
//		$(tblContent).css("background-color", "gray");
		viewport = $("#divViewPort");
		scroller = $("#scrollerDiv");
		seccombo = -1;
		currIntrv = -1;
		
		namesComboSecs = new Array ();
	}
	
	
	var onAjaxError = function (xhr, msg, err) {
alert ("onAjaxError: "+msg+"; xhr: "+xhr);
		alert ("There was a problem while retrieving the data."+ 
					" Please, try again or report the administrator");
	}
	
	
	
/**
 * Callback method to get the projects json structure to fill the combobox for
 * projects
 * @param {Object} jsonData
 */
	var onAjaxGetPrjs = function (jsonData) {
		var projs = ""; 
		var comboProjs = $("#comboPrj");
		for (i=0; i<jsonData.num; i++) {
			projs += jsonData.prjs[i].name+":"+jsonData.prjs[i].id;
			
			$(comboProjs).append("<option value=\""+jsonData.prjs[i].id+"\">"+
										jsonData.prjs[i].name+"</option>");
		}
	}

	

/**
 * Callback method to display the found interviews.
 * @param {Object} jsonData
 */
	var onAjaxGetIntrvs = function (jsonData) {
		var theDiv = $("#foundIntrvDiv");
		var myDiv = $("#interviews");
		var numIntrv = $("#numIntrvs");
		var compBtn = '<span id="btnComp" style="border:1px solid black;cursor:default;'
		compBtn += 'background-color:darkgray;padding-left:10px;padding-right:10px">';
		compBtn += '  Compare  </span>';
		
//		$("#foundIntrvDiv > input:checkbox").remove();
/*
		$.each ($("#foundIntrvDiv > input:checkbox"), function(i, elem) {
			var 	
		})
*/
		$("#foundIntrvDiv > span#btnComp").remove();
		$(myDiv).empty ();
		$(numIntrv).text("("+jsonData.num+")");
		$.each(jsonData.intrv, function (i, myintrv) {
			var clon = "";
			// if (myintrv.isclon == 0)
				// clon = " disabled=\"disabled\" checked=\"checked\"";
				
			var tag = '<input type="checkbox" id="intrv'+myintrv.id+'" name="intrv'+myintrv.id+
							'" value="'+myintrv.id+'" '+clon+'>'+myintrv.name+'</input>';
			$(myDiv).append(tag);
		});
		
	// comparison button
		$(theDiv).append(compBtn);
	
// click handler for the comparison button
		$("#foundIntrvDiv > span#btnComp").click (function () {
			var postData = "what=intrv&intrvids=";
			if ($("input:checked").length != 2) {
				alert ("Two (2) interviews have to be checked");
				return false;
			}
			
			$("input:checked").each (function (j, elem){
				postData += $(this).val()+",";
			});
			postData = postData.substr(0, postData.length-1);
			
			$.ajax ({
				url: APPNAME+'/servlet/QryServlet',
				type: 'GET',
				data: postData,
				dataType: "json",
				success: dispResp.onAjaxGetSections,
				error: dispResp.onAjaxError
			});
		});
	/*	
		$("#foundIntrvDiv > span#btnComp").mouseover (function () {
			$(this).css("background-color", "red");
		})
		
		$("#foundIntrvDiv > span#btnComp").mouseout (function () {
			$(this).css("background-color", "white");
		})
	*/	
		$(theDiv).css("visibility", "visible");
		
	}
		



/**
 * Callback method to retrieve the interviews with their sections. A div has
 * to be cleaned and some inner divs re-created to adapt the new query
 * @param {Object} jsonData
 */
	var onAjaxGetSections = function(jsonData) {
		var intrvArr = new Array ();
		
		$(scroller).empty();
		
// clear the array of section combos name for each interview as this is a 
// new interview comparison session
		namesComboSecs = jQuery.map (namesComboSecs, function(n, i) {
			return null;
		});
		
		$.each(jsonData.intrvs, function (i, elem) {
			var divCode = '<div id="intrv'+elem.id+'" name="intrv'+elem.id;
			divCode += '" class="divCombos"></div>';
			var $thisDiv = $(divCode);
			var $comboSecs = $('<select size="4" id="sections'+elem.id+'"></select>');
			var itemsDiv = $('<div id="divItems'+elem.id+'" style="white-space:normal"></div>');

			namesComboSecs.push($comboSecs.attr('id'));			
			
			$($thisDiv).appendTo($(scroller));
			$thisDiv.text(elem.name);
			$('<br>').appendTo($thisDiv);
			$($comboSecs).appendTo($thisDiv);
			$comboSecs.after($(itemsDiv));
			
			intrvArr.push (elem.id);
			
			$.each(elem.secs, function (j, elem){
				var secName = decodeURI (elem.name).replace(/\+/g, ' ');
				var $myOpt = $('<option value="'+elem.id+'">'+secName+'</option>');
				$($myOpt).appendTo ($comboSecs);

				$myOpt.bind ('mouseover', function () {
					Tip ($(this).text());
				}).bind ('mouseout', function () {
					UnTip ();
				});
			})
			

// In this event, items for the same section (by order) in all interviews has 
// to be got. This event is bound to every combo of sections
			$comboSecs.change (function () {
				
				secCombo = $(this);
				currIntrv = $(secCombo).attr('id').substring (8); // 8 = "sections".length
				/*
				var selIndex = $(this).attr("selectedIndex");
				var listSecId = "";
				$.each (namesComboSecs, function (n, i) {
					var $aCombo = $("#"+namesComboSecs[n]);
					var secId = $aCombo[0].options[selIndex].value;
					listSecId += secId+",";
					
					$aCombo.attr("selectedIndex", selIndex);
				});*/
				
//				var selIndex = $(this).attr("selectedIndex");
				var listSecId = "";
				$.each (namesComboSecs, function (n, i) {
					var $aCombo = $("#"+namesComboSecs[n]);
					var selIndex = $aCombo[0].selectedIndex;
					if (selIndex == -1 || selIndex == undefined) {
						listSecId = "";
						return;
					}
					var secId = $aCombo[0].options[selIndex].value;
					listSecId += secId+",";
					
//					$aCombo.attr("selectedIndex", selIndex);
				});
				
				if (listSecId.length > 0) {
					listSecId = listSecId.substring(0, listSecId.length-1);
				
					var postData = 'what=items&secid='+$(this).val();
					postData = "what=mulitems&secids="+listSecId;
					
					$.ajax ({
						url: APPNAME+'/servlet/QryServlet',
						type: 'GET',
						data: postData,
						dataType: "json",
	//					success: dispResp.onAjaxGetItems,
						success: dispResp.onAjaxGetMultItems,
						error: dispResp.onAjaxError
					});
				}
			})
			
			
// in order to select the sections correctly:
// the two selected sections have to come from different combos
// if another section from a combo is selected, the id has to be updated
// the ajax call is done when 2 sections from different interviews are selected
			
		}); // $each interviews retrieved

		var scrollerWidth = getScrollWidth (intrvArr);
		$(scroller).css("width", scrollerWidth+"px");
	}




/**
 * This is a callback method on response to getting items. As in the new version,
 * the json will be as:
 * {numsecs:2, 
 * 	secs:[{secid:150, items:[{id, text},{id, text}]},
 * 				{secid:1802, items:[]}
 * 	]}
 * @param {Object} jsonData
 */
	var onAjaxGetMultItems = function (jsonData) {

		$.each (jsonData.secs, function (i, elem) {
// elem here is {intrvid:50,secid:150, items:[{id, content},...,{id, content}]}
// alert ("a section: "+elem.secid);
			var $myDiv = $("#divItems"+elem.intrvid);
			$myDiv.empty();
			
			var $aux = $myDiv.append ('');
			var listElems = '<p align="left">';
			$.each (elem.items, function (i, item) {
				var span = "<div class=\"";
				if (i % 2 == 1)
					span += "itemOdd\">";
				else
					span += "itemEven\">";
					
				var aux = unescape(decodeURI (item.content).replace(/\+/g, ' '));
				listElems += span+aux.replace(/\"/g, '"')+"</div>";
			});
			
			listElems += "</p>";
			$aux.append (listElems);
		})
		
	}


/**
 * Callback method to execute upon the items for section are requested. To display
 * the section items, a new div is created and the items are lay out by using a
 * li list
 * @param {Object} jsonData
 */
	var onAjaxGetItems = function (jsonData) {
//		var $myCombo = $(secCombo);
		var $myDiv = $("#divItems"+currIntrv);
		var $myBr = $("<br>");
		
//		var $aux = $myCombo.after("<br>");
		$myDiv.empty();
		var $aux = $myDiv.append ('');
		var listElems = '<p align="left">';
		$.each (jsonData.items, function (i, elem) {
			var span = "<div class=\"";
			if (i % 2 == 1)
				span += "itemOdd\">";
			else
				span += "itemEven\">";
				
			var aux = unescape(decodeURI (elem.content).replace(/\+/g, ' '));
			listElems += span+aux.replace(/\"/g, '"')+"</div>";
		})
		listElems += "</p>";
		$aux.append (listElems);
	}
	
	
	
	
/**
 * This "private" method yields the new width for the scroller div, which
 * supports the set of combos. The "formula" to apply is:
 * for gecko & webkit (i guess):
 * width + margin left + margin right + padding*2 + border*2  from the contents
 * 
 * for IE
 * width + margin left + margin right from the content rule + 
 * border*2 from the container rule
 */	
	var getScrollWidth = function (intrvArr) {
		var containerWidth = $(viewport).css("width");
		var contentsWidth = 300;
		
		if (isIE) {
			var borderContainer = 1;
			var marginL = 2;
			var marginR = 2;
			
			return (contentsWidth + marginL + marginR)*intrvArr.length + borderContainer*2;
		}
		else {
			var marginL = 2;
			var marginR = 2;
			var border = 1;
			var padding = 0;
			var result = (contentsWidth + marginL + marginR + padding + border*2);
			result = result * intrvArr.length;
			
			return result;
		}
		
		
	}
	
	
	var isIE = function () {
		var browser=navigator.appName;
		var b_version=navigator.appVersion;
		var version=parseFloat(b_version);
		
		if (browser.indexOf ("Microsoft") != -1)
			return true;
			
		return false;
	}
	
	
	var test = function () {
		alert ("DisplayResponses loaded");
	}
	
	return {
		test: test,
		init: init,
		
		onAjaxGetItems: onAjaxGetItems,
		onAjaxGetMultItems: onAjaxGetMultItems,
		onAjaxError: onAjaxError,
		onAjaxGetIntrvs: onAjaxGetIntrvs,
		onAjaxGetSections: onAjaxGetSections,
		onAjaxGetPrjs: onAjaxGetPrjs
	}
}
