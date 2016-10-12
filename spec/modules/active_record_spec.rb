require 'spec_helper'

describe CarrierWave::Meta::ActiveRecord do
  let(:model) { TestComposedModel.new }
  let(:model_with_image) do
    model.tap do |m|
      m.image = File.open('spec/fixtures/big.jpg')
      m.save!
    end
  end

  it "model's virtual meta attributes must exists" do
    subject::ALLOWED.each do |name|
      model.should respond_to(:"image_#{name}")
    end
  end

  it "must assign model's virtual attributes and save meta column" do
    subject::ALLOWED.each do |name|
      model_with_image.send(:"image_#{name}").should_not be_blank
    end

    model_with_image.image_version_width.should_not be_blank
    model_with_image.image_version_height.should_not be_blank

    model_with_image.reload

    model_with_image.image_version_width.should_not be_blank
    model_with_image.image_version_height.should_not be_blank
  end
end