require 'sinatra'
require 'image_monkey'

get '/:geometry/:path' do

  pass unless params[:geometry] =~ /^\d+x\d+[!%<>]$/

  image = ImageMonkey::Image.new(:size => params[:geometry],
                                 :path => params[:path])

  pass if image.missing?

  expires      315360000, :public
  send_file    image.thumbnail_path, :type => image.content_type
end
