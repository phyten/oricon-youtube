class Music < ActiveRecord::Base
  belongs_to :artist
  belongs_to :m_group
  has_many :rankings

  def self.music_update
    youtube = Youtube.new
    good_musics = []
    Artist.transaction do
      Artist.find(:all).each do |artist|
        artist.musics.each do |music|
          printf ("%s %s\n", artist.name, music.name)
          pp good_music = youtube.search_keyword([artist.name, music.name], music.name).good_music
          next unless good_music
          music.addr = good_music[:addr]
          music.save!
        end
      end
    end
  end
end
