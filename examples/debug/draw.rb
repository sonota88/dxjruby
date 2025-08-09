case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

def ex_scale(img)
  Window.draw_ex(
    150, 150, img,
    scalex: 1.5,
    scaley: 1.5
  )
end

def ex_rot(img)
  Window.draw_ex(
    150, 150, img,
    angle: 45
  )
end

def ex_alpha(img)
  Window.draw_ex(
    150, 150, img,
    alpha: 128
  )
end

def ex_all(img)
  Window.draw_ex(
    150, 150, img,
    angle: 45,
    alpha: 180,
    scalex: 1.5,
    scaley: 1.5
    # blend: :add # unsupported
  )
end

img_red = Image.new(100, 100, [255, 0, 0])
img_blue = Image.new(100, 100, [0, 0, 255])
img_yellow = Image.new(100, 100, [255, 255, 0])

Window.load_resources do
  Window.loop do
    Window.draw(150, 250, img_yellow)

    Window.draw(100, 100, img_red)
    # ex_scale(img_blue)
    # ex_rot(img_blue)
    # ex_alpha(img_blue)
    ex_all(img_blue)

  end
end
