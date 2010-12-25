require 'sinatra'
require 'open-uri'
require 'RMagick'

module ImageMonkey
  SOURCE_HOST = "http://secure.tanga.com/"

  class Image
    attr_reader :content_type

    def content_type
      @img.format
    end

    def to_s
      @img.to_blob
    end

    # Options: :width, :height, :path
    def initialize options={}
      file = open(SOURCE_HOST + options[:path])
      size = "#{options[:width]}x#{options[:height]}"

      @img = Magick::Image.from_blob(file.read).first
      @img.change_geometry(size) { |cols, rows, image| image.crop_resized!(cols, rows) }
    end
  end

end

get '/*/*/*' do
  width, height, path = params[:splat]
  image = ImageMonkey::Image.new(:width => width, :height => height, :path => path)
  expires 315360000, :public
  content_type image.content_type
  image.to_s
end
