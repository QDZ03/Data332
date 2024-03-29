 # Consumer Complaints
 ## Contributor
 <p> Quang Nguyen </p>

 ## Introduction
 <p>I will analyze the consumer complaints narrative to identify which companies 
  have the most negative comments and solutions to solve for those. </p>

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
<img width="555" alt="Top 20 Companies with negative complaints" src="https://github.com/QDZ03/Data332/assets/159860533/bc0b72ef-85ac-4cfe-9c4d-8fbab6c72f54">



