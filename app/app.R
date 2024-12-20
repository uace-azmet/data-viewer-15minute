# Tables and time series of 15-minute data to support QA/QC

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->
# 'azmet-shiny-template.html': <!-- CSS specific to this AZMet Shiny app -->


# Libraries
library(azmetr)
library(bsicons)
library(bslib)
library(dplyr)
library(ggplot2)
library(htmltools)
library(reactable)
library(shiny)

# Functions. Loaded automatically at app start if in `R` folder
#source("./R/fxn_functionName.R", local = TRUE)

# Scripts. Loaded automatically at app start if in `R` folder
#source("./R/scr_scriptName.R", local = TRUE)


# UI --------------------

ui <- 
  htmltools::htmlTemplate(
    filename = "azmet-shiny-template.html",
    
    pageNavbar = bslib::page_navbar(
      
      # Network-wide Summary (nws) -----
      
      bslib::nav_panel(
        title = nwsNavpanelTitle, # `_setup.R`
        
        shiny::htmlOutput(outputId = "nwsTableTitle"),
        shiny::htmlOutput(outputId = "nwsTableHelpText"),
        
        reactable::reactableOutput(outputId = "nwsTable"),
        
        shiny::htmlOutput(outputId = "nwsTableFooter"),
        shiny::htmlOutput(outputId = "nwsBottomText"),
        
        value = "network-wide-summary"
      ), 
      
      # Station-level summaries -----
      
      bslib::nav_panel(
        title = slsNavpanelTitle, # `_setup.R``
        
        bslib::layout_sidebar(
          sidebar = slsSidebar, # `scr_slsSidebar.R`
          
          htmltools::p("Coming soon."),
          shiny::plotOutput(outputId = "slsTimeSeries")
          
          # options ???
          #fillable = TRUE,
          #fill = TRUE,
          #bg = NULL,
          #fg = NULL,
          #border = NULL,
          #border_radius = NULL,
          #border_color = NULL,
          #padding = NULL,
          #gap = NULL,
          #height = NULL
        ),
        
        shiny::htmlOutput(outputId = "slsBottomText"),
        
        value = "station-level-summaries"
      ),
      
      title = NULL,
      #  collapsible = FALSE,
      #  fillable = TRUE,
      #  fillable_mobile = FALSE,
      #  footer = shiny::htmlOutput(outputId = "reportPageText"),
      id = "pageNavbar",
      selected = "network-wide-summary",
      sidebar = NULL#,
      #  theme = theme, # `scr03_theme.R`,
      #title = "TITLE"
      #underline = TRUE,
      #fluid = TRUE,
      #window_title = NULL
    )
  )


# Server --------------------

server <- function(input, output, session) {
  dataETL <- fxn_dataETL()
  
  # Reactives -----
  
  #slsTimeSeries <- shiny::reactive({
  #  fxn_dataETL()
  #  
  #  fxn_slsTimeSeries(
  #    inData = dataELT,
  #    azmetStationGroup = input$azmetStationGroup,
  #    stationVariable = input$stationVariable
  #  )
  #})
  
  # Observables -----
  
  shiny::observe({
    if (shiny::req(input$pageNavbar) == "network-wide-summary") {
      message("network-wide-summary has been selected")
    }
      
    if (shiny::req(input$pageNavbar) == "station-level-summaries") {
      message("station-level-summaries has been selected")
    }
  })
  
  shiny::observeEvent(dataETL, {
    shiny::updateSelectInput(
      inputId = "stationVariable",
      label = "Station Variable",
      choices = sort(colnames(dplyr::select(dataETL, !datetime))),
      selected = sort(colnames(dplyr::select(dataETL, !datetime)))[1]
    )
  })
  
  # Outputs -----
  
  output$nwsBottomText <- shiny::renderUI({
    fxn_nwsBottomText()
  })
  
  output$nwsTable <- reactable::renderReactable({
    fxn_nwsTable(inData = dataETL)
  })
  
  output$nwsTableFooter <- shiny::renderUI({
    fxn_nwsTableFooter()
  })
  
  output$nwsTableHelpText <- shiny::renderUI({
    fxn_nwsTableHelpText()
  })
  
  output$nwsTableTitle <- shiny::renderUI({
    fxn_nwsTableTitle()
  })
  
  output$slsBottomText <- shiny::renderUI({
    fxn_slsBottomText()
  })
  
  output$slsTimeSeries <- shiny::renderPlot({
    #slsTimeSeries
    fxn_slsTimeSeries(
      inData = dataETL,
      azmetStationGroup = input$azmetStationGroup,
      stationVariable = input$stationVariable
    )
  })
}


# Run --------------------

shinyApp(ui, server)
