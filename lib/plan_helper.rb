class PlanHelper
	def initialize
	#@workouts = []
	# status
	# race_date
	# distance
	# target_time	
	end

	def build_plan
	#go from start date to race date
		race_date = Date.today + 30
		all_dates = (Date.today..race_date).to_a	
		all_dates.each do |date|
			Workout.create(date: date, distance: rand(5), duration: rand(30..45))
		end	
	end


end