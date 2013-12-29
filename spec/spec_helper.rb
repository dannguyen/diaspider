$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'diaspider'
include Diaspider

require 'pry'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.filter_run_excluding skip: true 
  config.run_all_when_everything_filtered = true
  config.filter_run :focus => true
  config.mock_with :rspec
  config.order = "random"
  config.color_enabled = true
  config.formatter = :documentation
end
