class Plan < ActiveRecord::Base
	has_many :workouts
	
	def weekly_summaries
		sundays = start_date.sunday? ? start_date : (start_date + 7- start_date.wday)
		weekly_summary = {}
		while sundays <= race_date
			weekly_summary[sundays.to_date] = workouts.weekly_summary(sundays)
			sundays += 7
		end
		weekly_summary
	end
end
