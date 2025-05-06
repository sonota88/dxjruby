# Forked from DXOpal
# https://github.com/yhara/dxopal/blob/v1.6.0/examples/top_page/main.rb

case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

Window.width = 300
Window.height = 300
Window.bgcolor = C_WHITE
Window.load_resources do
  x = rand(Window.width)
  y = rand(Window.height)
  dx = dy = 2
  Window.loop do
    Window.draw_circle_fill(x, y, 10, C_RED)
    dx = -dx if x < 0 || x > Window.width
    dy = -dy if y < 0 || y > Window.height
    x += dx
    y += dy
  end
end
