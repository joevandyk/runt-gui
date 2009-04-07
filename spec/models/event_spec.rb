require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  it "should let you set a event that repeats weekly" do
    event = Event.create! :start_at => DateTime.new(2009, 3, 29, 19, 30), :repeat_weekly => true

    april = nil
    assert_difference "EventOccurance.count", 4 do 
      april = EventOccurance.for_month(DateTime.new(2009, 4))
    end

    april.size.should == 4

    april.each do |e|
      e.start_at.wday.should == 0
      e.start_at.hour.should == event.start_at.hour
      e.start_at.min.should == event.start_at.min
      e.event.should == event
    end

    # Same set of event occurences should be returned on repeated calls
    assert_difference "EventOccurance.count", 0 do 
      april.should == EventOccurance.for_month(DateTime.new(2009, 4))
    end

    # Go one year in future
    assert_difference "EventOccurance.count", 4 do 
      EventOccurance.for_month(DateTime.new(2010, 4))
    end
  end

end
