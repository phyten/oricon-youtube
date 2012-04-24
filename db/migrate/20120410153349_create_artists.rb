class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :name_downcase
      t.string :wiki

      t.timestamps
    end
  end
end
