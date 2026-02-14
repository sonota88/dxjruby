case RUBY_ENGINE
when "opal"  then require "dxopal"
when "jruby" then require "dxjruby"
else raise "unsupported engine (#{RUBY_ENGINE})"
end

def resource_path(path)
  base =
    case RUBY_ENGINE
    when "opal"  then "."
    when "jruby" then __dir__
    end

  File.join(base, path)
end

Window.bgcolor = [127, 127, 127]

Image.register(
  :img1,
  resource_path("img_index.png")
)

Window.load_resources do
  img1 = Image[:img1]

  # 元イメージの範囲外の部分も含むパターン
  img2 = img1.slice(4, 1, 10, 10) # x, y, w, h

  Window.loop do
    Window.draw_ex(10,  50, img1)
    Window.draw_ex(10, 100, img2)
  end
end
