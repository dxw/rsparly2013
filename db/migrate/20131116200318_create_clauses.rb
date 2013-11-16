class CreateClauses < ActiveRecord::Migration
  def change
    create_table :clauses do |t|
      t.text :text
      t.integer :no, default: 0
      t.integer :crossheading_id

      t.timestamps
    end
  end
end
