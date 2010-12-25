require 'sinatra'
require 'open-uri'
require 'RMagick'

module ImageMonkey
  SOURCE_HOST = "http://secure.tanga.com/"

  def self.fetch_source path
    file = open(SOURCE_HOST + path)
  end

  def self.resize width, height, file
    size = "#{width}x#{height}"
    img = Magick::Image.from_blob(file.read).first
    img.change_geometry(size) { |cols, rows, image| image.crop_resized!(cols, rows) }
    img.to_blob
  end
end


get '/' do
  'Hello world!'
end

get '/*/*/*' do
  width, height, source = params[:splat]
  file = ImageMonkey.fetch_source(source)
  resized_thumbnail = ImageMonkey.resize width, height, file
  content_type :jpg
  expires 315360000, :public
  resized_thumbnail
end
