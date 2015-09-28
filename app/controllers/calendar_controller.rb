class CalendarController < ApplicationController
  def show
	@date = params[:date] ? Date.parse(params[:date]) : Date.today
	# plan = Plan.new
	# plan.build_plan
	plan = Plan.first
	@workouts = plan.workouts.group_by(&:date_only)
	@weekly_summaries = plan.weekly_summaries
	puts @weekly_summaries
  end

end
