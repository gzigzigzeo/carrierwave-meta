$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

require 'rubygems'
require 'bundler/setup'
require 'simplecov'
require 'mime/types'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'support/remote'
require 'support/current_processor'
require 'active_record'
require 'support/schema'

SimpleCov.start

require 'carrierwave-meta'

PROCESSOR = (ENV["PROCESSOR"] || :rmagick).to_sym
puts "Using #{PROCESSOR} processor"

PDF_EPS = ENV['PDF_EPS']
unless PDF_EPS == 'false' or [:vips, :image_sorcery].include?(PROCESSOR)
  CarrierWave::Meta.ghostscript_enabled = true
end

require 'support/test_delegate_uploader'
require 'support/test_blank_uploader'
require 'support/test_uploader'
require 'support/test_model'
require 'support/test_composed_model'
require 'fog'

RSpec.configure do |config|
  config.before do
    FileUtils.rm_rf('tmp')
  end
end

$: << File.join(File.dirname(__FILE__), '..', 'lib')