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

  def self.add_music(artist_name, music_name)
    youtube = Youtube.new
    good_musics = []

    Artist.transaction do
      pp good_music = youtube.search_keyword([artist_name, music_name], music_name).good_music
      artist_id = ""
      if Artist.find_by_name_downcase(artist_name.downcase).blank?
        Artist.create({:name => artist_name, :name_downcase => artist_name.downcase})
        artist_id = Artist.find(:last).id
      else
        artist_id = Artist.find_by_name_downcase(artist_name.downcase).id
      end
      music_id = ""
      if Music.find_by_name_downcase(music_name.downcase).blank?
        Music.create({:name => music_name, :name_downcase => music_name.downcase, :artist_id => artist_id, :addr => good_music[:addr]})
        music_id = Music.find(:last).id
      else          
        music = Music.find_by_name_downcase(music_name.downcase)
        music.addr = good_music[:addr]
        music.save!
        music_id = Music.find_by_name_downcase(music_name.downcase).id
      end
    end                         # end of transaction
  end
end
