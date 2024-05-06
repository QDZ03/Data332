 # Uber Assignment
 ## Contributor
 <p> Quang Nguyen </p>

 ## Introduction
 <p>I will analyze the data from Uber in 2014. </p>

## Data Dictionary
### Main Columns
<p>Date.Time: Date and time of the data</p>
<p>Lon: Longitude of the location</p>
<p>Lat: Latitude of the location</p>
<p>Base: The Base ID </p>

 ## Install Packages and Library
```
library(ggplot2)
library(shiny)
library(DT)
library(readxl)
library(dplyr)
library(tidyverse)
library(tidyr)
library(lubridate)
library(viridis)
library(leaflet)
library(leaflet.extras)
```
 ## Data Cleaning
 <p>1. Getting the data and bind them together.</p>

```
uber_apr<-read.csv('uber-raw-data-apr14.csv')
uber_may<-read.csv('uber-raw-data-may14.csv')
uber_jun<-read.csv('uber-raw-data-jun14.csv')
uber_jul<-read.csv('uber-raw-data-jul14.csv')
uber_aug<-read.csv('uber-raw-data-aug14.csv')
uber_sep<-read.csv('uber-raw-data-sep14.csv')

# Binding data
df <- data.frame()
df <- rbind(uber_apr, uber_may, uber_jun, uber_jul, uber_aug, uber_sep
```

<p>2. Cleaning data: Separate Date.Time to Date and Time columns.</p>

```
# Changing Date.Time to Date schema
df[c('Date', 'Time')] <- str_split_fixed(df$Date.Time, ' ', 2)
df <- df[, c(5, 1:6)]
df <- df[, c(1, 7, 2:6)]
df <- subset(df, select = -c(Date.Time, Date.1))
```

<p>3. Getting different columns from Date and Time: Hour, Month, Day, Week, and Weekdays

```
df <- df %>%
  mutate(Hour = hour(hms(Time)),
         Month = month(mdy(Date), label = TRUE),
         Day = day(mdy(Date)),
         Year = year(mdy(Date)),
         Week = week(mdy(Date)),
         Weekday = weekdays(parse_date_time(Date, orders = c("mdy", "ymd", "dmy"))))
df$Week <- as.integer(df$Week)
df$Week <- df$Week - min(df$Week)

df$Week <- ifelse(-1 < df$Week & df$Week <= 5 & df$Month == "Apr",
                  df$Week - 0 + 1,
                  ifelse(4 < df$Week & df$Week <= 10 & df$Month == "May",
                  df$Week - 5 + 1,
                  ifelse(8 < df$Week & df$Week <= 14 & df$Month == "Jun",
                         df$Week - 9 + 1,
                         ifelse(12 < df$Week & df$Week <= 19 & df$Month == "Jul",
                                df$Week - 13 + 1,
                                ifelse(17 < df$Week & df$Week <= 23 & df$Month == "Aug",
                                       df$Week - 18 + 1,
                                       df$Week - 22 + 1
                                )
                         )
                  )
                  )
)
```
## Pivot table 

<p>Create a pivot table to display trips by hour, month, day, year, week, and weekdays.</p>

```
pivot_table <- df %>%
  group_by(Month, Hour, Day, Week, Weekday, Base) %>%
  summarise(Trips = n())
# Getting day of the week in order
pivot_table$Weekday <- factor(pivot_table$Weekday,
                                 levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"),
                                 ordered = TRUE)
```

## Leaflet Map

<p>Create a leaflet map function for later use in Shiny.</p>

```
Map_leaflet <- function(df) {
  sample_df <- df %>% sample_n(100000, replace = FALSE)
  
  leaflet(sample_df) %>%
    addTiles() %>%
    addMarkers(
      lng = ~Lon,
      lat = ~Lat,
      popup = ~paste("Date:", Date, "<br>Time:", Time, "<br>Base: ", Base),
      clusterOptions = markerClusterOptions()
    ) 
}
```

## Shiny App
<p>1. Define UI: I use different tabs for each graphs and make some analysis for them /p>

