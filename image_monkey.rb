require 'sinatra'
require 'open-uri'
require 'RMagick'
require 'ftools'
require 'smusher'

module ImageMonkey
  SOURCE_HOST = "http://secure.tanga.com/"

  class Image
    def content_type
      @img.format
    end

    def thumbnail_path
      @_path ||= "tmp/#{rand(100000000)}"
    end

    # Options: :width, :height, :path
    def initialize options={}
      file = open(SOURCE_HOST + options[:path])
      size = "#{options[:width]}x#{options[:height]}"

      FileUtils.mkdir_p("tmp")
      @img = Magick::Image.from_blob(file.read).first
      @img.change_geometry(size) { |cols, rows, image| image.crop_resized!(cols, rows) }
      @img.write(thumbnail_path)
      Smusher.optimize_image(thumbnail_path)
    end
  end

end

get '/*/*/*' do
  width, height, path = params[:splat]
  image = ImageMonkey::Image.new(:width => width, :height => height, :path => path)
  expires      315360000, :public
  send_file    image.thumbnail_path, :type => image.content_type
end
