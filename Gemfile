source "https://rubygems.org"
git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }
ruby '2.6.5'

gem "sinatra"
gem 'sinatra-contrib'
gem 'sass'
gem 'compass'
gem 'aws-sdk-s3'
gem 'aws-sdk-transcribeservice'
gem 'faraday'

group :production do
  gem 'puma'
end
group :development do
  gem 'dotenv'
end

