$(document).ready(function(){
	var dismiss_popover = function(selector){
		$(selector).click();
	}

	$('[data-toggle="popover"]').popover({ html: true });
}