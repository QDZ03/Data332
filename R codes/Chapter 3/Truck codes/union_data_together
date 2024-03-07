library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(ggplot2)

rm(list = ls())
# Setting yp working directory
setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming')
df_truck <- read_excel('Data/NP_EX_1-2.xlsx', 
                       sheet = 2, skip = 3, .name_repair = 'universal')
#Selecting Columns
df <- df_truck[, c(4:15)]

df_truck_0001 <- read_excel('Data/truck data 0001.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_0369 <- read_excel('Data/truck data 0369.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1226 <- read_excel('Data/truck data 1226.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1442 <- read_excel('Data/truck data 1442.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1478 <- read_excel('Data/truck data 1478.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1539 <- read_excel('Data/truck data 1539.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_truck_1769 <- read_excel('Data/truck data 1769.xlsx',sheet = 2, skip = 3, .name_repair = 'universal')
df_pay <- read_excel('Data/Driver Pay Sheet.xlsx', .name_repair = 'universal')
df <- rbind(df_truck_0001, df_truck_0369, df_truck_1226, df_truck_1442,
                        df_truck_1478, df_truck_1539, df_truck_1769)
df_starting_Pivot <- df_pay %>%
  group_by(Truck.ID) %>%
  summarize(count = n())
df <- left_join(df, df_pay, by = c('Truck.ID'))

df <- subset(df, select = -c(...10))
df <- subset(df, select = -c(...2))

df$miles_driven_per_day <- df$Odometer.Ending - df$Odometer.Beginning
df$salary_per_trip <- df$miles_driven_per_day * df$labor_per_mil

df_labor_pivot <- df %>% 
  group_by (Truck.ID) %>%
  summarize(Total_pay = sum(salary_per_trip, na.rm = TRUE))

ggplot(df_labor_pivot, aes(x = Truck.ID, y = Total_pay, fill = Truck.ID)) + 
  geom_col() +
  theme(axis.text = element_text(angle = 45, vjust = .5, hjust = 1)) +
  geom_bar(stat = "identity") +
  labs(title = "Driver Salary")
  
