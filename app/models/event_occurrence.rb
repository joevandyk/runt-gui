class EventOccurrence < ActiveRecord::Base
  belongs_to :event

  def self.for_month month
    Event.all.map do |event|
      if event.repeat_weekly? || event.repeat_monthly?

        s = 
          if event.repeat_weekly?
            Runt::DIWeek.new(event.start_at.wday)                  
          else
            Runt::DIMonth.new(event.repeat_week, event.repeat_day) 
          end

        # Apply start date
        s = s & after(event.start_at)

        # If end date, apply it
        if event.events_end_at
          s = s & before(event.events_end_at)
        end

        next_month = month >> 1
        days_in_month = range(month, next_month)

        s.dates(days_in_month).map do |day|
          EventOccurrence.find_or_create_event_by_day(event, day)
        end

      else
        # Not a weekly or monthly repeating event, just create a single occurrence of it.
        find_or_create_event_by_day event, pday(event.start_at)
      end

    end.flatten
  end

  private
  
  # Given an event and a day, find the event occurrence for that day
  def self.find_or_create_event_by_day event, day
    if e = event.occurrences.find(:first, :conditions => ["start_at >= ? and start_at < ?", day, day + 1])
      return e
    else
      return event.create_occurrence_on(day)
    end
  end


  # Runt Helpers
  def self.sugar 
    ExpressionBuilder.new
  end

  def self.pday date
    Runt::PDate.day date.year, date.month, date.day 
  end

  def self.pweek date
    Runt::PDate.week date.year, date.month, date.day
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
