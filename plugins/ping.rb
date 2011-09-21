module Cinch
  module Plugins
    class Ping
      include Cinch::Plugin

      match %r{ping (.+)$}, :method => :show_ping

      def show_ping(m, url)
        ping(url).each { |r| m.reply r }
      end

      # Executes ping command and return the last 3 lines of output,the results.
      # `ping -c 5 google.com`
      #
      # @param [String] url
      #   The url to ping
      #
      # @api private
      def ping(url)
        result = `ping -c 5 #{url}`.split("\n")
        result[result.size-3..result.size]
      end

    end
  end
end
