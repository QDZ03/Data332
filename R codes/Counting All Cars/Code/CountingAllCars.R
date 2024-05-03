library(ggplot2)
library(shiny)
library(DT)
library(readxl)
library(dplyr)
library(lubridate)
#setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming/Cars Project')

capital_letter <- function(word_list) {
  sapply(word_list, function(word) {
    paste(toupper(substring(word, 1, 1)), substring(word, 2), sep = "")
  })
}

# Get group data 
group_1 <- read_excel('CarsData/Car.xlsx', .name_repair = 'universal', col_types = c("text"), col_names = c("Speed", "Orange.Light", "Color", "Manufacturer", "Type", "Day", "Time", "Weather", "Temperature", "Name"))
group_2 <- read_excel('CarsData/Car_Data.xlsx', .name_repair = 'universal', col_types = c("text"), col_names = c("Date", "Time", "Speed", "Color", "Type", "Temperature", "Weather", "Name"))
group_3 <- read_excel('CarsData/CarData  (2).xlsx', .name_repair = 'universal', col_types = c("text"), col_names = c("Date", "Temperature", "Weather", "Time", "Speed", "Color", "State", "Name"))
group_4 <- read_excel('CarsData/counting_cars.xlsx', .name_repair = 'universal', col_types = c("text"), col_names = c("Name","Date", "Speed", "Time", "Temperature", "Weather", "V1", "V2", "V3", "V4", "V5", "V6"))
group_5 <- read.csv('CarsData/IRL_Car_Data.csv', colClasses = "character", col.names = c("Speed", "Time", "Temperature", "Weather", "Day", "Name"))
group_6 <- read_excel('CarsData/MergedCarData.xlsx', .name_repair = 'universal', col_types = c("text"), col_names = c("Date", "Time", "Speed", "Orange.Light", "State", "Weather", "Temperature", "Name"))
group_7 <- read_excel('CarsData/Speed analyst 332 Car Data.xlsx', .name_repair = 'universal', col_types = c("text"), col_names = c("Name", "Date", "Speed", "Time", "Type", "Orange.Light", "Temperature", "Weather"))
group_8 <- read.csv('CarsData/UpdatedCarTracking.csv', stringsAsFactors = FALSE, colClasses = "character", col.names = c("CarNumber", "Time", "Temperature", "Type", "Speed", "Name"))

# Add all the group data into it
group_1$Group <- 1
group_2$Group <- 2
group_3$Group <- 3
group_4$Group <- 4
group_5$Group <- 5
group_6$Group <- 6
group_7$Group <- 7
group_8$Group <- 8

# New empty frame
df <- data.frame()
df <- bind_rows(group_1, group_2, group_3, group_4, group_5, group_6, group_7, group_8)

# Drop any useless columns. 
columns_to_remove <- c("CarNumber", "V1", "V2", "V3", "V4", "V5", "V6")
df <- df[, !names(df) %in% columns_to_remove]

# Time Format
df$Time <- as.POSIXct(df$Time, format = "%H:%M:%S")
df$Hour <- hour(df$Time)

# Assign Values
df$Speed <- as.numeric(df$Speed)
df$Weather <- as.character(df$Weather)
# Clean all the data
df$Weather <- replace(df$Weather, df$Weather %in% c('Clear skies, sundown', 'Sunny, clear skies'), 'Sunny') 
#Capitalize first letter
df$Weather <- capital_letter(df$Weather) 

ui <- fluidPage(
  titlePanel("Counting Cars Analysis"), #Set the Title 
  
  sidebarLayout(
    sidebarPanel( #Users can select the plot they want to see
      # Input for selecting the plot
      selectInput("plot_type", "Choose a plot:",
                  choices = c("Density Plot of MPH by Weather", "Boxplot of MPH by Hour"))
    ),
    
    mainPanel( #Main panel where the plot will be display
      plotOutput("plot")
    )
  )
)

# Define server
server <- function(input, output) {
  output$plot <- renderPlot({
    # Check if the user selected "Density Plot of MPH by Weather"
    if (input$plot_type == "Density Plot of MPH by Weather") {
      # Create a density plot of MPH by Weather
      ggplot(df, aes(x = Speed, fill = Weather)) +
        geom_density(alpha = 0.5) + # Add density plot with transparency
        labs(title = "Density Plot of MPH by Weather Condition",
             x = "MPH", y = "Density", fill = "Weather") +
        theme_minimal()
    }
    
    # Check if the user selected "Boxplot of MPH by Hour"
    else if (input$plot_type == "Boxplot of MPH by Hour") {
      # Create a boxplot of MPH by Hour with weather grouping
      ggplot(df, aes(x = as.factor(Hour), y = Speed)) +
        geom_boxplot(aes(fill = Weather)) + # Add boxplot with weather grouping   
        stat_summary(fun = mean, geom = "point", shape = 23, size = 4, color = "black") + # Add mean points
        stat_summary(fun = mean, geom = "text", aes(label = round(after_stat(y), digits = 2)), vjust = -1) + # Add mean text label
        stat_summary(fun = median, geom = "text", aes(label = round(after_stat(y), digits = 2)), vjust = 1.5, color = "blue") + # Add median text label
        labs(title = "Boxplot of MPH by Hour",
             x = "Hour", y = "MPH", fill = "Weather") +
        theme_minimal() +
        scale_x_discrete(labels = function(x) paste0(x, ":00"))
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
