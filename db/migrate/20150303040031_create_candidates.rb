class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :first_names
      t.string :last_name
      t.integer :party_id
      t.integer :electorate_id
    end
  end
end
