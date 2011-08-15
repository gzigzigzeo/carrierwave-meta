require 'spec_helper'

describe TestDelegateUploader do
  let(:values) { subject.class::VALUES }
  let(:default_values) { subject.class::DEFAULT_VALUES }  
  let(:file) { File.open("spec/fixtures/big.jpg") }
  let(:obj) { TestModel.new }
  
  before do
    obj.destroyed = false
  end

  def uploader_values_are_correct(uploader)
    uploader.x.should eq(values[:x])
    uploader.dimensions.should eq(values[:dimensions])    
    uploader.version.x.should eq(values[:version_x])
    uploader.version.dimensions.should eq(values[:version_dimensions])    
  end

  def obj_values_are_correct(obj)
    obj.image_x.should eq(values[:x])
    obj.image_dimensions.should eq(values[:dimensions])    
    obj.image_version_x.should eq(values[:version_x])
    obj.image_version_dimensions.should eq(values[:version_dimensions])      
  end

  def uploader_values_are_default(obj)
    obj.x.should eq(default_values[:x])
    obj.dimensions.should eq(default_values[:dimensions])    
    obj.version.x.should eq(default_values[:x])
    obj.version.dimensions.should eq(default_values[:dimensions])      
  end
  
  it "model receives values after process done" do
    uploader = TestDelegateUploader.new(obj, :image)
    uploader.cache!(file)

    uploader_values_are_correct(uploader)
    obj_values_are_correct(obj)
  end
  
  it "resets values to default after file is removed" do
    uploader = TestDelegateUploader.new(obj, :image)
    uploader.store!(file)

    uploader_values_are_correct(uploader)

    # CarrierWave's file is removed in after_destroy callback. Model attributes are freezed after destroy. 
    # Let mock this case.
    obj.image_x.freeze
    obj.destroyed = true
    uploader.remove!

    uploader_values_are_default(uploader)
    obj_values_are_correct(obj)
  end
  
  it "tries to receive value from a model when file was not processed at this time" do
    uploader = TestDelegateUploader.new(obj, :image)
    uploader.store!(file)

    uploader_values_are_correct(uploader)

    uploader = TestDelegateUploader.new(obj, :image)
    uploader.retrieve_from_store!(File.basename(file.path))

    obj_values_are_correct(obj)
  end
end