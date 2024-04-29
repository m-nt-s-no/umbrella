require "http"
require "json"

#got the idea to require and load dotenv from Vonage developer website:
#https://developer.vonage.com/en/blog/working-with-environment-variables-in-ruby
require "dotenv"
Dotenv.load
#also had to run this in terminal: gem install dotenv

gmaps_key = ENV.fetch("GMAPS_KEY")
pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

#Here is a suggested outline for your program:
#Ask the user for their location. (Recall gets.)
#Get and store the user’s location.

puts "Where are you?"
location = gets.chomp

#Get the user’s latitude and longitude from the Google Maps API.


#Get the weather at the user’s coordinates from the Pirate Weather API.
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_key + "/41.8887,-87.6355"

parsed_response = JSON.parse(HTTP.get(pirate_weather_url))

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

#Display the current temperature and summary of the weather for the next hour.
puts "The current temperature at #{location } is #{current_temp.to_s} Fahrenheit."


#If you get that far, then stretch further:
#For each of the next twelve hours, check if the precipitation probability is greater than 10%.
#If so, print a message saying how many hours from now and what the precipitation probability is.
#If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”
#If not, print “You probably won’t need an umbrella today.”
