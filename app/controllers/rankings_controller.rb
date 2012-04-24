class RankingsController < ApplicationController
  def index
    @rankings = Ranking.recent
    @config = {
      :h1 => "ホーム",
      :title => "ホーム"
    }
  end

  def each_page
    @music = Ranking.addr(params[:id])
    @config = {
      :h1 => "ホーム",
      :title => "ホーム"
    }
  end

end
