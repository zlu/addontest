require 'connfu'

Connfu.redis_uri = "redis://redistogo:73d5d351c2595cc21b9d9baef231ccc6@catfish.redistogo.com:9458/"

Connfu.start do
  on :offer do |call|
    answer
    say('i am answering your call even though i am just a robot')
    hangup
  end
end
