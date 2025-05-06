package dxjruby;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.swing.JPanel;

import dxjruby.DXJRuby.OsType;
import dxjruby.DrawQueue.Command;
import dxjruby.util.DXJRubyException;

@SuppressWarnings("serial")
class MainPanel extends JPanel {

    private static boolean painting = false;

    public MainPanel(final int winW, final int winH) {
        setBackground(Window.getBgcolor());
        this.setPreferredSize(new Dimension(winW, winH));
        this.setFocusable(true);
    }

    @Override
    public void paintComponent(final Graphics g) {
        final DrawQueue drawQueue = DrawQueue.getInstance();
        final List<Integer> sortedZs = drawQueue.getSortedZList();

        super.paintComponent(g);
        final Graphics2D g2 = (Graphics2D) g;
        for (Integer z : sortedZs) {
            final List<Command> cmds = drawQueue.getCommands(z);
            for (Command cmd : cmds) {
                cmd.execute(g2);
            }
        }
        g2.dispose();

        drawQueue.clear();
        painting = false;
    }

    void repaintSync() {
        painting = true;

        repaint();

        if (DXJRuby.OS_TYPE == OsType.LINUX) {
            /*
             * cpu - How do I cap my framerate at 60 fps in Java? - Stack Overflow
             * https://stackoverflow.com/questions/771206/how-do-i-cap-my-framerate-at-60-fps-in-java
             *
             * Make my java swing animation smoother in Linux - Stack Overflow
             * https://stackoverflow.com/questions/46580889/make-my-java-swing-animation-smoother-in-linux
             */
            Toolkit.getDefaultToolkit().sync();
        }

        try {
            while (painting) {
                TimeUnit.NANOSECONDS.sleep(100);
            }
        } catch (InterruptedException e) {
            throw new DXJRubyException(e);
        }
    }

}
