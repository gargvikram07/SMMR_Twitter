meru = paste(MeruTweetsCleaned, collapse=" ")
ola = paste(OlaTweetsCleaned, collapse=" ")
tfs = paste(TaxiForSureTweetsCleaned, collapse=" ")
uber = paste(UberTweetsCleaned, collapse=" ")

# put everything in a single vector
all = c(meru, ola, tfs, uber)
# remove stop-words
require(tm)
require(wordcloud)
all = removeWords(all,stopwords("english"))

all = removeWords(all,c("ola", "code", "app", "download", "sign","earn", "olacabs", "referral"))
all = removeWords(all,c("meru", "booking", "cabs"))
all = removeWords(all,c("you", "your", "team", "address", "taxiforsure","taxi","for","sure"))
all = removeWords(all,c("blame", "news", "uber", "delhi"))
# create corpus
corpus = Corpus(VectorSource(all))

# create term-document matrix
tdm = TermDocumentMatrix(corpus)

# convert as matrix
tdm = as.matrix(tdm)

# add column names
colnames(tdm) = c("MeruCabs", "OlaCabs", "TaxiForSure", "UberIndia")

# comparison cloud
comparison.cloud(tdm, random.order=FALSE,colors = c("#00B2FF", "red", "#FF0099", "#6600CC"), title.size=1.5, max.words=500)

