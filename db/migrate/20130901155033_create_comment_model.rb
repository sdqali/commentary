class CreateCommentModel < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string :nickname
      t.text :content
      t.string :domain
      t.text :document_path
      t.timestamps
    end
  end

  def down
    drop_table :comments
  end
end
