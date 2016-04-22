class CreateTextCleaners < ActiveRecord::Migration
  def change
    create_table :text_cleaners do |t|

      t.timestamps null: false
    end
  end
end
