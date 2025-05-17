package dxjruby.input;

import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

public class MouseEventQueue {

    private final Queue<DXJRubyMouseEvent> queue;

    public MouseEventQueue() {
        this.queue = new ConcurrentLinkedQueue<>();
    }

    public List<DXJRubyMouseEvent> takeFrameEvents(final long t) {
        final List<DXJRubyMouseEvent> frameEvents = new ArrayList<>();

        while (true) {
            final DXJRubyMouseEvent ev = this.queue.peek();

            if (ev == null) {
                // empty
                break;
            } else {
                if (ev.time() > t) {
                    break;
                }

                // move
                frameEvents.add(this.queue.remove());
            }
        }

        return frameEvents;
    }

    public void add(final MouseEvent ev) {
        final long t = System.nanoTime();
        this.queue.add(new DXJRubyMouseEvent(ev, t));
    }

    public record DXJRubyMouseEvent(
            MouseEvent awtEvent,
            long time
            ) {}

}
