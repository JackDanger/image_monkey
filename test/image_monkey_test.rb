require File.expand_path(File.dirname(__FILE__) + '/test_helper')


class ImageMonkeyTest < Test::Unit::TestCase

  context "instantiating an image" do
    context "with a valid source" do
      setup {
        @image_path = File.join(File.dirname(__FILE__), '/window.jpg')
        @image = ImageMonkey::Image.new(:size => '20x40',
                                        :path => @image_path)

      }
      should "not be #missing?" do
        assert !@image.missing?
      end
    end
  end

end