$('[data-hook~=make-plan]').click(function (event) {
	 	event.preventDefault()
	 	window.planData = $('form').serializeArray()
	 	console.log('I am here')
	 	debugger
	 })
