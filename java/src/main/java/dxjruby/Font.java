package dxjruby;

import java.awt.FontFormatException;
import java.awt.GraphicsEnvironment;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import dxjruby.util.DXJRubyException;

public class Font {

    /**
     * <li>key: CSS generic-family name
     * <li>value: Java generic-family name
     * 
     * <p>https://developer.mozilla.org/en-US/docs/Web/CSS/font-family
     */
    public static final Map<String, String> GENERIC_FAMILY_MAP;

    static {
        GENERIC_FAMILY_MAP = Map.of(
                "sans-serif", java.awt.Font.SANS_SERIF,
                "serif", java.awt.Font.SERIF,
                "monospace", java.awt.Font.MONOSPACED
                );
    }

    private final String name;
    private final int size;
    private final java.awt.Font awtFont;

    public Font(final String name, final int size) {
        this.name = name;
        this.size = size;
        this.awtFont = new java.awt.Font(name, java.awt.Font.PLAIN, size);
    }

    public static List<String> install(final String path) {
        final GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        final File file = new File(path);

        final java.awt.Font font;
        try {
            font = java.awt.Font.createFont(
                    java.awt.Font.TRUETYPE_FONT,
                    file
                    );
        } catch (IOException | FontFormatException e) {
            throw new DXJRubyException(e);
        }

        ge.registerFont(font);

        return List.of(font.getName());
    }

    public static List<String> getAvailableNames() {
        final String[] names = GraphicsEnvironment
                .getLocalGraphicsEnvironment()
                .getAvailableFontFamilyNames();

        return Arrays.asList(names);
    }

    // --------------------------------

    public String getName() {
        return name;
    }

    public int getSize() {
        return size;
    }

    public java.awt.Font getAwtFont() {
        return this.awtFont;
    }

}
