class CreateMGroups < ActiveRecord::Migration
  def change
    create_table :m_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
