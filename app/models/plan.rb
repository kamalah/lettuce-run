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
		
		#training_to_date = (start_date..Date.today).to_a 
		training_to_date = (start_date..(Date.today+30)).to_a
		#metrics
		#compliance[0] - did actual workout on day scheduled
		#completed actual mileage for the week
		compliance = Array.new(3,0)
		training_days = training_to_date.length
		training_to_date.each do |date|
			
			if training_plan[date] 
				if actual_workouts[date]
					actual_workouts[date].each do |workout|
					if (workout.activity == 'Run') 
						compliance[0] += 0.5 #bonus for running on running day
					end	
					converted = workout.convert_to_run
					compliance[0] += (converted[:distance]/training_plan[date][0].distance) + (converted[:duration]/training_plan[date][0].duration)
					end
				end	
			elsif actual_workouts[date]
				
			end
		end
		puts compliance
		95
	end
end
