package dxjruby.sound;

import javax.sound.sampled.AudioFormat;

record AudioData (
        byte[] bytes,
        AudioFormat format
          ) {}
