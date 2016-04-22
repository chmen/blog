class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :name
      t.integer :spam
      t.integer :ham
      t.string :language

      t.timestamps null: false
    end
  end
end
