class ChangeArtistsWikiStringLimit < ActiveRecord::Migration
  def change
    change_column :artists, :wiki, :string, :limit => 300
  end
end

