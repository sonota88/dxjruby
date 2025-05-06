package dxjruby;

import java.awt.Graphics2D;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

public class DrawQueue {

    private static DrawQueue instance;

    static {
        instance = new DrawQueue();
    }

    /** key: z */
    private Map<Integer, List<Command>> map;

    DrawQueue() {
        this.map = new HashMap<>();
    }

    void TEST__add(final int z, final Command command) {
        _add(z, command);
    }

    private void _add(final int z, final Command command) {
        final Integer z2 = Integer.valueOf(z);
        if (!map.containsKey(z2)) {
            map.put(z2, new ArrayList<>());
        }
        map.get(z2).add(command);
    }

    public static void add(final int z, final Command command) {
        getInstance()._add(z, command);
    }

    public List<Integer> getSortedZList() {
        final List<Integer> zs = new ArrayList<>(map.keySet());
        Collections.sort(zs);
        return zs;
    }

    public List<Command> getCommands(final Integer z) {
        return map.get(z);
    }

    public void clear() {
        map.clear();
    }

    // --------------------------------

    public static DrawQueue getInstance() {
        return instance;
    }

    // --------------------------------

    public static class Command {

        private final Consumer<Graphics2D> func;

        public Command(final Consumer<Graphics2D> proc) {
            this.func = proc;
        }

        public void execute(final Graphics2D g2) {
            this.func.accept(g2);
        }

    }

}
