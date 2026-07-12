library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)


netflix <- read.csv(file.choose(), stringsAsFactors = FALSE)


ui <- fluidPage(
  
  titlePanel("Netflix Dashboard"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        "type",
        "Select Content Type",
        choices = c("All", unique(netflix$type))
      )
      
    ),
    
    mainPanel(
      
      plotlyOutput("typePlot")
      
    )
    
  )
  
)


server <- function(input, output) {
  
  filtered <- reactive({
    
    if(input$type == "All"){
      
      netflix
      
    } else {
      
      filter(netflix, type == input$type)
      
    }
    
  })
  
  output$typePlot <- renderPlotly({
    
    p <- ggplot(filtered(),
                aes(x = type)) +
      
      geom_bar(fill = "red") +
      
      labs(
        title = "Movies vs TV Shows",
        x = "Content Type",
        y = "Count"
      ) +
      
      theme_minimal()
    
    ggplotly(p)
    
  })
  
}


shinyApp(ui, server)
