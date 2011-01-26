$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'pamfaxr'
require 'rspec'
require 'rspec/autorun'
require 'fakeweb'
require 'json'

RSpec.configure do |config|
  
end
