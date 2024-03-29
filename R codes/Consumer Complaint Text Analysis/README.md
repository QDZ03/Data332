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

<p> To do this, I create a data frame that groups by Company and then inner join "bing," filter with negative sentiment, and count the number of words. After that, I arrange the data and picked the top 20 companies.  </p>

```
negative_company <- tidy_complaints %>%
  group_by(Company) %>%
  inner_join(get_sentiments("bing")) %>%
  filter(sentiment == "negative") %>%
  count(Company, sentiment) %>%
  arrange(desc(n))

top_20_negative_company <- head(negative_company,20)
```
<img width="555" alt="Top 20 Companies with negative complaints" src="https://github.com/QDZ03/Data332/assets/159860533/bc0b72ef-85ac-4cfe-9c4d-8fbab6c72f54">

- The chart


