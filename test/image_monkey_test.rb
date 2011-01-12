require File.expand_path(File.dirname(__FILE__) + '/test_helper')


class ImageMonkeyTest < Test::Unit::TestCase

  context "instantiating an image" do
    context "with a valid source" do
      setup {
        @image_path = File.join(File.dirname(__FILE__), '/window.jpg')
        @image = ImageMonkey::Image.new(:size => '80x140',
                                        :path => @image_path)

      }
      should "not be #missing?" do
        assert !@image.missing?
      end
      should "detect content type" do
        assert_equal 'JPEG', @image.content_type
      end
    end
  end

  context "configuring" do
    setup {
      File.open(
        File.expand_path(
          File.join(File.dirname(__FILE__), '..', 'config.yml')
        ), 'w'
      ) {|f| f.write(<<-EOYAML) }
host: static.example.com
EOYAML
    }
    should "store host in configuration" do
      assert_equal 'static.example.com', ImageMonkey.config['host']
    end
  end

end