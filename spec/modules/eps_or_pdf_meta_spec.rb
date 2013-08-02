require 'spec_helper'
require 'mime/types'

describe TestUploader do
  ORIGINAL_EPS_SIZE = [464, 205]
  ORIGINAL_PDF_SIZE = [360, 360]
  VERSION_SIZE = [200, 200]

  let(:eps_file) { File.open("spec/fixtures/sample.eps") }
  let(:eps_corrupted_file) { File.open("spec/fixtures/corrupted.eps") }
  let(:eps_file_name) { File.basename(eps_file.path) }

  let(:pdf_file) { File.open("spec/fixtures/sample.pdf") }
  let(:pdf_corrupted_file) { File.open("spec/fixtures/corrupted.pdf") }
  let(:pdf_file_name) { File.basename(pdf_file.path) }

  let(:obj) { TestModel.new }

  def uploader_values_are_correct_with_eps(uploader)
    uploader.width.should eq(ORIGINAL_EPS_SIZE[0])
    uploader.height.should eq(ORIGINAL_EPS_SIZE[1])
    uploader.image_size.should eq(ORIGINAL_EPS_SIZE)
    uploader.content_type.should eq(MIME::Types.type_for(eps_file_name).first.to_s)
    uploader.file_size.should_not be_blank
    uploader.image_size_s.should eq(ORIGINAL_EPS_SIZE.join('x'))

    uploader.version.width.should eq(VERSION_SIZE[0])
    uploader.version.height.should eq(VERSION_SIZE[1])
    uploader.version.image_size.should eq(VERSION_SIZE)
    uploader.version.content_type.should eq(MIME::Types.type_for(eps_file_name).first.to_s)
    uploader.version.file_size.should_not be_blank
    uploader.version.image_size_s.should eq(VERSION_SIZE.join('x'))
  end

  def obj_values_are_correct_with_eps(obj)
    obj.image_width.should eq(ORIGINAL_EPS_SIZE[0])
    obj.image_height.should eq(ORIGINAL_EPS_SIZE[1])
    obj.image_image_size.should eq(ORIGINAL_EPS_SIZE)
    obj.image_content_type.should eq(MIME::Types.type_for(eps_file_name).first.to_s)
    obj.image_file_size.should_not be_blank

    obj.image_version_width.should eq(VERSION_SIZE[0])
    obj.image_version_height.should eq(VERSION_SIZE[1])
    obj.image_version_image_size.should eq(VERSION_SIZE)
    obj.image_version_content_type.should eq(MIME::Types.type_for(eps_file_name).first.to_s)
    obj.image_version_file_size.should_not be_blank
  end

    def uploader_values_are_correct_with_pdf(uploader)
    uploader.width.should eq(ORIGINAL_PDF_SIZE[0])
    uploader.height.should eq(ORIGINAL_PDF_SIZE[1])
    uploader.image_size.should eq(ORIGINAL_PDF_SIZE)
    uploader.content_type.should eq(MIME::Types.type_for(pdf_file_name).first.to_s)
    uploader.file_size.should_not be_blank
    uploader.image_size_s.should eq(ORIGINAL_PDF_SIZE.join('x'))

    uploader.version.width.should eq(VERSION_SIZE[0])
    uploader.version.height.should eq(VERSION_SIZE[1])
    uploader.version.image_size.should eq(VERSION_SIZE)
    uploader.version.content_type.should eq(MIME::Types.type_for(pdf_file_name).first.to_s)
    uploader.version.file_size.should_not be_blank
    uploader.version.image_size_s.should eq(VERSION_SIZE.join('x'))
  end

  def obj_values_are_correct_with_pdf(obj)
    obj.image_width.should eq(ORIGINAL_PDF_SIZE[0])
    obj.image_height.should eq(ORIGINAL_PDF_SIZE[1])
    obj.image_image_size.should eq(ORIGINAL_PDF_SIZE)
    obj.image_content_type.should eq(MIME::Types.type_for(pdf_file_name).first.to_s)
    obj.image_file_size.should_not be_blank

    obj.image_version_width.should eq(VERSION_SIZE[0])
    obj.image_version_height.should eq(VERSION_SIZE[1])
    obj.image_version_image_size.should eq(VERSION_SIZE)
    obj.image_version_content_type.should eq(MIME::Types.type_for(pdf_file_name).first.to_s)
    obj.image_version_file_size.should_not be_blank
  end

  context "detached uploader" do
    it "stores metadata after cache! for eps" do
      uploader = TestUploader.new
      uploader.cache!(eps_file)
      uploader_values_are_correct_with_eps(uploader)
    end

    it "stores metadata after cache! for pdf" do
      uploader = TestUploader.new
      uploader.cache!(pdf_file)
      uploader_values_are_correct_with_pdf(uploader)
    end

    it "stores metadata after store! for eps" do
      uploader = TestUploader.new
      uploader.store!(eps_file)
      uploader_values_are_correct_with_eps(uploader)
    end

    it "stores metadata after store! for pdf" do
      uploader = TestUploader.new
      uploader.store!(pdf_file)
      uploader_values_are_correct_with_pdf(uploader)
    end

    it "has metadata after cache!/retrieve_from_cache! for eps" do
      uploader = TestUploader.new
      uploader.cache!(eps_file)
      cache_name = uploader.cache_name

      uploader = TestUploader.new
      uploader.retrieve_from_cache!(cache_name)
      uploader_values_are_correct_with_eps(uploader)
    end

    it "has metadata after cache!/retrieve_from_cache! for pdf" do
      uploader = TestUploader.new
      uploader.cache!(pdf_file)
      cache_name = uploader.cache_name

      uploader = TestUploader.new
      uploader.retrieve_from_cache!(cache_name)
      uploader_values_are_correct_with_pdf(uploader)
    end    

    it "has metadata after store!/retrieve_from_store! for eps" do
      uploader = TestUploader.new
      uploader.store!(eps_file)
      uploader_values_are_correct_with_eps(uploader)

      uploader = TestUploader.new
      uploader.retrieve_from_store!(File.basename(eps_file.path))
      uploader_values_are_correct_with_eps(uploader)
    end

    it "has metadata after store!/retrieve_from_store! for pdf" do
      uploader = TestUploader.new
      uploader.store!(pdf_file)
      uploader_values_are_correct_with_pdf(uploader)

      uploader = TestUploader.new
      uploader.retrieve_from_store!(File.basename(pdf_file.path))
      uploader_values_are_correct_with_pdf(uploader)
    end    
  end

  context "attached uploader" do
    it "stores metadata after cache! for eps" do
      uploader = TestUploader.new(obj, :image)
      uploader.cache!(eps_file)
      uploader_values_are_correct_with_eps(uploader)
      obj_values_are_correct_with_eps(obj)
    end

    it "stores metadata after cache! for pdf" do
      uploader = TestUploader.new(obj, :image)
      uploader.cache!(pdf_file)
      uploader_values_are_correct_with_pdf(uploader)
      obj_values_are_correct_with_pdf(obj)
    end    

    it "stores metadata after store! for eps" do
      uploader = TestUploader.new(obj, :image)
      uploader.store!(eps_file)
      uploader_values_are_correct_with_eps(uploader)
      obj_values_are_correct_with_eps(obj)
    end

    it "stores metadata after store! for pdf" do
      uploader = TestUploader.new(obj, :image)
      uploader.store!(pdf_file)
      uploader_values_are_correct_with_pdf(uploader)
      obj_values_are_correct_with_pdf(obj)
    end    

    it "has metadata after cache!/retrieve_from_cache! for eps" do
      uploader = TestUploader.new(obj, :image)
      uploader.cache!(eps_file)
      cache_name = uploader.cache_name

      uploader = TestUploader.new(obj, :image)
      uploader.retrieve_from_cache!(cache_name)
      uploader_values_are_correct_with_eps(uploader)
    end

    it "has metadata after cache!/retrieve_from_cache! for pdf" do
      uploader = TestUploader.new(obj, :image)
      uploader.cache!(pdf_file)
      cache_name = uploader.cache_name

      uploader = TestUploader.new(obj, :image)
      uploader.retrieve_from_cache!(cache_name)
      uploader_values_are_correct_with_pdf(uploader)
    end    

    it "has metadata after store!/retrieve_from_store! for eps" do
      uploader = TestUploader.new(obj, :image)
      uploader.store!(eps_file)
      uploader_values_are_correct_with_eps(uploader)

      uploader = TestUploader.new(obj, :image)
      uploader.retrieve_from_store!(File.basename(eps_file.path))
      uploader_values_are_correct_with_eps(uploader)
    end

    it "has metadata after store!/retrieve_from_store! for pdf" do
      uploader = TestUploader.new(obj, :image)
      uploader.store!(pdf_file)
      uploader_values_are_correct_with_pdf(uploader)

      uploader = TestUploader.new(obj, :image)
      uploader.retrieve_from_store!(File.basename(pdf_file.path))
      uploader_values_are_correct_with_pdf(uploader)
    end    
  end

  context "when eps_file is corrupted/can not be processed" do
    it "passes without exceptions for eps" do
      uploader = TestBlankUploader.new(obj, :image)
      proc { uploader.store!(eps_corrupted_file) }.should_not raise_error
    end

     it "passes without exceptions for pdf" do
      uploader = TestBlankUploader.new(obj, :image)
      proc { uploader.store!(pdf_corrupted_file) }.should_not raise_error
    end   
  end
end