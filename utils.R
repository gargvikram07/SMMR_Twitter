cleanCorpus <- function(myCorpus){
  # Transformations, including 
  # 1. changing letters to lower case, 
  # 2. removing punctuations/numbers 
  # 3. removing stop words. 
  library(tm)
  myCorpus <- tm_map(myCorpus, tolower,lazy=TRUE)
  # remove punctuation
  myCorpus <- tm_map(myCorpus, removePunctuation,lazy=TRUE)
  # remove numbers
  myCorpus <- tm_map(myCorpus, removeNumbers,lazy=TRUE)
  # remove stopwords
  myStopwords <- c(stopwords('english'), 'available', 'via')
  idx <- which(myStopwords == 'r')
  myStopwords <- myStopwords[-idx]
  myCorpus <- tm_map(myCorpus, myStopwords,lazy=TRUE)
  myCorpus <- tm_map(myCorpus, stemDocument,lazy=TRUE)
}








