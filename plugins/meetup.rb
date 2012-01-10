require 'httparty'

module Cinch
  module Plugins
    class Meetup
      include Cinch::Plugin
      include HTTParty

      match "fetchtopic"

      def execute(m)
        m.reply "Setting topic..."
        set_topic generated_topic, :force
      end

      timer 900, :method => :timed
      def timed
        set_topic
      end

      def set_topic(topic = generated_topic, force = false)
        if force || topic_needs_resetting?(topic)
          Channel("#ocruby").topic = topic
          @last_set_at = Time.now
          @previous_topic = topic
        end
      end

      def generated_topic
        data = next_meetup
        time = (Time.at data['time'].to_i / 1000).strftime("%b %d, %Y %I:%M%p")
        "Next event: #{data['name']} @ #{time}. See #{data['event_url']} for more details."
      end

      private

      def next_meetup
        resp = self.class.get "https://api.meetup.com/2/events?key=347072721a3c723a747c2467147728&sign=true&group_urlname=ocruby"
        resp["results"].first
      end

      def topic_needs_resetting?(topic)
        @previous_topic != topic || Time.now.to_i - @last_set_at.to_i > 10800
      end
    end
  end
end
