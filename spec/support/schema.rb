ActiveRecord::Schema.define :version => 0 do
  create_table "test_models", :force => true do |t|
    t.string :image
    
    t.integer :image_width
    t.integer :image_height
    t.string  :image_content_type
    t.integer :image_file_size

    t.integer :image_version_width
    t.integer :image_version_height
    t.integer :image_version_file_size
    t.string  :image_version_content_type
  end
end
