library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidytext)
library(stringr)
library(tidyr)
library(wordcloud)

rm(list = ls())

#Set up directory
setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming/Consumer Complaint Text Analysis')
df <- read.csv('Data/Consumer_Complaints.csv')

#Remove blank Consumer complaint narrative
df <- df %>%
  filter(Consumer.complaint.narrative != "")
#Turning customer complaints to a row of words to inner join sentiment analysis
tidy_complaints <- df %>%
  unnest_tokens(word, Consumer.complaint.narrative) 
  
#Group by company, inner join "bing" negative sentiments and arrange the number of negative complaints from high to low
negative_company <- tidy_complaints %>%
  group_by(Company) %>%
  inner_join(get_sentiments("bing")) %>%
  filter(sentiment == "negative") %>%
  count(Company, sentiment) %>%
  arrange(desc(n))
#Pick top 20 company with the most negative complaints
top_20_negative_company <- head(negative_company,20) 
#Plot the data
ggplot(data = top_20_negative_company, aes(x = n, y = reorder(Company, n))) +
  geom_bar(stat = "identity", fill = "blue") + 
  labs(title = "Top 20 companies with neagative complaints", 
       x = "Negative complaints", y = "Company") +
  theme_minimal()

#Get negative nrc sentiment words using 
bing_word_counts <- tidy_complaints %>%
  inner_join(get_sentiments("nrc")) %>% 
  filter(sentiment == "negative") %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()
bing_word_counts

#Find the most negative words
bing_word_counts %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)

#Word bubbles
tidy_complaints %>%
  inner_join(get_sentiments("bing")) %>%
  filter(sentiment == "negative") %>%
  count(word, sentiment) %>%
  with(wordcloud(word, n, max.words = 100))
