package dxjruby;

import dxjruby.sound.FileSound;

public class Sound {

    private Sound() {}

    public static FileSound createSound(
            final String path
            ) {
        return new FileSound(path);
    }

}
