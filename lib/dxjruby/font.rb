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

    # option[:weight]:
    #   整数での指定は非推奨です。
    #   DXRuby との互換性のために整数での指定も受け付けていますが、
    #   あくまで簡易な対応となっています。
    def initialize(size, fontname=nil, option={})
      @fontname = fontname

      _fontname = fontname || "sans-serif"
      @name = Font.j_Font::GENERIC_FAMILY_MAP[_fontname] || _fontname

      # TODO option: italic, auto_fitting
      weight =
        case option[:weight]
        when Integer
          if option[:weight] >= 1_000
            Font.j_Font::WEIGHT_BOLD
          else
            Font.j_Font::WEIGHT_NORMAL
          end
        when true  then Font.j_Font::WEIGHT_BOLD
        when false then Font.j_Font::WEIGHT_NORMAL
        when nil   then Font.j_Font::WEIGHT_NORMAL
        else
          raise TypeError.new(
                  "wrong argument type #{option[:weight].class} (expected bool)"
                )
        end

      @j_font = Font.j_Font.new(@name, size, weight)
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
