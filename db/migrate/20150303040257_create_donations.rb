class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :donor_id
      t.integer :candidate_id
      t.float :amount
    end
  end
end
