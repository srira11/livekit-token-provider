# app.rb
require 'sinatra'
require 'json'
require 'livekit'

# Load environment variables
require 'dotenv/load'

# Ensure required environment variables are set
LIVEKIT_API_KEY = ENV['LIVEKIT_API_KEY']
LIVEKIT_API_SECRET = ENV['LIVEKIT_API_SECRET']
ALLOWED_ORIGINS = ENV['ALLOWED_ORIGINS']

before do
  response.headers['Access-Control-Allow-Origin'] = ALLOWED_ORIGINS
  response.headers['Access-Control-Allow-Methods'] = 'GET'
  response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, X-Requested-With'
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
