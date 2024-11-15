require 'sinatra'
require 'httparty'
require 'dotenv/load'
require 'faker'
# Base URL for the Esports Earnings API
BASE_URL = 'http://api.esportsearnings.com'


get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

require 'sinatra'
require 'httparty'
require 'json'
require 'faker'

require 'sinatra'
require 'httparty'
require 'json'
require 'faker'

get '/highest_players' do
  url = "#{BASE_URL}/v0/LookupHighestEarningPlayers?apikey=#{ENV['ESPORTS_API_KEY']}&offset=1000&format=json"

  response = HTTParty.get(url, verify: false)

  if response.success?
    content_type :json
    data = JSON.parse(response.body)
    
    # List of popular e-sport game titles
    esports_games = [
      "League of Legends",
      "Dota 2",
      "Counter-Strike: Global Offensive",
      "Fortnite",
      "Overwatch",
      "Call of Duty: Warzone",
      "PUBG",
      "Valorant",
      "Rainbow Six Siege",
      "Apex Legends",
      "Rocket League",
      "FIFA 22",
      "Mortal Kombat 11",
      "Street Fighter V",
      "Hearthstone",
      "Smite",
      "StarCraft II",
      "World of Warcraft",
      "Arena of Valor",
      "Super Smash Bros. Ultimate"
    ]
    
    # Map real player data
    players = data.map do |p|
      {
        "Player Id" => p["PlayerId"],
        "Player Name" => "#{p['NameFirst']} #{p['NameLast']}",
        "Player Handle" => p["CurrentHandle"],
        "Total Prize Money" => p["TotalUSDPrize"],
        "Country" => p["CountryCode"],
        "Game" => esports_games.sample,  # Randomly selected real e-sport game title
        "Tournament Name" => "#{Faker::Esport.event} Tournament",
        "Tournament Date" => Faker::Date.between(from: '2020-01-01', to: '2024-12-31').to_s
      }
    end

    # Generate 400 rows of fake data for games and players
    400.times do
      players << {
        "Player Id" => Faker::Number.unique.number(digits: 6),
        "Player Name" => Faker::Name.name,
        "Player Handle" => Faker::Internet.username,
        "Total Prize Money" => Faker::Number.decimal(l_digits: 5, r_digits: 2),
        "Country" => Faker::Address.country_code,
        "Game" => esports_games.sample,
        "Tournament Name" => "#{Faker::Esport.event} Tournament",
        "Tournament Date" => Faker::Date.between(from: '2020-01-01', to: '2024-12-31').to_s,
        "CountryRanking" => Faker::Number.between(from: 1, to: 100),
        "WorldRanking" => Faker::Number.between(from: 1, to: 500),
        "TotalTournaments" => Faker::Number.between(from: 1, to: 50)
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

