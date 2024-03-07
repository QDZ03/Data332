library(readxl)
library(dplyr)
library(ggplot2)

#Set work directory
setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming')
students <- read_excel('Data/Student.xlsx')
courses <- read_excel('Data/Course.xlsx')
registrations <- read_excel('Data/Registration.xlsx')

#Left Join the data together and find insights in the data.
course_registration <- left_join(courses, registrations, by = "Instance ID", )
student_course_registration <- left_join(students, course_registration, by = "Student ID")
df <- student_course_registration

#Chart on the number of majors (TITLE) 
title_total <- df %>%
  group_by(Title) %>%
  summarize(count_by_title = n())

ggplot(data = title_total, aes(x = Title, y = count_by_title, fill = Title))+ 
  geom_col() +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1)) +
  geom_bar(stat = "identity") +
  labs(title = "Students' Titles", x = "Title", y = "Number of Titles")+
  theme_minimal()

#Chart on the birth year of the student
df$birth_year <- as.integer(substr(df$`Birth Date`, 1, 4))

birthyear_summary <- df %>% 
  group_by(birth_year) %>%
  summarize(count_by_birth_year = n())

ggplot(data = birthyear_summary, aes(x = birth_year, y = count_by_birth_year, fill = birth_year))+ 
  geom_col() +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1)) +
  geom_bar(stat = "identity") + 
  labs(title = "Students' birth year", x = "Year", y = "Number of students")+
  theme_minimal()

#Total cost per major, segment by payment plan

costpermajor_summary <- df %>%
  group_by(Title, `Payment Plan`) %>%
  summarize(cost_per_major = sum(`Total Cost`))

costpermajor_summary$cost_per_major <- as.numeric(as.character(costpermajor_summary$cost_per_major))

ggplot(data = costpermajor_summary, aes(x = Title, y = cost_per_major, fill = `Payment Plan`)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Cost per Major Segmented by Payment Plan",
       x = "Major", y = "Total Cost") +
  scale_fill_discrete(name = "Payment Plan Available",
                      labels = c("No", "Yes")) +
  theme_minimal() +
  scale_y_continuous(labels = function(x) format(x, big.mark = ",", scientific = FALSE))

#Total balance due by major, segment by payment plan 
balanceduepermajor_summary <- df %>%
  group_by(Title, `Payment Plan`) %>%
  summarize(balance_due_per_major = sum(`Balance Due`))

ggplot(data = balanceduepermajor_summary, aes(x = Title, y = balance_due_per_major, fill = `Payment Plan`)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Total Balance Due by Major Segmented by Payment Plan",
       x = "Major", y = "Total Balance Due") +
  scale_fill_discrete(name = "Payment Plan Available",
                      labels = c("No", "Yes")) +
  theme_minimal()
