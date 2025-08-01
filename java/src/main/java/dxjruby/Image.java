package dxjruby;

import static dxjruby.util.Utils.toInt;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

import dxjruby.util.DXJRubyException;
import dxjruby.util.Utils;

public class Image {

    final BufferedImage img;

    private Image(final BufferedImage img) {
        this.img = img;
    }

    public static Image load(final String path) {
        final File file = new File(path);
        try {
            return new Image(ImageIO.read(file));
        } catch (IOException e) {
            throw new DXJRubyException(e);
        }
    }

    public static Image createBlank(final int w, final int h) {
        return new Image(
                new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB)
                );
    }

    public int getWidth() {
        return img.getWidth();
    }

    public int getHeight() {
        return img.getHeight();
    }

    public List<Integer> getPixel(
            final int x, final int y
            ) {
        final int[] rgba = new int[] { 0, 0, 0, 0 };
        img.getData().getPixel(x, y, rgba);

        return List.of(
                Integer.valueOf(rgba[3]), // a
                Integer.valueOf(rgba[0]), // r
                Integer.valueOf(rgba[1]), // g
                Integer.valueOf(rgba[2])  // b
                );
    }

    public void setPixel(
            final int x, final int y,
            final Color color
            ) {
        img.setRGB(x, y, color.getRGB());
    }

    public void line(
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);
                    g2.drawLine(
                            toInt(x1), toInt(y1),
                            toInt(x2), toInt(y2)
                            );
                    });
    }

    public void box(
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);
                    g2.drawRect(0, 0, toInt(x2 - x1), toInt(y2 - y1));
                    });
    }

    public void boxFill(
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);
                    g2.fillRect(0, 0, toInt(x2 - x1), toInt(y2 - y1));
                    });
    }

    public void circle(
            final double x, final double y,
            final double r,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);

                    final double x1 = x - r;
                    final double y1 = y - r;
                    final int diameter = toInt(r * 2);

                    g2.drawOval(toInt(x1), toInt(y1), diameter, diameter);
                    });
    }

    public void circleFill(
            final double x, final double y,
            final double r,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);

                    final double x1 = x - r;
                    final double y1 = y - r;
                    final int diameter = toInt(r * 2);

                    g2.fillOval(toInt(x1), toInt(y1), diameter, diameter);
                    });
    }

    public void triangle(
            final double x1, final double y1,
            final double x2, final double y2,
            final double x3, final double y3,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);

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

                    g2.drawPolyline(xs, ys, 3);
                    });
    }

    public void triangleFill(
            final double x1, final double y1,
            final double x2, final double y2,
            final double x3, final double y3,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> {
                    g2.setColor(color);

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
                    });
    }

    public BufferedImage getAwtImage() {
        return this.img;
    }

}