```
ui <- fluidPage(
  titlePanel("Interactive Charts and Map"),
  tabsetPanel(
    tabPanel("Trips by Hour and Month",
             fluidPage(
               titlePanel("Trips by Hour and Month"),
               mainPanel(
                 plotOutput("trips_hour_month"),
                 # Add analysis or description specific to this graph
                 p("This graph displays trips by hour and month, providing insights into hourly trends."),
                 p("Base on this graph: "), 
                 p("- Uber have the most trips around 6pm (rush hour) and least trips around 4am (night time)."),
                 p("- Most of the trips are in September, when summer is over and everybody has to travel more than usual.")  
               )
             )),
    tabPanel("Trips Every Hour",
             fluidPage(
               titlePanel("Trips Every Hour"),
               mainPanel(
                 plotOutput("trips_every_hour"),
                 # Add analysis or description specific to this graph
                 p("This graph shows a more specific stats with the number of trips taken every hour throughout the day.")
               )
             )),
    tabPanel("Trips by Day of Month",
             fluidPage(
               titlePanel("Trips by Day of Month"),
               mainPanel(
                 plotOutput("trips_day_month"),
                 # Add analysis or description specific to this graph
                 p("This graph illustrates the variation in trips across different days of the month."),
                 p("Base on this graph: "),
                 p("- Trips are equally distributed by day of month with the highest point on the 30th and lowest on the 31st since there are only 3 months with that day."),
                 p("- The average trips per day were around 15 thousands, which created many benefits for the company and we could see its stableness.")
               )
             )),
    tabPanel("Number of Trips by Month and Day of Week",
             fluidPage(
               titlePanel("Number of Trips by Month and Day of Week"),
               mainPanel(
                 plotOutput("trips_month_day_week"),
                 # Add analysis or description specific to this graph
                 p("This graph displays the number of trips by month and day of the week, highlighting patterns."),
                 p("Base on this graph: "),
                 p("- The most trips in April and June and July were consecutively on Wednesday and Tuesday, which are in the middle of the week."),
                 p("- Sunday is the day that have the least trips throughout those six months. This can be concluded that passengers were unlikely to go out in the weekends."),
                 p("- Most trips in May, June, and September were on Friday. This is the day when people travel outside after a long week of working.")
               )
             )),
    tabPanel("Trips by Bases and Month",
             fluidPage(
               titlePanel("Trips by Bases and Month"),
               mainPanel(
                 plotOutput("trips_bases_month"),
                 # Add analysis or description specific to this graph
                 p("This graph visualizes trips based on different bases and months, providing insights into usage."),
                 p("Base on this graph, we can see that Base 'B02764' has the least trips. Other bases have equal trips throughout the months.")
               )
             )),
    tabPanel("Heatmap by Hour and Day",
             fluidPage(
               titlePanel("Heatmap by Hour and Day"),
               mainPanel(
                 plotOutput("heatmap_hour_day"),
                 # Add analysis or description specific to this graph
                 p("This heatmap shows the distribution of trips by hour and day."),
                 p("According to this heat map: "),
                 p("- Drivers had their most trips around 5pm-6pm everyday and least during the early morning around 2pm everyday."),
                 p("- Drivers should drive more during the rush hours and less during night time and early morning to have the best income.")
               )
             )),
    tabPanel("Heatmap by Month and Day",
             fluidPage(
               titlePanel("Heatmap by Month and Day"),
               mainPanel(
                 plotOutput("heatmap_month_day"),
                 # Add analysis or description specific to this graph
                 p("This heatmap displays the trips heatmap by month and day, highlighting busy periods."),
                 p("- The most trips recorded were in September, especially in the 27th."),
                 p("- For other months, trips were distributed equally everyday but were recorded high at the end of the month, especially in July and August.")
               )
             )),
    tabPanel("Heatmap by Month and Week",
             fluidPage(
               titlePanel("Heatmap by Month and Week"),
               mainPanel(
                 plotOutput("heatmap_month_week"),
                 # Add analysis or description specific to this graph
                 p("This heatmap visualizes trips by month and week, showing trends over time."),
                 p("Most of the trips were in the final week of the every months.")
               )
             )),
    tabPanel("Heatmap by Base and Day of Week",
             fluidPage(
               titlePanel("Heatmap by Base and Day of Week"),
               mainPanel(
                 plotOutput("heatmap_base_day_week"),
                 # Add analysis or description specific to this graph
                 p("This heatmap illustrates trips by base and day of the week, highlighting usage patterns."),
                 p("From this heatmap, we see that: "),
                 p("- Most drivers were actived on Friday and Saturday, especially base 'B02617'. "),
                 p("- This illustrated that most people travels during Friday and Saturday since those are their day-off.")
               )
             )),
  tabPanel("Leaflet Map",
           fluidPage(
             titlePanel("Leaflet Map"),
             mainPanel(
               leafletOutput("leaflet"),
               column(2, actionButton("refreshButton", "Refresh"))
             )
           ))
  )
)
```

