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

<p>With numerous complaints from customers, the first step is to identify which companies received the most negative complaints</p>

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

- Most negative complaints are in big companies such as Equifax, Wells Fargo, and Bank of America, with over 20000 negative words

### 2. Top 10 most negative words 

<p>To clearly understand why customers were having complaints about these companies, we need to look for keywords that appear the most in those complaints </p>

<p>To look for negative words, I use "nrc" sentiment to identify and count the number of words precisely. </p>

```
nrc_word_counts <- tidy_complaints %>%
  inner_join(get_sentiments("nrc")) %>% 
  filter(sentiment == "negative") %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()
nrc_word_counts
```
<img width="555" alt="Top 10 negative words from customer complaints" src="https://github.com/QDZ03/Data332/assets/159860533/1f52cc55-5536-4777-b2a7-0dc035855c3b">





