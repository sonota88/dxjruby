package dxjruby;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;

import dxjruby.graphic.Drawer;
import dxjruby.util.DXJRubyException;
import dxjruby.util.Utils;

public class Image {

    private final BufferedImage img;

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

    /**
     * @return [a, r, g, b]
     */
    public List<Integer> getPixel(
            final int x, final int y
            ) {
        final int[] rgba = new int[] { 0, 0, 0, 0 };
        img.getRaster().getPixel(x, y, rgba);

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
                g2 -> Drawer.line(g2, x1, y1, x2, y2, color)
                );
    }

    public void box(
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> Drawer.box(g2, x1, y1, x2, y2, color)
                );
    }

    public void boxFill(
            final double x1, final double y1,
            final double x2, final double y2,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> Drawer.boxFill(g2, x1, y1, x2, y2, color)
                );
    }

    public void circle(
            final double x, final double y,
            final double r,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> Drawer.circle(g2, x, y, r, color)
                );
    }

    public void circleFill(
            final double x, final double y,
            final double r,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> Drawer.circleFill(g2, x, y, r, color)
                );
    }

    public void triangle(
            final double x1, final double y1,
            final double x2, final double y2,
            final double x3, final double y3,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> Drawer.triangle(g2, x1, y1, x2, y2, x3, y3, color)
                );
    }

    public void triangleFill(
            final double x1, final double y1,
            final double x2, final double y2,
            final double x3, final double y3,
            final Color color
            ) {
        Utils.withGraphics2D(
                img.getGraphics(),
                g2 -> Drawer.triangleFill(g2, x1, y1, x2, y2, x3, y3, color)
                );
    }

    public BufferedImage getAwtImage() {
        return this.img;
    }

}
