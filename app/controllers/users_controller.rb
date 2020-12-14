require 'mini_magick'

class UsersController < ApplicationController
  before_action :authenticate_user!

  def image
    if image = params[:image]
      img = MiniMagick::Image.read(params[:image])

      img.combine_options do |i|
        i.resize("40x40^")
        i.gravity("center")
        i.crop("40x40+0+0")
      end

      current_user.image.attach(io: File.open(img.path), filename: current_user.id, content_type: img.mime_type)
    end

    redirect_to controller: 'posts', action: 'index'
  end
end
