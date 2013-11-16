class CreateCrossheadings < ActiveRecord::Migration
  def change
    create_table :crossheadings do |t|
      t.text :title
      t.integer :no, default: 0
      t.integer :legislation_id

      t.timestamps
    end
  end
end
