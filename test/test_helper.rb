# coding: UTF-8
ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'shoulda'
require 'rack/test'
require 'image_monkey'


# Modify the ImageMonkey::Image class to overwrite the Kernel#open method
module ImageMonkey
  class Image
    def open path
      path = path.gsub(/^https?:\/\/.*\//, '')
      File.open(
        File.expand_path(File.join(File.dirname(__FILE__), path))
      )
    end
  end
end

