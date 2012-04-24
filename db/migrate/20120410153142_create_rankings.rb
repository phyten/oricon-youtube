class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings do |t|
      t.references :music
      t.references :ranking_group
      t.integer :ranking

      t.timestamps
    end
    add_index :rankings, [:ranking]
  end
end
