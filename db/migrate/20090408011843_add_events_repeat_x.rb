class AddEventsRepeatX < ActiveRecord::Migration
  def self.up
    add_column :events, :repeat_week, :integer
    add_column :events, :repeat_day, :integer
  end

  def self.down
  end
end
