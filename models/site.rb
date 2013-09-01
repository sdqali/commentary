require "rubygems"
require "sinatra"
require "sinatra/activerecord"

module Commentary
  class Site < ActiveRecord::Base
    has_many :comments
  end
end
