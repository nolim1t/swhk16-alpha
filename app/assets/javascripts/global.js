// $(document).ready(function(){
// 	var dismiss_popover = function(selector){
// 		$(selector).click();
// 	}

// 	$('[data-toggle="popover"]').popover({ html: true });
// }
$(function () {
  $('[data-toggle="popover"]').popover({ html: true });

  var carddetailsTrigger = $('.cd-carddetails-trigger');
  //show faq content clicking on faqTrigger
	carddetailsTrigger.on('click', function(event){
		event.preventDefault();
		$(this).next('.cd-carddetails-content').slideToggle(200).end().toggleClass('content-visible');
	});
})
