class Artist < ActiveRecord::Base
  has_many :musics
  def self.artists_includes_musics
    Artist.includes(:musics).find(:all)
  end

  def self.artist_by_id(id)
    Artist.includes(:musics).find(id)
  end
end
