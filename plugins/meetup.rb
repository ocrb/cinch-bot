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
    resp = self.class.get "https://api.meetup.com/2/events?key=347072721a3c723a747c2467147728&sign=true&group_urlname=ocruby"
    resp["results"].first
  end

  def generated_topic
    data = next_meetup
    time = (Time.at data['time'].to_i / 1000).strftime("%b %d, %Y %I:%M%p")
    "Next event: #{data['name']} @ #{time}. See #{data['event_url']} for more details."
  end
end
