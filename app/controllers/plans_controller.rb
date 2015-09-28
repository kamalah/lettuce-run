class PlansController < ApplicationController
	def new
	end

	def create
		redirect_to plan_path(1)
	end

	def show
		@date = Date.today
		plan = Plan.find_by(id: params[:id])
		@workouts = plan.workouts.group_by(&:date_only)
		@weekly_summaries = plan.weekly_summaries
  	end

  	private 
  		def build_plan
		#go from start date to race date
		race_date = params[:date]
		status = params[:status]
		distance = params[:distance]
		target_time = params[hours]*60 + params[:minutes]
		activity = params[:activity]
		plan = Plan.new(version: 0, target_time: target_time, 
			start_date: Date.today)
		plan.save
		training_dates = (plan.start_date..race_date).to_a	
		training_dates.each do |date|
			Workout.create(date: date, distance: rand(5), duration: rand(30..45))
		end	
	end
end

