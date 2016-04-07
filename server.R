
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)

shinyServer(function(input, output, session) {


  ##################################### Reactive UI Output ######################################### 
  output$sliderControl <- renderUI({
    num_bdays <- as.numeric(input$bdays)
    sliderInput(inputId = "animate", label = "Start",
                min = 0, max = num_bdays, value = 0, step = 1, animate = TRUE)
  })

  
  ##################################### Data Functions ############################################ 
  
  # Initiate reactive value (v), v$bdays is a vector of randomly generated birthdays (1-365)
  v <- reactiveValues(bdays = c(), counts = data.frame(), current = "", matches = "", total = "")
  
  observeEvent(input$animate, {
    if (input$animate != 0) {
      new_bday <- sample(1:365, (input$animate/input$animate), replace = TRUE)
      v$bdays <- v$bdays %>% append(new_bday)
      v$current <- cal_df[match(new_bday, cal_df$num), 3]
    }
  })
  
  observeEvent(input$reset,  {
    v$bdays <- c()
    v$counts <- data.frame()
    v$current <- ""
    updateSliderInput(session, "animate", value = 0)
  })
  
  update_counts <- reactive({
    bdays <- v$bdays
    counts <- table(bdays)
    counts <- as.data.frame(counts)
    counts$day <- cal_df[match(counts$bdays, cal_df$num), 2]
    counts$month <- cal_df[match(counts$bdays, cal_df$num), 1]
    counts$month <- factor(counts$month, levels=month.abb)
    return(counts)
  })
  
  bday_df <- reactive({
    df <- start_df
    counts <- update_counts()
    df$count <- counts[match(df$num, counts$bdays, nomatch = NA_integer_), 2] 
    df <- mutate(df, day = ifelse(!is.na(count), counts[match(df$num, counts$bdays), 3], day),
                 month = ifelse(!is.na(count), counts[match(df$num, counts$bdays), 4], month))
    # df <- mutate(df, month = ifelse(!is.na(count), counts[match(df$num, counts$bdays), 4], month))
    
    matches <- df %>% filter(count > 1) %>% select(count)
    v$matches <- length(matches$count)
    v$total <- sum(as.numeric(df$count), na.rm = TRUE)


#     df$day <- counts[match(df$num, counts$bdays), 3]
#     df$month <- counts[match(df$num, counts$bdays), 4]
#     df$month <- factor(df$month, levels=month.abb)
 

    
#     df$month[df$count != 0] <- cal_df[match(df$num, cal_df$num), 1] %>% as.numeric()
#     df$day[df$count != 0] <- cal_df[match(df$num, cal_df$num), 2] %>% as.numeric()
#     df$count <- df$count %>% as.character()
    
    
#     df$day <- as.numeric(df$day)
#     df$month <- as.numeric(df$month)
    df$count <- as.character(df$count)

#     counts <- update_counts()
#     df$count <- counts[match(df$num, counts$bdays), 2] %>% as.character()
#     df$month <- cal_df[match(df$num, cal_df$num), 1] %>% as.numeric()
#     df$day <- cal_df[match(df$num, cal_df$num), 2] %>% as.numeric()
    
    
    df <- df %>%
      select(name, day, month, count)
    return(df)
  })
  
  
  ##################################### Plot & Table Output ######################################### 
  output$table <- renderTable({
    bday_df()
  })
  
  output$text <- renderUI({
    str1 <- h3(paste0("Date: ", v$current))
    str2 <- h6(paste0("Generated: ", v$total))
    str3 <- h6(paste0("Matches: ", v$matches))
    HTML(paste0(str1, str2, str3, sep = '<br/>'))

  })
  

  
  output$chart <- reactive({
    list(data = googleDataTable(bday_df()),
         options = list(
           title = paste0("Calendar Grid"),
           series = series,
           legend = 'none',
           fontName = "Source Sans Pro",
           backgroundColor = "transparent",
           fontSize = 12, 
           hAxis = list(
             viewWindow = xlim,
             ticks = seq(1, 31, 1)
           ),
           vAxis = list(
             viewWindow = ylim,
             direction = -1, 
             ticks = seq(1, 12, 1)
           ),
           sizeAxis = list(
             maxSize = 12
           ),
           chartArea = list(
             top = 25, left = 25, bottom = 50, right = 25,
             height = "80%", width = "90%"
           ),
           bubble = list(
             opacity = 0.8, 
             textStyle = list(
               color = "white",
               fontSize = 8
             )
           ),
           animation = list(
#              "duration" = 600,
#              "easing" = "inAndOut"
           )
         ))
  })
  
  

})
