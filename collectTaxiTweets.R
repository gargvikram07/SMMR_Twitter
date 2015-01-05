# Load the necessary packages
source('authenticate.R')
source('utils.R')

Meru_tweets = searchTwitter("MeruCabs", n=2000, lang="en")
Ola_tweets = searchTwitter("OlaCabs", n=2000, lang="en")
TaxiForSure_tweets = searchTwitter("TaxiForSure", n=2000, lang="en")
Uber_tweets = searchTwitter("Uber_Delhi", n=2000, lang="en")


# BangaloreGeoCode = '77.59456,12.9716,100mi'
# Meru_tweets = searchTwitter("#MeruCabs", n=2000, lang="en", geocode = BangaloreGeoCode,retryOnRateLimit=10)
# Ola_tweets = searchTwitter("#OlaCabs", n=2000, lang="en", geocode = BangaloreGeoCode)
# TaxiForSure_tweets = searchTwitter("#TaxiForSure", n=2000, lang="en", geocode = BangaloreGeoCode)
# Uber_tweets = searchTwitter("#UberIndia", n=2000, lang="en", geocode = BangaloreGeoCode)


# # The latest Tweets from Meru Cabs (@MeruCabs)
# meruOfficialTweets = userTimeline(getUser('MeruCabs'), n = 2000)
# 
# # Check out the latest Tweets from Olacabs (@Olacabs)
# olaSupportTweets = userTimeline(getUser('support_ola'), n = 2000)
# 
# olaIndiaTweets = userTimeline(getUser('Olacabs'), n = 2000)
# olaBangaloreTweets = userTimeline(getUser('Ola_Bangalore'), n = 2000)
# olaDelhiTweets = userTimeline(getUser('Ola_Delhi'), n = 2000)
# olaMumbaiTweets = userTimeline(getUser('Ola_Mumbai)'), n = 2000)
# 
# # The latest Tweets from TaxiForSure (@taxiforsure)
# taxiForSureTweets = userTimeline(getUser('taxiforsure'), n = 2000)
# 
# # The latest Tweets from Uber India (@Uber_Mumbai)
# UberMumbaiTweets = userTimeline(getUser('Uber_Mumbai'), n = 2000)
