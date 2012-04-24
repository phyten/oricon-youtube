class Music < ActiveRecord::Base
  belongs_to :artist
  has_many :rankings
end
