class CreateLegislations < ActiveRecord::Migration
  def change
    create_table :legislations do |t|
      t.text :title
      t.date :passed_on
      t.date :proposed_on

      t.timestamps
    end
  end
end
