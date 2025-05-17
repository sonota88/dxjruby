case RUBY_ENGINE
when "opal"  then require "dxopal" ; include DXOpal
when "jruby" then require "dxjruby"; include DXJRuby
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

# --------------------------------

WIN_W = 640
WIN_H = 480
FPS = 60

# --------------------------------

Window.bgcolor = [245, 245, 245]
Window.fps = FPS

font = Font.new(14, "monospace")

# down_y = 0
# push_y = 0
# release_y = 0
m_down_y = 0
m_push_y = 0
m_release_y = 0
dy = 2

Window.load_resources do
  Window.loop do
    # down_y += dy
    # push_y += dy
    # release_y += dy

    m_down_y += dy
    m_push_y += dy
    m_release_y += dy

    # if Input.key_down?(K_J)
    #   down_y = 0
    # end
    # if Input.key_push?(K_J)
    #   push_y = 0
    # end
    # if Input.key_release?(K_J)
    #   release_y = 0
    # end

    if Input.mouse_down?(M_LBUTTON)
      m_down_y = 0
    end
    if Input.mouse_push?(M_LBUTTON)
      m_push_y = 0
    end
    if Input.mouse_release?(M_LBUTTON)
      m_release_y = 0
    end

    # 負荷をかける
    5000.times do
      x = 200 + rand(440)
      y = rand(480)
      Window.draw_circle_fill(
        x, y, 10 + rand(20), [100, rand(255), rand(255), rand(255)]
      )
    end

    # Window.draw_box_fill( 0, down_y   , 10 - 1, down_y + 10, C_BLACK)
    # Window.draw_box_fill(10, push_y   , 20 - 1, push_y + 10, C_BLACK)
    # Window.draw_box_fill(20, release_y, 30 - 1, release_y + 10, C_BLACK)

    [
      [40, m_down_y],
      [50, m_push_y],
      [60, m_release_y],
    ].each { |x, y|
      Window.draw_circle_fill(x, 10 + y, 5, C_BLACK)
    }

    # p ["keys", Input.keys] if rand < 0.1

    Window.draw_font(
      10, 10, "fps (#{Window.real_fps})",
      font, color: [0, 100, 200]
    )
  end
end
