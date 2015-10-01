class WorkoutsController < ApplicationController
	def new
		@plan = Plan.find_by(id: params[:plan_id])
		@workout = Workout.new(date: Date.parse(params[:date]))
	end

	def create
		@plan = Plan.find_by(id: params[:plan_id])
		@workout = @plan.workouts.new(workout_params.merge({planned: false}))
		if @workout.save
			flash[:notice] = "Your workout was successfully added."
			redirect_to plan_path(@plan)
		else
			flash[:alert] = @workout.errors.messages
	      	flash[:color]= "invalid"
	      	render :new
	    end
	end


	def edit
		@plan = Plan.find_by(id: params[:plan_id])
		@workout = Workout.find_by(id: params[:id])
	end

	def update
		@plan = Plan.find_by(id: params[:plan_id])
		@workout = Workout.find_by(id: params[:id])
		if @workout.update(workout_params)
			flash[:notice] = "Workout Edited Succesfully!"
			redirect_to plan_path(@plan)
		else
			flash[:alert] = @workout.errors.messages
	      	flash[:color]= "invalid"
			render :edit
		end
	end

	private
		def workout_params
			form_params= params.require(:workout).permit(:distance, 
				:date, :activity)
			form_params[:duration] = params[:duration][:hours].to_i* 60 + params[:duration][:mins].to_i + params[:duration][:secs].to_i/60 
			form_params
		end

end
