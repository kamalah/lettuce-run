class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :version	
      t.decimal :target_time
      t.date :race_date
      t.date :start_date
      t.timestamps null: false
    end
  end
end
