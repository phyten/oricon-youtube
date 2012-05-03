$KCODE = 'UTF-8'

require 'rubygems'
require 'mechanize'
require 'kconv'
require 'iconv'
require 'open-uri'
require 'yaml'
require 'yaml_waml'
require 'forwardable'
require 'hpricot'
require 'csv'
require 'uri'
require "active_support/all"
require "rexml/document"
require "pp"
require "moji"


class Youtube
  attr_accessor :config, :musics, :song_name
  def initialize
    @config = {
      :url => {
        :search_keyword => 'http://gdata.youtube.com/feeds/api/videos/?lr=ja&max-results=10&vq=',
        :weekly_ranking => 'http://www.oricon.co.jp/rank/js/d/',
        :weekly_ranking_more => 'http://www.oricon.co.jp/rank/js/d/more/',
      },
      :filter => [
                  {
                    :title => "(hd)|(高音質)|(完全版)|(オフィシャル)|(mp3)",
                    :content => "(高音質)|(完全版)|(オフィシャル)",
                    :priority => 1
                  },
                  {
                    :title => "(ripped)|(音源)|(pv)|(mv)",
                    :content => "(ripped)|(音源)|(soundtrack)",
                    :priority => 2
                  },
                  {
                    :title => "(autoplay)",
                    :content => "(autoplay)|(full)",
                    :priority => 3
                  }
                 ],
      :omit => {
        :title => "(弾き語り)|(踊って)|(歌って)|(演奏して)|(アレンジ)|(カラオケ)|(耳コピ)|(covered)|(midi)|(まとめ)|(インタビュー)|(【.+?てみた】)|(ロケ地)|(宣伝トラック)",
        :content => "(歌い)|(弾き語り)|(踊って)|(歌って)|(演奏して)|(アレンジ)|(カラオケ)|(プレイ動画)|(player)|(full combo)|(plays)|(played)|(耳コピ)",
        :priority => 4
      }
    }

    @agent = 'Mac Safari'
    @mech = Mechanize.new
    @mech.max_history = 10
    @mech.user_agent_alias = @agent
    @rank = 0
  end
  def search_keyword(keyword, music_name)
    # 引数keywordは任意の複数のキーワードを配列で渡している。
    musics = []
    page = @mech.get(URI.encode(@config[:url][:search_keyword]+keyword.map{ |key| key.gsub(/\/.+/, "").gsub(/\(.+?\)/,"").gsub(/\-/,"")}.join(" ")))
    pp URI.encode(@config[:url][:search_keyword]+keyword.map{ |key| key.gsub(/\/.+/, "").gsub(/\(.+?\)/,"").gsub(/\-/,"")}.join(" "))
    begin
      doc = REXML::Document.new(REXML::Source.new(page.content))
    rescue Exception => exc
      @musics = false
      @music_name = false
      return self
    end
    cnt = 0
    doc.root.elements.each("entry"){ |entry|
      musics[cnt] = { }
      musics[cnt][:id] = entry.elements["id"].text
      musics[cnt][:addr] = entry.elements["id"].text.gsub(/http:\/\/gdata\.youtube\.com\/feeds\/api\/videos\//, "")
      musics[cnt][:title] = !entry.elements["title"].text.nil? ? entry.elements["title"].text.downcase : entry.elements["content"].text
      musics[cnt][:content] = !entry.elements["content"].text.nil? ? entry.elements["content"].text.downcase : entry.elements["content"].text
      musics[cnt][:statistics] = !entry.elements["yt:statistics"].nil? ? entry.elements["yt:statistics"].attributes["viewCount"] : 0
      musics[cnt][:favorite] = !entry.elements["yt:statistics"].nil? ? entry.elements["yt:statistics"].attributes["favoriteCount"] : 0
      musics[cnt][:average] = !entry.elements["gd:rating"].nil? ? entry.elements["gd:rating"].attributes["average"] : 0
      musics[cnt][:raters] = !entry.elements["gd:rating"].nil? ? entry.elements["gd:rating"].attributes["numRaters"] : 0
      musics[cnt][:seconds] = !entry.elements["media:group"].elements["yt:duration"].nil? ? entry.elements["media:group"].elements["yt:duration"].attributes["seconds"] : 0
      musics[cnt][:favorite_percentage] = musics[cnt][:statistics].to_i != 0 ? (musics[cnt][:favorite].to_f/musics[cnt][:statistics].to_f).to_f * 100.0 : 0
      musics[cnt][:raters_percentage] = musics[cnt][:statistics].to_i != 0 ? (musics[cnt][:raters].to_f/musics[cnt][:statistics].to_f).to_f * 100.0 : 0      
      cnt = cnt + 1

    }
    @musics = musics
    @music_name = music_name
    return self
  end
  def good_music
    musics = @musics
    music_name = @music_name
    return false unless music_name
    statistics = 0
    rank_tmp = []
    music_name = music_name.downcase.to_s
    good_song = { }
    musics.each.with_index{ |song, index|
      statistics_tmp = song[:statistics].to_i
      song[:title] = Moji.zen_to_han(song[:title], Moji::ZEN_ALPHA)
      song[:title] = Moji.han_to_zen(song[:title], Moji::HAN_KATA)
      song[:title] = Moji.zen_to_han(song[:title], Moji::ZEN_ASYMBOL)
      song[:title] = Moji.zen_to_han(song[:title], Moji::ZEN_NUMBER)
      music_name = Moji.zen_to_han(music_name, Moji::ZEN_ALPHA)
      music_name = Moji.han_to_zen(music_name, Moji::HAN_KATA)
      music_name = Moji.zen_to_han(music_name, Moji::ZEN_ASYMBOL)
      music_name = Moji.zen_to_han(music_name, Moji::ZEN_NUMBER)
      music_name = music_name.gsub(/\/.+/, "").gsub(/\(.+?\)/,"").gsub(/\-/,"")
      puts music_name + song[:title]
      if song[:title].downcase =~ /#{music_name}/
          rank_array = @config[:filter].inject([]){ |rank, config|
          title = config[:title]
          content = config[:content]
          rank << config[:priority] if song[:title].downcase =~ /#{title}/ || song["content"] =~ /#{content}/
          rank
        }
      end
      if song[:title].downcase =~ /#{music_name}/
        rank_array << 4
      end
      if rank_array.blank?
        song[:rank] = [100]
      else
        song[:rank] = rank_array
      end

      pp song[:rank]

      title = @config[:omit][:title]
      content = @config[:omit][:content]
      if song[:title].downcase =~ /#{title}/ || song["content"] =~ /#{content}/
          song[:rank] = []
      end

      # averageの値がしきい値を下回れば省く
      if song[:average].to_f < 4.5 && song[:average].to_f != 0.0
        song[:rank] = []
      end

      if song[:seconds].to_i < 80
        song[:rank] = []
      end

      if song[:favorite].to_i == 0
        song[:rank] = []
      end
      if song[:rank].blank?
        puts "next"
        next
      end
      if rank_tmp.blank? || song[:rank].min <= rank_tmp.min
        puts song[:rank].min
        if statistics < song[:statistics].to_i
          statistics = song[:statistics].to_i
          rank_tmp = song[:rank]
          good_song = song
        end        
      end
    }
    if good_song == { }
      good_song = musics[0]
    end
    return good_song
  end
  
  def csv(artist_name, music_name, csv_name="test.csv")
    csv_writer = csv_name
    CSV.open(csv_writer, "a") do |writer|
      @musics.each do |music|
        ln = (0.004006 * music[:statistics].to_f - 0.0000000001383 * music[:statistics].to_f**2 - 24.73)
        flag = ln.to_i < music[:favorite].to_i ? 1 : 0
        writer << [
                   artist_name,
                   music_name,
                   music[:title],
                   music[:statistics].to_i,
                   music[:favorite].to_i,
                   music[:raters].to_i,
                   music[:average].to_f,
                   ln.to_f,
                   flag
                  ]
      end
    end
  end
end


class << CSV
  alias_method( :open_org, :open )
  
  def open( path, mode, fs=nil, rs=nil, &block )
    if mode == "a" || mode == "ab"
      open_writer( path, mode, fs, rs, &block)
    else
      open_org( path, mode, fs=nil, rs=nil, &block )
    end
  end
end
