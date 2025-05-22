case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

WIN_H = 480
FONT = Font.new(16, "monospace")

Sound.register(:s1, File.expand_path("s1.wav", __dir__))

Window.load_resources do
  Window.loop do
    my = Input.mouse_y
    vol = ((my.to_f / WIN_H) * 255).floor

    if Input.mouse_push?(M_LBUTTON)
      # p vol
      Sound[:s1].set_volume(vol)
      Sound[:s1].play
    end

    Window.draw_font(10, 10, "volume (#{vol})", FONT)
  end
end
