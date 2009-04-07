class EventOccurance < ActiveRecord::Base
  belongs_to :event

  def self.for_month month
    Event.find(:all).each do |event|
      if event.repeat_weekly
        s = sugar.define do
          on Runt::DIWeek.new(event.start_at.wday)
        end

        # Apply start date
        s = s & Runt::AfterTE.new(Runt::PDate.day(event.start_at.year, event.start_at.month, event.start_at.day), true)

        # If end date, apply it
        if event.end_at
          s = s & Runt::BeforeTE.new(Runt::PDate.day(event.end_at.year, event.end_at.month, event.end_at.day), true)
        end

        # Get the range of days in the current month
        next_month = month >> 1
        range = Runt::DateRange.new(Runt::PDate.day(month.year, month.month, month.day), 
                                    Runt::PDate.day(next_month.year, next_month.month, next_month.day))

        return s.dates(range).map do |day|
          EventOccurance.find_or_create_event_by_day(event, day)
        end
      end
    end
  end

  # Given an event and a day, find the event occurence for that day
  def self.find_or_create_event_by_day event, day
    if e = event.occurences.find(:first, :conditions => ["start_at >= ? and start_at < ?", day, day + 1])
      return e
    else
      EventOccurance.create! :event => event, :start_at => day.to_time + event.start_at.hour.hours + event.start_at.min.minutes
    end
  end

  private

  def self.sugar 
    ExpressionBuilder.new
  end
end
