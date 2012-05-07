class RankingsController < ApplicationController
  def index
    @rankings = Ranking.recent
    @artists = Artist.artists_includes_musics
    @config = {
      :description => "このサイトでは最新のPV/MVや歌詞付動画・ライブ動画を無料で視聴することができます。",
      :keywords => "PV,動画,無料,視聴,youtube,試聴,オリコン",
      :h1 => "CollecTube オリコン版 Beta!",
      :title => "ホーム"
    }
  end

  def each_page
    @music = Ranking.addr(params[:id])
    @artists = Artist.artists_includes_musics
    @config = {
      :description => @music.artist.name + "の曲" + @music.name,
      :keywords => "PV,試聴,#{@music.artist.name},#{@music.name},youtube,オリコン",
      :h1 => @music.name + "／" + @music.artist.name,
      :title => @music.name + "／" + @music.artist.name
    }
  end

  def artist_page
    @artist = Artist.artist_by_id(params[:artist_id])
    @artists = Artist.artists_includes_musics
    @config = {
      :description => @artist.name + "の曲",
      :keywords => "PV,試聴,#{@artist.name},新曲,youtube,オリコン",
      :h1 => @artist.name,
      :title => @artist.name
    }
  end

end
