require 'connfu'

Connfu.setup ENV['CONNFU_URL'], ENV['CONNFU_PASSWORD']

class AnswerExample
  include Connfu::Dsl

  on :incoming_call do |call|
    say('please record your greeting')
    hangup
  end
end

Connfu.start AnswerExample
