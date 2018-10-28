require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scrape_marmiton'

csv_file = File.join(__dir__, 'recipes.csv')
cookbook = Cookbook.new(csv_file)

get '/' do
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  recipe = Recipe.new(params[:name],
                      params[:description],
                      params[:prep_time],
                      params[:difficulty])
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/recipes/:index' do
  cookbook.remove_recipe(params[:index].to_i)
  redirect to '/'
end

get '/done/:index' do
  cookbook.mark_as_done(params[:index].to_i)
  redirect to '/'
end

get '/import' do
  erb :import
end

post '/results' do
  @results = ScrapeMarmiton.new(params[:keyword]).call
  @keyword = params[:keyword]
  erb :results
end
