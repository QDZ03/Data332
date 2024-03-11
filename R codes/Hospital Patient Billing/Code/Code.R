library(tidyverse)
library(ggplot2)
library(here)
library(dplyr)
library(readxl)
library(kableExtra)

#Set Work Directory
setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming/Hospital Patient Billing')
visit <- read_excel('Data/Visit.xlsx')
billing <- read_excel('Data/Billing.xlsx')
patient <- read_excel('Data/Patient.xlsx')

#Left Join the data together and find insights in the data
visit_billing <- left_join(visit, billing, by = 'VisitID')
df <- left_join(patient, visit_billing, by = 'PatientID')

#Clean data
df <- df[-205, ]

#Chart on the reason of visit segmented by month of the year
df$month_year <- substr(df$VisitDate, start = 1, stop = 7)
reason_summary <- df %>%
  group_by(Reason, month_year) %>%
  summarize(count_by_reason = n())

ggplot(data = reason_summary, aes(x = count_by_reason, y = Reason, fill = month_year)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Reason of visit segmented by month of the year",
       x = "Number of Reason", y = "Reason") +
  scale_fill_discrete(name = "Visit Date") +
  theme_minimal() 

#Reason for visit bases on walk in or not 
reasonbywalkin_summary <- df %>%
  group_by(Reason, WalkIn) %>%
  summarize(count_by_reason = n())

ggplot(data = reasonbywalkin_summary, aes(x = count_by_reason, y = Reason, fill = WalkIn)) +
  geom_bar(stat = "identity", position = "stack") + 
  labs(title = "Reason for visit bases on walk in", 
       x = "Number of Reason", y = "Reason") +
  scale_fill_discrete(name = "Walk-in") +
  theme_minimal()

#Reason for visit based on zip code
reasonbyzipcode_summary <- df %>%
  group_by(Reason, Zip) %>%
  summarize(count_by_reason = n())

ggplot(data = reasonbyzipcode_summary, aes(x = count_by_reason, y = Reason, fill = Zip)) +
  geom_bar(stat = "identity", position = "stack") + 
  labs(title = "Reason for visit based on zip code", 
       x = "Number of Reason", y = "Reason") +
  scale_fill_discrete(name = "Zip Code") +
  theme_minimal()

#Total invoice amount based on reason for visit, segmented with it was paid
totalinvoicebyreason_summary <- df %>%
  group_by(InvoiceAmt, Reason, InvoicePaid) %>%
  summarize(total_invoice = sum(InvoiceAmt)) 

ggplot(data = totalinvoicebyreason_summary, aes(x = total_invoice, y = Reason, fill = InvoicePaid)) +
  geom_bar(stat = 'identity', position = 'stack') +
  labs(title = "Total invoice amount based on reason for visit, segmented with paid invoice",
       x = "Total Invoice", y = "Reason") +
  scale_fill_discrete(name = "Invoice Paid") +
  theme_minimal()
