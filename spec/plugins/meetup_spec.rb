require 'httparty'
require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../plugins/meetup', __FILE__)

describe Meetup do
  before do
    Meetup.stubs(:__register_with_bot).with(any_parameters).returns(true)
  end

  it "should get generated topic based on next meetup" do
    meetup = Meetup.new(Object.new)
    next_meetup = { 'time' => '1817348000000', 'name' => 'NAME', 'event_url' => 'EVENT_URL'}
    meetup.stubs(:next_meetup).returns(next_meetup)  
    meetup.generated_topic.must_equal "Next event: NAME @ Aug 03, 2027 07:53PM. See EVENT_URL for more details." 
  end

end
