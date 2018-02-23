setwd('~/Documents/SMMR_Twitter/')

library(tm)
library(ggplot2)
library(dplyr)
replaceSynonyms <- content_transformer(function(x, syn=NULL) { 
  Reduce(function(a,b) {
    gsub(paste0("\\b(", paste(b$syns, collapse="|"),")\\b"), b$word, a)}, syn, x)   
})

catch.error = function(x)
{
  # let us create a missing value for test purpose
  y = NA
  # try to catch that error (NA) we just created
  catch_error = tryCatch(tolower(x), error=function(e) e)
  # if not an error
  if (!inherits(catch_error, "error"))
    y = tolower(x)
  # check result if error exists, otherwise the function works fine.
  return(y)
}

cleanTweets <- function(tweet){
  inputTweet = as.character(tweet)
  # Clean the tweet for sentiment analysis
  #  remove html links, which are not required for sentiment analysis
  tweet = gsub("(f|ht)(tp)(s?)(://)(.*)[.|/](.*)", " ", tweet)
  # First we will remove retweet entities from the stored tweets (text)
  tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", " ", tweet)
  # Then remove all “#Hashtag”
  tweet = gsub("#\\w+", " ", tweet)
  # Then remove all “@people”
  tweet = gsub("@\\w+", " ", tweet)
  # Then remove all the punctuation
  tweet = gsub("[[:punct:]]", " ", tweet)
  # Then remove numbers, we need only text for analytics
  tweet = gsub("[[:digit:]]", " ", tweet)
  # finally, we remove unnecessary spaces (white spaces, tabs etc)
  tweet = gsub("[ \t]{2,}", " ", tweet)
  tweet = gsub("^\\s+|\\s+$", "", tweet)
  # if anything else, you feel, should be removed, you can. For example “slang words” etc using the above function and methods.
  # Next we'll convert all the word in lowar case. This makes uniform pattern.
  tweet = catch.error(tweet)
  return(list(tweet = tweet, inputTweet = inputTweet))
}

cleanTweetsAndRemoveNAs <- function (Tweets) {
  TweetsCleaned = lapply(Tweets, cleanTweets)
  TweetsCleaned <- as.data.frame(do.call(rbind,TweetsCleaned))
  TweetsCleaned = TweetsCleaned[!duplicated(TweetsCleaned$tweet), ]
  TweetsCleaned
}

getSentimentScore = function(sentences)
{
  require(plyr)
  require(stringr)
  
  opinion.lexicon.pos = scan('opinion-lexicon-English/positive-words.txt', what='character', comment.char=';')
  opinion.lexicon.neg = scan('opinion-lexicon-English/negative-words.txt', what='character', comment.char=';')
  
  words.positive = c(opinion.lexicon.pos,'upgrade')
  words.negative = c(opinion.lexicon.neg,'wait', 'unfair', 'waiting', 'wtf', 'cancellation')
  
  scores = laply(sentences, function(sentence, words.positive, words.negative) {
    
    # Let first remove the Digit, Punctuation character and Control characters:
    sentence = gsub('[[:cntrl:]]', '', gsub('[[:punct:]]', '', gsub('\\d+', '', sentence)))
    
    # Then lets convert all to lower sentence case:
    sentence = tolower(sentence)
    
    # Now lets split each sentence by the space delimiter
    words = unlist(str_split(sentence, '\\s+'))
    
    # Get the boolean match of each words with the positive & negative opinion-lexicon
    pos.matches = !is.na(match(words, words.positive))
    neg.matches = !is.na(match(words, words.negative))
    
    # Now get the score as total positive sentiment minus the total negatives
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, words.positive, words.negative, .progress='none')
  
  # Return a data frame with respective sentence and the score
  return(data.frame(text=sentences, score=scores))
}

componies = c("Myntra", "Ajio", "Jabong", "Koovs", "Voonik")
inputfileNames = paste0(componies, ".csv")
outputfileNames = paste0(componies, "_sentiment.csv")
L = NULL
for(i in 1:length(inputfileNames)){
  print(i)
  inputfileName = inputfileNames[i]
  outputfileName = outputfileNames[i]
  Tweets = read.csv(inputfileName, header = F)
  totalTweets = dim(Tweets)[1]
  names(Tweets) = c('timestamp', 'tweet')
  Tweets$timestamp = as.POSIXct(Tweets$timestamp)
  Tweets$Date = as.Date(Tweets$timestamp)
  Tweets = Tweets %>% filter(!grepl("RT @", tweet))
  H = cleanTweetsAndRemoveNAs(Tweets$tweet)
  names(H) = c("cleanedTweets", "tweet")
  H$cleanedTweets = as.character(H$cleanedTweets)
  H$tweet = as.character(H$tweet)
  Tweets$tweet = as.character(Tweets$tweet)
  Tweets = inner_join(H, Tweets)
  Tweets = Tweets[!duplicated(Tweets$cleanedTweets), ]
  
  results = getSentimentScore(sapply(Tweets$tweet, function(x){x}))
  Tweets = cbind(Tweets, results);rm(results)
  Tweets$text <- NULL
  Tweets = Tweets %>% mutate(sentiment = ifelse(score > 0, "positive", ifelse(score < 0, "negative", "neutral")))
  # Tweets$tweet <- NULL
  sentimentPer = print(round(100*table(Tweets$sentiment)/length(Tweets$sentiment), 2))
  Tweets$tweet = as.character(Tweets$tweet)
  write.csv(Tweets, file = outputfileName, row.names = F)
  L = rbind(L, data.frame(Company = componies[i], totalTweets = as.numeric(totalTweets), 
                          negative = as.numeric(sentimentPer[1]), 
                          neutral = as.numeric(sentimentPer[2]), 
                          positive = as.numeric(sentimentPer[3])))
  # print(L)
}
