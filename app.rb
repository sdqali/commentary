require "rubygems"
require "sinatra"
require "sinatra/activerecord"

configure do
  ActiveRecord::Base.establish_connection(
                                          :adapter => 'sqlite3',
                                          :database => ENV['COMMENTS_DB_PATH'] || "db/development.sqlite3")
end
