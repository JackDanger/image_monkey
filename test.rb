ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'image_monkey'

class ImageMonkeyTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "on GET to /" do
    setup {
      get '/'
    }
    should "return 404" do
      assert_equal 404, last_response.status
    end
  end
end