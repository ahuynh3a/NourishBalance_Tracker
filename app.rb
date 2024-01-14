require "sinatra"
require "sinatra/reloader"
require "http"

get("/") do
  erb(:homepage)
end

get("/nutrition_facts") do
  
@ingredients_array = params.fetch("user_recipie").split("\r\n")

@calories_hash = {}
@protein_hash = {}
@carbohydrates_hash = {}
@fats_hash = {}

@ingredients_array.each do |ingredient|

  encoded_ingr = ingredient.gsub(" ","%20")

  app_key = ENV.fetch("NUTRITION_ANALYSIS_API")

  app_id = ENV.fetch("NUTRITION_ANALYSIS_APP_ID")

  nutrition_analysis_url = "https://api.edamam.com/api/nutrition-data?app_id=#{app_id}&app_key=#{app_key}&nutrition-type=cooking&ingr=#{encoded_ingr}"

  raw_data = HTTP.get(nutrition_analysis_url).to_s

  @parsed_response= JSON.parse(raw_data)

  @calories = @parsed_response.dig("calories")

  @calories_hash[ingredient]="#{@calories}"

  @total_calories = @calories_hash.values.map(&:to_i).sum

  @protein = @parsed_response.dig("totalNutrients","PROCNT","quantity")

  @protein_hash[ingredient]="#{@protein}"

  @total_protein = @protein_hash.values.map(&:to_i).sum

@carbohydrates = @parsed_response.dig("totalNutrients","CHOCDF", "quantity")

 @carbohydrates_hash[ingredient]="#{@carbohydrates}"

  @total_carbohydrates = @carbohydrates_hash.values.map(&:to_i).sum

  @fats = @parsed_response.dig("totalNutrients","FAT","quantity")

  @fats_hash[ingredient]="#{@fats}"

  @total_fats = @fats_hash.values.map(&:to_i).sum
end
erb(:nutrition_facts)
end

get("/bootstrap") do
erb(:bootstrap)
end
