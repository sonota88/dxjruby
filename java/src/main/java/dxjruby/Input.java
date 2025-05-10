package dxjruby;

public class Input {

    private static int mouseX = 0;
    private static int mouseY = 0;

    public static void setMousePosition(final int x, final int y) {
        mouseX = x;
        mouseY = y;
    }

    // --------------------------------

    public static int getMouseX() {
        return mouseX;
    }

    public static int getMouseY() {
        return mouseY;
    }

}
