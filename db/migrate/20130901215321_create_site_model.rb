class CreateSiteModel < ActiveRecord::Migration
  def up
    create_table :sites do |t|
      t.string :name
      t.string :domain
    end
  end

  def down
    drop_table :sites
  end
end
