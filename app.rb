require_relative "config"
require_relative "models/comment"

include Commentary

get "/comments" do
  comments = Comment.where({
                             :domain => params["domain"],
                             :document_path => params["document_path"]
                           }).to_a
  comments.to_json
end
