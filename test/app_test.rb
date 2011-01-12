require File.expand_path(File.dirname(__FILE__) + '/test_helper')

require 'app'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "on GET to /" do
    context "with no parameters" do
      setup {
        get '/'
      }
      should "return 404" do
        assert_equal 404, last_response.status
      end
    end
    context "with url of valid image" do
      setup {
        @image = "/window.jpg"
        @image_path = File.join(File.dirname(__FILE__), @image)
      }
      context "with imagemagick-qualified resize" do
        setup {
          @resize = '200x300!'
          get "/#{@resize}#{@image}"
        }
        should "return ok" do
          assert last_response.ok?
        end
        should "cache for a long time" do
          assert last_response.headers['Cache-Control'].split('=').last.to_i > 10000
        end
        should "return content type of image" do
          assert last_response.headers['Content-Type'] =~ /^image\/jpeg/
        end
        should "return properly resized image" do
          monkey = ImageMonkey::Image.new(
                        :size => @resize,
                        :path => @image_path
                      )
          # Ruby 1.9 misreads the filesize of the original file, hence the "<="
          assert File.read(monkey.thumbnail_path).size <= last_response.body.size
        end
      end
      context "with bogus resize string" do
        setup {
          @resize = 'what-am-i-doing'
          get "/#{@resize}#{@image}"
        }
        should "return 404" do
          assert_equal 404, last_response.status
        end
      end
    end
    context "with url of missing image" do
      setup {
        @image = "/missing.png"
      }
      context "with imagemagick-qualified resize" do
        setup {
          @resize = '200x300!'
          get "/#{@resize}#{@image}"
        }
        should "return 404" do
          assert_equal 404, last_response.status
        end
      end
    end
  end
end