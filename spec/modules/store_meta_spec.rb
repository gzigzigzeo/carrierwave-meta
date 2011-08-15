require 'spec_helper'

describe TestUploader do
  ORIGINAL_SIZE = [600, 277]
  VERSION_SIZE = [200, 200]

  let(:file) { File.open("spec/fixtures/big.jpg") }  
  let(:obj) { TestModel.new }  

  def uploader_values_are_correct(uploader)
    uploader.width.should eq(ORIGINAL_SIZE[0])
    uploader.height.should eq(ORIGINAL_SIZE[1])
    uploader.dimensions.should eq(ORIGINAL_SIZE)
    uploader.content_type.should eq(Mime::Type.for(file))
    uploader.file_size.should eq(file.size)

    uploader.version.width.should eq(VERSION_SIZE[0])
    uploader.version.height.should eq(VERSION_SIZE[1])

  end

  def uploader_values_are_correct(obj)
    obj.width.should eq(ORIGINAL_SIZE[0])
    obj.height.should eq(ORIGINAL_SIZE[1])
  end

  context "detached uploader" do
    it "stores metadata after cache!" do
      uploader = TestUploader.new
#      uploader.cache!(file)
#      uploader_values_are_correct(uploader)
    end
  
    it "stores metadata after store!" do
      uploader = TestUploader.new
#      uploader.store!(file)
#      uploader_values_are_correct(uploader)
    end
  
    it "has metadata after cache!/retrieve_from_cache!" do
      uploader = TestUploader.new
      uploader.cache!(file)
      cache_name = uploader.cache_name
      puts uploader.image_size.inspect
      puts uploader.width
puts '---'      
      uploader = TestUploader.new
      uploader.retrieve_from_cache!(cache_name)
puts '---'
      uploader_values_are_correct(uploader)
    end
    
    it "has metadata after store!/retrieve_from_store!" do
      uploader = TestUploader.new
#      uploader.store!(file)
#      uploader_values_are_correct(uploader)      
#        uploader.retrieve_from_store!(File.basename(file.path))
    end    
  end
end