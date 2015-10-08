class Api::PlansController < ApplicationController
	def show
		plan = Plan.find_by(id: params[:id])
		unless plan
			render json: { error: "plan not found"}, status: 400
			return
		end
		planned_workouts = plan.workouts.where(planned: true)
		render json: planned_workouts
	end
end