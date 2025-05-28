package dxjruby.input;

import java.awt.event.KeyEvent;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;

public class KeyEventQueue {

    private final Queue<DXJRubyKeyEvent> queue;

    public KeyEventQueue() {
        this.queue = new ConcurrentLinkedQueue<>();
    }

    public List<DXJRubyKeyEvent> takeFrameEvents(final long t) {
        final List<DXJRubyKeyEvent> frameEvents = new ArrayList<>();

        while (true) {
            final DXJRubyKeyEvent ev = this.queue.peek();

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

    public void add(final KeyEvent ev) {
        final long t = System.nanoTime();
        this.queue.add(new DXJRubyKeyEvent(ev, t));
    }

    public record DXJRubyKeyEvent(
            KeyEvent awtEvent,
            long time
            ) {}

}
