case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

WIN_W = 640
WIN_H = 480
FONT = Font.new(16, "monospace")

Sound.register(:s1, File.expand_path("s1.wav", __dir__))

SoundEffect.register(:se1, 500, WAVE_SIN) do
# SoundEffect.register(:se1, 500, WAVE_SAW) do
# SoundEffect.register(:se1, 500, WAVE_TRI) do
# SoundEffect.register(:se1, 500, WAVE_RECT) do
  [220, 80]
end

Window.load_resources do
  Window.loop do
    mx = Input.mouse_x
    my = Input.mouse_y
    vol = ((my.to_f / WIN_H) * 255).floor

    if Input.mouse_push?(M_LBUTTON)
      if mx < WIN_W / 2
        # p vol
        Sound[:s1].set_volume(vol)
        Sound[:s1].play
      else
        SoundEffect[:se1].play
      end
    end

    Window.draw_font(10, 10, "volume (#{vol})", FONT)
  end
end
