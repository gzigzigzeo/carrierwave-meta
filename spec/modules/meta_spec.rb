require 'spec_helper'
require 'mime/types'

describe TestUploader do
  let(:obj) { TestModel.new }

  IMAGE_FILE_NAME = "spec/fixtures/big.jpg"
  FLASH_FILE_NAME = "spec/fixtures/flash.swf"
  EPS_FILE_NAME = "spec/fixtures/sample.eps"
  PDF_FILE_NAME = "spec/fixtures/sample.pdf"

  FORMATS = {
    image: {
      original_size: [600, 277],
      version_size: [200, 200],
      file: File.open(IMAGE_FILE_NAME),
      file_name: File.basename(IMAGE_FILE_NAME),
      corrupted_file: File.open("spec/fixtures/corrupted.bmp"),
      mime_type: MIME::Types.type_for(IMAGE_FILE_NAME).first.to_s
    },
    eps: {
      original_size: [464, 205],
      version_size: [200, 200],
      file: File.open(EPS_FILE_NAME),
      corrupted_file: File.open("spec/fixtures/corrupted.eps"),
      file_name: File.basename(EPS_FILE_NAME),
      mime_type: MIME::Types.type_for(EPS_FILE_NAME).first.to_s
    },
    flash: {
      original_size: [728, 90],
      version_size: [200, 200],
      file: File.open(FLASH_FILE_NAME),
      file_name: File.basename(FLASH_FILE_NAME),
      corrupted_file: File.open("spec/fixtures/corrupted_flash.swf"),
      mime_type: MIME::Types.type_for(FLASH_FILE_NAME).first.to_s
    },
    pdf: {
      original_size: [360, 360],
      version_size: [200, 200],
      file: File.open(PDF_FILE_NAME),
      corrupted_file: File.open("spec/fixtures/corrupted.pdf"),
      file_name: File.basename(PDF_FILE_NAME),
      mime_type: MIME::Types.type_for(PDF_FILE_NAME).first.to_s
    }
  }

  def obj_values_eq(obj, size_arg, args, prefix = nil)
    size = args[size_arg]

    obj.send(obj_value_name(:width, prefix)).should eq(size.first)
    obj.send(obj_value_name(:height, prefix)).should eq(size.last)
    obj.send(obj_value_name(:image_size, prefix)).should eq(size)
    obj.send(obj_value_name(:content_type, prefix)).should eq(args[:mime_type])
    obj.send(obj_value_name(:file_size, prefix)).should_not be_blank

    if obj.is_a?(CarrierWave::Uploader::Base)
      obj.send(obj_value_name(:image_size_s, prefix)).should eq(size.join('x'))
    end
  end

  def obj_value_name(name, prefix)
    [prefix, name].compact.join('_')
  end

  def uploader_values_eq(uploader, args)
    obj_values_eq(uploader, :original_size, args)
    obj_values_eq(uploader.version, :version_size, args)
    uploader.md5sum.should_not be_blank
    uploader.version.md5sum.should be_blank
  end

  def model_values_eq(model, args)
    obj_values_eq(model, :original_size, args, 'image')
    obj_values_eq(model, :version_size, args, 'image_version')
    model.image_md5sum.should_not be_blank
  end

  FORMATS.each do |format, args|
    next if not(CarrierWave::Meta.ghostscript_enabled) and [:pdf, :eps].include?(format)
    context "detached uploader for #{format}" do
      it "stores metadata after cache!" do
        uploader = TestUploader.new
        uploader.cache!(args[:file])
        uploader_values_eq(uploader, args)
      end

      it "stores metadata after store!" do
        uploader = TestUploader.new
        uploader.store!(args[:file])
        uploader_values_eq(uploader, args)
      end

      it "has metadata after cache!/retrieve_from_cache!" do
        uploader = TestUploader.new
        uploader.cache!(args[:file])
        cache_name = uploader.cache_name
        uploader = TestUploader.new
        uploader.retrieve_from_cache!(cache_name)

        uploader_values_eq(uploader, args)
      end

      it "has metadata after store!/retrieve_from_store!" do
        uploader = TestUploader.new
        uploader.store!(args[:file])
        uploader_values_eq(uploader, args)

        uploader = TestUploader.new
        uploader.retrieve_from_store!(args[:file_name])
        uploader_values_eq(uploader, args)
      end
    end

    context "attached uploader for #{format}" do
      it "stores metadata after cache!" do
        uploader = TestUploader.new(obj, :image)
        uploader.cache!(args[:file])
        uploader_values_eq(uploader, args)
        model_values_eq(obj, args)
      end

      it "stores metadata after store!" do
        uploader = TestUploader.new(obj, :image)
        uploader.store!(args[:file])
        uploader_values_eq(uploader, args)
        model_values_eq(obj, args)
      end

      it "has metadata after cache!/retrieve_from_cache!" do
        uploader = TestUploader.new(obj, :image)
        uploader.cache!(args[:file])
        cache_name = uploader.cache_name

        uploader = TestUploader.new(obj, :image)
        uploader.retrieve_from_cache!(cache_name)
        uploader_values_eq(uploader, args)
        model_values_eq(obj, args)
      end

      it "has metadata after store!/retrieve_from_store!" do
        uploader = TestUploader.new(obj, :image)
        uploader.store!(args[:file])
        uploader_values_eq(uploader, args)
        model_values_eq(obj, args)

        uploader = TestUploader.new(obj, :image)
        uploader.retrieve_from_store!(args[:file_name])
        uploader_values_eq(uploader, args)
        model_values_eq(obj, args)
      end
    end

    context "when file is corrupted/can not be processed" do
      it "passes without exceptions" do
        uploader = TestBlankUploader.new(obj, :image)
        proc { uploader.store!(args[:corrupted_file]) }.should_not raise_error
      end
    end
  end
end
