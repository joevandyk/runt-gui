class EventOccurance < ActiveRecord::Base
  include Runt

  belongs_to :event

  def self.for_month month
    ::Event.find(:all).each do |event|
      if event.repeat_weekly
        s = Runt::EveryTE.new(event.start_at, 1, Runt::DPrecision::Precision.week)
        s = s & DIWeek.new(event.start_at.wday)
        next_month = month >> 1
        range = DateRange.new(PDate.day(month.year, month.month, month.day), 
                              PDate.day(next_month.year, next_month.month, next_month.day))
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
end
