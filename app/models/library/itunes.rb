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

class Itunes < Scraper

  attr_accessor :url

  def initialize
    super
  end

  def ranking
    @url = 'http://suitunes.com/itunes+index.id+2.htm'
    ranking = []
    ranking_ranking = content.search('td.itunesTitle a:nth(1)').map { |e| e.inner_text.scan(/([0-9]+?)\. /)[0]}
    ranking_artist = content.search('td.itunesTitle a:nth(1)').map { |e| e.inner_text.gsub(/[0-9]+?\. .+? \- /,"")}
    ranking_music = content.search('td.itunesTitle a:nth(1)').map { |e| e.inner_text.gsub(/[0-9]+?\. /,"").gsub(/ \- .+/, "")}
    pp ranking_ranking
    ranking_artist.each.with_index do |artist, index|
      ranking.push({ :artist => ranking_artist[index], :music => ranking_music[index], :ranking => ranking_ranking[index]})
    end
    return ranking
  end

end


