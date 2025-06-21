case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

Window.bgcolor = [200, 200, 200]

Image.register(:img1, File.join(__dir__, "img_ruby.png"))

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

  Window.loop do
    Window.draw(10, 20, Image[:img1])
    Window.draw(Input.mouse_x - 16, Input.mouse_y - 16, img2)
  end
end
