if (!require(twitteR, character.only=T, quietly=T)) {
  install.packages(c("devtools", "rjson", "bit64", "httr")) 
  library(devtools) 
  install_github(“geoffjentry/twitteR”)
  library(twitteR) 
}

if (!require(ggplot2, character.only=T, quietly=T)) {
  install.packages('ggplot2', dep = TRUE) 
  require(ggplot2)
}

if (!require(sentiment, character.only=T, quietly=T)) {
  install.packages("Rstem", repos = "http://www.omegahat.org/R", type="source") 
  install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz") 
  require(sentiment) 
  ls("package:sentiment") 
}

for (package in c('tm', 'wordcloud', 'tau')) {
  if (!require(package, character.only=T, quietly=T)) {
    install.packages(package)
    library(package, character.only=T)
  }
}

