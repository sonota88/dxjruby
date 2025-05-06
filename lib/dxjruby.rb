require 'java'

require File.expand_path(
          '../java/target/dxjruby-0.0.1-SNAPSHOT-jar-with-dependencies.jar',
          __dir__
        )

require 'dxjruby/constants/colors'
require 'dxjruby/window'
require 'dxjruby/version'

module DXJRuby
  include DXJRuby::Constants::Colors
end
