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
puts "Using #{PROCESSOR} processor"

require 'carrierwave-imagesorcery'
require 'mime/types'
require 'carrierwave'
require 'carrierwave-meta'
require 'support/current_processor'
require 'support/test_delegate_uploader'
require 'support/test_blank_uploader'
require 'support/test_uploader'
require 'support/test_model'
require 'zlib'
require 'image_size'

RSpec.configure do |config|
  config.before do
    FileUtils.rm_rf('tmp')
  end
end

$: << File.join(File.dirname(__FILE__), '..', 'lib')