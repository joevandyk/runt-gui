class EventOccurrence < ActiveRecord::Base
  belongs_to :event

  # Returns a flat array of all event occurrences that happen in the specified month.
  def self.for_month month
    # TODO Later, instead of looping over all events (inefficient), 
    # keep track if we've already generated occurrences for the events for 
    # that particular month.
    Event.all.map do |event|
      if event.repeats?
        occurrences_for_repeating_event(event, month)
      else 
        occurrence_for_single_event(event, month)
      end
    end.flatten
  end

  private

  def self.occurrence_for_single_event event, month
    find_or_create_event_by_day(event, pday(event.start_at))
  end

  def self.occurrences_for_repeating_event event, month
    # Setup repeating runt expression
    s = event.repeat_weekly? ? 
        weekly(event.start_at) : 
        monthly(event.repeat_week, event.repeat_day)

    # Apply start date
    s = s & after(event.start_at)

    # If end date, apply it
    if event.events_end_at
      s = s & before(event.events_end_at)
    end

    # Get the days in the month
    days_in_month = range(month, month >> 1)

    # Loop over the days in the month that the event falls on,
    # Find or create the occurrence for that day.
    s.dates(days_in_month).map do |day|
      find_or_create_event_by_day(event, day)
    end
  end
  
  # Given an event and a day, find the event occurrence for that day
  def self.find_or_create_event_by_day event, day
    event.occurrences.find(:first, :conditions => ["start_at >= ? and start_at < ?", day, day + 1]) \
      or
    event.create_occurrence_on(day)
  end

  # Runt Helpers below
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

  def self.weekly date
    Runt::DIWeek.new(date.wday)                  
  end

  def self.monthly week, wday
    Runt::DIMonth.new(week, wday) 
  end

end
