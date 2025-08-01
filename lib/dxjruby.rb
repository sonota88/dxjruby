require 'java'

require 'dxjruby/constants/colors'
require 'dxjruby/font'
require 'dxjruby/input'
require 'dxjruby/input/key_codes'
require 'dxjruby/image'
require 'dxjruby/sound'
require 'dxjruby/sound_effect'
require 'dxjruby/sprite'
require 'dxjruby/window'
require 'dxjruby/version'

if ENV.key?("DXJRUBY_JAR")
  require ENV["DXJRUBY_JAR"]
else
  require File.expand_path(
            "../java/target/dxjruby-#{DXJRuby::VERSION}.jar",
            __dir__
          )
end

DXJRuby::Input::KeyCodes.init

module DXJRuby
  include DXJRuby::Constants::Colors
  include DXJRuby::Input::KeyCodes
  include DXJRuby::Input::MouseCodes
  include DXJRuby::SoundEffect::WaveTypes

  def self.info
    cmd = ARGV.shift

    case cmd
    when "list-fonts"
      names = Java::dxjruby.Font.get_available_names()
      names.each { |name| puts name }
    else
      raise "invalid command (#{cmd})"
    end
  end
end

# `require 'dxjruby'` will automatically import names like `Window` to the
# toplevel (as `require 'dxruby'` does)
include DXJRuby
