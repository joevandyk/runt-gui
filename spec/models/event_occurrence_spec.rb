require 'spec/spec_helper'

describe "Recurring Events" do

  FEB       = DateTime.new(2009, 2)
  MARCH     = DateTime.new(2009, 3)
  APRIL     = DateTime.new(2009, 4)
  MARCH_29  = DateTime.new(2009, 3, 29, 19, 30)
  APRIL_19  = DateTime.new(2009, 4, 19)

  before(:each) do
    Event.destroy_all
  end

  describe "weekly event starting in march without end" do
    before(:each) do
      @event = Event.create! :start_at => MARCH_29, :end_at => MARCH_29 + 1.hour, :repeat_weekly => true
    end

    it "should have four events in april" do
      assert_difference "EventOccurrence.count", 4 do 
        EventOccurrence.for_month(APRIL).size.should == 4
      end
    end

    it "the created occurrences should be attached to the event, and have the same times for starting and ending" do
      april_events = EventOccurrence.for_month(APRIL)
      april_events[0].start_at.should == DateTime.new(2009, 4,  5, 19, 30)
      april_events[0].end_at.  should == DateTime.new(2009, 4,  5, 20, 30)

      april_events[1].start_at.should == DateTime.new(2009, 4, 12, 19, 30)
      april_events[1].end_at.  should == DateTime.new(2009, 4, 12, 20, 30)

      april_events[2].start_at.should == DateTime.new(2009, 4, 19, 19, 30)
      april_events[2].end_at.  should == DateTime.new(2009, 4, 19, 20, 30)

      april_events[3].start_at.should == DateTime.new(2009, 4, 26, 19, 30)
      april_events[3].end_at.  should == DateTime.new(2009, 4, 26, 20, 30)
    end

    it "shouldn't create new events on subsequent calls" do
      april = EventOccurrence.for_month(APRIL)
      assert_difference "EventOccurrence.count", 0 do 
        april.should == EventOccurrence.for_month(APRIL)
      end
    end

    it "should be able to find events in far future" do
      assert_difference "EventOccurrence.count", 4 do 
        EventOccurrence.for_month(APRIL + 1.year).size.should == 4
      end
    end

    it "should be one event in march" do
      EventOccurrence.for_month(MARCH).size.should == 1
    end

    it "should be no events in feb" do
      EventOccurrence.for_month(FEB).should be_blank
    end

    it "deleting the event should delete the occurrences" do
      april = EventOccurrence.for_month(APRIL)
      @event.destroy
      april.each { |o| lambda { o.reload }.should raise_error }
    end

=begin
    it "making the end date earlier should remove the occurrences after the new end date" do
      april = EventOccurrence.for_month(APRIL)
      @event.update_attribute :events_end_at, APRIL_19
      # The last event should have been removed
      lambda { april.last.reload }.should raise_error
    end
=end
  end

  describe "weekly event starting in march ending midway through april" do
    it "should have three events in april (not 4)" do
      @event = Event.create! :start_at => MARCH_29, :repeat_weekly => true, :end_at => MARCH_29 + 1.hour, :events_end_at => APRIL_19
      @april = EventOccurrence.for_month(APRIL)
      @april.size.should == 3
    end
  end

end
