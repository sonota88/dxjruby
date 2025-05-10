require 'java'

require File.expand_path(
          '../java/target/dxjruby-0.0.2.jar',
          __dir__
        )

require 'dxjruby/constants/colors'
require 'dxjruby/input'
require 'dxjruby/window'
require 'dxjruby/version'

module DXJRuby
  include DXJRuby::Constants::Colors
end
