require_relative "remote_resource"

module DXJRuby
  module Window
    # Load resources specified with Image.register or Sound.register
    # Call block when loaded
    def self.load_resources(&block)
      RemoteResource._load_resources
      block.call
    end

    class FpsManager
      attr_accessor :count
      attr_accessor :delta
      attr_accessor :real_fps
      attr_accessor :span_frame_acc
      attr_reader :span_per_frame
      attr_reader :fps

      def initialize
        @count = 0
        @delta = 0.0 # sec
        @real_fps = nil
        @span_frame_acc = 0.0 # sec accumurated
        @fps = 60
        change_fps(@fps)
      end

      def change_fps(fps)
        @fps = fps
        @real_fps = @fps
        @span_per_frame = 1.0 / @fps
      end
    end

    @@fpsm = FpsManager.new

    # Start main loop
    #
    # TODO When called twice, previous loop is stopped (this is useful
    #      when implementing interactive game editor, etc.)
    def self.loop(&block)
      if j_Window.get_caption() == ""
        j_Window.set_caption("DXJRubyApplication")
      end
      j_Window.start_gui()

      t_base_loop = Time.now
      t_base_frame = Time.now

      Kernel.loop do
        t_now = Time.now
        @@fpsm.delta += (t_now - t_base_loop) / @@fpsm.span_per_frame
        t_base_loop = t_now

        if @@fpsm.delta >= 1.0
          while @@fpsm.delta >= 1.0
            @@fpsm.delta -= 1.0
          end

          @@fpsm.count += 1

          j_Window.update_input_state()
          block.call

          j_Window.request_paint()

          t_now = Time.now
          span_delta = t_now - t_base_frame
          t_base_frame = t_now
          @@fpsm.span_frame_acc += span_delta

          if @@fpsm.span_frame_acc >= 1.0
            @@fpsm.span_frame_acc = 0.0
            @@fpsm.real_fps = @@fpsm.count
            @@fpsm.count = 0
          end
        end
      end
    end

    ## # (DXOpal original) Pause & resume
    ## def self.pause
    ## def self.paused?
    ## def self.resume
    ## def self.draw_pause_screen

    ## # (internal) call @@block periodically
    ## def self._loop(timestamp)

    ## def self._init

    ## # Return internal DXOpal::Image object (for experimental/hacking use)
    ## def self._img

    def self.fps
      @@fpsm.fps
    end

    def self.fps=(fps)
      @@fpsm.change_fps(fps)
    end

    def self.real_fps
      @@fpsm.real_fps
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

    ## @@bgcolor = Constants::Colors::C_BLACK
    ## def self.bgcolor
    def self.bgcolor=(col)
      j_Window.set_bgcolor(j_color(col))
    end

    def self.draw(x, y, image, z=0)
      j_Window.draw_image(x, y, image.to_j, z)
    end

    ## def self.draw_scale(x, y, image, scale_x, scale_y, center_x=nil, center_y=nil, z=0)

    ## def self.draw_rot(x, y, image, angle, center_x=nil, center_y=nil, z=0)

    # blend is not supported
    def self.draw_ex(x, y, image, options={})
      z = options[:z] || 0
      cx = options[:center_x] || (image.width.to_f / 2)
      cy = options[:center_y] || (image.height.to_f / 2)
      scalex = options[:scale_x] || 1.0
      scaley = options[:scale_y] || 1.0
      angle = options[:angle] || 0.0
      alpha = options[:alpha] || 255

      j_Window.draw_ex(
        x, y, image.to_j,
        # options
        z,
        cx.to_f, cy.to_f,
        scalex.to_f, scaley.to_f,
        angle.to_f,
        alpha
      )
    end

    def self.draw_font(x, y, string, font, option={})
      unless string.is_a?(String)
        raise TypeError.new("wrong argument type #{string.class} (expected String)")
      end

      z = option[:z] || 0
      color = option[:color] || [255, 255, 255]

      j_Window.draw_font(
        x, y, string, font.j_font,
        # options
        z, j_color(color)
      )
    end

    ## def self.draw_pixel(x, y, color, z=0)

    def self.draw_line(x1, y1, x2, y2, color, z=0)
      j_Window.draw_line(x1, y1, x2, y2, j_color(color), z)
    end

    def self.draw_box(x1, y1, x2, y2, color, z=0)
      j_Window.draw_box(x1, y1, x2, y2, j_color(color), z)
    end

    def self.draw_box_fill(x1, y1, x2, y2, color, z=0)
      j_Window.draw_box_fill(x1, y1, x2, y2, j_color(color), z)
    end

    def self.draw_circle(x, y, r, color, z=0)
      j_Window.draw_circle(x, y, r, j_color(color), z)
    end

    def self.draw_circle_fill(x, y, r, color, z=0)
      j_Window.draw_circle_fill(x, y, r, j_color(color), z)
    end

    ## def self.draw_triangle(x1, y1, x2, y2, x3, y3, color, z=0)

    ## def self.draw_triangle_fill(x1, y1, x2, y2, x3, y3, color, z=0)

    ## # (internal)
    ## def self.enqueue_draw(z, *args)

    #
    # DXRuby
    #

    def self.caption
      j_Window.get_caption()
    end

    def self.caption=(title)
      unless title.is_a?(String)
        raise TypeError.new("wrong argument type #{title.class} (expected String)")
      end

      j_Window.set_caption(title)
    end

    private

    def self.j_color(color_array)
      Java::dxjruby.DXJRuby.to_awt_color(*color_array)
    end

    def self.j_Window
      Java::dxjruby.Window
    end
  end
end
