
var FormManager = function () {
		
		var numGrp, numItemsGrp;
		var isPreview;
		
		function init (preview) {
      numGrp = 1;
			numItemsGrp = 1;
			isPreview = preview == undefined? 0: preview;
    }
    
		
		
		function rmvAnswers (id) {
			
			var xReq = new AjaxReq ();
			xReq.setMethod ("POST");
			xReq.setUrl (APPNAME+"/servlet/IntrvServlet");
			
			postdata = "what=save_just&txt=";
			postdata += encodeURIComponent(txtarea.value);
			postdata += "&patid="+patid+"&intrvid="+intrvid;
			xReq.setPostdata (postdata);
			xReq.setCallback(this.ajaxResp.onSaveItem, this.ajaxResp.onFail, this.ajaxResp, null);
			
			xReq.startReq (0);
		}
    
		
		
		
		
/**
 * Removes the last answer in a repeatable question. Actually, the last answer 
 * is the answer named by id param.
 * To do that, the entire row containing the answer and buttons has to be 
 * removed from DOM, and the buttons has to be added to the previous question.
 * The exception is the second answer as only one 'add' button has to be added
 * to the first answer (always there will be a first answer)
 * @param {Object} id, the id of the [-] minus button. It has the shape as
 * q12345-6-7, 6 number of answer, 7 the order
 */
		function rmvSimpleElem (id) {
			var idParts = id.split("-")
			var numAns = parseInt (idParts[1])
			var newId = idParts[0]+"-"+(numAns-1)+"-"+idParts[2]
			
			var lastTr = $("#"+id).parent().parent()
			var buttons = $(lastTr).children(':last-child').children("input:button")
			var clonedBtns = $(buttons).clone()
			var prevTr = $(lastTr).prev()
			
	// change the buttons name to set the name to the previous answer
	// actually, only the answer number has to be changed
			$(clonedBtns).each (function (index) {
				var btnAct = $(this).attr('id').split('-')[0]
				if (btnAct.toUpperCase() == 'RMV' && numAns == 2) 
					return // SKIP THE [-] MINUS BUTTON FOR THE FIRST ANSWER
				
				$(this).attr ('id', btnAct+'-'+newId)
				$(this).attr ('name', btnAct+'-'+newId)
				$(this).removeAttr ("onclick")		
				if (btnAct.toUpperCase() == 'ADD') 
					$(this)[0].setAttribute ('onclick', "ctrl.addElem('"+newId+"');")
					
				else
					$(this)[0].setAttribute ('onclick', "ctrl.rmvElem('"+newId+"');")
									
				
//				$(prevTr).children(':first-child').append($(this))
			})
			$(lastTr).remove()
			
			
			$(prevTr).children(':first-child').append($(clonedBtns)[0])
			if (numAns > 2) {
				$(prevTr).children(':first-child').append('&nbsp;')
				$(prevTr).children(':first-child').append($(clonedBtns)[1])
			}
		}
		
		
		
		
		
		
/**
 * This method removes the groups where the button is. This one have various 
 * implications:
 * i- the group itself have to be removed
 * ii- the buttons have to be added to the previous group again
 * iii- the questions for this group which have been answered have to be removed
 * from database
 * 
 * i- this is the table parent for these buttons. actually this is the table parent
 * with is id-children
 * 
 * ii- the buttons have to be cloned and, then, added to the previous table, which
 * the "older" sibling of the removed
 * 
 * iii- this one has to be done previous to remove the group. All input items
 * inside id-children have to be accessed in the database to be removed.
 * @param {Object} id the id of the table grouping everything
 * NOTE: this is done using jquery1.3.
 */		
		function rmvElem (id) {
			
			var elemType = id.charAt (0)
			
			if (elemType == 't') {
				var boxes = $("table[name='"+id+"-children']");
				if (boxes.length == 1)
					return;
					
				var myBoxSel = "table[name='"+id+"-children']:last";
				var mybox = $(myBoxSel); // the table which is required to be removed
				
				var btns = $(myBoxSel+" input[type='button']"); // the bottom buttons
//				var btnClones = $(btns).clone (); // clon the buttons to add to the previous table
				
				
	// Loop over input items on box to build up the postdata for an ajax call
	// in order to remove those answers from database
				var text = " input[type='text']";
				var select = " select";
				var qIds = new Array (); // array of ids: qQQQQ-N-O
				$(myBoxSel+text+", "+myBoxSel+select).each (function (i) {
					var myElem = $(this);
					var myId = $(myElem).attr('id'); // get the id of 'this' jquery object
					qIds.push(myId.slice (1)); // remove the 'q' from id and inser into array
				})
				
				var postData = "what=rmvAns&ids="+qIds.join(",");
				if (isPreview == 0) { // real performance...
					$.ajax ({
						url: APPNAME+'/servlet/AjaxUtilServlet',
						type: 'POST',
						dataType: 'json',
						data: postData,
						
		// callbacks
						error: function (req, errMsg, exc) {
							alert ("There was an error while server connection. Fail to remove group of questions");
							return;
						},
						
						success: function (data, status) {
							if (data.res == 0) {
								alert (data.msg);
								return false;
							}
							return true;	
						}
					}); // EO ajax call
				}
				
				$(mybox).remove();
				var newBox = $(myBoxSel);
				$(newBox).next().remove();
//				numGrp--
/*				
				var newRow = $(myBoxSel).append(document.createElement('tr'))
				var newTd = document.createElement('td')
				newTd.setAttribute ('align', 'right')
				$(newRow).append(newTd)
*/				
				var btnPlace = $(myBoxSel+" td[align='right']");
				if ($(btnPlace).length == 0) { // have to add tr+tr to myBoxSel
					var lastRow = $(myBoxSel+" tr:last")
					$(lastRow).after('<tr><td align="right"></td></tr>')
					btnPlace = $(myBoxSel+" tr:last > td")
				} 
				
	//			$(btns).appendTo($(btnPlace));
// If only one group is left, then only the add [+] button has to be rendered
				$(btnPlace).append($(btns[0]));
				if (numGrp > 2) {
					$(btnPlace).append("&nbsp;");
					$(btnPlace).append($(btns[1]));
				}
				numGrp--
			}
			else 
				rmvSimpleElem (id);
			
			
			return;
		}
		
		
		
		
/**
 * It adds a simple element (a question, with one or several answer items) after
 * clicking the [+] button.
 * To carry it out, a new <td> element has to be cloned from the original and 
 * the answer number index has to be increased and the item names rewrited with
 * this new answer number. So, the steps are as following:
 * - get the parent td
 * - get the answer number index in q<itemId>-<answer_number>-<answer_order>
 * - increase <answer_number>
 * - clone the td and their children (current element)
 * - rename the cloned elements to set the new <answer_number>
 * 
 * In the end, the two buttons will have a slightly different
 * 
 * @param {Object} elemId, the element id with the shape 
 * q<itemId>-<answer_number>-<answer_order>
 */		
		function addSimpleItem (elemId) {

			var identify = elemId.split ("-")
			
			var itemId = identify[0].substring (1);
			var ansNum = identify[1]
//			var ansOrd = identify[2]
			var nextAnsNum = parseInt (ansNum)+1
			
			var formElem = $("#"+elemId)
		
// The reference to add another question is a row, so, the "current" row is the
// grandparent of the form element (tr > td > element), row which has to be cloned			
			var trParent = $(formElem).parent().parent()
			var trClone = $(trParent).clone(true)
			var btnCount = 0
			
			$(trClone).children("td").children().each (function (index) {
				if ($(this).get(0).tagName.toLowerCase() == "input" || 
						$(this).get(0).tagName.toLowerCase() == "select") {
					var currentId = $(this).attr("id")
// currentId ~ btn-q12345-num-order
					var ord = $(this).attr('type') == 'button'? currentId.split("-")[3]: 
										currentId.split("-")[2]
					var newId = "q"+itemId+"-"+ nextAnsNum +"-"+ord
					
					$(this).attr ("id", newId)
					$(this).attr ("name", newId)
					
					if ($(this).attr('type') == "button") {
						var clickEv = btnCount == 0? "ctrl.addElem('"+newId+"');": 
												"ctrl.rmvElem('"+newId+"');"
						var btnId = btnCount == 0? 'add-'+newId: 'rmv-'+newId
						
						$(this).attr ("id", btnId)
						$(this).attr ("name", btnId)
					
						$(this).removeAttr ("onclick")
						$(this)[0].setAttribute ('onclick', clickEv)
						
						btnCount++
//						$(this)[1].setAttribute ('onclick', "ctrl.rmvElem('"+newId+"');");
					}
				}						
					
			})
			
// Remove buttons
			$(trParent).children(':first-child').children ("input:button").each (function (index) {
				$(this).remove()

			})
			
// As we are adding the minus button every time, it has to be checked whether or
// not there are two buttons to avoid adding minus button every time
			if ($(trClone).children(':first-child').children("input:button").length < 2) {
				var theNewId = "q"+itemId+"-"+nextAnsNum+"-1"
				var minusBtn = $('<input type="button" />').attr('name', 'rmv-'+theNewId)
				$(minusBtn).attr('id', 'rmv-'+theNewId)
				$(minusBtn).val(' - ')
	//			$(minusBtn).attr('type', 'button')
				$(minusBtn).attr ('onclick', "ctrl.rmvElem('"+theNewId+"')")
				
				$(trClone).children(':first-child').append ("&nbsp;")
				$(trClone).children(':first-child').append($(minusBtn))	
			}
			
			$(trParent).after($(trClone))
		} // EO addSimpleElem method
		
		
		

/**
	Llega como id algo de la forma qXXX-N-O, qXXX-N-O-gG o tXXX.
	Lo que hay que hacer es:
	* si llega qXXX-N-O, crear un elemento debajo
	de éste, incrementando N
	* si llega qXXX-N-O-gG, se crea un elemento debajo de este incrementando N
	* si llega tXXX, hay que crear un elemento del grupo (que será la tabla entera)
	incrementando el N de todos los elementos y, si hay alguno con gG, cambiar
	la G, incrementándola or generando un número con Math.random.
	
	This 'method' replicates some form elems, represented for the id, which can 
	be:
	- qXXXX-N-O, which is a single element represented by a "normal" id. The N
	has to be increased every time the button is pushed
	- qXXXX-N-O-gG, which is a element inside a repeteable container. The G has to
	be increased every time the container is cloned, the N has to be increased
	every time the single component is cloned and when the container is cloned
	- tXXX is the span id previous to a container and, indicates than a container
	has to be increased. The container has to be a table just next to this mark
*/
		function addElem (id) {
			
    	var br=document.createElement('br');
			var nbsp = document.createTextNode('  ');
    	var input, clon;
			var newbtn, newName;
      
    	var identify=id.split("-");
    	var first=document.getElementById(id);
      var oldBtn = document.getElementById('btn-'+id);
      var elemId = identify[0];
			var lastGroupName;
      
// first, the container: a group of questions has to be duplicated			
    	if (elemId.indexOf('t') != -1) {
// this is to get the last table with this name, because several times the
// button '+' could be clicked and then disappears from the form        
//        var aux = document.getElementById (elemId+'-children');
        var aux = document.getElementsByName(elemId+'-children');
        first = aux[aux.length-1];        

				lastGroupName = first.getAttribute ("id");
				clon = first.cloneNode (true);
				numGrp++;
				
				children = clon.getElementsByTagName('*');
				var lastBtns = new Array();
				var contBtns = 0;
   			for (var i=0; i<children.length; i++)	{

// Update the buttons for the new group
          if (children[i].getAttribute('type') == 'button') {
						if (contBtns == 1) // this for the remove button
							children[i].setAttribute('onclick', 
													"ctrl.rmvElem('" + id + "');");
						else
	            children[i].setAttribute('onclick', 
														"ctrl.addElem('" + id + "');");
														
						lastBtns[contBtns] = children[i];
						contBtns++;
          }
          
// Update form input components to the new group
          else if (children[i].tagName == 'INPUT' || children[i].tagName == 'SELECT') {
            var selId = children[i].getAttribute('name').split("-");
            var theId = selId[0];
            var ansNum = selId[1];
            var ansOrd = selId[2];
            var ansGrp = selId[3];
            
            ansNum++;
            newName = theId + '-' + ansNum + '-' + ansOrd;
            
            if (ansGrp != undefined && 
                children[i].getAttribute('type') != 'button') {
    		  		var grpNum = ansGrp.substring(1);
              grpNum++;
    		  		numItemsGrp++;
    					newName = theId + '-' + numItemsGrp + '-' + ansOrd;
              newName += '-g' + grpNum;
    		  	}
            
            children[i].setAttribute('name', newName);
            children[i].setAttribute('id', newName);
            if (children[i].tagName == 'INPUT' &&
                children[i].getAttribute('type') != 'button') {
              children[i].value="";
            }
          }
					
  			}
        
// REMOVE the last button(s) of the previous pack    
        var inputElems = first.getElementsByTagName('input');
        var buttons = new Array();
				var countBtns = 0;
        for (var i = 0; i < inputElems.length; i++) {
          if (inputElems[i].getAttribute('type') == 'button') {
            buttons[countBtns] = inputElems[i];
						countBtns++;
          }
        }
				
				for (var j=0; j<buttons.length; j++)
					buttons[j].parentNode.removeChild(buttons[j]);
//        	button.parentNode.removeChild(button);
				
// there will be one or two buttons per group (+ and -)
// If only one button is present, the minus [-] button has to be created
				lastBtns[0].setAttribute ('onclick', "ctrl.addElem('"+id+"');");
				if (lastBtns.length < 2) {
					var minusBtn = document.createElement('input')
					minusBtn = lastBtns[0].cloneNode (true)
					lastBtns.push(minusBtn)
//					lastBtns[1].setAttribute ('id', 'rmv-'+id)
//					lastBtns[1].setAttribute ('name', 'rmv-'+id)
//					lastBtns[1].setAttribute ('type', 'button')
					lastBtns[1].setAttribute ('value', '-')
					var onClickStr = lastBtns[0].getAttribute ('onclick')
					onClickStr = onClickStr.replace("add", "rmv")
					lastBtns[1].setAttribute ('onclick', onClickStr)
//				  lastBtns[1].setAttribute ('onclick', "ctrl.rmvElem('"+id+"');");
					
					lastBtns[0].parentNode.appendChild (nbsp)
					lastBtns[0].parentNode.appendChild (lastBtns[1])
				}

				input = clon;
				
				first.parentNode.appendChild(br);
	      first.parentNode.appendChild(br);
	      first.parentNode.appendChild(br);
				first.parentNode.appendChild(input);
	
				if (newbtn != undefined) {
			  	first.parentNode.appendChild(nbsp);
	        first.parentNode.appendChild(nbsp);
			  	first.parentNode.appendChild(newbtn);
			  }
  	  } // if element is a container
/////////////////////////////////////////////////////////////////////////
			
// a normal element i.e. a question item			
			if (elemId.indexOf ('q') != -1) {
				addSimpleItem (id);
				

			} // EO adding another question after clicking [+] button
			
/*
			first.parentNode.appendChild(br);
      first.parentNode.appendChild(br);
      first.parentNode.appendChild(br);
			first.parentNode.appendChild(input);
        

			if (newbtn != undefined) {
		  	first.parentNode.appendChild(nbsp);
        first.parentNode.appendChild(nbsp);
		  	first.parentNode.appendChild(newbtn);
		  }
*/			
    	return;
		}
		
		
		
    
		var test = function () {
			alert ("(repelems.js) FormManager")
		}
    
    return {
      addElem:addElem,
			rmvElem: rmvElem,
      init: init,
//       fail: onFail
    }
  }
 
 var ctrl;
 
 function onReady() {
// 	ctrl = new FormManager ();
//  ctrl.init();
 }