class CreateElectorates < ActiveRecord::Migration
  def change
    create_table :electorates do |t|
      t.string :name
    end
  end
end
