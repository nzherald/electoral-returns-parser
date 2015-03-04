class AddColourToParties < ActiveRecord::Migration
  def change
    add_column :parties, :colour, :string
  end
end
