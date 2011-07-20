require 'connfu'

uri = URI.parse(ENV['CONNFU_URL'])
jid = "#{uri.userinfo}@#{uri.host}"
Connfu.setup jid, ENV['CONNFU_PASSWORD']

class AnswerExample
  include Connfu::Dsl

  on :incoming_call do |call|
    say('please record your greeting')
    hangup
  end
end

Connfu.start AnswerExample
