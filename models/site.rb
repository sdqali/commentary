require "rubygems"
require "sinatra"
require "sinatra/activerecord"

module Commentary
  class Site < ActiveRecord::Base
    has_many :comments

    validates_presence_of :name
    validates_presence_of :domain
    validates_uniqueness_of :domain
  end
end
