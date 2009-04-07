require 'spec/spec_helper'

describe "Recurring Events" do
  before(:each) do
    Event.destroy_all
  end

  describe "weekly event starting in march without end" do
    before(:each) do
      @event = Event.create! :start_at => DateTime.new(2009, 3, 29, 19, 30), :repeat_weekly => true
    end

    it "should have four events in april" do
      assert_difference "EventOccurance.count", 4 do 
        EventOccurance.for_month(DateTime.new(2009, 4)).size.should == 4
      end
    end

    it "the created occurances should be attached to the event, and have the same times for starting" do
      EventOccurance.for_month(DateTime.new(2009, 4)).each do |e|
        e.start_at.wday.should == 0
        e.start_at.hour.should == @event.start_at.hour
        e.start_at.min.should == @event.start_at.min
        e.event.should == @event
      end
    end

    it "shouldn't create new events on subsequent calls" do
      april = EventOccurance.for_month(DateTime.new(2009, 4))
      assert_difference "EventOccurance.count", 0 do 
        april.should == EventOccurance.for_month(DateTime.new(2009, 4))
      end
    end

    it "should be able to find events in far future" do
      assert_difference "EventOccurance.count", 4 do 
        EventOccurance.for_month(DateTime.new(2010, 4)).size.should == 4
      end
    end

    it "should be one event in march" do
      march = EventOccurance.for_month(DateTime.new(2009, 3))
      march.size.should == 1
    end

    it "should be no events in feb" do
      feb = EventOccurance.for_month(DateTime.new(2009, 2))
      feb.size.should == 0
    end
  end

  describe "weekly event starting in march ending midway through april" do
    before(:each) do
      @event = Event.create! :start_at => DateTime.new(2009, 3, 29, 19, 30), :repeat_weekly => true, :end_at => DateTime.new(2009, 4, 19)
      @april = EventOccurance.for_month(DateTime.new(2009, 4))
    end

    it "should have three events in april" do
      @april.size.should == 3
    end

    it "should set the end times on the occurances" do
      @april.each do |e|
        e.end_at.wday.should == 0
        e.end_at.hour.should == @event.end_at.hour
        e.end_at.min.should == @event.end_at.min
      end
    end

  end
end
