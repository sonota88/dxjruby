case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

Window.width = 320
Window.height = 240
Window.fps = 10

Window.load_resources do
  Window.loop do
    mx = Input.mouse_x
    my = Input.mouse_y

    Window.draw_circle_fill(mx, my, 10, C_RED)
    Window.draw_line(0, 0, mx, my, [255, 255, 0])

    if rand < 0.2
      p [Input.mouse_x, Input.mouse_y, Window.real_fps]
    end
  end
end
