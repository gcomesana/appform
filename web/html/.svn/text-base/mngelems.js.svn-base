
var FormManager = function () {
		
		var numGrp, numItemsGrp;
		
		function init () {
      numGrp = 1;
			numItemsGrp = 1;
    }
    
    

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
			var identify=id.split("-");
    	var first=document.getElementById(id);
    	var br=document.createElement('br');
			var nbsp = document.createTextNode('  ');
    	var input, clon;
			var newbtn, newName;
      
    	var elemId = identify[0];
      
// first, the container: a group of questions has to be duplicated			
    	if (elemId.indexOf('t') != -1) {       
    		first=document.getElementById (elemId+'-children');
				clon = first.cloneNode (true);
				numGrp++;
				
				children = clon.getElementsByTagName('*');
				var lastBtn;
   			for (var i=0; i<children.length; i++)	{
          if (children[i].getAttribute('type') == 'button') { 
          /*  children[i].setAttribute('onclick', 
													"ctrl.addElem('" + children[i].getAttribute('id') + "');");
					*/	
            children[i].setAttribute('onclick', 
													"ctrl.addElem('" + newName + "');");
						lastBtn = children[i];
          }
          
          if (children[i].tagName == 'INPUT' || children[i].tagName == 'SELECT') {
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
              children[i].setAttribute('value', '');
            }
          }
  			}
        
// remove the last button of the previous pack    
        var inputElems = first.getElementsByTagName('input');
        var button;
        for (var i = 0; i < inputElems.length; i++) {
          if (inputElems[i].getAttribute('type') == 'button') {
            button = inputElems[i];
          }
        }
        button.parentNode.removeChild(button);
        
				lastBtn.setAttribute('onclick', 
											"ctrl.addElem('" + id + "');");
				input = clon;
  	  } // if element is a container
/////////////////////////////////////////////////////////////////////////
			
// a normal element			
			if (elemId.indexOf ('q') != -1) {
// defined in the top of the function				
				var elemId = identify[0];
	    	var ansNum = identify[1];
	    	var ansOrd = identify[2];
	    	var ansGrp = identify[3];
				
		    ansNum++;
        var newName;
        
		  	if (ansGrp != undefined) {
		  		var grpNum = ansGrp.substring(1);
		  		numItemsGrp++;
					newName = elemId + '-' + numItemsGrp + '-' + ansOrd;
          newName += '-g' + grpNum;
		  	}
				else
					newName = elemId + '-' + ansNum + '-' + ansOrd;
		  	
		  	input = first.cloneNode(true);
				input.setAttribute('name', newName);
				input.setAttribute('id', newName);
//				input.setAttribute('size', first.getAttribute('size'));
//				input.setAttribute('maxlength', first.getAttribute('maxlength'));
        if (input.getAttribute('type') != undefined)
          input.setAttribute('value', '');
				
//				var btn = document.getElementById ('btn-'+id);
				newbtn = document.createElement('input');
				newbtn.setAttribute('type', 'button');
				newbtn.setAttribute('name', 'btn-'+newName);
				newbtn.setAttribute('id', 'btn-'+newName);
        newbtn.setAttribute('value', ' + ');
				newbtn.setAttribute('onclick', 'ctrl.addElem("'+newName+'")');
			}
			
			first.parentNode.appendChild(br);
      first.parentNode.appendChild(br);
			first.parentNode.appendChild(input);
        

			if (newbtn != undefined) {
		  	first.parentNode.appendChild(nbsp);
		  	first.parentNode.appendChild(newbtn);
		  }
    	return;
		}
		
    
    
    return {
      addElem:addElem,
      init: init,
//       fail: onFail
    }
  }
 
 var ctrl;
 
 function onReady() {
 	ctrl = new FormManager ();
  ctrl.init();
 }