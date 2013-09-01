class RemoveDomainFromComment < ActiveRecord::Migration
  def up
    remove_column :comments, :domain
  end

  def down
    add_column :comments, :domain, :integer
  end
end
