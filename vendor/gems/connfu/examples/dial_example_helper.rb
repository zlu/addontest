#!/usr/bin/env ruby
require File.expand_path('../environment', __FILE__)

class DialExampleHelper
  include Connfu::Dsl

  on :offer do |call|
    answer
  end
end

Connfu.start DialExampleHelper