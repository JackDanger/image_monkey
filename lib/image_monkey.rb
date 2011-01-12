require 'open-uri'
require 'RMagick'
require 'smusher'

module ImageMonkey


  def self.config
    @config ||= configure
  end

  def self.configure
    require 'yaml'
    YAML.load_file(
      File.expand_path(
        File.join(File.dirname(__FILE__),'..', 'config.yml')
      )
    )
  end

  class Image
    def missing?
      @missing
    end

    def content_type
      @img.format
    end

    def thumbnail
      @_path ||= Tempfile.new('image_monkey')
    end

    def thumbnail_path
      thumbnail.path
    end

    # Options: :size :path
    def initialize options={}
      file = open('http://' + File.join(ImageMonkey.config['host'], options[:path]))

      @img = Magick::Image.from_blob(file.read).first
      @img.change_geometry(options[:size]) { |cols, rows, image| image.crop_resized!(cols, rows) }
      @img = @img.sharpen(0.5, 0.5)
      @img.write(thumbnail_path) { self.quality = 70 }
      Smusher.optimize_image(thumbnail_path)

    rescue Errno::ENOENT, OpenURI::HTTPError
      @missing = true
    end
  end

end

