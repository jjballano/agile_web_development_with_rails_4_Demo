require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
  	product = Product.new

  	assert product.invalid?
  	assert product.errors[:title].any?
  	assert product.errors[:description].any?
  	assert product.errors[:image_url].any?
  	assert product.errors[:price].any?
  end

  test "product price must be positive" do
  	product = new_product("any.jpg")
  	
  	product.price = -1

  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  	
  	product.price = 0

  	assert product.invalid?
  	assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

  	product.price = 1
  	assert product.valid?
  end

  test "image url is a image" do
  	ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://example.com/fred.jpg }
  	bad = %w{ fred.doc fred fred.gif/more fred.gif.more }
  	ok.each do |name|
  	  assert new_product(name).valid?, "#{name} should be valid"
  	end
  	bad.each do |name|
  	  assert new_product(name).invalid?, "#{name} should be invalid"
  	end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "any",
                          price: 1,
                          image_url: "file.jpg")

    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end

  def new_product(image_url) 
  	Product.new(title: "My book title", 
  		        description: "Any description",
  		        price: 1,
  		        image_url: image_url)
  end
end
