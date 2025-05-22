package dxjruby.input;

import java.awt.event.MouseEvent;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import dxjruby.Input;
import dxjruby.input.MouseEventQueue.DXJRubyMouseEvent;

public class InputState {

    private final Set<Integer> mouseDownSet;
    private final Set<Integer> mousePressedSet;
    private final Set<Integer> mouseReleasedSet;

    public InputState() {
        this.mouseDownSet = new HashSet<>();
        this.mousePressedSet = new HashSet<>();
        this.mouseReleasedSet = new HashSet<>();
    }

    public void updateMouseState(final List<DXJRubyMouseEvent> evs) {
        // down set ... no need to reset
        this.mousePressedSet.clear();
        this.mouseReleasedSet.clear();

        for (DXJRubyMouseEvent ev : evs) {
            final MouseEvent awtEvent = ev.awtEvent();

            switch (awtEvent.getID()) {
            case MouseEvent.MOUSE_PRESSED:
                mousePressed(awtEvent);
                break;
            case MouseEvent.MOUSE_RELEASED:
                mouseReleased(awtEvent);
                break;
            }
        }
    }

    private void mousePressed(final MouseEvent event) {
        final Integer mouseCode = Integer.valueOf(event.getButton());

        final boolean pressed = this.mouseDownSet.contains(mouseCode);
        if (pressed) {
            // no change
        } else {
            this.mouseDownSet.add(mouseCode);
            this.mousePressedSet.add(mouseCode);
        }
    }

    private void mouseReleased(final MouseEvent event) {
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

}
