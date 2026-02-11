require "bundler/inline"

gemfile do
  source "https://rubygems.org"
  gem "wavefile", "1.1.2"
end

TWO_PI = 2 * Math::PI
SAMPLING_RATE = 44100
SEC_PER_SAMPLE = 1.0 / SAMPLING_RATE
MASTER_VOLUME = 0.1

class TimeTable
  def initialize(table)
    @table = table
    @table = @table.sort_by { |t, _| -t } # desc
  end

  def get(t)
    _, val = @table.find { |t_beg, _| t_beg <= t }
    val
  end
end

class WaveTable
  def initialize(values)
    avg = values.sum.to_f / values.size
    vs2 = values.map { |v| v - avg }
    max = vs2.map { |v| v.abs }.max
    @values = vs2.map { |v| v.to_f / max }
  end

  def get(x)
    ratio = x.to_f % 1
    i = (ratio * @values.size).floor
    @values[i]
  end

  def self.create_osc_tri(n)
    raise unless n % 2 == 0

    half = n / 2
    max = n - 1

    WaveTable.new(
      half.upto(max).to_a +
      max.downto(0).to_a +
      0.upto(half - 1).to_a
    )
  end

  def self.create_osc_saw(n)
    vs = (0...n).to_a
    WaveTable.new(vs)
  end

  def self.create_osc_sin(n)
    vs = (0...n)
      .map { |x|
        ratio = x.to_f / n
        Math.sin(TWO_PI * ratio)
      }
    WaveTable.new(vs)
  end
end

OSC_SIN_16 = WaveTable.create_osc_sin(16)
OSC_SIN_32 = WaveTable.create_osc_sin(32)

OSC_SAW_4 = WaveTable.create_osc_saw(4)
OSC_SAW_8 = WaveTable.create_osc_saw(8)

OSC_TRI_16 = WaveTable.create_osc_tri(16)
OSC_TRI_32 = WaveTable.create_osc_tri(32)

OSC_PULSE = WaveTable.new([1, 0])
OSC_PULSE_250 = WaveTable.new([1, 0, 0, 0])
OSC_PULSE_125 = WaveTable.new([1, 0, 0, 0, 0, 0, 0, 0])

def wav_write(file, samples, ch)
  buf_fmt = WaveFile::Format.new(ch, :float, SAMPLING_RATE)
  file_fmt = WaveFile::Format.new(ch, :pcm_16, SAMPLING_RATE)
  buf = WaveFile::Buffer.new(
    samples.map { |v| v *= MASTER_VOLUME },
    buf_fmt
  )

  WaveFile::Writer.new(file, file_fmt) do |writer|
    writer.write(buf)
  end
end

def wav_write_mono(file, samples)
  wav_write(file, samples, :mono)
end

def wav_write_stereo(file, samples_l, samples_r)
  n = [samples_l.size, samples_r.size].max
  samples = []
  n.times do |i|
    samples << samples_l[i] || 0
    samples << samples_r[i] || 0
  end

  wav_write(file, samples, :stereo)
end

# --------------------------------

class Channel
  def initialize(t0, fn_vol:, fn_inst:)
    reset!(t0)
    @fn_vol = fn_vol
    @fn_inst = fn_inst
  end

  def reset!(t0)
    @t0 = t0
  end

  def volume(t_now)
    @fn_vol.call(t_now - @t0)
  end

  def inst(t_now)
    @fn_inst.call(t_now - @t0)
  end

  def osc(t_now, x)
    _inst = inst(t_now)
    _inst.get(x)
  end
end

# -1c: 0 / 4c: 60 / 4a: 69 / 9g: 127
def to_hz(note_no)
  n = note_no - 69
  440.0 * (2.0 ** (n.to_f / 12))
end

def to_note_no_v2(oct, c)
  n = {
    "c" => 0,
  }[c]
  60 + (oct - 4) * 12 + n
end

