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
      
      # Network-wide Summary -----
      
      bslib::nav_panel(
        title = networkWideNavpanelTitle, # `_setup.R`
        
        shiny::htmlOutput(outputId = "networkWideTableTitle"),
        shiny::htmlOutput(outputId = "networkWideTableHelpText"),
        
        reactable::reactableOutput(outputId = "networkWideTable"),
        
        shiny::htmlOutput(outputId = "networkWideTableFooter"),
        shiny::htmlOutput(outputId = "networkWideBottomText"),
        
        value = "network-wide-summary"
      ), 
      
      # Station-level summaries -----
      
      bslib::nav_panel(
        title = stationLevelNavpanelTitle, # `_setup.R``
        
        bslib::layout_sidebar(
          sidebar = stationLevelSidebar, # `scr_stationLevelSidebar.R`
          
          htmltools::p("Coming soon."),
          shiny::plotOutput(outputId = "stationLevelTimeSeries")
          
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
        
        shiny::htmlOutput(outputId = "stationLevelBottomText"),
        
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
  
  # Reactives -----
  
  stationLevelTimeSeries <- shiny::reactive({
    fxn_stationLevelTimeSeries(
      #inData = dataAZMetDataELT(),
      azmetStationGroup = input$azmetStationGroup,
      stationVariable = input$stationVariable
    )
  })
  
  # Observables -----
  
  shiny::observe({
    if (shiny::req(input$pageNavbar) == "network-wide-summary") {
      message("network-wide-summary has been selected")
    }
      
    if (shiny::req(input$pageNavbar) == "station-level-summaries") {
      message("station-level-summaries has been selected")
    }
  })
  
  
  # Outputs -----
  
  output$networkWideBottomText <- shiny::renderUI({
    networkWideBottomText()
  })
  
  output$networkWideTable <- reactable::renderReactable({
    networkWideTable()
  })
  
  output$networkWideTableFooter <- shiny::renderUI({
    networkWideTableFooter()
  })
  
  output$networkWideTableHelpText <- shiny::renderUI({
    networkWideTableHelpText()
  })
  
  output$networkWideTableTitle <- shiny::renderUI({
    networkWideTableTitle()
  })
  
  output$stationLevelBottomText <- shiny::renderUI({
    stationLevelBottomText()
  })
  
  output$stationLevelTimeSeries <- shiny::renderPlot({
    stationLevelTimeSeries()
  })
}


# Run --------------------

shinyApp(ui, server)
