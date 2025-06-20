package dxjruby;

import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.util.List;

import dxjruby.input.MouseEventQueue;
import dxjruby.input.MouseEventQueue.DXJRubyMouseEvent;
import dxjruby.input.InputState;
import dxjruby.input.KeyEventQueue;
import dxjruby.input.KeyEventQueue.DXJRubyKeyEvent;

public class Input {

    private static final InputState state;
    private static final MouseEventQueue mouseEventQueue;
    private static final KeyEventQueue keyEventQueue;

    static {
        state = new InputState();
        mouseEventQueue = new MouseEventQueue();
        keyEventQueue = new KeyEventQueue();
    }

    public static void setMousePosition(final int x, final int y) {
        state.setMousePosition(x, y);
    }

    // --------------------------------
    // keyboard

    public static void updateKeyState(final long t) {
        final List<DXJRubyKeyEvent> evs = keyEventQueue.takeFrameEvents(t);
        state.updateKeyState(evs);
    }

    public static void addToKeyEventQueue(final KeyEvent ev) {
        keyEventQueue.add(ev);
    }

    public static boolean keyPushP(final int dxrubyKeyCode) {
        return state.keyPushP(dxrubyKeyCode);
    }

    public static boolean keyReleaseP(final int dxrubyKeyCode) {
        return state.keyReleaseP(dxrubyKeyCode);
    }

    public static boolean keyDownP(final int dxrubyKeyCode) {
        return state.keyDownP(dxrubyKeyCode);
    }

    // --------------------------------
    // mouse

    public static void updateMouseState(final long t) {
        final List<DXJRubyMouseEvent> evs = mouseEventQueue.takeFrameEvents(t);
        state.updateMouseState(evs);
    }

    public static void addToMouseEventQueue(final MouseEvent ev) {
        mouseEventQueue.add(ev);
    }

    public static boolean mousePushP(final int dxrubyMouseCode) {
        return state.mousePushP(dxrubyMouseCode);
    }

    public static boolean mouseReleaseP(final int dxrubyMouseCode) {
        return state.mouseReleaseP(dxrubyMouseCode);
    }

    public static boolean mouseDownP(final int dxrubyMouseCode) {
        return state.mouseDownP(dxrubyMouseCode);
    }

    @SuppressWarnings("boxing")
    public static int toAwtMouseButton(final int dxrubyMouseCode) {
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
        return state.getMouseX();
    }

    public static int getMouseY() {
        return state.getMouseY();
    }

    // --------------------------------

    private static class DXJRubyMouseCode {
        //                                 dxopal  dxruby
        static final int M_LBUTTON = 1; // 1       0
        static final int M_RBUTTON = 2; // 2       1
        static final int M_MBUTTON = 4; // 4       2
    }

}
