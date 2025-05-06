package dxjruby;

import java.awt.Color;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JFrame;

public class DXJRuby {

    private static MainPanel mainPanel;
    public static final OsType OS_TYPE;

    static {
        OS_TYPE = OsType.from(System.getProperty("os.name"));
    }

    public void start() {
        final JFrame frame = new JFrame();

        frame.setLocation(0, 0);

        frame.setResizable(false);
        frame.setTitle("DXJRuby window title");
        setCloseOperation(frame);

        mainPanel = new MainPanel(
                Window.getWidth(),
                Window.getHeight()
                );

        frame.add(mainPanel);
        frame.pack();

        frame.setVisible(true);
    }

    public static void setCloseOperation(final JFrame frame) {
        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(final WindowEvent e) {
                System.exit(0);
            }
        });
    }

    public static Color toAwtColor(final int a, final int r, final int g, final int b) {
        return new Color(r, g, b, a);
    }

    public static Color toAwtColor(final int r, final int g, final int b) {
        return new Color(r, g, b);
    }

    // --------------------------------

    public static MainPanel getMainPanel() {
        return mainPanel;
    }

    // --------------------------------

    public enum OsType {

        LINUX,
        OTHER,
        ;

        public static OsType from(final String osName) {
            if (osName.startsWith("Linux")) {
                return LINUX;
            } else {
                return OTHER;
            }
        }

    }

}
