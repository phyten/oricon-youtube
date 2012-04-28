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

class Scraper

  attr_accessor :url

  def initialize
    @useragent = 'Mac Safari'
    @mechanize = Mechanize.new
    @mechanize.read_timeout = 20
    @mechanize.max_history = 10
    @mechanize.user_agent_alias = @useragent
  end

  def content
    return @document if @document
    page = @mechanize.get(@url)
    @content = page.content.to_s.toutf8
    @document = Hpricot @content
    return @document
  end

  def reload
    page = @mechanize.get(@url)
    @content = page.content.to_s.toutf8
    @document = Hpricot @content
    return @document
  end

end
