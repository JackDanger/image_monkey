require 'sinatra'
require 'open-uri'
require 'RMagick'
require 'ftools'
require 'smusher'

module ImageMonkey
  SOURCE_HOST = "http://test.tanga.com/"

  class Image
    def missing?
      @missing
    end

    def content_type
      @img.format
    end

    def thumbnail_path
      @_path ||= Tempfile.new('image_monkey').path
    end

    # Options: :size :path
    def initialize options={}
      file = open(SOURCE_HOST + options[:path])

      @img = Magick::Image.from_blob(file.read).first
      @img.change_geometry(options[:size]) { |cols, rows, image| image.crop_resized!(cols, rows) }
      @img = @img.sharpen(0.5, 0.5)
      @img.write(thumbnail_path) { self.quality = 70 }
      Smusher.optimize_image(thumbnail_path)
    rescue Errno::ENOENT
      @missing = true
    end
  end

end

get '/:geometry/:path' do

  pass unless params[:geometry] =~ /^\d+x\d+[!%<>]$/

  image = ImageMonkey::Image.new(:size => params[:geometry],
                                 :path => params[:path])

  pass if image.missing?

  expires      315360000, :public
  send_file    image.thumbnail_path, :type => image.content_type
end
