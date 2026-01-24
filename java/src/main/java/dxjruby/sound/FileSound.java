package dxjruby.sound;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.UnsupportedAudioFileException;

import dxjruby.util.DXJRubyException;

public class FileSound extends SoundBase {

    public FileSound(final String path) {
        final File file = new File(path);
        final AudioData audioData = readAudioData(file);

        init(audioData);
    }

    public FileSound(final byte[] byteArray) {
        final AudioData audioData = readAudioData(byteArray);

        init(audioData);
    }

    private static AudioData readAudioData(final File file) {
        try (
                final AudioInputStream ais = AudioSystem.getAudioInputStream(file);
        ) {
            return readAudioData(ais);
        } catch (IOException e1) {
            throw new DXJRubyException(e1);
        } catch (UnsupportedAudioFileException e2) {
            throw new DXJRubyException(e2);
        }

    }

    private static AudioData readAudioData(final byte[] byteArray) {
        try (
                final InputStream is = new ByteArrayInputStream(byteArray);
                final AudioInputStream ais = AudioSystem.getAudioInputStream(is);
        ) {
            return readAudioData(ais);
        } catch (IOException e1) {
            throw new DXJRubyException(e1);
        } catch (UnsupportedAudioFileException e2) {
            throw new DXJRubyException(e2);
        }
    }

    private static AudioData readAudioData(final AudioInputStream ais) throws IOException {
        final AudioFormat format = ais.getFormat();

        final byte[] buf = new byte[1024];
        final List<Byte> byteList = new ArrayList<>(1024);

        while (true) {
            int n;
                n = ais.read(buf);
            if (n == -1) {
                break;
            } else {
                for (int i = 0; i < n; i++) {
                    byteList.add(Byte.valueOf(buf[i]));
                }
            }
        }
        return new AudioData(toArray(byteList), format);
    }

    private static byte[] toArray(final List<Byte> byteList) {
        final byte[] byteArray = new byte[byteList.size()];
        for (int i = 0; i < byteList.size(); i++) {
            byteArray[i] = byteList.get(i).byteValue();
        }
        return byteArray;
    }

}
