
var Overlay = function () {

  function show () {
  		el = document.getElementById("overlay");
  		el.style.visibility =  "visible";
  };
  
  function hide () {
    el = document.getElementById("overlay");
  	el.style.visibility =  "hidden";    
  }
  
  
  function operate () {
    el = document.getElementById("overlay");
  	el.style.visibility = 
          (el.style.visibility == "visible")? "hidden": "visible";
  }
  
  function test () {
    alert ("overlay is reachable!!!");
  }
  
  return {
    test: test,
    show: show,
    hide: hide
  }
  
}