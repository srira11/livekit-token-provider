# app.rb
require 'sinatra'
require 'json'
require 'livekit'
require 'rack/cors'

# Load environment variables
require 'dotenv/load'

# Ensure required environment variables are set
LIVEKIT_API_KEY = ENV['LIVEKIT_API_KEY']
LIVEKIT_API_SECRET = ENV['LIVEKIT_API_SECRET']
ALLOWED_ORIGINS = ENV['ALLOWED_ORIGINS']

use Rack::Cors do
  allow do
    origins ALLOWED_ORIGINS.split(',').map(&:strip)
    resource '*',
      headers: :any,
      methods: [:get, :post, :options],
      credentials: true
  end
end

get "/api/token" do
  puts params

  content_type :json
  token = LiveKit::AccessToken.new(api_key: LIVEKIT_API_KEY, api_secret: LIVEKIT_API_SECRET)
  token.identity = params["identity"]
  token.name = params["roomName"]
  token.video_grant = LiveKit::VideoGrant.new(roomJoin: true, room: 'room-name')
  token.attributes = { "mykey" => "myvalue" }
  { accessToken: token.to_jwt }.to_json
end

get "/healthcheck" do
  "OK"
end
