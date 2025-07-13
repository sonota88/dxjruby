case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

WIN_W = 640
WIN_H = 480
FONT = Font.new(16, "monospace")

RESOURCE_DIR =
  case RUBY_ENGINE
  when "opal"  then "."
  when "jruby" then __dir__
  else
    raise "unsupported engine (#{RUBY_ENGINE})"
  end

Sound.register(:s1, File.join(RESOURCE_DIR, "s1.wav"))

def scope() yield end

WAVE_TYPES = [
  [:se_sin , WAVE_SIN , K_1],
  [:se_saw , WAVE_SAW , K_2],
  [:se_tri , WAVE_TRI , K_3],
  [:se_rect, WAVE_RECT, K_4],
].each { |name, wave_type, _|
  SoundEffect.register(name, 500, wave_type) do
    [220, 30]
  end
}

# 以下は SoundEffect のチュートリアルで紹介されている例です
# https://mirichi.github.io/dxruby-doc/tutorial/soundeffect.html

SE_VOLUME = 0.3

scope {
  v = 100.0
  c = 60
  f = 1300
  SoundEffect.register(:se1, 500) do
    c = c - 1
    if c < 0 then
      v = v - 0.2
      f = 1760
    end
    [f, v * SE_VOLUME]
  end
}

scope {
  SoundEffect.register(:se2, 1000, WAVE_TRI) do # 低音は三角波
    [110, 80 * SE_VOLUME]
  end

  # TODO
  # s2.add(WAVE_RECT) do # 矩形波
  #   [275, 40 * SE_VOLUME]
  # end
  # s2.add(WAVE_RECT) do # 矩形波
  #   [330, 40 * SE_VOLUME]
  # end
}

scope {
  f = 0
  v = 150.0
  SoundEffect.register(:se3, 500, WAVE_SIN) do
    f = f + 1
    v = v - 0.1
    [880 + Math.sin(f) * 200, v * SE_VOLUME]
  end
}

SE_MAP = []
WAVE_TYPES.each { |name, _, key_code|
  SE_MAP << [key_code, name]
}
SE_MAP << [K_5, :se1]
SE_MAP << [K_6, :se2]
SE_MAP << [K_7, :se3]

Window.load_resources do
  Window.loop do
    my = Input.mouse_y
    vol = ((my.to_f / WIN_H) * 255).floor

    if Input.mouse_push?(M_LBUTTON)
      # p vol
      if RUBY_ENGINE != "opal"
        Sound[:s1].set_volume(vol)
      end
      Sound[:s1].play
    end

    se_name = nil
    SE_MAP.each { |key_code, name|
      if Input.key_push?(key_code)
        se_name = name
      end      
    }
    SoundEffect[se_name].play if se_name

    Window.draw_font(10, 10, "volume (#{vol})", FONT)
  end
end
