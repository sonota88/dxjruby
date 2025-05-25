package dxjruby;

import org.jruby.RubyArray;

import dxjruby.sound.FileSound;
import dxjruby.sound.SoundEffect;

public class Sound {

    private Sound() {}

    public static FileSound createSound(
            final String path
            ) {
        return new FileSound(path);
    }

    public static SoundEffect createSoundEffect(
            final RubyArray<?> rbSamples
            ) {
        return new SoundEffect(rbSamples);
    }

}
