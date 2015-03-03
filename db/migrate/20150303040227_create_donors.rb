class CreateDonors < ActiveRecord::Migration
  def change
    create_table :donors do |t|
      t.string :name
      t.string :slug
    end
  end
end
