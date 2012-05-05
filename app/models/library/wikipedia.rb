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


class Wikipedia < Scraper

  attr_accessor :url

  def initialize
    @base_url = "http://ja.wikipedia.org/wiki/"
    super
  end
  
  def keyword(key)
    @url = @base_url + key
  end

  def nakami
    reload
    content.search('#bodyContent').inner_text.gsub("\t", "").gsub("\n", "").to_s
  end

end

