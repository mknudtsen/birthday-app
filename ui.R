library(shiny)
library(googleCharts)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
# xlim <- list(
#   min = 0,
#   max = 32
# )
# ylim <- list(
#   min = 0,
#   max = 13
# )


shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?", "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css", "body {font-family: 'Source Sans Pro'}"),

  # Application title
  titlePanel("Random Birthday Applet"),
  br(),

  # Set up fluid grid 
  sidebarLayout(
    sidebarPanel(width = 3,
      selectInput(inputId = "bdays", label = "Birthdays to Generate:",
                  choices = c(seq(5, 50, 5), 75, 100), selected = 20),
      uiOutput(outputId = "sliderControl"),
      wellPanel(uiOutput(outputId = "text")),
      actionButton(inputId = "reset", label = "Reset")
    ),
    mainPanel(width = 9,
      # tableOutput("table"),
      
      googleBubbleChart("chart", width = "900", height = "500px"
#         options = list(
#           fontName = "Source Sans Pro",
#           backgroundColor = "transparent",
#           fontSize = 12, 
#           hAxis = list(
#             viewWindow = xlim,
#             ticks = seq(1, 31, 1)
#           ),
#           vAxis = list(
#             viewWindow = ylim,
#             direction = -1, 
#             ticks = seq(1, 12, 1)
#           ),
#           sizeAxis = list(
#             maxSize = 12
#           ),
#           chartArea = list(
#             top = 0, left = 25, 
#             height = "95%", width = "95%"
#           ),
#           bubble = list(
#             opacity = 0.8, 
#             textStyle = list(
#               color = "white",
#               fontSize = 8
#             )
#           )
#         ) # End chart options
      ) # End chart
    ) # End mainpanel

    
    
  )


))
