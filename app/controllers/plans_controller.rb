class PlansController < ApplicationController
	def new
	end

	def create
		redirect_to plan_path(1)
	end

	def show
		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		plan = Plan.find_by(id: params[:id])
		@workouts = plan.workouts.group_by(&:date_only)
		@weekly_summaries = plan.weekly_summaries
  	end

  	private 
  		def build_plan
		distance_map ={'0': 6.2, '1': 13.1, '2':26.2}
		race_date = params[:date]
		status = params[:status]
		distance = distance_map[params[:distance]]
		target_time = params[hours]*60 + params[:minutes]
		activity = params[:activity]
		plan = Plan.new(version: 0, target_time: target_time, race_date: race_date, 
			start_date: Date.today)
		plan.save
		#go from start date to race date
		training_dates = (plan.start_date..race_date).to_a	
		# 10k plan
		# rest_day M-W-S (wday = 0, 2, 5)
		# cross-train F (wday = 4) 
		# week 1,2: 3 miles 2x week (wday = 1, 3), 4 miles wday= 6 
		# week 3,4: 4 miles 2x week (wday = 1, 3), 5 miles wday= 6
		# week 5,6: 5 miles 2x week (wday = 1, 3), 6 miles wday= 6
		# week 7,8: 5 miles 2x week (wday = 1, 3), 6.5 miles wday= 6
		thirds = (plan.race_date - plan.start_date)/3
		first_third = plan.start_date + thirds
		middle_third = first_third+thirds
		target_pace = target_time/distance
		training_dates.each do |date|
			if date < first_third
				distance_scale = 0.5
				pace_scale = [1.2, 1.2]
			elsif date < middle_third
				distance_scale = 0.75
				pace_scale = [1.1, 1.2]
			else
				distance_scale = 1.1
				pace_scale = [1, 1.1]
			end
				
			if (date.wday == 1 || date.wday == 3)
					plan.workouts.create(date: date, distance: distance*distance_scale, duration: distance*distance_scale*target_pace*pace_scale[0])
			elsif (date.wday == 4)
					plan.workouts.create(activity: activity, date: date, duration: 45)
			elsif (date.wday == 6)
					plan.workouts.create(date: date, distance: (distance*distance_scale*1.5), duration: (distance*distance_scale*1.5)*target_pace*pace_scale[1])
			end
		end	
	end
end

