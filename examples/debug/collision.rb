case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

GRID_W = 80
SHAPE_W = 64
WIN_W = GRID_W * 6
WIN_H = GRID_W * 6
C_A = [255, 255, 0, 0]
C_B = [180, 255, 255, 255]

Window.width = WIN_W
Window.height = WIN_H
Window.bgcolor = [0, 0, 0]

class FixedSprite < Sprite
  def initialize(x, y, image)
    super(x, y, image)
    @angle = 10
    @hit = false
  end

  def update
    @image = @hit ? @img_b : @img_a
    @hit = false
  end

  def hit(other = nil)
    @hit = true
  end
end

class MovingSprite < Sprite
  def update
    margin = 5
    @x += 0.5
    if @x < 0
      @x = WIN_W - 1 - margin
    elsif WIN_W < @x
      @x = 0 + margin
    end
  end
end

# --------------------------------

class FixedPoint < FixedSprite
  def initialize(x, y)
    w = SHAPE_W

    @img_a = Image.new(w, w)
    @img_a.circle(w / 2, w / 2, 1, C_A)
    @img_b = Image.new(w, w)
    @img_b.circle(w / 2, w / 2, 1, C_B)

    super(x, y, @img_a)
    self.collision = [w / 2, w / 2]
  end
end

class MovingPoint < MovingSprite
  def initialize(x, y)
    w = SHAPE_W

    image = Image.new(w, w)
    image.circle(w / 2, w / 2, 1, C_A)

    super(x, y, image)
    self.collision = [w / 2, w / 2]
  end
end

class FixedCircle < FixedSprite
  def initialize(x, y)
    w = SHAPE_W
    r = w/2 - 1

    @img_a = Image.new(w, w)
    @img_a.circle(w/2, w/2, r, C_A)
    @img_b = Image.new(w, w)
    @img_b.circle(w/2, w/2, r, C_B)

    super(x, y, @img_a)
    self.collision = [w / 2, w / 2, r]
  end
end

class MovingCircle < MovingSprite
  def initialize(x, y)
    w = SHAPE_W
    r = w/2 - 1

    image = Image.new(w, w)
    image.circle(w/2, w/2, r, C_A)

    super(x, y, image)
    self.collision = [w / 2, w / 2, r]
  end
end

class FixedRect < FixedSprite
  def initialize(x, y)
    w = SHAPE_W

    @img_a = Image.new(w, w)
    @img_a.box(0, 0, w-1, w-1, C_A)
    @img_b = Image.new(w, w)
    @img_b.box(0, 0, w-1, w-1, C_B)

    super(x, y, @img_a)
    self.collision = [0, 0, w - 1, w - 1]
  end
end

class MovingRect < MovingSprite
  def initialize(x, y)
    w = SHAPE_W

    image = Image.new(w, w)
    image.box(0, 0, w - 1, w - 1, C_A)

    super(x, y, image)
    self.collision = [0, 0, w - 1, w - 1]
  end
end

def image_triangle(w, poss, color)
  Image.new(w, w)
    .triangle(*poss.flatten, color)
end

class FixedTriangle < FixedSprite
  def initialize(x, y)
    w = SHAPE_W
    poss = [[0, 0], [w-1, 0], [w/2, w-1]]

    @img_a = image_triangle(w, poss, C_A)
    @img_b = image_triangle(w, poss, C_B)

    super(x, y, @img_a)
    self.collision = poss.flatten
  end
end

class MovingTriangle < MovingSprite
  def initialize(x, y)
    w = SHAPE_W
    poss = [[0, 0], [w, 0], [w/2, w]]

    image = image_triangle(w, poss, C_A)

    super(x, y, image)
    self.collision = poss.flatten
  end
end

# --------------------------------

sprites_fix = []
sprites_mov = []

[1, 2, 3, 4].each do |ri|
  sprites_fix << FixedPoint.new(   GRID_W * 1, GRID_W * ri)
  sprites_fix << FixedCircle.new(  GRID_W * 2, GRID_W * ri)
  sprites_fix << FixedRect.new(    GRID_W * 3, GRID_W * ri)
  sprites_fix << FixedTriangle.new(GRID_W * 4, GRID_W * ri)
end

sprites_mov << MovingPoint.new(   0, GRID_W * 1)
sprites_mov << MovingCircle.new(  0, GRID_W * 2)
sprites_mov << MovingRect.new(    0, GRID_W * 3)
sprites_mov << MovingTriangle.new(0, GRID_W * 4)

Window.load_resources do
  Window.loop do
    # input

    if Input.key_down?(K_LEFT)
      sprites_mov.each { |spr| spr.x -= 2 }
    end
    if Input.key_down?(K_RIGHT)
      sprites_mov.each { |spr| spr.x += 2 }
    end

    # update

    Sprite.check(sprites_mov, sprites_fix)
    Sprite.update(sprites_fix)
    Sprite.update(sprites_mov)

    # draw

    Sprite.draw(sprites_mov)
    Sprite.draw(sprites_fix)
  end
end
