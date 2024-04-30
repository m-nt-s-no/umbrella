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

puts "Please enter your location to check the weather report."
location = gets.chomp

#Get the user’s latitude and longitude from the Google Maps API.
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{location}&key=#{gmaps_key}"
parsed_gmaps_response = JSON.parse(HTTP.get(gmaps_url))

#added if-else logic to filter out locations not in Gmaps
if parsed_gmaps_response["results"].length > 0

  location_latitude =  parsed_gmaps_response["results"][0]["geometry"]["location"]["lat"]
  location_longitude = parsed_gmaps_response["results"][0]["geometry"]["location"]["lng"]

  #Get the weather at the user’s coordinates from the Pirate Weather API.
  pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{location_latitude},#{location_longitude}"

  parsed_response = JSON.parse(HTTP.get(pirate_weather_url))

  currently_hash = parsed_response.fetch("currently")
  current_temp = currently_hash.fetch("temperature")
  current_summary = currently_hash.fetch("summary")

  #Display the current temperature and summary of the weather for the next hour.
  puts "\n"
  puts "Weather report for #{location}" 
  puts "temperature: #{current_temp.to_s} degrees Fahrenheit"
  puts "current conditions: #{current_summary.downcase}"

else
  puts "Sorry, we couldn't find #{location}."
end

#If you get that far, then stretch further:
#For each of the next twelve hours, check if the precipitation probability is greater than 10%.
hourly_report =   parsed_response.fetch("hourly")
next_twelve_hours = {}
counter = 1
while counter < 13 do
  precip_probability = hourly_report["data"].at(counter)["precipProbability"]
  if precip_probability > 0.1
    next_twelve_hours[counter] = hourly_report["data"].at(counter)["precipProbability"]
  end
  counter = counter + 1
end

#If so, print a message saying how many hours from now and what the precipitation probability is.
#If any of the next twelve hours has a precipitation probability greater than 10%, print “You might want to carry an umbrella!”
if next_twelve_hours.length > 0
  next_twelve_hours.each do |entry|
    hour, percent = entry
    if hour == 1
      hour_or_hours = "hour"
    else
      hour_or_hours = "hours"
    end
    puts "#{hour} #{hour_or_hours} from now the percent chance of rain is #{percent * 100} percent"
  end
  puts "You might want to carry an umbrella!"
else
  #If not, print “You probably won’t need an umbrella today.”
  puts "You probably won’t need an umbrella today."
end
