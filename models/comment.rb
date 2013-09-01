require "rubygems"
require "sinatra"
require "sinatra/activerecord"

module Commentary
  class Comment < ActiveRecord::Base
    belongs_to :site

    validates_presence_of :site_id
    validates_presence_of :nickname
    validates_presence_of :content
    validates_presence_of :document_path
  end
end
