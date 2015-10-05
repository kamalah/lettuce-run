class AddUsersToPlansAndWorkouts < ActiveRecord::Migration
  def change
  	add_reference :workouts, :user, index: true
  	add_reference :plans, :user, index: true
  end
end
