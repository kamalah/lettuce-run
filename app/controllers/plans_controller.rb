class PlansController < ApplicationController
	def new
	end

	def create
		build_plan
		plan = Plan.last
		redirect_to plan_path(plan)
	end

	def show
		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		plan = Plan.find_by(id: params[:id])
		@workouts = plan.workouts.group_by(&:date_only)
		@weekly_summaries = plan.weekly_summaries
  	end

  	private 
  		def build_plan
		distance_map ={'0': 6.2, '1': 13.1, '2': 26.2}
		race_date = params[:race_date]
		start_date = params[:start_date]
		status = params[:status]
		distance = distance_map[params[:distance].to_sym]

		target_time = params[:hours].to_i*60 + params[:minutes].to_i
		activities = ['Run',params[:activity1],params[:activity2],params[:activity3]].reject(&:blank?).join(',')
		plan = Plan.new(version: 0, target_time: target_time, race_date: race_date, 
			start_date: start_date, distance: distance, activities: activities)
		
		plan.save
		
		case params[:distance]
			when '0'
				tenkPlan(plan)
			when '1'
				halfPlan(plan)
			when '2'
				fullPlan(plan)
		end
	end

	def tenkPlan(plan)
		# 10k plan
		# rest_day M-W-S (wday = 1, 3, 6)
		# cross-train F (wday = 5) 
		# week 1,2: 3 miles 2x week (wday = 2, 4), 4 miles wday= 0 
		# week 3,4: 4 miles 2x week (wday = 2, 4), 5 miles wday= 0
		# week 5,6: 5 miles 2x week (wday = 2, 4), 6 miles wday= 0
		# week 7,8: 5 miles 2x week (wday = 2, 4), 6.5 miles wday= 0
		training_dates = (plan.start_date...plan.race_date).to_a
		thirds = (plan.race_date - plan.start_date)/3
		first_third = plan.start_date + thirds
		middle_third = first_third + thirds
		target_pace = plan.target_time / plan.distance
		taper_week = plan.race_date - 6
		#race_date "workout"
		plan.workouts.create(date: plan.race_date, distance: (plan.distance), duration: plan.target_time)

		training_dates.each do |date|
			if date < first_third
				distance_scale = [0.5, 0.75]
				pace_scale = [1.2, 1.2]
			elsif date < middle_third
				distance_scale = [0.75, 1]
				pace_scale = [1.1, 1.2]
			else
				distance_scale = [0.75, 1.1]
				pace_scale = [1, 1.1]
			end
				
			if (date.wday == 2 || date.wday == 4)
					plan.workouts.create(date: date, distance: plan.distance*distance_scale[0], duration: plan.distance*distance_scale[0]*target_pace*pace_scale[0])
			elsif (date.wday == 5)
					plan.workouts.create(activity: "cross-train", date: date, duration: 45)
			elsif (date.wday == 0)
					plan.workouts.create(date: date, distance: (plan.distance*distance_scale[1]), duration: (plan.distance*distance_scale[1])*target_pace*pace_scale[1])
			end
		end	
	end

	def halfPlan(plan)
	end

	def fullPlan(plan)
	end
end

