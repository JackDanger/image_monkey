require 'sinatra'
require 'open-uri'
require 'RMagick'
require 'ftools'
require 'smusher'

module ImageMonkey
  SOURCE_HOST = "http://test.tanga.com/"

  class Image
    def content_type
      @img.format
    end

    def thumbnail_path
      @_path ||= "tmp/#{rand(100000000)}"
    end

    # Options: :size :path
    def initialize options={}
      file = open(SOURCE_HOST + options[:path])

      FileUtils.mkdir_p("tmp")
      @img = Magick::Image.from_blob(file.read).first
      @img.change_geometry(options[:size]) { |cols, rows, image| image.crop_resized!(cols, rows) }
      @img = @img.sharpen(0.5, 0.5)
      @img.write(thumbnail_path) { self.quality = 70 }
      Smusher.optimize_image(thumbnail_path)
    end
  end

end

get '/*/*' do
  size, path = params[:splat]
  image = ImageMonkey::Image.new(:size => size,:path => path)
  expires      315360000, :public
  send_file    image.thumbnail_path, :type => image.content_type
end
