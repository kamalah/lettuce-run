class Plan < ActiveRecord::Base
	validates_presence_of :start_date, :race_date, :distance, :target_time
	validate :race_date_after_start_date, :dates_in_future, :target_time_reasonable
	has_many :workouts
	
	def race_date_after_start_date
		 if race_date <= start_date
	      errors.add(:start_date, "must be before race date")
	    end
	end
	
	def dates_in_future
		 if (race_date < Date.today)
		 	errors.add(:race_date, "must be in the future: race date")
		 end

		 if (start_date < Date.today)
	      errors.add(:start_date, "must be in the future: start date")
	    end
	end

	def target_time_reasonable
		if ((target_time / distance) < 5)
			errors.add(:target_time, "your target time is not reasonable")
		end	
	end

	def weekly_summaries
		sundays = start_date.sunday? ? start_date : (start_date + 7- start_date.wday)
		weekly_summary = {}
		while sundays <= (race_date+6)
			weekly_summary[sundays.to_date] = workouts.weekly_summary(sundays)
			sundays += 7
		end
		weekly_summary
	end

	def analyze
		training_plan = workouts.where(planned: true).group_by(&:date_only)
		actual_workouts = workouts.where(planned: false).group_by(&:date_only)
		training_to_date = (start_date..Date.today).to_a 
		#metrics
		#actual_compliance - did actual workout on day scheduled
		#completed actual mileage for the week

		training_to_date.each do |date|
			if training_plan[date] 
				if actual_workouts[date]
					base_line = (training_plan[date].activity == actual_workouts[date].activity) ? 1 : 0  
					# actual_workouts[date].distance/training_plan[date].distance
					# actual_workouts[date].duration/training_plan[date].duration
				end
			end
		end
	end
end
