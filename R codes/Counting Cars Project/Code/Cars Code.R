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
      ggplot(df_cars, aes(x = MPH, fill = Weather)) +
        geom_density(alpha = 0.5) + # Add density plot with transparency
        labs(title = "Density Plot of MPH by Weather Condition",
             x = "MPH", y = "Density", fill = "Weather") +
        theme_minimal()
    }
    
    # Check if the user selected "Boxplot of MPH by Hour"
    else if (input$plot_type == "Boxplot of MPH by Hour") {
      # Create a boxplot of MPH by Hour with weather grouping
      ggplot(df_cars, aes(x = as.factor(Hour), y = MPH)) +
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

