class WorkoutsController < ApplicationController
	def new
		workout_date = Date.parse(params[:date])
		@plan = Plan.find_by(id: params[:plan_id])
		@planned_workout = @plan.workouts.where("(planned = ?) AND (date = ?) ", true, workout_date)
		@workout = Workout.new(date: workout_date, duration: 0)
		@user = current_user
	end

	def create
		@user = current_user
		@plan = Plan.find_by(id: params[:plan_id])
		@workout = @plan.workouts.new(workout_params.merge({planned: false}))
		if @workout.save
			flash[:notice] = "Your workout was successfully added."
			redirect_to plan_path({id: @plan.id, date: @workout.date})
		else
			flash[:alert] = @workout.errors.messages
	      	flash[:color]= "invalid"
	      	@planned_workout = @plan.workouts.where("(planned = ?) AND (date = ?) ", true, @workout.date)
	      	render :new
	    end
	end

	def destroy
		workout = Workout.find(params[:id])
		workout.destroy
		flash[:notice] = "Workout #{workout.id} succesfully deleted."
		redirect_to plan_path({id: params[:plan_id], date: workout.date})
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
			redirect_to plan_path({id: @plan.id, date: @workout.date})
		else
			flash[:alert] = @workout.errors.messages
	      	flash[:color]= "invalid"
			render :new
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
