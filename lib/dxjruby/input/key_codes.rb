module DXJRuby
  module Input
    # List of key codes (event.code)
    # https://developer.mozilla.org/ja/docs/Web/API/KeyboardEvent
    module KeyCodes
      KeyCode = Data.define(:value, :dxopal_code)

      ConfigEntry = Data.define(
        :dxjruby_code,
        :rb_const_name,
        :dxopal_code,
        :awt_const_name
      )

      # columns: rb_const_name, dxopal_code, awt_const_name
      # TODO: add event.code for those commented out (pull request welcome)
      CONFIG = [
        # K_ESCAPE = 'Escape'
        "K_1  Digit1  VK_1",
        "K_2  Digit2  VK_2",
        "K_3  Digit3  VK_3",
        "K_4  Digit4  VK_4",
        "K_5  Digit5  VK_5",
        "K_6  Digit6  VK_6",
        "K_7  Digit7  VK_7",
        "K_8  Digit8  VK_8",
        "K_9  Digit9  VK_9",
        "K_0  Digit0  VK_0",
        # K_MINUS = 'Minus'
        # K_EQUALS = 'Equal'
        # K_BACK = 'Backspace'
        # K_TAB = 'Tab'
        "K_Q  KeyQ  VK_Q",
        "K_W  KeyW  VK_W",
        "K_E  KeyE  VK_E",
        "K_R  KeyR  VK_R",
        "K_T  KeyT  VK_T",
        "K_Y  KeyY  VK_Y",
        "K_U  KeyU  VK_U",
        "K_I  KeyI  VK_I",
        "K_O  KeyO  VK_O",
        "K_P  KeyP  VK_P",
        # K_LBRACKET = 'BracketLeft'
        # K_RBRACKET = 'BracketRight'
        # K_RETURN = 'Enter'
        # K_ENTER = 'Enter'  # Alias; not in DXRuby
        # K_LCONTROL = 'ControlLeft'
        "K_A  KeyA  VK_A",
        "K_S  KeyS  VK_S",
        "K_D  KeyD  VK_D",
        "K_F  KeyF  VK_F",
        "K_G  KeyG  VK_G",
        "K_H  KeyH  VK_H",
        "K_J  KeyJ  VK_J",
        "K_K  KeyK  VK_K",
        "K_L  KeyL  VK_L",
        # K_SEMICOLON = 'Semicolon'
        # K_APOSTROPHE = 'Quote'  # '
        # K_GRAVE = "Backquote"   # `
        # K_LSHIFT = 'ShiftLeft'
        # K_BACKSLASH = 'BackSlash'  # Note: different to K_YEN
        "K_Z  KeyZ  VK_Z",
        "K_X  KeyX  VK_X",
        "K_C  KeyC  VK_C",
        "K_V  KeyV  VK_V",
        "K_B  KeyB  VK_B",
        "K_N  KeyN  VK_N",
        "K_M  KeyM  VK_M",
        # K_COMMA = 'Comma'
        # K_PERIOD = 'Period'
        # K_SLASH = 'Slash'
        # K_RSHIFT = 'ShiftRight'
        # K_MULTIPLY = "NumpadMultiply"
        # #K_LMENU Alt
        # K_SPACE = 'Space'
        # #K_CAPITAL
        # K_F1  = "F1"
        # K_F2  = "F2"
        # K_F3  = "F3"
        # K_F4  = "F4"
        # K_F5  = "F5"
        # K_F6  = "F6"
        # K_F7  = "F7"
        # K_F8  = "F8"
        # K_F9  = "F9"
        # K_F10 = "F10"
        # K_NUMLOCK = "NumLock"
        # K_SCROLL = "ScrollLock"
        # K_NUMPAD7 = "Numpad7"
        # K_NUMPAD8 = "Numpad8"
        # K_NUMPAD9 = "Numpad9"
        # K_SUBTRACT = "NumpadSubtract"
        # K_NUMPAD4 = "Numpad4"
        # K_NUMPAD5 = "Numpad5"
        # K_NUMPAD6 = "Numpad6"
        # K_ADD = "NumpadAdd"
        # K_NUMPAD1 = "Numpad1"
        # K_NUMPAD2 = "Numpad2"
        # K_NUMPAD3 = "Numpad3"
        # K_NUMPAD0 = "Numpad0"
        # K_DECIMAL = "NumpadDecimal"
        # #K_OEM_102 
        # K_F11 = "F11"
        # K_F12 = "F12"
        # K_F13 = "F13"
        # K_F14 = "F14"
        # K_F15 = "F15"
        # K_KANA = "KanaMode"
        # #K_ABNT_C1 
        # K_CONVERT = "Convert"
        # K_NOCONVERT = "NonConvert"
        # K_YEN = 'IntlYen'
        # #K_ABNT_C2 
        # #K_NUMPADEQUALS  = *3 *1
        # #K_PREVTRACK
        # #K_AT
        # K_COLON = 'Colon'
        # K_UNDERLINE = 'IntlRo'   # _
        # #K_KANJI 
        # #K_STOP
        # #K_AX
        # #K_UNLABELED
        # #K_NEXTTRACK
        # K_NUMPADENTER = "NumpadEnter"
        # K_RCONTROL = 'ControlRight'
        # K_MUTE = "VolumeMute"
        # #K_CALCULATOR
        # #K_PLAYPAUSE
        # #K_MEDIASTOP
        # K_VOLUMEDOWN = "VolumeDown"
        # K_VOLUMEUP = "VolumeUp"
        # K_WEBHOME = "BrowserHome"
        # #K_NUMPADCOMMA , *3 *1
        # K_DIVIDE = "NumpadDivide"
        # #K_SYSRQ
        # #K_RMENU Alt
        # K_PAUSE = "Pause"
        # K_HOME = "Home"
        # K_UP = 'ArrowUp'
        # #K_PRIOR
        # K_LEFT = 'ArrowLeft'
        # K_RIGHT = 'ArrowRight'
        # K_END = "End"
        # K_DOWN = 'ArrowDown'
        # #K_NEXT
        # K_INSERT = "Insert"
        # K_DELETE = "Delete"
        # #K_LWIN
        # #K_RWIN
        # #K_APPS
        # #K_POWER
        # #K_SLEEP
        # #K_WAKE
        # K_WEBSEARCH = "BrowserSearch"
        # K_WEBFAVORITES = "BrowserFavorites"
        # K_WEBREFRESH = "BrowserRefresh"
        # K_WEBSTOP = "BrowserStop"
        # K_WEBFORWARD = "BrowserForward"
        # K_WEBBACK = "BrowserBack"
        # #K_MYCOMPUTER
        # #K_MAIL
        # #K_MEDIASELECT
        # K_BACKSPACE = 'Backspace'
        # K_NUMPADSTAR = "NumpadMultiply"
        # K_LALT = "AltLeft"
        # K_CAPSLOCK = 'CapsLock'
        # K_NUMPADMINUS = "NumpadSubtract"
        # K_NUMPADPLUS = "NumpadAdd"
        # K_NUMPADPERIOD = "NumpadDecimal"
        # K_NUMPADSLASH = "NumpadDivide"
        # K_RALT = "AltRight"
        # K_UPARROW = 'ArrowUp'
        # K_PGUP = "PageUp"
        # K_LEFTARROW = 'ArrowLeft'
        # K_RIGHTARROW = 'ArrowRight'
        # K_DOWNARROW = 'ArrowDown'
        # K_PGDN = "PageDown"
      ]

      def self._parse_config
        entries = []
        CONFIG.each_with_index do |line, i|
          rb_const_name, dxopal_code, awt_const_name = line.split(/ +/)
          dxjruby_code = i

          entries << ConfigEntry.new(
            dxjruby_code:,
            rb_const_name:,
            dxopal_code:,
            awt_const_name:
          )
        end
        entries
      end

      # Define key code constants
      def self.init
        entries = _parse_config()

        entries.each { |entry|
          # Ruby
          const_set(
            entry.rb_const_name,
            KeyCode.new(entry.dxjruby_code, entry.dxopal_code)
          )

          # Java
          awt_code = Java::java.awt.event.KeyEvent.const_get(entry.awt_const_name)
          Java::dxjruby.input.KeyCodeMap.put(entry.dxjruby_code, awt_code)
        }
      end
    end
  end
end
