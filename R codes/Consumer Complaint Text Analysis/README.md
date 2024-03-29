 # Consumer Complaints
 ## Contributor
 <p> Quang Nguyen </p>

 ## Introduction
 <p>I will analyze the consumer complaints narrative to identify which companies 
  have the most negative comments and solutions to solve those. </p>

 ## Data Cleaning
 <p>Consumer complaints narrative: Clearing the blank complaints and turning those into a row of words to later inner join sentiment analysis.</p>
 
```
df <- df %>%
  filter(Consumer.complaint.narrative != "")

tidy_complaints <- df %>%
  unnest_tokens(word, Consumer.complaint.narrative)
```
## Data Analysis
### 1. Top 20 companies with negative complaints

<p>With numerous customer complaints, the first step is to identify which companies received the most negative complaints.</p>

<p> To do this, I create a data frame that groups by Company and then inner join "bing," filter with negative sentiment, and count the number of words. After that, I arranged the data and picked the top 20 companies.  </p>

```
negative_company <- tidy_complaints %>%
  group_by(Company) %>%
  inner_join(get_sentiments("bing")) %>%
  filter(sentiment == "negative") %>%
  count(Company, sentiment) %>%
  arrange(desc(n))

top_20_negative_company <- head(negative_company,20)
```
<img width="555" alt="Top 20 companies with negative customer complaints" src="https://github.com/QDZ03/Data332/assets/159860533/7d0a52be-3ab9-4803-a673-385a2aff4b27">

- Most negative complaints are in big companies such as Equifax, Wells Fargo, and Bank of America, with over 20000 negative words.

### 2. Top 10 most negative words 

<p>To clearly understand why customers were having complaints about these companies, we need to look for keywords that appear the most in those complaints. </p>

<p>To look for negative words, I use "nrc" sentiment to identify and precisely count the number of words. </p>

```
nrc_word_counts <- tidy_complaints %>%
  inner_join(get_sentiments("nrc")) %>% 
  filter(sentiment == "negative") %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()
nrc_word_counts
```
<img width="555" alt="Top 10 negative words from customer complaints" src="https://github.com/QDZ03/Data332/assets/159860533/1f52cc55-5536-4777-b2a7-0dc035855c3b">
- Most people have complaints about late debt or payment, dispute calls, and fraud when complaining with those companies.

### 3. Word bubble of negative complaints

<p>After knowing negative complaints from customers, I can show a big picture of more negative words.</p>

<p>I will use the word bubble of "nrc" negative sentiment and see the top 100 words.</p>

```
tidy_complaints %>%
  inner_join(get_sentiments("nrc")) %>%
  filter(sentiment == "negative") %>%
  count(word, sentiment) %>%
  with(wordcloud(word, n, max.words = 100))
```
<img width="555" alt="Complaints word bubble" src="https://github.com/QDZ03/Data332/assets/159860533/424d73bd-4b6e-435f-ba83-ddd849175ac5">

# Conclusion

1. With this data, customers can realize that big companies have lots of problems, and they can shift to big companies with low negative comments.
2. Companies with high negative complaints should consider and fix their problems in time.   



