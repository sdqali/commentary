class CreateCommentModel < ActiveRecord::Migration
  def up
    create_table :comment do |t|
      t.string :nickname
      t.text :content
      t.string :domain
      t.text :document_path
    end
  end

  def down
    drop_table :comment
  end
end
