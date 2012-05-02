class RankingsController < ApplicationController
  def index
    @rankings = Ranking.recent
    @artists = Artist.artists_includes_musics
    @config = {
      :h1 => "CollecTube オリコン版 Beta!",
      :title => "ホーム"
    }
  end

  def each_page
    @music = Ranking.addr(params[:id])
    @artists = Artist.artists_includes_musics
    @config = {
      :h1 => @music.name + "／" + @music.artist.name,
      :title => @music.name + "／" + @music.artist.name
    }
  end

  def artist_page
    @artist = Artist.artist_by_id(params[:artist_id])
    @artists = Artist.artists_includes_musics
    @config = {
      :h1 => @artist.name,
      :title => @artist.name
    }
  end

end
