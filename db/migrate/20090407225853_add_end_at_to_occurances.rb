class AddEndAtToOccurances < ActiveRecord::Migration
  def self.up
    add_column :event_occurrences, :end_at, :datetime
  end

  def self.down
  end
end
