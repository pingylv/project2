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

	@db.execute 'CREATE TABLE IF NOT EXISTS comments (
	id	INTEGER PRIMARY KEY AUTOINCREMENT,
	created_date	TEXT,
	content	TEXT,
	post_id INTEGER); '

	@db.execute 'CREATE TABLE IF NOT EXISTS users (
	id	INTEGER PRIMARY KEY AUTOINCREMENT,
	username	TEXT,
	post_id INTEGER); '

end

get '/' do
	@results = @db.execute 'select * from posts order by id desc'
	erb :index
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

	@db.execute 'insert into posts (content, created_date) values (?, datetime())', [content]
	redirect to '/'
end

get '/details/:post_id' do
	post_id = params[:post_id]

	results = @db.execute 'select * from posts where id = ?', [post_id]
	@row = results[0]

	@comments = @db.execute 'select * from comments where post_id = ? order by id', [post_id]

	erb :details
end

post '/details/:post_id' do
	post_id = params[:post_id]
	content = params[:content]	

	@db.execute 'insert into comments (content, created_date, post_id) values (?, datetime(), ?)', [content, post_id]

	redirect to('/details/'+post_id)
end