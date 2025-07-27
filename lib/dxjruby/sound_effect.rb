module DXJRuby
  # User-generated sound
  #
  # Example:
  #   v = 80
  #   SoundEffect.register(:sound1, 4000, WAVE_RECT, 5000) do
  #     v = v - 0.03
  #     [rand(300), v]
  #   end
  class SoundEffect < Sound
    RemoteResource.add_class(SoundEffect)

    module WaveTypes
      WAVE_SIN = :sine
      WAVE_SAW = :sawtooth
      WAVE_TRI = :triangle
      WAVE_RECT = :square
    end

    OSCILLATORS = {}

    OSCILLATORS[WaveTypes::WAVE_SIN] = ->(phase){
      Math.sin(2 * Math::PI * phase)
    }

    OSCILLATORS[WaveTypes::WAVE_SAW] = ->(phase){
      phase * 2 - 1
    }

    OSCILLATORS[WaveTypes::WAVE_TRI] = ->(phase){
      slope = 4
      case
      when phase < 0.25 then  slope * phase +  0
      when phase < 0.75 then -slope * phase +  2
      else                    slope * phase + -4
      end
    }

    OSCILLATORS[WaveTypes::WAVE_RECT] = ->(phase){
      phase < 0.5 ? 1.0 : -1.0
    }

    # time : Total number of ticks
    #   When resolution=1000(default), `time` is equivalent to the 
    #   total length of the sound in milliseconds.
    # wave_type : Type of wave form
    # resolution : Number of ticks per second
    # block : Should return [freq(0~44100), volume(0~255)]
    def self._load(time, wave_type=WAVE_RECT, resolution=1000, &block)
      instance = new(time, wave_type, resolution, block)
      [instance, nil]
    end

    def initialize(time, wave_type, resolution, block)
      osc = OSCILLATORS.fetch(wave_type)

      srate = 44100
      num_samples = (srate * (time / 1000.0)).floor
      samples = []

      res_i = 0.0
      res_i_prev = 0.0
      res_frame_msec = (1.0 / resolution) * 1000

      freq = nil
      vol = nil
      num_samples.times do |i|
        msec = i.to_f * 1000 / srate
        res_i = msec / res_frame_msec

        if i == 0 || (res_i.floor - res_i_prev.floor > 0)
          _freq, _vol = block.call
          freq = _freq.clamp(0, 44100)
          vol = _vol.clamp(0, 255)

          res_i_prev = res_i
        end

        spc = srate.to_f / freq # samples per cycle
        phase = (i % spc) / spc

        v = osc.call(phase)

        samples[i] = v * (vol.to_f / 255.0)
      end

      @j_sound_effect = Java::dxjruby.Sound.create_sound_effect(samples)
    end

    def play
      @j_sound_effect.play()
    end

    ## def add(wave_type=WAVE_RECT, resolution=1000)
  end
end
