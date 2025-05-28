package dxjruby.input;

import java.awt.event.MouseEvent;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import dxjruby.Input;
import dxjruby.input.MouseEventQueue.DXJRubyMouseEvent;

public class InputState {

    private static int mouseX = 0;
    private static int mouseY = 0;

    private final Set<Integer> mouseDownSet;
    private final Set<Integer> mousePressedSet;
    private final Set<Integer> mouseReleasedSet;

    public InputState() {
        this.mouseDownSet = new HashSet<>();
        this.mousePressedSet = new HashSet<>();
        this.mouseReleasedSet = new HashSet<>();
    }

    public void setMousePosition(final int x, final int y) {
        mouseX = x;
        mouseY = y;
    }

    public void updateMouseState(final List<DXJRubyMouseEvent> evs) {
        // down set ... no need to reset
        this.mousePressedSet.clear();
        this.mouseReleasedSet.clear();

        for (DXJRubyMouseEvent ev : evs) {
            final MouseEvent awtEvent = ev.awtEvent();

            switch (awtEvent.getID()) {
            case MouseEvent.MOUSE_PRESSED:
                onMousePressed(awtEvent);
                break;
            case MouseEvent.MOUSE_RELEASED:
                onMouseReleased(awtEvent);
                break;
            }
        }
    }

    private void onMousePressed(final MouseEvent event) {
        final Integer mouseCode = Integer.valueOf(event.getButton());

        final boolean pressed = this.mouseDownSet.contains(mouseCode);
        if (pressed) {
            // no change
        } else {
            this.mouseDownSet.add(mouseCode);
            this.mousePressedSet.add(mouseCode);
        }
    }

    private void onMouseReleased(final MouseEvent event) {
        final Integer mouseCode = Integer.valueOf(event.getButton());

        final boolean pressed = this.mouseDownSet.contains(mouseCode);
        if (pressed) {
            this.mouseDownSet.remove(mouseCode);
            this.mouseReleasedSet.add(mouseCode);
        } else {
            // no change
        }
    }

    public boolean mousePushP(final int dxrubyMouseCode) {
        final int awtButton = Input.toAwtMouseButton(dxrubyMouseCode);

        return this.mousePressedSet.contains(
                Integer.valueOf(awtButton));
    }

    public boolean mouseReleaseP(final int dxrubyMouseCode) {
        final int awtButton = Input.toAwtMouseButton(dxrubyMouseCode);

        return this.mouseReleasedSet.contains(
                Integer.valueOf(awtButton));
    }

    public boolean mouseDownP(final int dxrubyMouseCode) {
        final int awtButton = Input.toAwtMouseButton(dxrubyMouseCode);

        return this.mouseDownSet.contains(
                Integer.valueOf(awtButton));
    }

    // --------------------------------

    public int getMouseX() {
        return mouseX;
    }

    public int getMouseY() {
        return mouseY;
    }

}
