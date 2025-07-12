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

import javax.swing.JPanel;

import dxjruby.DXJRuby.OsType;
import dxjruby.DrawQueue.Command;

@SuppressWarnings("serial")
class MainPanel extends JPanel {

    private static boolean painting = false;
    private DrawQueue drawQueueSnapshot = new DrawQueue();

    public MainPanel(final int winW, final int winH, final Color bgcolor) {
        setBackground(bgcolor);
        setPreferredSize(new Dimension(winW, winH));
        setFocusable(true);
        setOpaque(false);

        addKeyListener(new KeyListenerImpl());
        addMouseMotionListener(new MouseMotionListenerImpl());
        addMouseListener(new MouseListenerImpl());
    }

    @Override
    public void paintComponent(final Graphics g) {
        final List<Integer> sortedZs = drawQueueSnapshot.getSortedZList();

        super.paintComponent(g);
        final Graphics2D g2 = (Graphics2D) g;

        g2.setColor(Window.getBgcolor());
        g2.fillRect(0, 0, Window.getWidth(), Window.getHeight());

        for (Integer z : sortedZs) {
            final List<Command> cmds = drawQueueSnapshot.getCommands(z);
            for (Command cmd : cmds) {
                cmd.execute(g2);
            }
        }
        g2.dispose();

        painting = false;
    }

    void requestPaint() {
        if (painting) {
            // skip painting
            DrawQueue.takeSnapshot();
            return;
        } else {
            // 描画処理の最中は this.drawQueue を更新しないこと
            drawQueueSnapshot = DrawQueue.takeSnapshot();
        }

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
