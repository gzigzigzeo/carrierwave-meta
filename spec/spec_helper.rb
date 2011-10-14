$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

begin
  require "bundler"
  Bundler.setup
  Bundler.require  
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

PROCESSOR = (ENV["PROCESSOR"] || :rmagick).to_sym

require 'mime/types'
require 'carrierwave'
require 'carrierwave-meta'
require 'support/test_delegate_uploader'
require 'support/test_uploader'
require 'support/test_model'

RSpec.configure do |config|
  config.before do
    FileUtils.rm_rf('tmp')
  end
end

$: << File.join(File.dirname(__FILE__), '..', 'lib')