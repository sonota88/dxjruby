case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

WIN_W = 320
WIN_H = 240
FONT = Font.new(16, "monospace")

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
CHARA_COLOR_MAP = {
  # " " => [255, 255, 0],
  " " => [0, 0, 0, 0],
  "." => [255, 255, 255],
  "x" => [100, 0, 50],
}

def image_from_pattern(pattern, color_map)
  rows = pattern
    .map { |line|
      line.chars.map { |c|
        color_map[c]
      }
    }

  w = rows[0].size
  h = rows.size

  img = Image.new(w, h)
  (0...h).each { |y|
    (0...w).each { |x|
      img[x, y] = rows[y][x]
    }
  }

  img
end

def image_scale(img, w, h)
  w1 = img.width
  h1 = img.height

  img2 = Image.new(w, h)
  (0...h).each { |y2|
    y1 = ((y2.to_f / w) * h1).floor
    (0...w).each { |x2|
      x1 = ((x2.to_f / w) * w1).floor
      img2[x2, y2] = img[x1, y1]
    }
  }
  img2
end

def to_image(pattern, color_map)
  img_raw = image_from_pattern(pattern, color_map)
  image_scale(img_raw, 16, 16)
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

class Chara < Sprite
  VELOCITY = 0.5
  IMGS = CHARA_PATTERNS.map { |pat| to_image(pat, CHARA_COLOR_MAP) }

  def initialize
    @img_i = 0
    img = IMGS[@img_i]

    @pos = random_pos()
    super(@pos.x, @pos.y, img)

    @angle = rand(360)

    @mv_dest = random_pos()
    @mv_d = calc_mv_d(@pos, @mv_dest)

    @counter = Counter.new(Window.fps.to_f / 4) do
      update_img()
    end
  end

  def update_img
    @img_i += 1
    if @img_i >= IMGS.size
      @img_i = 0
    end
    @image = IMGS[@img_i]
  end

  def random_pos
    Vec(rand(WIN_W - 16), rand(WIN_H - 16))
  end

  def calc_mv_d(from, to)
    v = to - from
    v_norm = v / v.magnitude
    v_norm * VELOCITY
  end

  def update
    @counter.count

    rest = @mv_dest - @pos
    if VELOCITY < rest.magnitude
      @pos += @mv_d
    else
      @pos = @mv_dest
      @mv_dest = random_pos()
      @mv_d = calc_mv_d(@pos, @mv_dest)
    end

    @x = @pos.x
    @y = @pos.y
  end
end

# --------------------------------

Window.bgcolor = [220, 220, 200]
Window.width = WIN_W
Window.height = WIN_H

t_next = Time.now

charas = []
5.times { charas << Chara.new }

Window.load_resources do
  Window.loop do
    if t_next <= Time.now
      t_next += 5

      if rand < 0.5
        if charas.size < 10
          charas << Chara.new
        end
      else
        if charas.size >= 2
          charas.shuffle[0].vanish
        end
      end
    end

    Sprite.update(charas)
    Sprite.draw(charas)
    Sprite.clean(charas)

    Window.draw_font(
      10, 10,
      format("# of sprites: %d", charas.size),
      FONT,
      color: C_BLACK
    )
  end
end
