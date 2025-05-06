package dxjruby;

import static dxjruby.util.Utils.toInt;

import java.awt.Color;

import org.jruby.Ruby;
import org.jruby.RubyProc;
import org.jruby.runtime.builtin.IRubyObject;

import dxjruby.DrawQueue.Command;

public class Window {

    private static int width = 640;
    private static int height = 480;
    private static Color bgcolor = new Color(0, 0, 0);

    private static FpsManager fpsm;

    static {
        fpsm = new FpsManager();
    }

    /**
     * Game Loop and Key Input - How to Make a 2D Game in Java #2 - YouTube
     * https://www.youtube.com/watch?v=VpH33Uw-_0E
     */
    public static void startLoop(final RubyProc proc) {
        final Ruby runtime = proc.getRuntime();
        final IRubyObject[] args = new IRubyObject[] {};

        long tBaseLoop = System.nanoTime();
        long tBaseFrame = System.nanoTime();

        while (true) {
            {
                final long tNow = System.nanoTime();
                fpsm.delta += (tNow - tBaseLoop) / fpsm.spanPerFrame;
                tBaseLoop = tNow;
            }

            if (fpsm.delta > 1.0) {
                fpsm.delta -= 1.0;
                fpsm.count += 1;

                // update
                proc.call(runtime.getCurrentContext(), args);
                // repaint
                DXJRuby.getMainPanel().repaintSync();

                {
                    final long tNow = System.nanoTime();
                    final long spanDelta = tNow - tBaseFrame;
                    tBaseFrame = tNow;
                    fpsm.spanAcc += spanDelta;
                }
                if (fpsm.spanAcc >= 1_000_000_000) {
                    fpsm.spanAcc -= 1_000_000_000;
                    fpsm.realFps = fpsm.count;
                    fpsm.count = 0;
                    // Utils.puts("real fps=" + fpsm.realFps);
                }
            }
        }
    }

    public static double getFps() {
        return fpsm.getFps();
    }

    public static int getRealFps() {
        return fpsm.realFps;
    }

    // --------------------------------

    public static void drawCircleFill(
            final double x, final double y, final double r,
            final Color c, final int z
            ) {
        DrawQueue.add(
                z,
                new Command(g2 -> {
                    g2.setColor(c);

                    final double x1 = x - r;
                    final double y1 = y - r;

                    final int diameter = toInt(r * 2);

                    g2.fillOval(toInt(x1), toInt(y1), diameter, diameter);
                }));
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

    // --------------------------------

    private static class FpsManager {

        private int fps = 60;
        double spanPerFrame;
        double delta = 0;

        int realFps;
        int count = 0;
        long spanAcc = 0; // accumulated

        FpsManager() {
            changeFps(this.fps);
        }

        public double getFps() {
            return this.fps;
        }

        public void changeFps(final int fps) {
            this.fps = fps;
            this.realFps = this.fps;
            this.spanPerFrame = 1_000_000_000.0 / this.fps;
        }

    }

}
