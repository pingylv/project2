#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'pr_2.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS posts (
	id	INTEGER PRIMARY KEY AUTOINCREMENT,
	created_date	TEXT,
	content	TEXT); '
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/new' do
	erb :new		
end

post '/new' do
	content = params[:content]	
	if content.length <= 0
		@error = 'Enter something to post!'
		return erb :new
	end
	erb "rly bro u typed #{content} YIKES bro thats so cringe"	

end