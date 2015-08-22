# library(wordcloud)
# library(RColorBrewer)
# library(plyr)
# library(ggplot2)
require(sentiment)
# the classify_emotion function returns an object of class data.frame with 
# seven columns (anger, disgust, fear, joy, sadness, surprise, best_fit) and 
# one row for each document:
MeruTweetsClassEmo = classify_emotion(MeruTweetsCleaned, algorithm="bayes", prior=1.0)
OlaTweetsClassEmo = classify_emotion(OlaTweetsCleaned, algorithm="bayes", prior=1.0)
TaxiForSureTweetsClassEmo = classify_emotion(TaxiForSureTweetsCleaned, algorithm="bayes", prior=1.0)
UberTweetsClassEmo = classify_emotion(UberTweetsCleaned, algorithm="bayes", prior=1.0)

# we will fetch emotion category best_fit for our analysis purposes.
MeruEmotion = MeruTweetsClassEmo[,7]
OlaEmotion = OlaTweetsClassEmo[,7]
TaxiForSureEmotion = TaxiForSureTweetsClassEmo[,7]
UberEmotion = UberTweetsClassEmo[,7]

# Replace NA’s by word “unknown”
MeruEmotion[is.na(MeruEmotion)] = "unknown"
OlaEmotion[is.na(OlaEmotion)] = "unknown"
TaxiForSureEmotion[is.na(TaxiForSureEmotion)] = "unknown"
UberEmotion[is.na(UberEmotion)] = "unknown"

# Similar to above, we will classify polarity 
MeruTweetsClassPol = classify_polarity(MeruTweetsCleaned, algorithm="bayes")
OlaTweetsClassPol = classify_polarity(OlaTweetsCleaned, algorithm="bayes")
TaxiForSureTweetsClassPol = classify_polarity(TaxiForSureTweetsCleaned, algorithm="bayes")
UberTweetsClassPol = classify_polarity(UberTweetsCleaned, algorithm="bayes")

# we will fetch polarity category best_fit for our analysis purposes, 
MeruPol = MeruTweetsClassPol[,4]
OlaPol = OlaTweetsClassPol[,4]
TaxiForSurePol = TaxiForSureTweetsClassPol[,4]
UberPol = UberTweetsClassPol[,4]

# Let us now create a data frame with the above results 
MeruSentimentDataFrame = data.frame(text=MeruTweetsCleaned, emotion=MeruEmotion, polarity=MeruPol, stringsAsFactors=FALSE)
OlaSentimentDataFrame = data.frame(text=OlaTweetsCleaned, emotion=OlaEmotion, polarity=OlaPol, stringsAsFactors=FALSE)
TaxiForSureSentimentDataFrame = data.frame(text=TaxiForSureTweetsCleaned, emotion=TaxiForSureEmotion, polarity=TaxiForSurePol, stringsAsFactors=FALSE)
UberSentimentDataFrame = data.frame(text=UberTweetsCleaned, emotion=UberEmotion, polarity=UberPol, stringsAsFactors=FALSE)

# rearrange data inside the frame by sorting it
MeruSentimentDataFrame = within(MeruSentimentDataFrame, emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
OlaSentimentDataFrame = within(OlaSentimentDataFrame, emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
TaxiForSureSentimentDataFrame = within(TaxiForSureSentimentDataFrame, emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))
UberSentimentDataFrame = within(UberSentimentDataFrame, emotion <- factor(emotion, levels=names(sort(table(emotion), decreasing=TRUE))))

plotSentiments1 <- function (sentiment_dataframe,title) {
  require(ggplot2)
  ggplot(sentiment_dataframe, aes(x=emotion)) + geom_bar(aes(y=..count.., fill=emotion)) +
    scale_fill_brewer(palette="Dark2") +
    ggtitle(title) +
    theme(legend.position='right') + ylab('Number of Tweets') + xlab('Emotion Categories')
}

plotSentiments1(MeruSentimentDataFrame, 'Sentiment Analysis of Tweets on Twitter about MeruCabs')
plotSentiments1(OlaSentimentDataFrame, 'Sentiment Analysis of Tweets on Twitter about OlaCabs')
plotSentiments1(TaxiForSureSentimentDataFrame, 'Sentiment Analysis of Tweets on Twitter about TaxiForSure')
plotSentiments1(UberSentimentDataFrame, 'Sentiment Analysis of Tweets on Twitter about UberIndia')

# Similary we will plot distribution of polarity in the tweets
plotSentiments2 <- function (sentiment_dataframe,title) {
  require(ggplot2)
  ggplot(sentiment_dataframe, aes(x=polarity)) +
    geom_bar(aes(y=..count.., fill=polarity)) +
    scale_fill_brewer(palette="RdGy") +
    ggtitle(title) +
    theme(legend.position='right') + ylab('Number of Tweets') + xlab('Polarity Categories')
}

plotSentiments2(MeruSentimentDataFrame, 'Polarity Analysis of Tweets on Twitter about MeruCabs')
plotSentiments2(OlaSentimentDataFrame, 'Polarity Analysis of Tweets on Twitter about OlaCabs')
plotSentiments2(TaxiForSureSentimentDataFrame, 'Polarity Analysis of Tweets on Twitter about TaxiForSure')
plotSentiments2(UberSentimentDataFrame, 'Polarity Analysis of Tweets on Twitter about UberIndia')

removeCustomeWords <- function (TweetsCleaned) {
  for(i in 1:length(TweetsCleaned)){
    TweetsCleaned[i] <- tryCatch({
      TweetsCleaned[i] =  removeWords(TweetsCleaned[i], c(stopwords("english"), "care", "guys", "can", "dis", "didn", "guy" ,"booked", "plz"))
      TweetsCleaned[i]
    }, error=function(cond) {
      TweetsCleaned[i]
    }, warning=function(cond) {
      TweetsCleaned[i]
    })  
  }
  return(TweetsCleaned)
}

getWordCloud <- function (sentiment_dataframe, TweetsCleaned, Emotion) {
  emos = levels(factor(sentiment_dataframe$emotion))
  n_emos = length(emos)
  emo.docs = rep("", n_emos)
  TweetsCleaned = removeCustomeWords(TweetsCleaned)
  
  for (i in 1:n_emos){
    emo.docs[i] = paste(TweetsCleaned[Emotion == emos[i]], collapse=" ")
  }
  corpus = Corpus(VectorSource(emo.docs))
  tdm = TermDocumentMatrix(corpus)
  tdm = as.matrix(tdm)
  colnames(tdm) = emos
  require(wordcloud)
  suppressWarnings(comparison.cloud(tdm, colors = brewer.pal(n_emos, "Dark2"),  scale = c(3,.5), random.order = FALSE, title.size = 1.5))
}

getWordCloud(MeruSentimentDataFrame, MeruTweetsCleaned, MeruEmotion)
getWordCloud(OlaSentimentDataFrame, OlaTweetsCleaned, OlaEmotion)
getWordCloud(TaxiForSureSentimentDataFrame, TaxiForSureTweetsCleaned, TaxiForSureEmotion)
getWordCloud(UberSentimentDataFrame, UberTweetsCleaned, UberEmotion)


