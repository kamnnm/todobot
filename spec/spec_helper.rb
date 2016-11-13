ENV['BOT_ENV'] = 'test'

require 'todobot'
require 'todobot/app_configurator'
require 'telegram/bot'
require 'support/factory_girl'
require 'support/shoulda_matchers'
require 'webmock/rspec'
require 'database_cleaner'
require 'pry'

WebMock.disable_net_connect!

TodoBot::AppConfigurator.configure

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
