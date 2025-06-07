# This script will create a shiny app that visualizes ABS CPI data
# across Australia.

# Load necessary libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
# Load the ABS CPI data
cpi_data <- read.csv("All groups CPI and Trimmed mean, Australia, annual movement (%).csv") # nolint

nrow(cpi_data)
# Check the structure of the data
str(cpi_data)
# Convert the 'Year' column to a factor
cpi_data$Year <- as.factor(cpi_data$Year)
# Create a Shiny app
ui <- fluidPage(
  titlePanel("ABS CPI Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput("region", "Select Region:", 
                  choices = unique(cpi_data$Region), 
                  selected = "Australia"),
      selectInput("cpi_type", "Select CPI Type:", 
                  choices = c("All groups CPI", "Trimmed mean"), 
                  selected = "All groups CPI")
    ),
    mainPanel(
      plotOutput("cpiPlot")
    )
  )
)
server <- function(input, output) {
  output$cpiPlot <- renderPlot({
    filtered_data <- cpi_data %>%
      filter(Region == input$region, CPI_Type == input$cpi_type)
    
    ggplot(filtered_data, aes(x = Year, y = Value)) +
      geom_line() +
      geom_point() +
      labs(title = paste("CPI Data for", input$region, "-", input$cpi_type),
           x = "Year",
           y = "CPI (%)") +
      theme_minimal()
  })
}
# Run the Shiny app
shinyApp(ui = ui, server = server)
# Save the app as a Shiny app
# Note: To run this app, save the code in a file named "app.R" and run it in RStudio or any R environment that supports Shiny. # nolint
