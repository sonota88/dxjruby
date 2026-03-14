case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
when "ruby"
  require "dxruby"
  require_relative "dxruby_helper"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

Window.bgcolor = [200, 200, 200]

RESOURCE_DIR =
  case RUBY_ENGINE
  when "opal"  then "."
  when "jruby" then __dir__
  when "ruby"  then __dir__
  else
    raise "unsupported engine (#{RUBY_ENGINE})"
  end

Image.register(:img1, File.join(RESOURCE_DIR, "img_ruby.png"))

img_draw1 = Image.new(20, 20, C_BLUE)
img_draw2 = Image.new(10, 10, C_MAGENTA)
img_draw1.draw(2, 4, img_draw2)

Window.load_resources do
  img1 = Image[:img1]
  p [img1.width, img1.height]

  img2 = Image.new(10, 20, C_BLUE)
  p [img2.width, img2.height]
  img2.line(0, 0, 10, 20, C_WHITE)
  (5...10).each { |x| img2[x, 1] = [255, 255, 255] }
  (5...10).each { |x| img2[x, 3] = [100, 255, 255, 255] }
  img2[1, 5] = [11, 12, 13, 14]
  p ["get pixel", img2[1, 5]]

  # Image[:img1]._resize(8, 16)
  # Image[:img1].circle_fill(0, 0, 12, [255,0,0])

  Window.loop do
    Window.draw(10, 20, Image[:img1])
    Window.draw(Input.mouse_x - 16, Input.mouse_y - 16, img2)
    Window.draw(10, 50, img_draw1)
  end
end
