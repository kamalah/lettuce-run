class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.string :activity, default: 'Run'
      t.datetime :date
      t.decimal :distance
      t.decimal :duration
      t.boolean :planned, default: true
      t.timestamps null: false
    end
  end
end
