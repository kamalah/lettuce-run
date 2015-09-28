class AddPlanIDtoWorkouts < ActiveRecord::Migration
  def change
  	add_reference :workouts, :plan, index: true
  end
end
