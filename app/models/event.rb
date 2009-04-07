class Event < ActiveRecord::Base
  has_many :occurences, :class_name => "EventOccurance"
end
