require 'sinatra'
require "sinatra/json"
require 'compass'
require 'sass'
require 'aws-sdk-s3'
require 'aws-sdk-transcribeservice'
require 'faraday'
if development?
  require 'sinatra/reloader'
  require 'dotenv/load'
end

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
  end
  set :scss, Compass.sass_engine_options

  Aws.config.update({
    region: 'ap-northeast-1',
    credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
  })
  S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])
  TRANSCRIBE = Aws::TranscribeService::Client.new
end
get '/style.css' do
  scss :style
end

get '/' do
  @transcribes = TRANSCRIBE.list_transcription_jobs({
    #status: "QUEUED", # accepts QUEUED, IN_PROGRESS, FAILED, COMPLETED
    job_name_contains: "heroku",
    max_results: 20,
  })
  erb :index #views/index.erb
end

get '/new' do
  erb :new
end

get '/show/:id' do
  @res = TRANSCRIBE.get_transcription_job({
    transcription_job_name: params[:id]
  })
  uri = @res.transcription_job.transcript.transcript_file_uri
  @transcript = JSON.parse(Faraday.get(uri).body)

  erb :show
rescue => e
  "失敗しました #{e}"
end

get '/upload' do
  name = params[:name]
  type = params[:type]
  post = S3_BUCKET.presigned_post(
    key: "upload/#{name}",
    acl: 'public-read',
    content_type: type,
    metadata: { 'original-filename': name }
  )
  json({url: post.url, fields: post.fields})
end

post '/transcribe' do
  resp = TRANSCRIBE.start_transcription_job({
    transcription_job_name: params[:name],
    media_format: params[:format],
    language_code: params[:lang],
    media: { media_file_uri: params[:uri] },
    settings: {
      show_speaker_labels: true,
      max_speaker_labels: params[:number]
    }
  })
  json(resp)
end
