require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../plugins/ping', __FILE__)

describe Cinch::Plugins::Ping do
  before do
    Cinch::Plugins::Ping.stubs(:__register_with_bot).with(any_parameters).returns(true)
    Cinch::Plugins::Ping.any_instance.expects(:`).with('ping -c 5 google.com').returns("google.com statistics\n5 packets\n stuff")
    @ping = Cinch::Plugins::Ping.new(Object.new)
  end

  it "should have a ping method which pings for 5 counts" do
    result = @ping.ping('google.com')
    result.size.must_equal 3
    result.first.must_match /google\.com/
    result[1].must_match /5 packets/
  end

end
