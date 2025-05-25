package dxjruby.sound;

import javax.sound.sampled.AudioFormat;

import org.jruby.RubyArray;

public class SoundEffect extends SoundBase {

    private static AudioFormat AUDIO_FORMAT = new AudioFormat(
            /* sampling rate */ 44100,
            /* bit depth */ 16,
            /* num channels */ 1,
            /* signed */ true,
            /* big endian */ false
      );

    public SoundEffect(final RubyArray<?> rbSamples) {
        final AudioData audioData = createAudioData(rbSamples);

        init(audioData);
    }

    private AudioData createAudioData(final RubyArray<?> rbSamples) {
        final byte[] samples = new byte[rbSamples.size() * 2];

        final double full = Math.pow(2, 16) - 1;
        final double half = Math.pow(2, 15);

        for (int i = 0; i < rbSamples.size(); i++) {
            final int i2 = i * 2;
            @SuppressWarnings("boxing")
            final double val = (double) rbSamples.get(i);

            final int intvalH =
                    Double.valueOf(
                            (
                                    ((val + 1.0) / 2.0) // 0<=..<=1
                                    * full // 0<=..<=2^16-1
                            )
                            - half // -2^15<=..<=(2^15)-1
                    )
                    .intValue();
            final int intvalL = intvalH;
            samples[i2 + 0] = (byte) (intvalL & 0x00ff);
            samples[i2 + 1] = (byte) ((intvalH >> 8) & 0x00ff);
        }

        return new AudioData(samples, AUDIO_FORMAT);
    }

}
