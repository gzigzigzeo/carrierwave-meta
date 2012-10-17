require 'spec_helper'
require 'mime/types'

describe TestUploader do
  ORIGINAL_SIZE = [600, 277]
  ORIGINAL_FLASH_SIZE = [728, 90]
  VERSION_SIZE = [200, 200]

  let(:file) { File.open("spec/fixtures/big.jpg") }
  let(:corrupted_file) { File.open("spec/fixtures/corrupted.bmp") }
  let(:file_name) { File.basename(file.path) }
  let(:flash_file) { File.open("spec/fixtures/flash.swf") }
  let(:corrupted_flash_file) { File.open("spec/fixtures/corrupted_flash.swf") }
  let(:flash_file_name) { File.basename(flash_file.path) }
  let(:obj) { TestModel.new }

  def uploader_values_are_correct(uploader)
    uploader.width.should eq(ORIGINAL_SIZE[0])
    uploader.height.should eq(ORIGINAL_SIZE[1])
    uploader.image_size.should eq(ORIGINAL_SIZE)
    uploader.content_type.should eq(MIME::Types.type_for(file_name).first.to_s)
    uploader.file_size.should_not be_blank
    uploader.image_size_s.should eq(ORIGINAL_SIZE.join('x'))

    uploader.version.width.should eq(VERSION_SIZE[0])
    uploader.version.height.should eq(VERSION_SIZE[1])
    uploader.version.image_size.should eq(VERSION_SIZE)
    uploader.version.content_type.should eq(MIME::Types.type_for(file_name).first.to_s)
    uploader.version.file_size.should_not be_blank
    uploader.version.image_size_s.should eq(VERSION_SIZE.join('x'))
  end

  def obj_values_are_correct(obj)
    obj.image_width.should eq(ORIGINAL_SIZE[0])
    obj.image_height.should eq(ORIGINAL_SIZE[1])
    obj.image_image_size.should eq(ORIGINAL_SIZE)
    obj.image_content_type.should eq(MIME::Types.type_for(file_name).first.to_s)
    obj.image_file_size.should_not be_blank

    obj.image_version_width.should eq(VERSION_SIZE[0])
    obj.image_version_height.should eq(VERSION_SIZE[1])
    obj.image_version_image_size.should eq(VERSION_SIZE)
    obj.image_version_content_type.should eq(MIME::Types.type_for(file_name).first.to_s)
    obj.image_version_file_size.should_not be_blank
  end

  def uploader_values_are_correct_with_flash(uploader)
    uploader.width.should eq(ORIGINAL_FLASH_SIZE[0])
    uploader.height.should eq(ORIGINAL_FLASH_SIZE[1])
    uploader.image_size.should eq(ORIGINAL_FLASH_SIZE)
    uploader.content_type.should eq(MIME::Types.type_for(flash_file_name).first.to_s)
    uploader.file_size.should_not be_blank
    uploader.image_size_s.should eq(ORIGINAL_FLASH_SIZE.join('x'))

    uploader.version.width.should eq(ORIGINAL_FLASH_SIZE[0])
    uploader.version.height.should eq(ORIGINAL_FLASH_SIZE[1])
    uploader.version.image_size.should eq(ORIGINAL_FLASH_SIZE)
    uploader.version.content_type.should eq(MIME::Types.type_for(flash_file_name).first.to_s)
    uploader.version.file_size.should_not be_blank
    uploader.version.image_size_s.should eq(ORIGINAL_FLASH_SIZE.join('x'))
  end

  def obj_values_are_correct_with_flash(obj)
    obj.image_width.should eq(ORIGINAL_FLASH_SIZE[0])
    obj.image_height.should eq(ORIGINAL_FLASH_SIZE[1])
    obj.image_image_size.should eq(ORIGINAL_FLASH_SIZE)
    obj.image_content_type.should eq(MIME::Types.type_for(flash_file_name).first.to_s)
    obj.image_file_size.should_not be_blank

    obj.image_version_width.should eq(ORIGINAL_FLASH_SIZE[0])
    obj.image_version_height.should eq(ORIGINAL_FLASH_SIZE[1])
    obj.image_version_image_size.should eq(ORIGINAL_FLASH_SIZE)
    obj.image_version_content_type.should eq(MIME::Types.type_for(flash_file_name).first.to_s)
    obj.image_version_file_size.should_not be_blank
  end

  context "detached uploader" do
    it "stores metadata after cache!" do
      uploader = TestUploader.new
      uploader.cache!(file)
      uploader_values_are_correct(uploader)
    end

    it "stores metadata after store!" do
      uploader = TestUploader.new
      uploader.store!(file)
      uploader_values_are_correct(uploader)
    end

    it "has metadata after cache!/retrieve_from_cache!" do
      uploader = TestUploader.new
      uploader.cache!(file)
      cache_name = uploader.cache_name

      uploader = TestUploader.new
      uploader.retrieve_from_cache!(cache_name)
      uploader_values_are_correct(uploader)
    end

    it "has metadata after store!/retrieve_from_store!" do
      uploader = TestUploader.new
      uploader.store!(file)
      uploader_values_are_correct(uploader)

      uploader = TestUploader.new
      uploader.retrieve_from_store!(File.basename(file.path))
      uploader_values_are_correct(uploader)
    end
  end

  context "attached uploader" do
    it "stores metadata after cache!" do
      uploader = TestUploader.new(obj, :image)
      uploader.cache!(file)
      uploader_values_are_correct(uploader)
      obj_values_are_correct(obj)
    end

    it "stores metadata after store!" do
      uploader = TestUploader.new(obj, :image)
      uploader.store!(file)
      uploader_values_are_correct(uploader)
      obj_values_are_correct(obj)
    end

    it "has metadata after cache!/retrieve_from_cache!" do
      uploader = TestUploader.new(obj, :image)
      uploader.cache!(file)
      cache_name = uploader.cache_name

      uploader = TestUploader.new(obj, :image)
      uploader.retrieve_from_cache!(cache_name)
      uploader_values_are_correct(uploader)
    end

    it "has metadata after store!/retrieve_from_store!" do
      uploader = TestUploader.new(obj, :image)
      uploader.store!(file)
      uploader_values_are_correct(uploader)

      uploader = TestUploader.new(obj, :image)
      uploader.retrieve_from_store!(File.basename(file.path))
      uploader_values_are_correct(uploader)
    end
  end

  context "when file is corrupted/can not be processed" do
    it "passes without exceptions" do
      uploader = TestBlankUploader.new(obj, :image)
      proc { uploader.store!(corrupted_file) }.should_not raise_error
    end
  end

  context "flash / swf" do
    context "detached uploader" do
      it "stores metadata after cache!" do
        uploader = TestUploader.new
        uploader.cache!(flash_file)
        uploader_values_are_correct_with_flash(uploader)
      end

      it "stores metadata after store!" do
        uploader = TestUploader.new
        uploader.store!(flash_file)
        uploader_values_are_correct_with_flash(uploader)
      end

      it "has metadata after cache!/retrieve_from_cache!" do
        uploader = TestUploader.new
        uploader.cache!(flash_file)
        cache_name = uploader.cache_name

        uploader = TestUploader.new
        uploader.retrieve_from_cache!(cache_name)
        uploader_values_are_correct_with_flash(uploader)
      end

      it "has metadata after store!/retrieve_from_store!" do
        uploader = TestUploader.new
        uploader.store!(flash_file)
        uploader_values_are_correct_with_flash(uploader)

        uploader = TestUploader.new
        uploader.retrieve_from_store!(File.basename(flash_file.path))
        uploader_values_are_correct_with_flash(uploader)
      end
    end

    context "attached uploader" do
      it "stores metadata after cache!" do
        uploader = TestUploader.new(obj, :image)
        uploader.cache!(flash_file)
        uploader_values_are_correct_with_flash(uploader)
        obj_values_are_correct_with_flash(obj)
      end

      it "stores metadata after store!" do
        uploader = TestUploader.new(obj, :image)
        uploader.store!(flash_file)
        uploader_values_are_correct_with_flash(uploader)
        obj_values_are_correct_with_flash(obj)
      end

      it "has metadata after cache!/retrieve_from_cache!" do
        uploader = TestUploader.new(obj, :image)
        uploader.cache!(flash_file)
        cache_name = uploader.cache_name

        uploader = TestUploader.new(obj, :image)
        uploader.retrieve_from_cache!(cache_name)
        uploader_values_are_correct_with_flash(uploader)
      end

      it "has metadata after store!/retrieve_from_store!" do
        uploader = TestUploader.new(obj, :image)
        uploader.store!(flash_file)
        uploader_values_are_correct_with_flash(uploader)

        uploader = TestUploader.new(obj, :image)
        uploader.retrieve_from_store!(File.basename(flash_file.path))
        uploader_values_are_correct_with_flash(uploader)
      end
    end

    context "when flash file is corrupted/can not be processed" do
      it "passes without exceptions" do
        uploader = TestBlankUploader.new(obj, :image)
        proc { uploader.store!(corrupted_flash_file) }.should_not raise_error
      end
    end
  end
end