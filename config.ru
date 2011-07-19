require 'rubygems'
require 'bundler/setup'
require 'sinatra'

get "/" do
  "This is a connfu test application"
end

run Sinatra::Application


