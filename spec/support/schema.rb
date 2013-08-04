ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define :version => 1 do

  create_table "test_composed_models", :force => true do |t|
    t.string :image
    t.text :image_meta
  end

end
