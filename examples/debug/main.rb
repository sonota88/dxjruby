case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

DXJRuby.shape_antialias_enabled = false

Window.width = 320
Window.height = 240
Window.bgcolor = [200, 200, 200]
Window.fps = 10
Window.caption = "example" if RUBY_ENGINE != "opal"

# font_name_foo, _ = Font.install("/path/to/some_font.ttf")
# font_foo = Font.new(12, font_name_foo)

font_16 = Font.new(16, "Noto Sans Mono CJK JP")
font_32 = Font.new(32, "Noto Sans Mono CJK JP")

Window.load_resources do
  Window.loop do
    mx = Input.mouse_x
    my = Input.mouse_y

    Window.draw_circle_fill(mx, my, 10, C_RED)
    Window.draw_line(0, 0, mx, my, [255, 255, 0])

    Window.draw_font(
      10, 10, "mouse (#{mx}, #{my})", font_16,
      color: [0, 20, 255]
    )
    Window.draw_font(
      10, 30, "fps (#{Window.real_fps})", font_16,
      color: [0, 0, 0]
    )
  end
end
