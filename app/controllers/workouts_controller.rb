class WorkoutsController < ApplicationController
	def new
		#@plan = Plan.find_by(id: params[:id])
		@plan = Plan.find_by(id: 1)
		@workout = Workout.new
	end

	def create
		binding.pry
		redirect_to plan_path(1)
	end
end
