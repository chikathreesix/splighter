#!/usr/bin/ruby
require 'RMagick'
require 'json'
include Magick

dir_name = ARGV[0]
css_dir = ARGV[1] || 'css/'
img_dir = ARGV[2] || 'img/'

dir_name += '/' unless dir_name =~ /\/$/
css_dir += '/' unless css_dir =~ /\/$/
img_dir += '/' unless img_dir =~ /\/$/

image_names = []
image_info = {}
y_pos = 0
css_string = ''

Dir.open(dir_name).each do |f|
  if f =~ /\.png/
    name = dir_name + f
    image = ImageList.new(name)

    css_string += <<-EOS
.sprite-#{f.gsub('_', '-').gsub('.png', '')}{
  display: inline-block;
  background-image: url('/#{img_dir}sprite.png');
  width: #{image.columns}px;
  height: #{image.rows}px;
  background-position: 0 #{-y_pos}px;
}
    EOS

    y_pos += image.rows
    image_names << name
  end
end

sprite_list = ImageList.new(*image_names) do |image|
  image.background_color = "Transparent"
end
sprite_image = sprite_list.append(true)
sprite_image.write("#{img_dir}sprite.png")

File.write("#{css_dir}sprite.css", css_string)
