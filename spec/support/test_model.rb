class TestModel
  attr_accessor :image_x
  attr_accessor :image_version_x
  attr_accessor :image_dimensions
  attr_accessor :image_version_dimensions  

  attr_accessor :image_width  
  attr_accessor :image_height
  attr_accessor :image_image_size  
  attr_accessor :image_content_type
  attr_accessor :image_file_size

  attr_accessor :image_version_width  
  attr_accessor :image_version_height
  attr_accessor :image_version_image_size
  attr_accessor :image_version_content_type
  attr_accessor :image_version_file_size
  
  attr_accessor :destroyed

  def destroyed?
    destroyed
  end
end