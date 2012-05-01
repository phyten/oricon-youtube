class Music < ActiveRecord::Base
  belongs_to :artist
  belongs_to :m_group
  has_many :rankings
end
