require "rubygems"
require "sinatra"

require_relative "config"
require_relative "models/comment"

include Commentary

get "/comments" do
  return [422, ["The domain and document_path must be specified"]] unless (params["domain"] && params["document_path"])
  comments = Comment.where({
                             :domain => params["domain"],
                             :document_path => params["document_path"]
                           }).to_a
  comments.to_json
end
