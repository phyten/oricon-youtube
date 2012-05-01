class AddMGroupsReferenceToMusics < ActiveRecord::Migration
  def change
    add_column :musics, :m_group_id, :integer
    add_index :musics, :m_group_id
  end
end
