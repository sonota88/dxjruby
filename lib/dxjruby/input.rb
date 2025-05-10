module DXJRuby
  module Input
    # module MouseCodes
    #   M_LBUTTON = 1
    #   M_RBUTTON = 2
    #   M_MBUTTON = 4
    #   # DXOpal extention
    #   M_4TH_BUTTON = 8
    #   M_5TH_BUTTON = 16
    # end

    # def self._pressing_keys

    # # Internal setup for Input class
    # def self._init(canvas)
    
    # # Called on every frame from Window
    # def self._on_tick

    # # Return 1 if 'right', -1 if 'left'
    # def self.x(pad_number=0)

    # # Return 1 if 'down', -1 if 'up'
    # def self.y(pad_number=0)

    # #
    # # Keyboard
    # #

    # # Return true if the key is being pressed
    # def self.key_down?(code)

    # # Return true if the key is just pressed
    # def self.key_push?(code)

    # # Return true if the key is just released
    # def self.key_release?(code)

    # # Set DOM element to receive keydown/keyup event
    # #
    # # By default, `window` is set to this (i.e. all key events are
    # # stolen by DXOpal.) If canvas element is set to this, only key events
    # # happend on canvas are processed by DXOpal.
    # def self.keyevent_target=(target)

    # # Return DOM element set by `keyevent_target=`
    # def self.keyevent_target

    # #
    # # Mouse
    # #

    # # (internal) initialize mouse events
    # def self._init_mouse_events

    # # Return position of mouse cursor
    # # (0, 0) is the top-left corner of the canvas
    def self.mouse_x
      j_Input.get_mouse_x()
    end
    def self.mouse_y
      j_Input.get_mouse_y()
    end

    # class << self
    #   alias mouse_pos_x mouse_x
    #   alias mouse_pos_y mouse_y
    # end

    # # Return true if the mouse button is being pressed
    # def self.mouse_down?(mouse_code)

    # # Return true if the mouse button is pressed in the last tick
    # def self.mouse_push?(mouse_code)

    # # Return true if the mouse button is released in the last tick
    # def self.mouse_release?(mouse_code)

    #
    # Touch (unsupported)
    #

    private

    def self.j_Input
      Java::dxjruby.Input
    end
  end
end
