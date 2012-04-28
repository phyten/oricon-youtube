$KCODE = 'UTF-8'
# -*- encoding: utf-8 -*-

require 'rubygems'
require 'mechanize'
require 'kconv'
require 'jcode'
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
require "mysql"

class YahooOricon < Scraper

  attr_accessor :url

  def initialize
    @url = 'http://rank.music.yahoo.co.jp/rank_dtl/sa/or/d/sngl'
    super
  end

  def ranking
    ranking = []
    ranking_artist = content.search('div#mnc div.wr table tr td:nth(3)').map { |e| e.inner_text.gsub(/[「」]/,"")}
    ranking_music = content.search('div#mnc div.wr table tr td:nth(2)').map { |e| e.inner_text.gsub(/[「」]/,"")}
    ranking_artist.each.with_index do |artist, index|
      ranking.push({ :artist => ranking_artist[index], :music => ranking_music[index]})
    end
    return ranking
  end

end

