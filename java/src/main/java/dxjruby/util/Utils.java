package dxjruby.util;

public class Utils {

    public static int toInt(final double d) {
        return Double.valueOf(d).intValue();
    }

    public static void puts(final Object obj) {
        String valStr;
        if (obj == null) {
            valStr = "null";
        } else {
            valStr = obj.toString();
        }

        System.out.println("java: " + valStr);
    }

}
