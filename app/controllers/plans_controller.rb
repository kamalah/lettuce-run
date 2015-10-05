class PlansController < ApplicationController
	include PlanBuilder
	
  def index
  end

  def create
    build_plan
  end
  
  def make_active
    plan = Plan.find_by(id: params[:id])
    last_active_plan = Plan.where("(master = ?) AND (active = ?)", plan.master, true).first
    plan.update(active: true)
    last_active_plan.update(active: false)
    last_active_plan.workouts.where(planned: false).update_all(plan_id: plan.id)
    redirect_to plan_path(plan)
  end

  def new
  end

  def show
		@date = params[:date] ? Date.parse(params[:date]) : Date.today
		@plan = Plan.find_by(id: params[:id])
		@workouts = @plan.workouts.group_by(&:date_only)
		@planned_summaries = @plan.weekly_summaries(true)
    @actual_summaries = @plan.weekly_summaries(false)
    @all_plans = Plan.where(master: @plan.master).order("version DESC")
  end

  def update
  	current_plan = Plan.find_by(id: params[:id]) 
    compliance = current_plan.analyze
  	if compliance > 90 
  		flash[:notice] = "Your are following your current plan well, no need to update."
  	else
  		flash[:notice] = "Here is your new plan!"
      update_plan(current_plan)
    end
    redirect_to plan_path(current_plan)
  end

end