class Workout < ActiveRecord::Base
	belongs_to :plan
	def date_only
		date.to_date
	end

	def self.weekly_summary(day_seven)
		day_one = day_seven - 6
		weeks_workout = self.where("(date >= ?) AND (date <= ?)",day_one, day_seven)
		total_distance = {'Run'=> 0}
		weeks_workout.each do |workout|
			total_distance[workout.activity] += workout.distance
		end

		total_distance
	end
end
