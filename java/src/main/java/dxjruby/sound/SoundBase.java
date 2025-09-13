package dxjruby.sound;

import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.DataLine;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineEvent;
import javax.sound.sampled.LineListener;
import javax.sound.sampled.LineUnavailableException;

public abstract class SoundBase {

    protected AudioData getAudioData() {
        return this.audioData;
    };

    private AudioData audioData;
    private int volume = 255; // 0<=..<=255
    private Clip clip;

    protected void init(AudioData audioData) {
        this.audioData = audioData;

        // 初回再生時の遅延防止
        createClip(getAudioData());
    }

    public void play() {
        this.clip = createClip(getAudioData());

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

    public void stop() {
        if (this.clip != null) {
            this.clip.stop();
            this.clip.close();
        }
    }

    private final static Clip createClip(final AudioData audioData) {
        final DataLine.Info info = new DataLine.Info(Clip.class, audioData.format());

        final Clip clip;
        try {
            clip = (Clip) AudioSystem.getLine(info);
            clip.open(
                    audioData.format(),
                    audioData.bytes(),
                    0,
                    audioData.bytes().length
                    );
        } catch (LineUnavailableException e) {
            throw new RuntimeException(e);
        }

        return clip;
    }

    private float toDecibel(final int volume) {
        final float normalized = (volume > 255 ? 255 : volume) / 255.0f;
        return (normalized - 1.0f) * 96f;
    }

    // --------------------------------

      public void setVolume(final int volume) {
          this.volume = volume;
      }

}
