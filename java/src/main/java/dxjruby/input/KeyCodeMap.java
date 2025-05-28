package dxjruby.input;

import java.util.HashMap;
import java.util.Map;

import dxjruby.util.DXJRubyException;

public class KeyCodeMap {

    /** key: DXJRuby key code, value: AWT key code */
    private static final Map<Integer, Integer> map;

    static {
        map = new HashMap<>();
    }

    public static int toAwtKeyCode(final int dxjrubyCode) {
        final Integer code = Integer.valueOf(dxjrubyCode);
        if (map.containsKey(code)) {
            return map.get(code).intValue();
        } else {
          throw new DXJRubyException(
                  String.format(
                          "unknown key code (%d)",
                          Integer.valueOf(dxjrubyCode)
                          )
          );
        }
    }

    public static void put(final int dxjrubyCode, final int awtCode) {
        map.put(
                Integer.valueOf(dxjrubyCode),
                Integer.valueOf(awtCode)
                );
    }

}
