require 'connfu'

uri = URI.parse(ENV['CONNFU_URL'])
jid = "#{uri.userinfo}@#{uri.host}"
Connfu.setup jid, ENV['CONNFU_PASSWD']

class AnswerExample
  include Connfu::Dsl

  on :offer do |call|
    answer
    say('i am answering your call even though i am just a robot')
    hangup
  end
end

Connfu.start AnswerExample
