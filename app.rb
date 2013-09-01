require "rubygems"
require "sinatra"

require_relative "config"
require_relative "models/comment"

include Commentary

def app_headers
  {
    "Access-Control-Allow-Origin" => "*",
    "Content-Type" => "application/json"
  }
end


get "/comments.json" do
  return [422,
          app_headers,
          [{:error => "The domain and document_path must be specified"}.to_json]] unless (params["domain"] && params["document_path"])
  comments = Comment.where({
                             :domain => params["domain"],
                             :document_path => params["document_path"]
                           }).to_a
  [200, app_headers, [comments.to_json]]
end

post "/comments.json" do
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
    return [422, app_headers, [{:error => "The JSON provided is not valid."}.to_json]]
  rescue ActiveRecord::RecordInvalid => e
    return [422, app_headers, [{:error => e.message}.to_json]]
  end

  [201, app_headers, [comment.to_json]]
end