def note_len_to_sec(bpm, len)
  60.0 / bpm * (4.0 / len)
end

def parse_mml(mml)
  cmds = mml.split(/ +/)

  cmds2 =
    cmds.map { |part|
      case
      when m = part.match(/^t(\d+)/)
        n = m[1].to_i
        [:bpm, n]
      when m = part.match(/^o(\d+)/)
        n = m[1].to_i
        [:oct, n]
      when m = part.match(/^([a-g])(\d+)/)
        note = m[1]
        len = m[2].to_i
        [:note, note, len]
      when m = part.match(/^r(\d+)/)
        len = m[1].to_i
        [:rest, len]
      else
        raise "unsupported (#{part})"
      end
    }
  cmds2 << [:end]

  t = 0.0
  bpm = 120

  events = []
  cmds2.each do |cmd|
    si = (t.to_f * SAMPLING_RATE).floor
    events << { t: t, si: si, cmd: cmd }

    case cmd
    in [:bpm, val]
      bpm = val
    in [:note, note, len]
      t += note_len_to_sec(bpm, len)
    in [:rest, len]
      t += note_len_to_sec(bpm, len)
    else
      ;
    end
  end

  dur_sec = events.last[:t]

  map_events = {}
  events.each do |event|
    si = event[:si]
    map_events[si] ||= []
    map_events[si] << event
  end

  [map_events, dur_sec]
end

def mml_to_samples(mml)
  map_events, dur_sec = parse_mml(mml)

  num_samples = (SAMPLING_RATE * dur_sec).floor
  f = 0
  x = 0.0 # cycle
  vol = 0.5
  t_on = 0.0 # note on
  oct = 4

  tt_vol = TimeTable.new([
    [0  , 1.0],
    [0.1, 0.5],
  ])

  tt_inst = TimeTable.new([
    [0   , OSC_PULSE],
    [0.05, OSC_PULSE_250],
  ])

  ch = Channel.new(
    0.0,
    fn_vol:  ->(t) { tt_vol.get(t) },
    fn_inst: ->(t) { tt_inst.get(t) }
  )

  samples = []
  num_samples.times do |si|
    t = si.to_f / SAMPLING_RATE

    if map_events.key?(si)
      evs = map_events.fetch(si)
      evs.each do |ev|
        cmd = ev[:cmd]
        case cmd
        in [:bpm, val]
          bpm = val
        in [:oct, val]
          oct = val
        in [:note, note, len]
          t_on = t
          ch.reset!(t)
          note_no = to_note_no_v2(oct, note)
          f = to_hz(note_no)
          x = 0.0
        in [:rest, len]
          t_on = nil
        in [:end]
          ;
        else
          raise "unsupported command (#{cmd.inspect})"
        end
      end
    end

    if t_on
      samples << ch.osc(t, x) * vol * ch.volume(t)
    else
      samples << 0.0
    end

    x_delta = f * SEC_PER_SAMPLE
    x += x_delta
  end

  samples
end

# --------------------------------

def make_s1
  dur_msec = 50
  dur_sec = dur_msec.to_f / 1000
  num_samples = (SAMPLING_RATE * dur_sec).floor
  f = 880

  x = 0.0 # cycle
  samples = []
  num_samples.times {
    v = OSC_TRI_32.get(x)
    samples << v
    x += f * SEC_PER_SAMPLE
  }

  samples
end

def make_bgm1
  bpm = "t160"
  seq1 = "o3 c8 o4 c8 o5 c8 o6 c8 r2"

  mml_l = [bpm, seq1, "r1"].join(" ")
  mml_r = [bpm, "r1", seq1].join(" ")

  samples_l = mml_to_samples(mml_l)
  samples_r = mml_to_samples(mml_r)

  [samples_l, samples_r]
end

samples = make_s1()
wav_write_mono("s1.wav", samples)

samples_l, samples_r = make_bgm1()
wav_write_stereo("bgm_2ch.wav", samples_l, samples_r)
