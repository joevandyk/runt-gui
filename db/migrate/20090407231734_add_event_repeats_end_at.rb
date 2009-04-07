class AddEventRepeatsEndAt < ActiveRecord::Migration
  def self.up
    add_column :events, :events_end_at, :datetime
  end

  def self.down
  end
end
