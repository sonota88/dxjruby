require 'dxjruby/remote_resource'

module DXJRuby
  class Sound < RemoteResource
    RemoteResource.add_class(Sound)

    # Load remote sound (called via Window.load_resources)
    def self._load(path_or_url)
      instance = new(path_or_url)
      [instance, nil]
    end

    DATA_URL_HEAD = "data:audio/wav;base64,"

    def initialize(path_or_url)
      if path_or_url.start_with?(DATA_URL_HEAD)
        b64str = path_or_url[DATA_URL_HEAD.size..]
        j_sound = Sound.j_Sound.create_sound_from_memory(b64str)
        _initialize("(data_url)", j_sound)
      else
        j_sound = Sound.j_Sound.create_sound(path_or_url)
        _initialize(path_or_url, j_sound)
      end
    end

    # path_or_url: Used in error message
    def _initialize(path_or_url, j_sound)
      @path_or_url = path_or_url
      @j_sound = j_sound

      set_volume(230)
    end

    ## attr_accessor :decoded

    # Play this sound
    #
    # DXRuby では Sound#loop_count でループを制御している
    # https://mirichi.github.io/dxruby-doc/api/Sound_23play.html
    def play(loop_ = false)
      @j_sound.play(loop_)
    end

    # Stop playing this sound (if playing)
    def stop
      @j_sound.stop()
    end

    # TODO: support for volume change using 'time' parameter
    def set_volume(volume, time=0)
      @j_sound.set_volume(volume)
    end

    private

    def self.j_Sound
      Java::dxjruby.Sound
    end
  end
end
