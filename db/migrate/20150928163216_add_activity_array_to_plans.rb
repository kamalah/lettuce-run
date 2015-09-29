class AddActivityArrayToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :activities, :string
	end
end
