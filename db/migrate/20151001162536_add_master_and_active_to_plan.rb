class AddMasterAndActiveToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :active, :boolean, default: true
    add_column :plans, :master, :integer, default: 0
  end
end
