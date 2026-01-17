case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

case RUBY_ENGINE
when "opal"
when "jruby"
  require_relative "memory_sound_dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

# --------------------------------

dur_msec = 500 # 音の長さ（ミリ秒）
freq = 440     # 周波数（Hz）
volume = 0.2   # 音量

memory_sound = MemorySound.generate(dur_msec) do |i, t_sec|
  Math.sin(2 * Math::PI * freq * t_sec) * volume
end

sound_register_from_memory(:s1, memory_sound)

Window.load_resources do
  Window.loop do
    if Input.mouse_push?(M_LBUTTON)
      Sound[:s1].play
    end
  end
end
