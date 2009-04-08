class Event < ActiveRecord::Base
  has_many :occurrences, :class_name => "EventOccurrence", :dependent => :destroy
  after_update :update_occurrences

  # Given a day, create an occurrence based on this event for that particular day.
  def create_occurrence_on day
    o = EventOccurrence.new
    o.event = self
    o.start_at = day.to_time + self.start_at.hour.hours + self.start_at.min.minutes
    if self.end_at
      o.end_at = day.to_time + self.end_at.hour.hours + self.end_at.min.minutes
    end

    o.save!
    o
  end

  private

  def update_occurrences
    if self.events_end_at
      EventOccurrence.destroy_all ["start_at > ? and event_id = ?", self.events_end_at, self.id]
    end
  end
end
