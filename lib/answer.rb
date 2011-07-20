require 'connfu'

uri = URI.parse(ENV['CONNFU_URL'])
jid = "#{uri.userinfo}@#{uri.host}"
Connfu.setup jid, ENV['CONNFU_PASSWORD']

class AnswerExample
  include Connfu::Dsl

  on :offer do |call|
    say('please record your greeting')
    hangup
  end
end

Connfu.start AnswerExample
