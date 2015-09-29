class WorkoutsController < ApplicationController
	def new
		@plan = Plan.find_by(id: params[:plan_id])
		@workout = Workout.new(date: Date.parse(params[:date]))
	end

	def create
		@plan = Plan.find_by(id: params[:plan_id])
		redirect_to plan_path(@plan)
	end

	private
		def workout_params
			form_params= params.require(:workout).permit(:distance, 
				:date, :activity)
			form_params[:duration] = params[:duration][:hours]* 60 + params[:duration][:hours] 
			form_params
		end

end
