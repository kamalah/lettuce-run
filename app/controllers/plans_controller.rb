class PlansController < ApplicationController
	include PlanBuilder
	def new
	end

	def create
		build_plan
	end

	def show
		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		plan = Plan.find_by(id: params[:id])
		@workouts = plan.workouts.group_by(&:date_only)
		@weekly_summaries = plan.weekly_summaries
  	end

  	def update
  		current_plan = Plan.find_by(id: params[:id]) 
  		compliance = current_plan.analyze
  		if compliance > 90 
  			flash[:notice] = "Your are following your current plan well, no need to update."
  		else
  			update_plan(plan)
  		end
  		plan = Plan.last
  		redirect_to plan_path(plan)
  	end
  	
end