<p>2. Define server: Graphs and map outputs.</p>

```
# Define server logic
server <- function(input, output) {

  output$trips_hour_month <- renderPlot({
      ggplot(pivot_table, aes(x = Hour, y = Trips, fill = Month)) +
        geom_bar(stat = "identity", position = "dodge") +
        labs(x = "Hour of Day", y = "Trips", title = "Trips by Hour and Month") +
        scale_x_continuous(breaks = seq(0, 23, by = 1)) +
        theme_minimal()
  })
  output$trips_every_hour <- renderPlot({
      ggplot(pivot_table, aes(x = Hour, y = Trips, fill = factor(Hour))) +
        geom_bar(stat = "identity", fill = "#0066CC") +
        labs(x = "Hour of Day", y = "Trips", title = "Trips Every Hour") +
        scale_x_continuous(breaks = seq(0, 23, by = 1)) +
        scale_y_continuous(labels = function(x) format(x, scientific = FALSE)) +
        theme_minimal()
  })
  output$trips_day_month <- renderPlot({
      ggplot(pivot_table, aes(x = Day, y = Trips)) +
        geom_bar(stat = "identity", fill = "#66CCFF") +
        labs(x = "Day of Month", y = "Trips", title = "Trips by Day of Month") +
        scale_x_continuous(breaks = seq(1, max(pivot_table$Day), by = 1)) +
        theme_minimal()
  }) 
  output$trips_month_day_week <- renderPlot({
      ggplot(pivot_table, aes(x = Month, y = Trips, fill = Weekday)) +
        geom_bar(stat = "identity", position = "dodge") +
        labs(x = "Month", y = "Trips", title = "Number of Trips by Month and Day of Week") +
        scale_fill_manual(values = c("Monday" = "skyblue", "Tuesday" = "orange", "Wednesday" = "green",
                                     "Thursday" = "yellow", "Friday" = "blue", "Saturday" = "purple", "Sunday" = "red"))+
        theme_minimal()
  }) 
  output$trips_bases_month <- renderPlot({
      ggplot(pivot_table, aes(x = Base, fill = Month)) +
        geom_bar() +
        labs(x = "Base", y = "Trips", title = "Trips by Bases and Month") +
        theme_minimal()
  }) 
  output$heatmap_hour_day <- renderPlot({
      heatmap_DayHour <- df %>%
        group_by(Day, Hour) %>%
        summarise(Trips = n()) %>%
        pivot_wider(names_from = Hour, values_from = Trips, values_fill = 0)
      
      heatmap_matrix <- as.matrix(heatmap_DayHour[, -1])
      
      heatmap(heatmap_matrix, Rowv = NA, Colv = NA,
              col = viridis::viridis(20),
              xlab = "Hour", ylab = "Day", main = "Heatmap by Hour and Day")
  }) 
  output$heatmap_month_day <- renderPlot({
      ggplot(pivot_table, aes(x = Day, y = Month)) +
        geom_tile(aes(fill = Trips)) +
        scale_fill_viridis_c() +
        labs(x = "Day", y = "Month", fill = "Trips", title = "Heatmap by Month and Day") +
        theme_minimal()
  }) 
  output$heatmap_month_week <- renderPlot({
      ggplot(pivot_table, aes(x = Week, y = Month)) +
        geom_tile(aes(fill = Trips)) +
        scale_fill_viridis_c() +
        labs(x = "Week", y = "Month", fill = "Trips", title = "Heatmap by Month and Week") +
        theme_minimal()
  }) 
  output$heatmap_base_day_week <- renderPlot({
      ggplot(pivot_table, aes(x = Base, y = Weekday)) +
        geom_tile(aes(fill = Trips)) +
        scale_fill_viridis_c() +
        labs(x = "Base", y = "Weekday", fill = "Trips", title = "Heatmap by Base and Day of Week") +
        theme_minimal()
  }) 
  output$leaflet <- renderLeaflet({ Map_leaflet(df) })
  # Handle the refresh button
  observeEvent(input$refreshButton, {
    output$leaflet <- renderLeaflet({ Map_leaflet(df) })
  })
}
```
<p>3. Run the application</p>

```
shinyApp(ui = ui, server = server)
```
