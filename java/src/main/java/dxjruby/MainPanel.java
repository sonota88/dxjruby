package dxjruby;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.List;
import java.util.concurrent.TimeUnit;

import javax.swing.JPanel;

import dxjruby.DXJRuby.OsType;
import dxjruby.DrawQueue.Command;
import dxjruby.util.DXJRubyException;

@SuppressWarnings("serial")
class MainPanel extends JPanel {

    private static boolean painting = false;

    public MainPanel(final int winW, final int winH, final Color bgcolor) {
        setBackground(bgcolor);
        setPreferredSize(new Dimension(winW, winH));
        setFocusable(true);

        addKeyListener(new KeyListenerImpl());
        addMouseMotionListener(new MouseMotionListenerImpl());
        addMouseListener(new MouseListenerImpl());
    }

    @Override
    public void paintComponent(final Graphics g) {
        final DrawQueue drawQueue = DrawQueue.takeSnapshot();
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

    // --------------------------------

    private static class KeyListenerImpl implements KeyListener {

        @Override
        public void keyTyped(KeyEvent e) {
            // ignore
        }

        @Override
        public void keyPressed(KeyEvent e) {
            Input.addToKeyEventQueue(e);
        }

        @Override
        public void keyReleased(KeyEvent e) {
            Input.addToKeyEventQueue(e);
        }

    }

    private static class MouseMotionListenerImpl implements MouseMotionListener {

      @Override
      public void mouseDragged(final MouseEvent e) {
          // ignore
      }

      @Override
      public void mouseMoved(final MouseEvent e) {
          Input.setMousePosition(e.getX(), e.getY());
      }

  }

    private static class MouseListenerImpl implements MouseListener {

        @Override
        public void mouseClicked(final MouseEvent e) {
            // ignore
        }

        @Override
        public void mousePressed(final MouseEvent e) {
            Input.addToMouseEventQueue(e);
        }

        @Override
        public void mouseReleased(final MouseEvent e) {
            Input.addToMouseEventQueue(e);
        }

        @Override
        public void mouseEntered(final MouseEvent e) {
            // ignore
        }

        @Override
        public void mouseExited(final MouseEvent e) {
            // ignore
        }

    }

}
