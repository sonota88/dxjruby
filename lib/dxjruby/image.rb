require 'dxjruby/remote_resource'

module DXJRuby
  # Represents an image
  # Each instance of Image has its own off-screen canvas.
  class Image < RemoteResource
    RemoteResource.add_class(Image)

    ## # Convert HSL to RGB (DXOpal original; not in DXRuby)
    ## # h: 0-359
    ## # s: 0-100
    ## # l: 0-100
    ## def self.hsl2rgb(h, s, l)
    ##   if l < 50
    ##     max = 2.55 * (l + l*(s/100.0))
    ##     min = 2.55 * (l - l*(s/100.0))
    ##   else
    ##     max = 2.55 * (l + (100-l)*(s/100.0))
    ##     min = 2.55 * (l - (100-l)*(s/100.0))
    ##   end
    ##   case h
    ##   when 0...60
    ##     [max, (h/60.0)*(max-min) + min, min]
    ##   when 60...120
    ##     [((120-h)/60.0)*(max-min) + min, max, min]
    ##   when 120...180
    ##     [min, max, ((h-120)/60.0)*(max-min) + min]
    ##   when 180...240
    ##     [min, ((240-h)/60.0)*(max-min) + min, max]
    ##   when 240...300
    ##     [((h-240)/60.0)*(max-min) + min, min, max]
    ##   else
    ##     [max, min, ((360-h)/60.0)*(max-min) + min]
    ##   end
    ## end

    # Load remote image (called via Window.load_resources)
    def self._load(path_or_url)
      new(nil, nil, path_or_url:)
    end

    ## attr_accessor :promise, :loaded
    ## def loaded?
    ## 
    ## def self.load(path_or_url)
    ## 
    ## def load(path_or_url)
    ## 
    ## def onload(&block)
    
    # Create an instance of Image
    def initialize(width, height, color=C_DEFAULT, path_or_url: nil)
      if path_or_url
        # internal API / Use register for DXOpal
        @j_image = Image.j_Image.load(path_or_url)
      else
        @j_image = Image.j_Image.create_blank(width, height)
        @j_image.box_fill(0, 0, width, height, j_color(color))
      end
    end

    def width
      @j_image.get_width()
    end

    def height
      @j_image.get_height()
    end

    ## # Set size of this image
    ## def _resize(w, h)
    ## 
    ## # Draw an Image on this image
    ## def draw(x, y, image)
    ## 
    ## # Draw an Image on this image with scaling
    ## # - scale_x, scale_y: scaling factor (eg. 1.5)
    ## # - center_x, center_y: scaling center (in other words, the point
    ## #   which does not move by this scaling. Default: image center)
    ## def draw_scale(x, y, image, scale_x, scale_y, center_x=nil, center_y=nil)
    ## 
    ## # Draw an Image on this image with rotation
    ## # - angle: Rotation angle (radian)
    ## # - center_x, center_y: Rotation center in the `image` (default: center of the `image`)
    ## def draw_rot(x, y, image, angle, center_x=nil, center_y=nil)
    ## 
    ## BLEND_TYPES = {
    ##   alpha: "source-over", # A over B (Default)
    ##   add:   "lighter"      # A + B
    ## }
    ## 
    ## def draw_ex(x, y, image, options={})
    ## 
    ## # Draw some text on this image
    ## def draw_font(x, y, string, font, color=[255,255,255])

    # Get a pixel as ARGB array
    def [](x, y)
      @j_image.get_pixel(x, y).to_a
    end

    # Put a pixel on this image
    def []=(x, y, color)
      @j_image.set_pixel(x, y, j_color(color))
    end

    ## # Return true if the pixel at `(x, y)` has the `color`
    ## def compare(x, y, color)

    # Draw a line on this image
    def line(x1, y1, x2, y2, color)
      @j_image.line(x1, y1, x2, y2, j_color(color))
    end

    # Draw a rectangle on this image
    def box(x1, y1, x2, y2, color)
      @j_image.box(x1, y1, x2, y2, j_color(color))
    end

    # Draw a filled box on this image
    def box_fill(x1, y1, x2, y2, color)
      @j_image.box_fill(x1, y1, x2, y2, j_color(color))
    end

    # Draw a circle on this image
    def circle(x, y, r, color)
      @j_image.circle(x, y, r, j_color(color))
    end

    # Draw a filled circle on this image
    def circle_fill(x, y, r, color)
      @j_image.circle_fill(x, y, r, j_color(color))
    end

    # Draw a triangle on this image
    def triangle(x1, y1, x2, y2, x3, y3, color)
      @j_image.triangle(x1, y1, x2, y2, x3, y3, j_color(color))
    end

    # Draw a filled triangle on this image
    def triangle_fill(x1, y1, x2, y2, x3, y3, color)
      @j_image.triangle_fill(x1, y1, x2, y2, x3, y3, j_color(color))
    end

    ## # Fill this image with `color`
    ## def fill(color)
    ## 
    ## # Clear this image (i.e. fill with `[0,0,0,0]`)
    ## def clear
    ## 
    ## # Return an Image which is a copy of the specified area
    ## def slice(x, y, width, height)
    ## 
    ## # Slice this image into xcount*ycount tiles
    ## def slice_tiles(xcount, ycount)
    ## 
    ## # Set alpha of the pixels of the given color to 0
    ## # - color : RGB color (If ARGV color is given, A is just ignored)
    ## def set_color_key(color)
    ## 
    ## # Copy an <img> onto this image
    ## def _draw_raw_image(x, y, raw_img)
    ## 
    ## # Return .getImageData
    ## def _image_data(x=0, y=0, w=@width, h=@height)
    ## 
    ## # Call .putImageData
    ## def _put_image_data(image_data, x=0, y=0)
    ## 
    ## # Return a string like 'rgb(255, 255, 255)'
    ## # `color` is 3 or 4 numbers
    ## def _rgb(color)
    ## 
    ## # Return a string like 'rgba(255, 255, 255, 128)'
    ## # `color` is 3 or 4 numbers
    ## def _rgba(color)
    ## 
    ## # Return an array like `[255, 255, 255, 128]`
    ## def _rgba_ary(color)

    def to_j
      @j_image
    end

    private

    def j_color(color_array)
      Java::dxjruby.DXJRuby.to_awt_color(*color_array)
    end

    def self.j_Image
      Java::dxjruby.Image
    end
  end
end
