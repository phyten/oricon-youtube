class ChangeArtistsWikiStringLimit < ActiveRecord::Migration
  def change
    change_column :artists, :wiki, :string, :limit => 10000
  end
end

