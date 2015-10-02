class Workout < ActiveRecord::Base
	belongs_to :plan
	def date_only
		date.to_date
	end

	def self.weekly_summary(day_seven)
		day_one = day_seven - 6
		weeks_workout = self.where("(date >= ?) AND (date <= ?)",day_one, day_seven)
		total_distance={}
		weeks_workout.each do |workout|
			if total_distance[workout.activity]
				total_distance[workout.activity] += workout.distance
			else
				total_distance[workout.activity] = workout.distance
			end
		end
		total_distance
	end

	def duration_pretty
		hours = (duration/60).floor
		minutes = (duration - hours*60).floor
		seconds = ((duration - hours*60)-minutes).round(2)
		"#{hours}:#{minutes}:#{seconds}"
	end

	def convert_to_run
		workout_scales = {'Run'=> [1,1], 'Bike'=> [0.15, 0.8], 'Swim'=> [1, 0.25], 'Elliptical'=> [0.67, 1]}
		{distance: (workout_scales[activity][0]*distance), duration: (workout_scales[activity][1]*duration) }

	end
end
