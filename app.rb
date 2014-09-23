require 'sinatra'
require 'sinatra/sequel'
require 'sinatra/json'

# setup the database
configure do
	# connect to the DB
	# 
	# The ENV['---'] part is determined by the DB Heroku puts you on,
	# to find it, use Heroku's irb (`heroku run irb`), and just print out the 
	# `ENV` variable, find the "HEROKU_POSTGRESQL_[color]_URL" key, copy that,
	# and use that here.
	DB = Sequel.connect(ENV['HEROKU_POSTGRESQL_CYAN_URL'] || "sqlite://words.db")
	
	# for more information on this, read Sequel's documentation...
	DB.create_table? :words do
		primary_key :id
		String :word
	end

	# This goes here apparently...
	class Words < Sequel::Model
	end
end

# This is the Sinatra part.
get '/' do
	@words = Words.order(:word)
	erb :index
end

post '/' do
	Words.create(:word => params[:word])

	words = Words.order(:word).map do |word|
		word.word
	end

	json words
end