module DXJRuby
  attr_reader :j_font

  class Font
    # def self.default
    # def self.default=(f)

    def initialize(size, fontname=nil, option={})
      # TODO option
      @j_font = Java::dxjruby.Font.new(fontname || "sans-serif", size)
    end

    # def size
    # def fontname

    # def get_width(string)

    def self.install(path)
      j_Font.install(path).map(&:to_s)
    end

    private

    def self.j_Font
      Java::dxjruby.Font
    end
  end
end
