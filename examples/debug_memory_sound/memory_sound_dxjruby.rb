require "base64"
require "stringio"
require "wavefile"

class MemorySound
  SAMPLING_RATE = 44100

  attr_reader :bin

  def initialize(bin)
    @bin = bin
  end

  def self._to_wav(samples)
    buf_fmt = WaveFile::Format.new(:mono, :float, SAMPLING_RATE)
    file_fmt = WaveFile::Format.new(:mono, :pcm_16, SAMPLING_RATE)
    buf = WaveFile::Buffer.new(samples, buf_fmt)

    sio = StringIO.new(String.new(encoding: Encoding::BINARY))
    WaveFile::Writer.new(sio, file_fmt) do |writer|
      writer.write(buf)
    end

    sio.string
  end

  def self.generate(duration_msec)
    dur_sec = duration_msec.to_f / 1000
    num_samples = dur_sec.to_f * SAMPLING_RATE

    samples = [] # Float の配列。値の範囲は -1.0 <= ... <= 1.0
    (0...num_samples).each do |i|
      ratio = i.to_f / num_samples
      t_sec = dur_sec * ratio
      samples << yield(i, t_sec)
    end

    bin = _to_wav(samples)
    MemorySound.new(bin)
  end

  def base64str
    Base64.strict_encode64(@bin)
  end
end

def sound_register_from_memory(name, mem_sound)
  Sound.register(name, "data:audio/wav;base64," + mem_sound.base64str)
end
