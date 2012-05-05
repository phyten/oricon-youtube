require 'uri'

wikipedia = Wikipedia.new
artists = Artist.find(:all)
artists.each do |artist|
  puts artist.name
  wikipedia.keyword(URI.encode(artist.name))
  artist.wiki = wikipedia.nakami
  artist.save
end
