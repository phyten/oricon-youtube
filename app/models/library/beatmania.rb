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

module Beatmania
  class ACLincle19 < Scraper

    attr_accessor :url

    def initialize
      @url = 'http://textage.cc/iidx/19.html'
      super
    end

    def musics
      content.search('td[@bgcolor="white"]').inject([]){ |musics, music| musics.push(
                                                                                     {
                                                                                       :music => music.search('b').inner_text.chomp,
                                                                                       :artist => music.inner_text.gsub(/\n/, "").scan(/\/ (.+)/)[0][0]
                                                                                     })}
    end

  end
end
