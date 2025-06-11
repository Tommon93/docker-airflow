library(shiny)
library(bslib)
library(ggplot2)
library(tidyr)
library(plotly)

# Read datasets to variables
cpi_data <- read.csv("All groups CPI and Trimmed mean, Australia, annual movement (%).csv")
goods_services_data <- read.csv("CPI, Goods and Services components, annual movement (%).csv")

# Convert MonthYear to Date
cpi_data$MonthYear <- as.Date(paste0("01-", cpi_data$MonthYear), format = "%d-%b-%y")
# Define UI for app that draws a line chart ----
ui <- page_sidebar(
  title = div(
    h1("Cost of Living in Australia - Consumer Price Index (CPI)"),
    tags$h4(
      style = "margin-top: 0; font-size: 1.1em; font-style: italic; color: #555;",
      "Source: Australian Bureau of Statistics. (2025, April 30). Consumer price index, Australia, March quarter 2025."
    )
  ),
  tags$style(HTML("
    .form-group label[for='monthyear'] { color: #000 !important; }
    .js-irs-0 .irs-bar, .js-irs-0 .irs-handle, .js-irs-0 .irs-single, .js-irs-0 .irs-from, .js-irs-0 .irs-to {
      background: #000 !important;
      color: #fff !important;
      border-color: #000 !important;
    }
  ")),
  sidebar = sidebar(
    selectInput(
      inputId = "type",
      label = "Choose type:",
      choices = c("Goods", "Services", "Both"),
      selected = "Both"
    ),
    sliderInput(
      inputId = "monthyear",
      label = "Select Month-Year:",
      min = min(cpi_data$MonthYear, na.rm = TRUE),
      max = max(cpi_data$MonthYear, na.rm = TRUE),
      value = max(cpi_data$MonthYear, na.rm = TRUE),
      timeFormat = "%b-%Y",
      step = 1
    ),
    position = "left"
  ),
  # Main content
  card(
    card_header("CPI and Trimmed Mean CPI"),
    card_body(
      tags$p("Annual movement in All grouped CPI and trimmed mean CPI for Australia."),
      plotlyOutput("cpi_line")
    )
  ),
  card(
    card_header("Goods and Services"),
    card_body(
      tags$p("CPI by goods and services, annual movement."),
      plotlyOutput("goods_services_bar")
    )
  )
)

server <- function(input, output) { 
  output$cpi_line <- renderPlotly({
    filtered <- cpi_data[cpi_data$MonthYear <= input$monthyear, ]
    p <- ggplot(filtered, aes(x = MonthYear)) +
      geom_line(aes(y = CPI, color = "CPI"), linewidth = 0.7) +
      geom_line(aes(y = MeanCPI, color = "Trimmed mean CPI"), linewidth = 0.7) +
      scale_color_manual(
        name = "",
        values = c("CPI" = "#00CED1", "Trimmed mean CPI" = "#5F9EA0")
      ) +
      labs(
        x = NULL,
        y = "Annual Movement (%)",
        title = NULL
      ) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 0, hjust = 1))
    
    ggplotly(p, source = "cpi")
  })

  output$goods_services_bar <- renderPlotly({
    goods_services_data$MonthYear <- as.Date(paste0("01-", goods_services_data$MonthYear), format = "%d-%b-%y")
    filtered_gs <- goods_services_data[goods_services_data$MonthYear <= input$monthyear, ]
    long_gs <- pivot_longer(
      filtered_gs,
      cols = c("Goods", "Services"),
      names_to = "Type",
      values_to = "Value"
    )
    # Filter by dropdown selection
    if (input$type != "Both") {
      long_gs <- long_gs[long_gs$Type == input$type, ]
    }
    p <- ggplot(long_gs, aes(x = MonthYear, y = Value, fill = Type)) +
      geom_bar(stat = "identity", position = "stack") +
      labs(
        x = NULL,
        y = "Annual Movement (%)",
        title = NULL
      ) +
      scale_fill_manual(values = c("Goods" = "#AFEEEE", "Services" = "#00CED1")) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 0, hjust = 1))
    
    ggplotly(p, source = "gs")
  })
}

shinyApp(ui = ui, server = server)


