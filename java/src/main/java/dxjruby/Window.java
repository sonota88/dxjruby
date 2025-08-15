package dxjruby;

import static dxjruby.util.Utils.toInt;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Composite;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.util.function.Consumer;

import javax.swing.JFrame;

import dxjruby.DrawQueue.Command;
import dxjruby.graphic.Drawer;

public class Window {

    private static int width = 640;
    private static int height = 480;
    private static Color bgcolor = new Color(0, 0, 0);
    private static MainPanel mainPanel;
    private static final JFrame frame;

    static {
        frame = new JFrame();
    }

    public static void startGui() {
        frame.setLocationByPlatform(true);

        frame.setResizable(false);
        setCloseOperation(frame);

        mainPanel = new MainPanel(
                getWidth(),
                getHeight(),
                getBgcolor()
                );

        frame.add(mainPanel);
        frame.pack();

        frame.setVisible(true);
    }

    private static void setCloseOperation(final JFrame frame) {
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(final WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static void updateInputState() {
        final long tNow = System.nanoTime();
        Input.updateMouseState(tNow);
        Input.updateKeyState(tNow);
    }

    public static void requestPaint() {
        mainPanel.requestPaint();
    }

    public static String getCaption() {
        return frame.getTitle();
    }

    public static void setCaption(final String caption) {
        frame.setTitle(caption);
    }

    // --------------------------------

    public static void drawImage(
            final double x, final double y,
            final Image image,
            final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> {
                    final BufferedImage img = image.getAwtImage();
                    g2.drawImage(img, toInt(x), toInt(y), null);
                });
    }

    public static void drawEx(
            final double x, final double y,
            final Image image,
            final int z,
            final double cx, final double cy,
            final double scalex, final double scaley,
            final double angle,
            final int alpha
            ) {
        addToDrawQueue(
                z,
                g2 -> {
                    final AffineTransform atReset = g2.getTransform();
                    final Composite compReset = g2.getComposite();

                    final AffineTransform atTranslateRev =
                            AffineTransform.getTranslateInstance(
                                    (x + cx),
                                    (y + cy)
                            );

                    final AffineTransform atTranslate =
                            AffineTransform.getTranslateInstance(
                                    -(x + cx),
                                    -(y + cy)
                            );

                    final AffineTransform atRotate =
                            AffineTransform.getRotateInstance(
                                    Math.toRadians(angle)
                            );

                    final AffineTransform atScale =
                            AffineTransform.getScaleInstance(
                                    scalex, scaley
                            );

                    final AffineTransform at = new AffineTransform();
                    at.concatenate(atTranslateRev);
                    at.concatenate(atRotate);
                    at.concatenate(atScale);
                    at.concatenate(atTranslate);
                    g2.setTransform(at);

                    final float fAlpha = Integer.valueOf(alpha).floatValue() / 255.0F;
                    g2.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, fAlpha));

                    g2.drawImage(image.getAwtImage(), toInt(x), toInt(y), null);

                    g2.setTransform(atReset);
                    g2.setComposite(compReset);
                });
    }

    public static void drawFont(
            final double x, final double y, final String text,
            final dxjruby.Font font,
            // options
            final int z,
            final Color color
            ) {
        addToDrawQueue(
                z,
                g2 -> {
                    g2.setColor(color);

                    g2.setRenderingHint(
                            RenderingHints.KEY_TEXT_ANTIALIASING,
                            RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

                    final java.awt.Font awtFont = font.getAwtFont();
                    int fontHeight = g2.getFontMetrics(awtFont).getHeight();
                    g2.setFont(awtFont);
                    g2.drawString(text, toInt(x), toInt(y) + fontHeight);
                });
    }

    public static void drawLine(
            final double x1, final double y1,
            final double x2, final double y2,
            final Color c, final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> Drawer.line(g2, x1, y1, x2, y2, c)
                );
    }

    public static void drawBox(
            final double x1,
            final double y1,
            final double x2,
            final double y2,
            final Color color,
            final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> Drawer.box(g2, x1, y1, x2, y2, color)
                );
    }

    public static void drawBoxFill(
            final double x1,
            final double y1,
            final double x2,
            final double y2,
            final Color color,
            final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> Drawer.boxFill(g2, x1, y1, x2, y2, color)
                );
    }

    public static void drawCircle(
            final double x, final double y, final double r,
            final Color c, final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> Drawer.circle(g2, x, y, r, c)
                );
    }

    public static void drawCircleFill(
            final double x, final double y, final double r,
            final Color c, final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> Drawer.circleFill(g2, x, y, r, c)
                );
    }

    private static void addToDrawQueue(final int z, final Consumer<Graphics2D> func) {
        DrawQueue.add(z, new Command(func));
    }

    // --------------------------------

    public static int getWidth() {
        return width;
    }

    public static void setWidth(final int width) {
        Window.width = width;
    }

    public static int getHeight() {
        return height;
    }

    public static void setHeight(final int height) {
        Window.height = height;
    }

    public static Color getBgcolor() {
        return bgcolor;
    }

    public static void setBgcolor(final Color color) {
        Window.bgcolor = color;
    }

}
