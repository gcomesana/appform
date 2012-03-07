/**
 * @author gcomesana
 */
var IntrvAjaxResponse = function () {
  
  var formComplete = new YAHOO.util.CustomEvent("formComplete", ControlForms);
  var secsComplete = new YAHOO.util.CustomEvent("secsComplete", ControlForms);
  
	var loginPage = APPNAME+'/jsp/index.jsp';
	var noprofilePage = '../noprofile.jsp';
	
	var idBlink1, idBlink2;
  
  
/**
 * Subscribe the object obj with the callback fnCallback as listener for the
 * secsComplete event
 * @param {Object} fnCallback 
 * @param {Object} obj
 */  
  var subscribeSecs = function(fnCallback, obj){
    secsComplete.subscribe (fnCallback, obj);
  }
  
  
/**
 * Subscribe the object obj with the callback fnCallback as listener for the
 * formComplete event
 * @param {Object} fnCallback
 * @param {Object} obj
 */  
  var subscribeForm = function(fnCallback, obj) {
    formComplete.subscribe (fnCallback, obj);
  }
  
  
	var onFail = function (o) {
    overlay.hide ();
// Access the response object's properties in the
// same manner as listed in responseSuccess( ).
// Please see the Failure Case section and
// Communication Error sub-section for more details on the
// response object's properties.
		var msg = o.responseText;
    
		
//		document.getElementById("body").appendChild(document.createTextNode(msg));
		alert ("The operation couldnt be performed: "+msg);
	};

	
	
	var onEndSession = function (o) {
// alert ("at onEndSession");
		try {
      msg = YAHOO.lang.JSON.parse(o.responseText);
			alert ("onEndSession: " + msg);
    }
    catch (x) {
			return;
    }
	}
	

/****************************************************************************
 * onSecs4Intrv
 * Gets the sections which are got from the server as a json object:
 * json_section = [
 *					{ "name": "SECTION A: DEMOGRAPHICS", "order": '1', "id":'51',"active":0|1},
 *					{ "name": "SECTION B: SHIFT WORK", "order": '2',"id":'52',"active":0|1},
 *					{ "name": "SECTION C: TOBACCO", "order": '3' ,"id":'53',"active":0|1}
 *				];
 * where active sets if the section was completed (active:1) or not 
 */	
	var onSecs4Intrv = function (o) {
		var sections;
    overlay.hide ();
		try {
      sections = YAHOO.lang.JSON.parse(o.responseText);
			if (sections.res == 0) {
//				top.location = loginPage;
alert (sections.msg);
				top.location = noprofilePage;
				
				return false;
			}
    }
    catch (x) {
			if (o.responseText.indexOf ('html') != -1) {
				top.location = loginPage;
			}			
      alert("JSON Parse failed!");
      return;
    }

// first, remove all children from regionA div
    var regionA = document.getElementById('regionA');
    var children = regionA.childNodes;
    
//    for (j=0; j<children.length; j++)
  //    regionA.removeChild(children[j]);

      
    while (regionA.childNodes.length > 0) {
      myChild = regionA.lastChild;
      regionA.removeChild(myChild);
    }
    
//    regionA.removeChild(regionA.lastChild);
    // The returned data was parsed into an array of objects.
    // Add a P element for each received message
    for (i = 0, len = sections.length; i < len; ++i) {
        var name = sections[i].name;
        var order = sections[i].order;
        var secid = sections[i].id;
        var active = sections[i].active;
        
        var  newParrafo=document.createElement('li');
        if (active == 0) {
          newParrafo.innerHTML = name;
          newParrafo.setAttribute('id', 'sec' + secid);
          newParrafo.setAttribute('class', 'inactiveSec');
        }
        else {
          var newSection = document.createElement('a');
          newSection.setAttribute('id', 'sec' + secid);
          newSection.setAttribute('class', 'activeSec handpointer');
            /*
     newSection.setAttribute('onclick',
     'intrvFormCtrl.getNextForm("",'+secid+')'); */
          newSection.setAttribute('onclick', 'intrvFormCtrl.loadForm(' + secid + ')');
          
          newSection.innerHTML=name;
          newParrafo.appendChild(newSection);
        }
/*				if(i==0) {
					newSection.setAttribute('href','#');
				}
*/        
				document.getElementById('regionA').appendChild(newParrafo);
    }
    
    secsComplete.fire ('from onSecs4Intrv');
	};



/***************************************************************************
 * This method is supossed just refresh the sections which means changing the 
 * class (from inactiveSec to activeSec) and adding the onclick attribute
 * @param {Object} o
 
  var onUpdateSecs = function (o) {
    overlay.hide ();
    try {
      sections = YAHOO.lang.JSON.parse(o.responseText);
    }
    catch (x) {
      alert("JSON Parse failed!");
      return;
    }
    
    var regionA = document.getElementById('regionA');
    var children = regionA.childNodes;
    
// compare every section with the list of sections and update only the sections
// with different class
    for (i=0; i < sections.length; i++) {
      var name = sections[i].name;
      var order = sections[i].order;
      var secid = sections[i].id;
      var active = sections[i].active;
      
      var secLink = children[i].firstNode;
      
    }    
    
  }
*/


/****************************************************************************
 * onItems4Sec
 * Gets the items for the section. Actually, the items gotta be sent as a form
 * to embed into the div tag or something similar
 */	
	var onItems4Sec = function(o){
  	var newForm;
  	overlay.hide();
  	
  	try {
  		var resp = YAHOO.lang.JSON.parse(o.responseText);
			if (resp.res == 0) {
//				top.location = loginPage;
alert ("onItems4Sec: "+ resp.msg);
				top.location = noprofilePage;
				
				return false;
			}
  	} 
  	catch (x) {
			if (o.responseText.indexOf("<html>") != -1) {
				top.location = loginPage;
				return;
			}
  		newForm = o.responseText;
  		document.getElementById('form').innerHTML = newForm;
  	}
	};

	
	
/**
 * Response method for a group change/setting. The object response (o) will
 * have the form of {"res":1,"msg":"The group blablabla"}
 * @param {Object} o
 */	
	var onGrpChanged = function (o) {
// alert ("onGrpChanged ("+o.responseText+")");
		overlay.hide();
//		var resp = "{\"res\": 1,\"msg\": \"New active group is 'vallhebron'\"}";
		try {
			var result = YAHOO.lang.JSON.parse (o.responseText);
			if (result.res == 1)
				alert (result.msg);
				
			else
				alert ("New group could not be selected. Try again later");
		}
		catch (x) {
			alert ("Err: "+o.responseText);
		}
	};
	

  
	
/**
 * This is a callback ajax method on response to real time item saving.
 * The response will have the following form:
 * {"res":[0|1],["itemname":"q2267-1-2",]"msg":[""|"could not save the value"]
 * @param {Object} o
 */	
	var onSaveItem = function (o) {

		try {
			var result = YAHOO.lang.JSON.parse (o.responseText);
// alert ("onSaveItem: "+result.itemname);
			if (result.res == 0) {
				var errStyle = {'background-color':'red',
												'border':'3px red solid',
												'font-weight': 'bold',
												'color':'white'};
				var elem = $("#"+result.itemname);
//				$("input#"+result.itemname).css(errStyle);
				$(elem).css(errStyle);
//				$("input#"+result.itemname).val("io sono");
				$("div#errMsg").text (result.msg);
			}
			
		}
		catch (x) {
			alert ("Err: "+o.responseText);
		}
	}	
	
	
	
	
	
/****************************************************************************
 * onSaveForm
 * Response after saving one form, either introform or sectionform. If the
 * response is a json response, display up an alert, otherwise just replace
 * the current dialog; in any case, an event reporting the form filling was
 * completed is raised
 */	
	var onSaveForm = function (o) {
		var newForm;
    overlay.hide();
    
    try {
      result = YAHOO.lang.JSON.parse(o.responseText);
			if (result.res && (result.res == 0)) {
				alert (result.msg);
				top.location = loginPage;
				
				return false;
			}
/*			
			var spanTag = $('#grpSpan');
			var spanLnk = '<a href="setsecondarygrp.jsp?typegroup=SEC" id="linkGrp">'+
										$(spanTag).html()+'</a>';
			$(spanTag).html(spanLnk);
*/			
			alert (result.msg);
			if (result.sessionExpired == 0)
				top.location.href = 'index.jsp?rt='+result.rt+'&intrv='+result.intrv;
			else
				top.location.href = APPNAME+"/index.jsp"
			return true;
    }
    catch (x) {
			if (o.responseText.indexOf('<html>') == 0) {
				top.location = loginPage;
				
				return false;
			}
      newForm = o.responseText;
      document.getElementById('form').innerHTML = newForm;
    }
    finally {
      formComplete.fire ('from onSaveForm');  
    }
//    alert (newForm);
	};



	
  var onPrevForm = function (o) {
// alert ("onPrevForm");
    var newForm;
    overlay.hide();
    
    try {
      result = YAHOO.lang.JSON.parse(o.responseText);
			if (result.res == 0) {
				top.location = loginPage;
				
				return false;
			}
//      alert (result.msg);
    }
    catch (x) {
      newForm = o.responseText;
      document.getElementById('form').innerHTML=newForm;
      return;
    }
  }
  


	var onNextCheck = function (o) {
		overlay.hide();
    
    try {
      result = YAHOO.lang.JSON.parse(o.responseText);
			if (result.res && (result.res == 0)) {
				alert (result.msg);
				top.location = loginPage;
				
				return false;
			}
			
			var spanTag = $('#grpSpan');
			var spanLnk = '<a href="setsecondarygrp.jsp?typegroup=SEC" id="linkGrp">'+
										$(spanTag).html()+'</a>';
			$(spanTag).html(spanLnk);
			
//			alert (result.msg);
    }
    catch (x) {
			if (o.responseText.indexOf('<html>') == 0) {
				top.location = loginPage;
				
				return false;
			}
      newForm = o.responseText;
      document.getElementById('form').innerHTML = newForm;
    }
    finally {
      formComplete.fire ('from onSaveForm');  
    }
	}
	

  var test = function () {
		alert ("IntrvAjaxResponse.test works ok");
	};
	
	
	return {
		test: test,
    onSecs4Intrv: onSecs4Intrv,
    onItems4Sec: onItems4Sec,
    onSaveForm: onSaveForm,
		onGrpChanged: onGrpChanged,
		
		onSaveItem: onSaveItem,
    onEndSession: onEndSession,
		
    subscribeSecs: subscribeSecs,
    subscribeForm: subscribeForm,
    
		onFail: onFail
	}  
	
};
/// AJAXRESPONSE /////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////