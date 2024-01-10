require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  erb(:homepage)
end

get("/nutrition_facts") do
  
@ingredients_array = params.fetch("user_recipie").split("\r\n")

@ingredients_array.each do |ingredient|

  encoded_ingr = ingredient.gsub(" ","%20")

  app_key = ENV.fetch("NUTRITION_ANALYSIS_API")

  app_id = ENV.fetch("NUTRITION_ANALYSIS_APP_ID")

  nutrition_analysis_url = "https://api.edamam.com/api/nutrition-data?app_id=#{app_id}&app_key=#{app_key}&nutrition-type=cooking&ingr=#{encoded_ingr}"

  @raw_data = HTTP.get(nutrition_analysis_url).to_s

  @parsed_response= JSON.parse(@raw_data)
end 

erb(:nutrition_facts)
end
