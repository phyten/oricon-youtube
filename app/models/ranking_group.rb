class RankingGroup < ActiveRecord::Base
  has_many :rankings, :include => :music
end
