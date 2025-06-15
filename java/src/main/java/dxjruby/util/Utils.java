package dxjruby.util;

import java.awt.Graphics;
import java.awt.Graphics2D;
import java.util.function.Consumer;

public class Utils {

    public static int toInt(final double d) {
        return Double.valueOf(d).intValue();
    }

    public static void puts(final Object obj) {
        final String valStr;
        if (obj == null) {
            valStr = "null";
        } else {
            valStr = obj.toString();
        }

        System.out.println("java: " + valStr);
    }

    public static void withGraphics2D(final Graphics g, final Consumer<Graphics2D> func) {
        withGraphics2D((Graphics2D) g, func);
    }

    public static void withGraphics2D(final Graphics2D g2, final Consumer<Graphics2D> func) {
        func.accept(g2);
        g2.dispose();
    }

}
