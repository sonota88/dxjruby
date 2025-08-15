case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

WIN_W = 640
WIN_H = 480
FPS = 60
T_START = Time.now

# --------------------------------

module DXJRuby
  module Window
    def self.fpsm
      @@fpsm
    end
  end
end

class LinePrinter
  FONT = Font.new(14, "monospace")
  OFFSET_X = 10
  OFFSET_Y = 10
  LINE_HEIGHT = 20

  def initialize
    reset
  end

  def reset
    @lineno = 0
  end

  def puts(line)
    Window.draw_font(
      OFFSET_X,
      OFFSET_Y + LINE_HEIGHT * @lineno,
      line,
      FONT, color: C_BLACK
    )
    @lineno += 1
  end
end

# --------------------------------

class Ball
  attr_accessor :x, :y, :dx
  def initialize(x, y, dx)
    @x, @y, @dx = x, y, dx
  end
end

balls =
  [
    [1, 1],
    [2, WIN_W.to_f / 10 / FPS],
    [3, WIN_W.to_f /  5 / FPS],
    [4, WIN_W.to_f /  2 / FPS],
    [5, WIN_W.to_f /  1 / FPS],
  ]
  .map { |n, d|
    Ball.new(0, 100 + 40 * n, d)
  }

t_base_count = Time.now
count = 0
fps_hist = []
fps_timer = 0

lp = LinePrinter.new

SoundEffect.register(:se1, 50) do
  [220, 3]
end

Window.bgcolor = [245, 245, 245]
Window.fps = FPS

Window.load_resources do
  Window.loop do
    exit if Input.key_push?(K_ESCAPE)

    count += 1
    Time.now.yield_self { |t_now|
      if t_base_count + 1 < t_now
        t_base_count = t_now
        count = 0
        $stderr.print "."
        SoundEffect[:se1].play
      end
    }

    fps_timer += 1
    if fps_timer >= 20
      fps_timer = 0
      fps_hist << Window.real_fps
      if fps_hist.size > 100
        fps_hist.shift
      end
    end

    if Input.key_down?(K_1)
      # 負荷をかける
      5000.times do
        _x = 200 + rand(WIN_W - 200)
        _y = rand(WIN_H)
        Window.draw_circle_fill(
          _x, _y, 10 + rand(20), [100, rand(256), rand(256), rand(200)]
        )
      end
    end

    if Input.key_down?(K_2)
      # 時間のかかる処理のエミュレート
      sleep 0.1
    end

    balls.each { |ball|
      ball.x = 0 if WIN_W < ball.x
      ball.x = ball.x + ball.dx
    }
    balls.each { |ball|
      Window.draw_circle_fill(ball.x, ball.y, 10, C_BLACK)
    }

    lp.reset
    lp.puts format(
      "fps: %d, average: %.1f",
      Window.real_fps,
      fps_hist.sum.to_f / fps_hist.size
    )
    lp.puts format("elapsed: %.3f sec", Time.now - T_START)
    lp.puts format("count: % 3d", count)
    if RUBY_ENGINE != "opal"
      lp.puts format("fpsm.count: % 3d", Window.fpsm.count)
      lp.puts format("fpsm.delta: %.1f", Window.fpsm.delta)
    end
  end
end
