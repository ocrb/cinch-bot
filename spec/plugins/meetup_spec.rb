require File.expand_path('../../spec_helper', __FILE__)
require File.expand_path('../../../plugins/meetup', __FILE__)

describe Cinch::Plugins::Meetup do
  let(:next_meetup){ { 'time' => '1817348000000', 'name' => 'NAME', 'event_url' => 'EVENT_URL' } }
  let(:channel) { stub }
  let(:bot) { stub(:Channel => channel) }
  let(:topic){ "Next event: NAME @ Aug 03, 2027 07:53PM. See EVENT_URL for more details." }

  subject { Cinch::Plugins::Meetup.new(bot) }

  before do
    Timecop.freeze
    Cinch::Plugins::Meetup.stubs(:__register_with_bot).returns(true)

    # Don't stub system under test in a serious work project ;)
    # Feel free to extract a meetup fetcher so as to fix this
    subject.stubs(:next_meetup).returns(next_meetup)
  end

  after do
    Timecop.return
  end

  describe "setting the topic" do
    it "occurs for a new topic" do
      channel.expects(:topic=).with(topic)
      subject.timed
    end

    it "only sets the topic once if the same topic was set recently" do
      channel.expects(:topic=)
      subject.timed
      subject.timed
    end

    it "sets a recently used topic if forced" do
      channel.expects(:topic=).with(topic).twice
      subject.set_topic(topic)
      subject.set_topic(topic, :force)
    end

    it "doesn't occur if the same topic was set last less than 3 hours ago" do
      channel.expects(:topic=).with(topic)
      subject.timed
      Timecop.travel(Time.now + 10799) # just short of 3 hours
      subject.timed
    end

    it "occurs if the same topic was set last more than 3 hours ago" do
      channel.expects(:topic=).with(topic).twice
      subject.timed
      Timecop.travel(Time.now + 10801) # 3 hours 1 second
      subject.timed
    end
  end

  it "can generate a topic based on next meetup" do
    subject.generated_topic.must_equal topic
  end
end
