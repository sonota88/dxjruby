package dxjruby;

import static dxjruby.util.Utils.toInt;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.function.Consumer;

import javax.swing.JFrame;

import dxjruby.DrawQueue.Command;

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
        frame.setLocation(0, 0);

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

    public static void repaint() {
        mainPanel.requestPaint();
    }

    public static String getCaption() {
        return frame.getTitle();
    }

    public static void setCaption(final String caption) {
        frame.setTitle(caption);
    }

    // --------------------------------

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
                g2 -> {
                    g2.setColor(c);
                    enableAntiAlias(g2);

                    g2.drawLine(
                            toInt(x1), toInt(y1),
                            toInt(x2), toInt(y2)
                            );
                });
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
                g2 -> {
                    g2.setColor(color);
                    enableAntiAlias(g2);

                    final double width = x2 - x1;
                    final double height = y2 - y1;
                    g2.drawRect(toInt(x1), toInt(y1), toInt(width), toInt(height));
                });
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
                g2 -> {
                    g2.setColor(color);
                    enableAntiAlias(g2);

                    final double width = x2 - x1;
                    final double height = y2 - y1;
                    g2.fillRect(toInt(x1), toInt(y1), toInt(width), toInt(height));
                });
    }

    public static void drawCircle(
            final double x, final double y, final double r,
            final Color c, final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> {
                    g2.setColor(c);
                    enableAntiAlias(g2);

                    final double x1 = x - r;
                    final double y1 = y - r;
                    final int diameter = toInt(r * 2);

                    g2.drawOval(toInt(x1), toInt(y1), diameter, diameter);
                });
    }

    public static void drawCircleFill(
            final double x, final double y, final double r,
            final Color c, final int z
            ) {
        addToDrawQueue(
                z,
                g2 -> {
                    g2.setColor(c);
                    enableAntiAlias(g2);

                    final double x1 = x - r;
                    final double y1 = y - r;
                    final int diameter = toInt(r * 2);

                    g2.fillOval(toInt(x1), toInt(y1), diameter, diameter);
                });
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
