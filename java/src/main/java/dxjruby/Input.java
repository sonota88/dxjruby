package dxjruby;

import java.awt.event.MouseEvent;
import java.util.List;

import dxjruby.input.MouseEventQueue;
import dxjruby.input.MouseEventQueue.DXJRubyMouseEvent;
import dxjruby.input.InputState;

public class Input {

    private static final InputState state;
    private static final MouseEventQueue mouseEventQueue;

    static {
        state = new InputState();
        mouseEventQueue = new MouseEventQueue();
    }

    private static int mouseX = 0;
    private static int mouseY = 0;

    public static void setMousePosition(final int x, final int y) {
        mouseX = x;
        mouseY = y;
    }

    public static void updateMouseState(final long t) {
        final List<DXJRubyMouseEvent> evs = mouseEventQueue.takeFrameEvents(t);
        state.updateMouseState(evs);
    }

    public static void addToMouseEventQueue(final MouseEvent ev) {
        mouseEventQueue.add(ev);
    }

    public static boolean mousePushP(int dxrubyMouseCode) {
        return state.mousePushP(dxrubyMouseCode);
    }

    public static boolean mouseReleaseP(int dxrubyMouseCode) {
        return state.mouseReleaseP(dxrubyMouseCode);
    }

    public static boolean mouseDownP(final int dxrubyMouseCode) {
        return state.mouseDownP(dxrubyMouseCode);
    }

    @SuppressWarnings("boxing")
    public static int toAwtMouseButton(int dxrubyMouseCode) {
        switch (dxrubyMouseCode) {
        case DXJRubyMouseCode.M_LBUTTON:
            return MouseEvent.BUTTON1;
        case DXJRubyMouseCode.M_RBUTTON:
            return MouseEvent.BUTTON3;
        case DXJRubyMouseCode.M_MBUTTON:
            return MouseEvent.BUTTON2;
        default:
            throw new RuntimeException(
                    String.format("unknown DXRuby mouse code (%s)", dxrubyMouseCode));
        }
    }

    // --------------------------------

    public static int getMouseX() {
        return mouseX;
    }

    public static int getMouseY() {
        return mouseY;
    }

    // --------------------------------

    private static class DXJRubyMouseCode {
        //                                 dxopal  dxruby
        static final int M_LBUTTON = 1; // 1       0
        static final int M_RBUTTON = 2; // 2       1
        static final int M_MBUTTON = 4; // 4       2
    }

}
