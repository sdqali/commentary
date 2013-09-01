require "rubygems"
require "sinatra"
require "sinatra/activerecord"


def get_db_for_env(rack_env)
  puts "Running in #{rack_env} mode..."
  return "db/development.db" unless rack_env
  mapping = {
    "development" => "db/development.db",
    "production" => "db/production.db",
    "test" => "db/test.db"
  }
  mapping[rack_env]
end

configure do
  ActiveRecord::Base.establish_connection(
                                          :adapter => 'sqlite3',
                                          :database => get_db_for_env(ENV["RACK_ENV"]))
end

class Comment < ActiveRecord::Base
  validates_presence_of :nickname
  validates_presence_of :content
  validates_presence_of :domain
  validates_presence_of :document_path
end

get "/comments" do
  comments = Comment.where({
                             :domain => params["domain"],
                             :document_path => params["document_path"]
                           }).to_a
  comments.to_json
end
