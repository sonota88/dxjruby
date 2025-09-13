case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

# --------------------------------

WIN_W = 640
WIN_H = 480
FPS = 60

C_BALL = [80, 0, 0, 0]

# --------------------------------

Window.bgcolor = [245, 245, 245]
Window.fps = FPS

ALL_KEY_CODES = Input::KeyCodes.constants
  .select { |name| name.start_with?("K_") }
  .map { |name| Input::KeyCodes.const_get(name) }

FONT = Font.new(14, "monospace")

k_down_y = 0
k_push_y = 0
k_release_y = 0

m_down_y = 0
m_push_y = 0
m_release_y = 0

dy = 2

fps_hist = []
fps_timer = 0

Window.load_resources do
  Window.loop do
    mx = Input.mouse_x
    my = Input.mouse_y

    k_down_y += dy
    k_push_y += dy
    k_release_y += dy

    m_down_y += dy
    m_push_y += dy
    m_release_y += dy

    if Input.key_down?(K_1)
      k_down_y = 0
    end
    if Input.key_push?(K_1)
      k_push_y = 0
    end
    if Input.key_release?(K_1)
      k_release_y = 0
    end

    if Input.mouse_down?(M_LBUTTON)
      m_down_y = 0
    end
    if Input.mouse_push?(M_LBUTTON)
      m_push_y = 0
    end
    if Input.mouse_release?(M_LBUTTON)
      m_release_y = 0
    end

    fps_timer += 1
    if fps_timer >= 50
      fps_timer = 0
      fps_hist << Window.real_fps
      if fps_hist.size > 100
        fps_hist.shift
      end
    end

    # 負荷をかける
    2000.times do
      x = rand(200...WIN_W)
      y = rand(0...WIN_H)
      Window.draw_circle_fill(
        x, y, 10 + rand(20), [100, rand(255), rand(255), rand(255)]
      )
    end

    # Window.draw_box_fill( 0, down_y   , 10 - 1, down_y + 10, C_BLACK)
    # Window.draw_box_fill(10, push_y   , 20 - 1, push_y + 10, C_BLACK)
    # Window.draw_box_fill(20, release_y, 30 - 1, release_y + 10, C_BLACK)

    [
      [ 0, k_down_y],
      [10, k_push_y],
      [20, k_release_y],
      [40, m_down_y],
      [50, m_push_y],
      [60, m_release_y],
    ].each { |x, y|
      Window.draw_circle_fill(10 + x, 10 + y, 5, C_BALL)
    }

    # p ["keys", Input.keys] if rand < 0.1

    text_y = 10
    text_color = [0, 100, 200]
    line_height = 20

    Window.draw_font(
      10, text_y,
      format(
        "fps (%d) avg (%.1f)",
        Window.real_fps,
        fps_hist.sum.to_f / fps_hist.size
      ),
      FONT, color: text_color
    )
    text_y += line_height

    Window.draw_font(
      10, text_y, "mouse x, y (#{mx}, #{my})",
      FONT, color: text_color
    )
    text_y += line_height

    ALL_KEY_CODES.each { |key_code|
      if Input.key_push?(key_code)
        puts "key pushed: " + key_code.inspect
      end
    }
  end
end
