require "rubygems"
require "rsruby"
# require "gsl"
require "csv"
require "yaml"
require "yaml_waml"
require "pp"

class Analysis

  def self.lm
r = RSRuby::instance

r.eval_R(<<-RCOMMANDS)
x <- read.csv("test.csv")
attach(x)

# print (summary(lm(price ~ hdd)))
# print (summary(lm(price ~ hdd +  screensize +  starting_bid + feedback_score + bid)))
# print (summary(lm(price ~ cpu)))
# result_line <- (lm(price ~ screensize + I(screensize^2)))
# result_line <- (lm(price ~ screensize + I(screensize^2) + I(screensize^3)))
# result_line <- (lm(price ~ screensize + I(screensize^2) + I(screensize^3) + I(screensize^4)))
# result_line <- (lm(price ~ hdd + memory + screensize + I(screensize^2) + I(screensize^3) + I(screensize^4) + starting_bid + feedback_score))
# result_line <- (lm(price ~ hdd + memory + screensize + I(screensize^2) + I(screensize^3) + I(screensize^4)))
# print (summary(result_line))
# print (summary(result_line))
# print (summary(lm(price ~ hdd + screensize + I(screensize^2) + starting_bid + top_seller + bid)))
# print (summary(lm(price ~ hdd + memory + screensize + I(screensize^2) + starting_bid + feedback_score + bid)))
# print (summary(lm(x$price ~ x$hdd + x$kind)))
#print (summary(lm(x$price ~ x$os)))

# print (summary(lm(x$favorite ~ x$viewcounts)))
# print (summary(lm(x$favorite ~ x$viewcounts + I(x$viewcounts^2)   )))
# print (summary(lm(x$favorite ~ log(x$viewcounts) , subset=x$viewscounts>0  )))
print (summary(lm(x$viewcounts ~ x$favorite + I(x$favorite^2) + I(x$favorite^3)   )))


# ( result <- nls(x$favorite ~ a*log(x$viewcounts), start=c(a=1)))

#print (summary(lm(x$price ~ x$description)))
# print (summary(lm(price ~ hdd)))
# print (summary(lm(price ~ kind )))
# print (nls(y ~ x + z + a + a*a, start=c(x=0, a=0, z=0)))
# plot(starting_bid, bid, xlim=c(0,100))
# print (summary(result_line))
# plot(screensize, price, xlim=c(0,30))
# print (cor(bid, starting_bid, method="pearson"))      # 無相関かどうかの検定
# print (cor(screensize, starting_bid, method="pearson"))      # 無相関かどうかの検定
# print (cor(screensize, memory, method="pearson"))      # 無相関かどうかの検定
# print (cor(memory, hdd, method="pearson"))      # 無相関かどうかの検定
# print (cor(memory, starting_bid, method="pearson"))      # 無相関かどうかの検定
# print (cor(screensize, hdd,method="pearson"))      # 無相関かどうかの検定
# print (multiple.cor(x))

RCOMMANDS

  end

end
