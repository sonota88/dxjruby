package dxjruby.sound;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineEvent;
import javax.sound.sampled.LineListener;
import javax.sound.sampled.LineUnavailableException;

import dxjruby.util.DXJRubyException;

public class FileSound extends SoundBase {

    private final AudioData audioData;
    private int volume; // 0<=..<=255

    public FileSound(final String path) {
        final File file = new File(path);
        this.audioData = readAudioData(file);

        // 初回再生時の遅延防止
        createClip(this.audioData);
    }

    @Override
    public void play() {
        final AudioData adata = this.audioData;
        final Clip clip = createClip(adata);

        final FloatControl ctrl = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);

        float db = toDecibel(volume);
        if (db < ctrl.getMinimum()) {
            db = ctrl.getMinimum();
        } else if (db > ctrl.getMaximum()) {
            db = ctrl.getMaximum();
        }

        ctrl.setValue(db);

        final LineListener lineListener = new LineListener() {
            @Override
            public void update(LineEvent event) {
                if (event.getType() == LineEvent.Type.STOP) {
                    clip.close();
                }
            }};
        clip.addLineListener(lineListener);

        clip.setFramePosition(0);
        clip.start();
    }

    private float toDecibel(final int volume) {
        final float normalized = (volume > 255 ? 255 : volume) / 255.0f;
        return (normalized - 1.0f) * 96f;
    }

    private final static Clip createClip(final AudioData adata) {
        final DataLine.Info info = new DataLine.Info(Clip.class, adata.format());
        final Clip clip;
        try {
            clip = (Clip) AudioSystem.getLine(info);
            clip.open(adata.format(), adata.bytes(), 0, adata.bytes().length);
        } catch (LineUnavailableException e) {
            throw new RuntimeException(e);
        }
        return clip;
    }

    private static AudioData readAudioData(final File file) {
        try (
                final AudioInputStream ais = AudioSystem.getAudioInputStream(file);
        ) {
            final AudioFormat format = ais.getFormat();

            final byte[] buf = new byte[1024];
            final List<Byte> byteList = new ArrayList<>();

            while (true) {
                final int n = ais.read(buf);
                if (n == -1) {
                    break;
                } else {
                    for (int i = 0; i < n; i++) {
                        byteList.add(Byte.valueOf(buf[i]));
                    }
                }
            }
            return new AudioData(toArray(byteList), format);
        } catch (Exception e) {
            throw new DXJRubyException(e);
        }
    }

    private static byte[] toArray(final List<Byte> byteList) {
        final byte[] byteArray = new byte[byteList.size()];
        for (int i = 0; i < byteList.size(); i++) {
            byteArray[i] = byteList.get(i).byteValue();
        }
        return byteArray;
    }

    // --------------------------------

    public void setVolume(final int volume) {
        this.volume = volume;
    }

}
