class AddRuntToSchedule < ActiveRecord::Migration
  def self.up
    add_column :schedules, :runt, :binary
  end

  def self.down
  end
end
