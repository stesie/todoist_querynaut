if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
else
  require 'coveralls'
  Coveralls.wear!
end

require "todoist_querynaut"

require "webmock/rspec"
WebMock.disable_net_connect!

def json_response_raw(fixture_name)
  File.read(File.join(__dir__, "lib/todoist_querynaut/fixtures/#{fixture_name}.json"))
end
