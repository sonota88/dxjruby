package dxjruby;

import java.awt.Color;

public class DXJRuby {

    public static final OsType OS_TYPE;

    static {
        OS_TYPE = OsType.from(System.getProperty("os.name"));
    }

    public static Color toAwtColor(final int a, final int r, final int g, final int b) {
        return new Color(r, g, b, a);
    }

    public static Color toAwtColor(final int r, final int g, final int b) {
        return new Color(r, g, b);
    }

    // --------------------------------

    public enum OsType {

        LINUX,
        OTHER,
        ;

        public static OsType from(final String osName) {
            if (osName.startsWith("Linux")) {
                return LINUX;
            } else {
                return OTHER;
            }
        }

    }

}
