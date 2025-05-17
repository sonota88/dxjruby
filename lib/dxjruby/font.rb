module DXJRuby
  attr_reader :j_font
  attr_reader :fontname, :name

  class Font
    def self.default
      @@default ||= Font.new(24)
    end

    def self.default=(f)
      @@default = f
    end

    def initialize(size, fontname=nil, option={})
      @fontname = fontname

      _fontname = fontname || "sans-serif"
      @name = Font.j_Font::GENERIC_FAMILY_MAP[_fontname] || _fontname

      # TODO option
      @j_font = Font.j_Font.new(@name, size)
    end

    def size; @j_font.size end
    def fontname; @fontname end

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
