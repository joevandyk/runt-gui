class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.datetime :last_generated_event
      t.boolean :repeat_weekly
      t.boolean :repeat_daily
      t.boolean :repeat_monthly
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
