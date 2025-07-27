require 'dxjruby/remote_resource'

module DXJRuby
  class Sound < RemoteResource
    RemoteResource.add_class(Sound)

    # Load remote sound (called via Window.load_resources)
    def self._load(path_or_url)
      instance = new(path_or_url)
      [instance, nil]
    end

    def initialize(path_or_url)
      @path_or_url = path_or_url  # Used in error message
      @j_sound = Sound.j_Sound.create_sound(@path_or_url)
      set_volume(230)
    end

    ## attr_accessor :decoded

    # Play this sound
    # TODO: loop_
    def play(loop_ = false)
      @j_sound.play()
    end

    ## # Stop playing this sound (if playing)
    ## def stop

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
