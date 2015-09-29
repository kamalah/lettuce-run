class AddDistanceToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :distance, :decimal
  end
end
