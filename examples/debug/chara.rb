case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else
  raise "unsupported engine (#{RUBY_ENGINE})"
end

WIN_W = 320
WIN_H = 240

CHARA_PATTERNS = [
  [
    "        ",
    " xxxxxx ",
    " xxxxxx ",
    " x.xx.x ",
    " xxxxxx ",
    " xxxxxx ",
    "  x     ",
    "        ",
  ],
  [
    "        ",
    " xxxxxx ",
    " xxxxxx ",
    " x.xx.x ",
    " xxxxxx ",
    " xxxxxx ",
    "     x  ",
    "        ",
  ]
]

def to_image(pattern)
  color_map = {
    # " " => [255, 255, 0],
    " " => [0, 0, 0, 0],
    "." => [255, 255, 255],
    "x" => [100, 0, 50],
  }

  rows = pattern
    .map { |line|
      line.chars.map { |c|
        color_map[c]
      }
    }

  img = Image.new(16, 16)
  (0...8).each { |y|
    (0...8).each { |x|
      [
        [0, 0],
        [1, 0],
        [0, 1],
        [1, 1],
      ].each { |x2, y2|
        img[x * 2 + x2, y * 2 + y2] = rows[y][x]
      }
    }
  }

  img
end

class Vec
  attr_reader :x, :y

  def initialize(x, y) @x, @y = x, y end

  def negate(v) Vec(-v.x, -v.y) end
  def +(v) Vec(@x + v.x, @y + v.y) end
  def -(v) self + negate(v) end
  def *(val) Vec(@x.to_f * val, @y.to_f * val) end
  def /(val) Vec(@x.to_f / val, @y.to_f / val) end
  def magnitude() Math.sqrt(@x ** 2 + @y ** 2) end
  # def to_a() [@x, @y] end
end

def Vec(x, y) Vec.new(x, y) end

class Counter
  def initialize(cycle, &block)
    @cycle = cycle
    @count = @cycle
    @block = block
  end

  def count
    @count -= 1
    if @count <= 0
      @count += @cycle
      @block.call
    end
  end
end

def q2(x)
  (x.to_f / 2).floor * 2
end

class Chara
  VELOCITY = 0.5

  def initialize
    @imgs = CHARA_PATTERNS.map { |pat| to_image(pat) }
    @img_i = 0
    @img = @imgs[@img_i]

    @pos = Vec(rand(WIN_W - 16), rand(WIN_H - 16))

    @action = :move # :stop | :move
    @action_init = true

    # action: move
    @mv_dest = Vec(100, 200)
    @mv_d = calc_mv_d(@pos, @mv_dest)

    # action: stop
    @t_stop_end = nil

    @counter = Counter.new(Window.fps.to_f / 4) do
      shift_img()
    end
  end

  def calc_mv_d(from, to)
    v = to - from
    v_norm = v / v.magnitude
    v_norm * VELOCITY
  end

  def change_action(action)
    @action = action
    @action_init = true
  end

  def update
    case @action
    when :move
      if @action_init
        @action_init = false
        @mv_dest = Vec(rand(WIN_W - 16), rand(WIN_H - 16))
        @mv_d = calc_mv_d(@pos, @mv_dest)
      end

      @counter.count

      rest = @mv_dest - @pos
      if VELOCITY <= rest.magnitude
        @pos += @mv_d
      else
        @pos = @mv_dest
        select_next_action()
      end
    when :stop
      if @action_init
        @action_init = false
        @t_stop_end = Time.now + 1
      end

      if Time.now < @t_stop_end
        # do nothing
      else
        select_next_action()
      end
    else
      raise "invalid action"
    end
  end

  ACTIONS = [:move, :stop]

  def select_next_action
    act =
      if rand < 0.2
        :stop
      else
        :move
      end
    change_action(act)
  end

  def shift_img
    @img_i += 1
    if @img_i >= @imgs.size
      @img_i = 0
    end
    @img = @imgs[@img_i]
  end

  def draw
    Window.draw(@pos.x, @pos.y, @img)
    # Window.draw(q2(@pos.x), q2(@pos.y), @img)
  end
end

# --------------------------------

Window.bgcolor = [220, 220, 200]
Window.width = WIN_W
Window.height = WIN_H

Window.load_resources do
  chara = Chara.new

  Window.loop do
    chara.update
    chara.draw
  end
end
