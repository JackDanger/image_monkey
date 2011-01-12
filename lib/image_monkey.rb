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

    rescue Errno::ENOENT, OpenURI::HTTPError
      @missing = true
    end
  end

end

