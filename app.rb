require 'sinatra'
require 'httparty'
require 'dotenv/load'

# Base URL for the Esports Earnings API
BASE_URL = 'http://api.esportsearnings.com'


get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/highest_players' do
  # Extract parameters from the query string

  # Build the URL with the provided parameters
  url = "#{BASE_URL}/v0/LookupHighestEarningPlayers?apikey=#{ENV['ESPORTS_API_KEY']}&offset=1000&format=json"

  # Make the API request
  response = HTTParty.get(url, verify: false)

  # Check if the response was successful
  if response.success?
    content_type :json
    data = JSON.parse(response.body)
    players = data.map do |p| 
      {
        "Player Id" => p["PlayerId"],
        "Player Name" => "#{p['NameFirst']} #{p['NameLast']}",
        "Player Handle" => p["CurrentHandle"],
        "Total Prize Money" => p["TotalUSDPrize"],
        "Country" => p["CountryCode"]
      }
    end

    players.to_json
  else
    status 500
    { error: "Failed to fetch data from Esports Earnings API" }.to_json
  end
end

get '/player_info/:id' do 
  id = params[:id]
  # Build the URL with the provided parameters
  url = "#{BASE_URL}/v0/LookupPlayerById?apikey=#{ENV['ESPORTS_API_KEY']}&playerid=#{id}&format=json"

  # Make the API request
  response = HTTParty.get(url, verify: false)

  # Check if the response was successful
  if response.success?
    content_type :json
    data = JSON.parse(response.body)
    data.to_json
  else
    status 500
    { error: "Failed to fetch data from Esports Earnings API" }.to_json
  end
end

get '/player_tournaments/:id' do 
  id = params[:id]
  # Build the URL with the provided parameters
  url = "#{BASE_URL}/v0/LookupPlayerTournaments?apikey=#{ENV['ESPORTS_API_KEY']}&playerid=#{id}&offset=2&format=json"

  # Make the API request
  response = HTTParty.get(url, verify: false)

  # Check if the response was successful
  if response.success?
    content_type :json
    data = JSON.parse(response.body)
    data.to_json
  else
    status 500
    { error: "Failed to fetch data from Esports Earnings API" }.to_json
  end
end

