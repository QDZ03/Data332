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

#Deselect Columns
df <- subset(df, select = -c(...10))

#Getting difference in days within a column
date_min <- min(df$Date)
date_max <- max(df$Date)

number_of_days_on_the_road <- date_max - date_min
print(number_of_days_on_the_road)

days <- difftime(max(df$Date), min(df$Date))
print(days)
number_of_days_recorded <- nrow(df)

#Total hours of driving
total_hours <- sum(df$Hours)
print(total_hours)

#Average Hours Per Day
avg_hours_per_day_rec <- round(total_hours / number_of_days_recorded, digits = 3)
print(avg_hours_per_day_rec)

#Fuel Cost Column and total expense per day
df$fuel_cost <- df$Gallons * df$Price.per.Gallon
df$cost_per_day <- df$fuel_cost + df$Tolls + df$Misc

#Total expenses
total_expense <- sum(df$fuel_cost) + sum(df$Tolls) + sum(df$Misc)

#Total Fuel Expenses
total_fuel_expenses <- sum(df$fuel_cost)

#Other Expenses
other_expense <- sum(df$Tolls) + sum(df$Misc)

#Total Gallons Consumed
total_gallons_consumed <- sum(df$Gallons)

#Total Miles Driven
df$miles_driven_per_day <- df$Odometer.Ending - df$Odometer.Beginning
total_miles_driven <- sum(df$miles_driven_per_day)

#Miles per Gallon
miles_per_gallon <- round(total_miles_driven / total_gallons_consumed, 3)

#Total Cost per Mile
cost_per_mile <- round(total_expense / total_miles_driven, 3)

#Split Location to Warehouse and City_State
df[c('starting_warehouse', 'starting_city_state')] <- str_split_fixed(df$Starting.Location, ',', 2)

#Split Delivery Location to Warehouse and City_state
df[c('deliveery_warehouse', 'delivery_city_state')] <- str_split_fixed(df$Delivery.Location, ',', 2)
