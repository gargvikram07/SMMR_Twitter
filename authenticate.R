# install.packages(c("devtools", "rjson", "bit64", "httr"))
# #RESTART R session!
# library(devtools)
# install_github("twitteR", username="geoffjentry")

require(twitteR)
api_key <- "5OhwD8Sx954OFqPzsTCGgwS3C"
api_secret <- "AwclCCeeAYhSjtETOuLaKvTwDc8Wr1Zaahj0iRcYV98uXgqLwI"
access_token <- "	64227694-Xl6vEIrE4i0gUKZAD5Ou9p9WMh5EPrdQ4FiXYZEYS"
access_token_secret <- "jiZ8k40bCxVuDZE3JJ9Lovdu7Y5yhCYpr4vIVmZ8UKoS1"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
rm(api_key)
rm(api_secret)
rm(access_token)
rm(access_token_secret)
# EQ = searchTwitter("EarthQuake", since='2014-09-24')
