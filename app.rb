require 'sinatra'
require 'sinatra/reloader' if development?
require 'compass'
require 'sass'

# Sintra
# http://sinatrarb.com/intro-ja.html
#
# S3 direct upload
# https://devcenter.heroku.com/articles/direct-to-s3-image-uploads-in-rails
#
# Amazon Transcribe
# https://docs.aws.amazon.com/sdkforruby/api/Aws/TranscribeService/Client.html

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end
  set :scss, Compass.sass_engine_options
end
get '/style.css' do
  scss :style
end

get '/' do
  @now = DateTime.now
  erb :index #views/index.erb
end


