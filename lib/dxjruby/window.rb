require_relative "remote_resource"

module DXJRuby
  module Window

    # Load resources specified with Image.register or Sound.register
    # Call block when loaded
    def self.load_resources(&block)
      RemoteResource._load_resources
      block.call
    end

    # Start main loop
    #
    # When called twice, previous loop is stopped (this is useful
    # when implementing interactive game editor, etc.)
    def self.loop(&block)
      j_Window.start(block)
    end

    # # (DXOpal original) Pause & resume
    # def self.pause
    # def self.paused?
    # def self.resume
    # def self.draw_pause_screen

    # # (internal) call @@block periodically
    # def self._loop(timestamp)

    # def self._init

    # # Return internal DXOpal::Image object (for experimental/hacking use)
    # def self._img

    # def self.fps

    def self.fps=(fps)
      j_Window.set_fps(fps)
    end

    def self.real_fps
      j_Window.get_real_fps()
    end

    def self.width
      j_Window.get_width()
    end

    # Set window width and resize the canvas
    # Set `nil` to maximize canvas
    # TODO resize, maximize
    def self.width=(w)
      j_Window.set_width(w)
    end

    def self.height
      j_Window.get_height()
    end

    # Set window height and resize the canvas
    # Set `nil` to maximize canvas
    # TODO resize, maximize
    def self.height=(h)
      j_Window.set_height(h)
    end

    # @@bgcolor = Constants::Colors::C_BLACK
    # def self.bgcolor
    def self.bgcolor=(col)
      j_Window.set_bgcolor(j_color(col))
    end

    # def self.draw(x, y, image, z=0)

    # def self.draw_scale(x, y, image, scale_x, scale_y, center_x=nil, center_y=nil, z=0)

    # def self.draw_rot(x, y, image, angle, center_x=nil, center_y=nil, z=0)

    # def self.draw_ex(x, y, image, options={})

    def self.draw_font(x, y, string, font, option={})
      z = option[:z] || 0
      color = option[:color] || [255, 255, 255]

      j_Window.draw_font(
        x, y, string, font.j_font,
        # options
        z, j_color(color)
      )
    end

    # def self.draw_pixel(x, y, color, z=0)

    def self.draw_line(x1, y1, x2, y2, color, z=0)
      j_Window.draw_line(x1, y1, x2, y2, j_color(color), z)
    end

    # def self.draw_box(x1, y1, x2, y2, color, z=0)

    # def self.draw_box_fill(x1, y1, x2, y2, color, z=0)

    # def self.draw_circle(x, y, r, color, z=0)

    def self.draw_circle_fill(x, y, r, color, z=0)
      j_Window.draw_circle_fill(x, y, r, j_color(color), z)
    end

    # def self.draw_triangle(x1, y1, x2, y2, x3, y3, color, z=0)

    # def self.draw_triangle_fill(x1, y1, x2, y2, x3, y3, color, z=0)

    # # (internal)
    # def self.enqueue_draw(z, *args)

    private

    def self.j_color(color_array)
      Java::dxjruby.DXJRuby.to_awt_color(*color_array)
    end

    def self.j_Window
      Java::dxjruby.Window
    end
  end
end
