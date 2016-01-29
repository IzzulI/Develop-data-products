library(shiny)


shinyUI(pageWithSidebar(
  
  headerPanel("Equity Time-Series Analysis"),
  
  sidebarPanel(
    
    helpText("Use Yahoo Finance (http://finance.yahoo.com/) to find stock code"),
    
    textInput("symb", "Stock Code", "FB"),
    
    dateRangeInput("dates", 
                   "Period",
                   start = "2015-01-01", end = "2015-12-31"),
    
    actionButton("get", "GO"),
    
    br(),
    br(),
    
    uiOutput("newBox")
    
    ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Instructions", textOutput("text1"),textOutput("text2"),textOutput("text3"),textOutput("text4")),
      tabPanel("Charts", plotOutput("chart")), 
      
      id = "tab"
    )
  )
))