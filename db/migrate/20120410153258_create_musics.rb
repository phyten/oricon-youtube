class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.references :artist
      t.string :addr
      t.string :name
      t.string :name_downcase

      t.timestamps
    end
    add_index :musics, [:artist_id]
  end
end
