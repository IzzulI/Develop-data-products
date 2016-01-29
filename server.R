library(shiny)
library(quantmod)
library(VGAM)

shinyServer(function(input, output) {
  
  # acquiring data
  dataInput <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      getSymbols(input$symb,src="yahoo", auto.assign = FALSE)
    }))
  })
  
  datesInput <- reactive({
    if (input$get == 0)
      return(NULL)
    
    return(isolate({
      paste0(input$dates[1], "::",  input$dates[2])
    }))
  })
  
  returns <- reactive({ 
    if (input$get == 0)
      return(NULL)
    
    dailyReturn(dataInput())
  })
  
  xs <- reactive({ 
    if (input$get == 0)
      return(NULL)
    
    span <- range(returns())
    seq(span[1], span[2], by = diff(span) / 100)
  })
  
  # tab based controls
  output$newBox <- renderUI({
    switch(input$tab,
           "Charts" = chartControls
    )
  })
  
  # Charts tab
  chartControls <- div(
    wellPanel(
      selectInput("chart_type",
                  label = "Please Select Chart Type",
                  choices = c("Candlestick" = "candlesticks", 
                              "Matchstick" = "matchsticks",
                              "Bar" = "bars",
                              "Line" = "line"),
                  selected = "Line"
      ),
      checkboxInput(inputId = "log_y", label = "Logarithmic y-axis", 
                    value = FALSE)
    ),
    
    wellPanel(
      p(strong("Adding Technical Analysis")),
      checkboxInput("ta_vol", label = "Volume", value = FALSE),
      checkboxInput("ta_sma", label = "Simple Moving Average", 
                    value = FALSE),
      
      checkboxInput("ta_wma", label = "Weighted Moving Average", 
                    value = FALSE),
 
      checkboxInput("ta_momentum", label = "Momentum", 
                    value = FALSE),
      
      br(),
      
      actionButton("chart_act", "Add")
    )
  )
  
  TAInput <- reactive({
    if (input$chart_act == 0)
      return("NULL")
    
    tas <- isolate({c(input$ta_vol, input$ta_sma, input$ta_ema, 
                      input$ta_wma, input$ta_momentum)})
    funcs <- c(addVo(), addSMA(), addWMA(), addMomentum())
    
    if (any(tas)) funcs[tas]
    else "NULL"
  })
  
  output$chart <- renderPlot({
    chartSeries(dataInput(),
                name = input$symb,
                type = input$chart_type,
                subset = datesInput(),
                log.scale = input$log_y,
                theme = "white",
                TA = TAInput())
  })
  
  
  output$text1<- renderText({ 
    paste("This application is a simple data visual analysis on equity where user can select a particular stock and see the time series trend of the stock prices. 
          The equity data is downloaded from yahoo finance and use stock code from the website.Input your code on the sidebar and select the period of analysis that you require.
          Then please go to the Chart tab see the output")
  })
  
  output$text2<- renderText({ 
    paste("Currently you are selecting stock",input$symb)
  })
  
  output$text3<- renderText({ 
    paste("The period selected is from",input$dates[1])
  }) 
  
  output$text4<- renderText({ 
    paste("To the period of",input$dates[2])
  }) 
  
})