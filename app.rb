require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  erb(:homepage)
end

post("/nutrition_facts") do
  @user_recipie_for_analysis = params.fetch("user_recipie")

  nutrition_analysis_key = ENV.fetch("NUTRITION_ANALYSIS_API")

  nutrition_url =  https://api.edamam.com/api/nutrition-details

  @raw_gmaps_data = HTTP.get(gmaps_url).to_s

  @parsed_response= JSON.parse(@raw_gmaps_data)
  erb(:nutrition_facts)
end
