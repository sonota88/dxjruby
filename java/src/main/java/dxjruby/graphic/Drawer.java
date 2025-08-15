package dxjruby.graphic;

import static dxjruby.util.Utils.toInt;

import java.awt.Color;
import java.awt.Graphics2D;

public class Drawer {

    public static void line(
            final Graphics2D g2,
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        g2.drawLine(
                toInt(x1), toInt(y1),
                toInt(x2), toInt(y2)
                );
    }

    public static void box(
            final Graphics2D g2,
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        final double width = x2 - x1;
        final double height = y2 - y1;
        g2.drawRect(toInt(x1), toInt(y1), toInt(width), toInt(height));
    }

    public static void boxFill(
            final Graphics2D g2,
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        final double width = x2 - x1;
        final double height = y2 - y1;
        g2.fillRect(toInt(x1), toInt(y1), toInt(width), toInt(height));
    }

    public static void circle(
            final Graphics2D g2,
            final double x, final double y,
            final double r,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        final double x1 = x - r;
        final double y1 = y - r;
        final int diameter = toInt(r * 2);

        g2.drawOval(toInt(x1), toInt(y1), diameter, diameter);
    }

    public static void circleFill(
            final Graphics2D g2,
            final double x, final double y,
            final double r,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        final double x1 = x - r;
        final double y1 = y - r;
        final int diameter = toInt(r * 2);

        g2.fillOval(toInt(x1), toInt(y1), diameter, diameter);
    }

    public static void triangle(
            final Graphics2D g2,
            final double x1, final double y1,
            final double x2, final double y2,
            final double x3, final double y3,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        final int[] xs = new int[] {
                toInt(x1),
                toInt(x2),
                toInt(x3)
        };
        final int[] ys = new int[] {
                toInt(y1),
                toInt(y2),
                toInt(y3)
        };

        g2.drawPolygon(xs, ys, 3);
    }

    public static void triangleFill(
            final Graphics2D g2,
            final double x1, final double y1,
            final double x2, final double y2,
            final double x3, final double y3,
            final Color color
            ) {
        g2.setColor(color);
        enableAntiAlias(g2);

        final int[] xs = new int[] {
                toInt(x1),
                toInt(x2),
                toInt(x3)
        };
        final int[] ys = new int[] {
                toInt(y1),
                toInt(y2),
                toInt(y3)
        };

        g2.fillPolygon(xs, ys, 3);
    }

    /**
     * <pre>
     * antialias
     * DXRuby: disabled
     * DXOpal: enabled
     * </pre>
     */
    private static void enableAntiAlias(final Graphics2D g2) {
        /*
        g2.setRenderingHint(
                RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON
        );
        */
    }

}
