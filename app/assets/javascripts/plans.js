function find_value(value_name, form_values){
	var val_index = form_values.findIndex(function (el){
		return value_name == el.name
	});

	return form_values[val_index].value

}

function check_values (form_values) {
	var warnings = "";
	var distance = find_value("distance", form_values);
	var status = find_value("status", form_values);
	var start_date =  new Date(find_value("start_date", form_values));
	var race_date =  new Date(find_value("race_date", form_values));
	var training_time = (race_date-start_date) / (1000*60*60*24);
	var hours =  find_value("hours", form_values);
	var minutes =  find_value("minutes", form_values);
	var target_time = (parseInt(hours) * 60) + parseInt(minutes);
	
	//check if target_time is too fast (< 30 min 10K, < 65 half, 125 full)
	if ((distance == "0" && target_time < 30) || (distance == "1" && target_time < 65) || (distance == "2" && target_time < 125))
		warnings += "Confirm your race/target_time ";
	//training_time too short
	if ((distance == "0" && training_time < 28) || (distance == "1" && training_time < 42) || (distance == "2" && training_time < 56))
		warnings += "Confirm your race date and training start date";
	return warnings
}

$('#submit').on('click', function(){
	 var reasonable = check_values(form_values);
            if (reasonable) {
            	if (confirm('Are you sure the following are correct: ' + reasonable)) {
            	$('#plan-form').submit();
            	}
			} else {
				$('#plan-form').submit();
			}
});

$('#show-hide-versions').click(function (){
		$(".plan-versions").toggle();
		if ($(".plan-versions").is(":hidden")) {
			$('#show-hide-versions').text("Show All Versions Plan");
		} else {
			$('#show-hide-versions').text("Hide All Versions Plan");
		}
});

$('#show-hide-summary').click(function (){
		$(".plan-summary").toggle();
		if ($(".plan-summary").is(":hidden")) {
			$('#show-hide-summary').text("Show Plan Details");
		} else {
			$('#show-hide-summary').text("Hide Plan Details");
		}
});

$('#download-ics').click(function() {
var planId = $('#download-ics').data('plan')
var request = $.get('/api/plans/' + planId)
    request.fail(function () {
     	alert('Error Downloading.')
     });
    request.done(function (workouts) {
       var cal = ics();
       workouts.forEach(function (workout){
      cal.addEvent('Lettuce Run Workout', workout.activity + '-' + workout.distance + 'miles, - ' + workout.duration_pretty.join(':')+ '(hh:mm:ss)', '', workout.date, workout.date);
     })
       cal.download('Lettuce_Plan')
    });

});

(function () {
    $('#plan-form').change(function() {
        var empty = false;
        window.form_values = $('#plan-form').serializeArray();
        form_values.forEach(function(object) {
            if (object.value == '') {
                empty = true;
                       }
        });

        if (empty) {
            $('#submit').attr('disabled', 'disabled'); 
        } else {
            $('#submit').removeAttr('disabled');
        }
    });
})()

