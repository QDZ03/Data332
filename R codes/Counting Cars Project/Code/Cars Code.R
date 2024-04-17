library(shiny)
library(ggplot2)
library(readxl)
library(dplyr)
library(lubridate)
library(DT)

setwd('C:/Users/quang/Downloads/Documents/Data 332/R-programming/Cars Project/Data')
counting_cars <- read_excel('counting_cars.xlsx')

# Subset the dataframe
df_cars <- counting_cars[, c("Date", "MPH", "Time", "Temp", "Weather")]
df_cars$Time <- as.POSIXct(df_cars$Time, format = "%H:%M:%S")
df_cars$Hour <- hour(df_cars$Time)

# Define UI
ui <- fluidPage(
  titlePanel("Counting Cars Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      # Input for selecting the plot
      selectInput("plot_type", "Choose a plot:",
                  choices = c("Density Plot of MPH by Weather", "Boxplot of MPH by Hour"))
    ),
    
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define server
server <- function(input, output) {
  
  output$plot <- renderPlot({
    # Density Plot of MPH by Weather Condition
    if (input$plot_type == "Density Plot of MPH by Weather") {
      ggplot(df_cars, aes(x = MPH, fill = Weather)) +
        geom_density(alpha = 0.5) +
        labs(title = "Density Plot of MPH by Weather Condition",
             x = "MPH", y = "Density", fill = "Weather") +
        theme_minimal()
    }
    
    # Boxplot of MPH by Hour
    else if (input$plot_type == "Boxplot of MPH by Hour") {
      ggplot(df_cars, aes(x = as.factor(Hour), y = MPH)) +
        geom_boxplot(aes(fill = Weather)) +
        stat_summary(fun = mean, geom = "point", shape = 23, size = 4, color = "black") +
        stat_summary(fun = mean, geom = "text", aes(label = round(..y.., digits = 2)), vjust = -1) +
        stat_summary(fun = median, geom = "text", aes(label = round(after_stat(y), digits = 2)), vjust = 1.5, color = "blue") +
        labs(title = "Boxplot of MPH by Hour",
             x = "Hour", y = "MPH", fill = "Weather") +
        theme_minimal() +
        scale_x_discrete(labels = function(x) paste0(x, ":00"))
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)

