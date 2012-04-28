

youtube = Youtube.new
beatmania = Beatmania::ACLincle19.new
beatmania.musics.each.with_index do |music, index|
  pp youtube.search_keyword(["beatmania", music[:artist], music[:music]], music[:music]).csv(music[:artist], music[:music], "ttt.csv")
end
