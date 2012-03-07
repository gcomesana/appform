

var Hint = function() {

	var showTooltip = function(option){
		var toolDiv = $("#toolDiv");
		var posx = getMouseCoord(null, 'x'), posy = getMouseCoord(null, 'y');
		
		$(toolDiv).html("<b>" + option.text + "</b>");
		/*
		$(toolDiv).height(10);
		$(toolDiv).width(option.text.length * 5);
		$(toolDiv).position({
			left: posx,
			top: posy
		});
		*/
		
		$(toolDiv).css ("height", "10px");
		$(toolDiv).css ("width", option.text.length*5);
		$(toolDiv).css ("left", posx);
		$(toolDiv).css ("top", posy);
		$(toolDiv).css("visibility", "visible");
	}
	
	
	function getMouseCoord(e, what) {
		var posx = 0;
		var posy = 0;
		var e;
		
		if (!e) {
			e = window.event || window.Event;
			if (e == undefined) 
				e = event;
		}
		
		if (e.pageX || e.pageY) {
			posx = e.pageX;
			posy = e.pageY;
		}
		else 
			if (e.clientX || e.clientY) {
				posx = e.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
				posy = e.clientY + document.body.scrollTop + document.documentElement.scrollTop;
			}
		//You have the coordinates in the posx and posY variables
		//You can do whatever you want with them after this point
		
		return (what.toLowerCase() == 'x') ? posx : posy;
	}
	
	
	
	return {
		show: showTooltip,
	}
	
}