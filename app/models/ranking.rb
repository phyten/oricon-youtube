require 'app/models/ranking_group'
require 'app/models/library/yahoooricon'

class Ranking < ActiveRecord::Base
  belongs_to :music
  belongs_to :ranking_group
  
  # scope 

  def self.recent
    RankingGroup.includes(:rankings => [{:music => :artist}]).where("(select max(id) from ranking_groups) = rankings.ranking_group_id").find(:all).first.rankings
  end

  def self.addr(addr)
    Music.includes(:artist).where(:addr => addr).find(:last)
  end

  def self.make_csv
    oricon = YahooOricon.new
    youtube = Youtube.new
    oricon.ranking.each.with_index do |rank, index|
      youtube.search_keyword([rank[:artist], rank[:music]], rank[:music]).csv(rank[:artist], rank[:music])
    end
  end

  def self.make_ranking
    oricon = YahooOricon.new
    youtube = Youtube.new
    good_musics = []

    Artist.transaction do
      RankingGroup.create()
      ranking_group_id = RankingGroup.find(:last).id
      oricon.ranking.each.with_index do |rank, index|
        pp good_music = youtube.search_keyword([rank[:artist], rank[:music]], rank[:music]).good_music
        next unless good_music
        artist_id = ""
        if Artist.find_by_name_downcase(rank[:artist].downcase).blank?
          Artist.create({:name => rank[:artist], :name_downcase => rank[:artist].downcase})
          artist_id = Artist.find(:last).id
        else
          artist_id = Artist.find_by_name_downcase(rank[:artist].downcase).id
        end

        Music.create({:name => rank[:music], :name_downcase => rank[:music].downcase, :artist_id => artist_id, :addr => good_music[:addr]})
        music_id = Music.find(:last).id

        Ranking.create({:music_id => music_id, :ranking => index + 1, :ranking_group_id => ranking_group_id})
      end
    end
  end
end
