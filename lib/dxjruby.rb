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
  proj_dir = File.expand_path("..", __dir__)
  jar_path_candidates = [
    File.join(proj_dir, "dxjruby-#{DXJRuby::VERSION}.jar"),
    File.join(proj_dir, "java/target/dxjruby-#{DXJRuby::VERSION}.jar"), # for develop
  ]
  jar_path = jar_path_candidates.find { |jar_path| File.exist?(jar_path) }
  if jar_path
    require jar_path
  else
    raise "jar file not found"
  end
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

  def self.shape_antialias_enabled=(enabled)
    Java::dxjruby.DXJRuby.shapeAntialiasEnabled = enabled
  end

  def self.shape_antialias_enabled
    Java::dxjruby.DXJRuby.shapeAntialiasEnabled
  end
end

# `require 'dxjruby'` will automatically import names like `Window` to the
# toplevel (as `require 'dxruby'` does)
include DXJRuby
