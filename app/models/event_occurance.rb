class EventOccurance < ActiveRecord::Base
  belongs_to :event

  def self.for_month month
    Event.find(:all).each do |event|
      if event.repeat_weekly
        s = sugar.define do
          on Runt::DIWeek.new(event.start_at.wday)
        end

        # Apply start date
        s = s & after(event.start_at)

        # If end date, apply it
        if event.events_end_at
          s = s & before(event.events_end_at)
        end

        next_month = month >> 1
        days_in_month = range(month, next_month)

        return s.dates(days_in_month).map do |day|
          EventOccurance.find_or_create_event_by_day(event, day)
        end
      end
    end
  end

  private
  
  # Given an event and a day, find the event occurence for that day
  def self.find_or_create_event_by_day event, day
    if e = event.occurences.find(:first, :conditions => ["start_at >= ? and start_at < ?", day, day + 1])
      return e
    else
      return event.create_occurance_on(day)
    end
  end


  # Runt Helpers
  def self.sugar 
    ExpressionBuilder.new
  end

  def self.pday date
    Runt::PDate.day date.year, date.month, date.day 
  end

  def self.after date
    Runt::AfterTE.new(pday(date), true)
  end

  def self.before date
    Runt::BeforeTE.new(pday(date), true)
  end

  def self.range start_at, end_at
    Runt::DateRange.new(pday(start_at), pday(end_at))
  end

end
