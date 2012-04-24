class CreateRankingGroups < ActiveRecord::Migration
  def change
    create_table :ranking_groups do |t|
      t.timestamps
    end
  end
end
