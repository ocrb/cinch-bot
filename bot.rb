require "cinch"
require "cinch/plugins/memo"
require "cinch/plugins/last_seen"
require "cinch/plugins/fortune"
require "net/http"
require "httparty"

class Meetup
  include Cinch::Plugin
  include HTTParty

  match "fetchtopic"

  def execute(m)
    m.reply "Setting topic..." 
    m.channel.topic = generated_topic
  end

  timer 1800, :method => :timed
  def timed
    Channel("#ocruby").topic = generated_topic
  end

  def next_meetup
    resp = self.class.get "https://api.meetup.com/2/events?key=347072721a3c723a747c2467147728&sign=true&group_urlname=ocruby&page=20"
    resp["results"].first
  end

  def generated_topic
    data = next_meetup
    time = (Time.at data['time'].to_i / 1000).strftime("%b %d, %Y %I:%M%p")
     "The next event, #{data['name']} @ #{time}. See #{data['event_url']} for more details." 
  end
end


Cinch::Plugins::Memo::Base.configure do |c|
  c.store   = :redis          # data store
  c.host    = 'localhost'     # your host
  c.port    = '6379'          # your port
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server           = "irc.freenode.net"
    c.nick             = "ocruby"
    c.channels         = ["#ocruby"]
    c.plugins.plugins  = [
      Cinch::Plugins::Memo::Base,
      Cinch::Plugins::LastSeen::Base,
      Cinch::Plugins::Fortune,
      ::Meetup
    ]
  end

end

bot.start
