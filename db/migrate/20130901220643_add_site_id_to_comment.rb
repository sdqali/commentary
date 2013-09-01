class AddSiteIdToComment < ActiveRecord::Migration
  def up
    add_column :comments, :site_id, :integer
  end

  def down
    remove_column :comments, :site_id
  end
end
