$('body').on('click',"#show-hide",function (){
		$(".plan-summary").toggle();
		if ($(".plan-summary").is(":hidden")) {
			$('#show-hide').text("Show Training Plan");
		} else {
			$('#show-hide').text("Hide Training Plan");
		}
});

(function showPlan() {
// add call to API
$(".plan-summary").text("Training Plan Goes Here")
})();