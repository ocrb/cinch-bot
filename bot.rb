require "cinch"
require "cinch/plugins/memo"

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
    c.plugins.plugins  = [Cinch::Plugins::Memo::Base]
  end

end

bot.start
