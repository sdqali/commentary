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

post "/comments" do
  raw_json = request.body.read
  begin
    comment_hash = JSON.parse(raw_json)
    comment = Comment.create!({
                                :content => comment_hash["content"],
                                :nickname => comment_hash["nickname"],
                                :domain => comment_hash["domain"],
                                :document_path => comment_hash["document_path"]
                              })

  rescue JSON::ParserError
    return [422, ["The JSON provided is not valid."]]
  rescue ActiveRecord::RecordInvalid => e
    return [422, [e.message]]
  end

  [201, [comment.to_json]]
end
