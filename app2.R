library(shiny)
library(bslib)

# Read datasets to variables
cpi_data <- read.csv("All groups CPI and Trimmed mean, Australia, annual movement (%).csv")
goods_services_data <- read.csv("CPI, Goods and Services components, annual movement (%).csv")
# Quarterly group Change by capital city 
capital_city_data <- read.csv("Quarterly percentage change by capital city.csv")
rent_data <- read.csv("Rents, Australia, quarterly and annual movement (%).csv")

# Define UI for app that draws a line chart ----
ui <- page_sidebar(
  title = div(
    style = "display: flex; flex-direction: column;",
    h1("Cost of Living in Australia - Consumer Price Index (CPI)"),
    tags$h4(
      style = "margin-top: 0; font-size: 1.1em; font-style: italic; color: #555;",
      "Source: Australian Bureau of Statistics (ABS) - CPI Data"
    )
  ),
  sidebar = sidebar(
    "sidebar",
    position = "left"
  ),
  # Main content
  card(
    card_header("CPI and Trimmed Mean Annual Movement"),
    card_body(
      tags$p("This chart shows the annual movement in CPI and trimmed mean for Australia.")
    )
  ),
  card(
    card_header("Goods and Services Components"),
    card_body(
      tags$p(
        tags$small(
          tags$em("Breakdown of CPI by goods and services components, annual movement.")
        )
      )
    )
  )
)

server = function(input, output) {
    # Placeholder for server logic
  }
shinyApp(ui = ui, server = server)