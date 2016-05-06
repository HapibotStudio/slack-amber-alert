$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-bot-server'

if ENV['RACK_ENV'] == 'development'
  puts 'Loading NewRelic in developer mode ...'
  require 'new_relic/rack/developer_mode'
  use NewRelic::Rack::DeveloperMode
end

NewRelic::Agent.manual_start

SlackBotServer::App.instance.prepare!

Thread.abort_on_exception = true

Thread.new do
  SlackBotServer::Service.instance.start_from_database!
end

run Api::Middleware.instance
