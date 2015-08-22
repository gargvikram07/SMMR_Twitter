# install.packages(c("devtools", "rjson", "bit64", "httr"))
# #RESTART R session!
# library(devtools)
# install_github("twitteR", username="geoffjentry")

require(twitteR)
api_key <- ""
api_secret <- ""
access_token <- ""
access_token_secret <- ""

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
rm(api_key)
rm(api_secret)
rm(access_token)
rm(access_token_secret)
# EQ = searchTwitter("EarthQuake", since='2014-09-24')
