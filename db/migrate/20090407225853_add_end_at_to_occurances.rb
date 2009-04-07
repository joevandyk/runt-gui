class AddEndAtToOccurances < ActiveRecord::Migration
  def self.up
    add_column :event_occurances, :end_at, :datetime
  end

  def self.down
  end
end
