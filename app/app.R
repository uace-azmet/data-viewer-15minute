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
    
    #pageNavbar = bslib::page_navbar(
    navsetTab = bslib::navset_tab(
    #navsetTab = bslib::navset_card_tab(
    #navsetTab = bslib::page_sidebar(
      #title = NULL,
      #sidebar = NULL,
      #fillable = TRUE,
      #fillable_mobile = FALSE,
      #theme = theme, # `scr03_theme.R`
      #lang = NULL,
      #window_title = NA,
    #navsetTab = bslib::navset_card_tab(
        
      id = "navsetTab",
      selected = "network-wide-summary",
      header = NULL,
      footer = NULL,    
      
      #id = "navsetCardTab",
      #selected = "network-wide-summary",
      #title = NULL,
      #sidebar = NULL,
      #header = NULL,
      #footer = NULL,
      #height = 600,
      #full_screen = TRUE,
      #wrapper = card_body,
        #id = "navsetCardTab",
        #selected = "network-wide-summary",
        #title = NULL,
        #sidebar = NULL,
        #header = NULL,
        #footer = NULL,
        #height = 600,
        #full_screen = TRUE,
        #wrapper = card_body,
        
      # Network-wide Summary (nws) -----
      
      bslib::nav_panel(
        title = nwsNavpanelTitle, # `_setup.R`
        
        shiny::htmlOutput(outputId = "nwsTableTitle"),
        shiny::htmlOutput(outputId = "nwsTableHelpText"),
        
        reactable::reactableOutput(outputId = "nwsTable"),
        
        shiny::htmlOutput(outputId = "nwsTableFooter"),
        shiny::htmlOutput(outputId = "nwsDownloadHelpText"),
        shiny::uiOutput(outputId = "nwsDownloadButton"),
        shiny::htmlOutput(outputId = "nwsBottomText"),
        
        value = "network-wide-summary"
      ),
      
      # Station-level summaries (sls) -----
      
      bslib::nav_panel(
        title = slsNavpanelTitle, # `_setup.R``
        
        bslib::layout_sidebar(
          sidebar = slsSidebar, # `scr_slsSidebar.R`
          
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
        
        shiny::htmlOutput(outputId = "slsDownloadHelpText"),
        shiny::uiOutput(outputId = "slsDownloadButton"),
        shiny::htmlOutput(outputId = "slsBottomText"),
        
        value = "station-level-summaries"
      )
      
      #title = NULL,
      #  collapsible = FALSE,
      #  fillable = TRUE,
      #  fillable_mobile = FALSE,
      #  footer = shiny::htmlOutput(outputId = "reportPageText"),
      #id = "pageNavbar",
      #selected = "network-wide-summary",
      #sidebar = NULL#,
      #theme = theme, # `scr03_theme.R`,
      #title = "TITLE"
      #underline = TRUE,
      #fluid = TRUE,
      #window_title = NULL
    )
  )


# Server --------------------

server <- function(input, output, session) {
  dataETL <- fxn_dataETL()
  
  # Observables -----
  
  shiny::observe({
    if (shiny::req(input$pageNavbar) == "network-wide-summary") {
      message("network-wide-summary has been selected")
      
      #idRetrievingData <- shiny::showNotification(
      #  ui = "Retrieving data . . .", 
      #  action = NULL, 
      #  duration = NULL, 
      #  closeButton = FALSE,
      #  id = "idRetrievingData",
      #  type = "message"
      #)
      
      #on.exit(shiny::removeNotification(id = idRetrievingData), add = TRUE)
    }
    
    if (shiny::req(input$pageNavbar) == "station-level-summaries") {
      message("station-level-summaries has been selected")
      
      #idRetrievingData <- shiny::showNotification(
      #  ui = "Retrieving data . . .", 
      #  action = NULL, 
      #  duration = NULL, 
      #  closeButton = FALSE,
      #  id = "idRetrievingData",
      #  type = "message"
      #)
      
      #on.exit(shiny::removeNotification(id = idRetrievingData), add = TRUE)
    }
  })
  
  shiny::observeEvent(dataETL, {
    shiny::updateSelectInput(
      inputId = "azmetStationGroup",
      label = "AZMet Station Group",
      choices = sort(unique(dataETL$meta_station_group)),
      selected = sort(unique(dataETL$meta_station_group))[1]
    )
    
    shiny::updateSelectInput(
      inputId = "stationVariable",
      label = "Station Variable",
      choices = 
        sort(
          colnames(
            dplyr::select(
              dataETL, !c(datetime, meta_station_group, meta_station_name)
            )
          )
        ),
      selected = 
        sort(
          colnames(
            dplyr::select(
              dataETL, !c(datetime, meta_station_group, meta_station_name)
            )
          )
        )[1]
    )
  })
  
  # Reactives -----
  
  # Filter and format 15-minute data for the most recent report from each station
  nwsData <- shiny::eventReactive(dataETL, {
    fxn_nwsData(inData = dataETL)
  })
  
  # Build download button help text for network-wide summary table
  nwsDownloadHelpText <- shiny::eventReactive(nwsData, {
    fxn_nwsDownloadHelpText()
  })
  
  # Build download button help text for station-level summaries
  slsDownloadHelpText <- shiny::eventReactive(dataETL, {
    fxn_slsDownloadHelpText()
  })
  
  # Outputs -----
  
  output$nwsBottomText <- shiny::renderUI({
    fxn_nwsBottomText()
  })
  
  output$nwsDownloadButton <- shiny::renderUI({
    shiny::req(nwsData)
    shiny::downloadButton(
      outputId = "nwsDownloadTSV", 
      label = "Download .tsv", 
      class = "btn btn-default btn-blue", 
      type = "button"
    )
  })
  
  output$nwsDownloadHelpText <- shiny::renderUI({
    nwsDownloadHelpText()
  })
  
  output$nwsDownloadTSV <- shiny::downloadHandler(
    filename = function() {
      "AZMet-15-minute-network-wide-summary.tsv"
    },
    
    content = function(file) {
      vroom::vroom_write(
        x = nwsData(),
        file = file, 
        delim = "\t"
      )
    }
  )
  
  output$nwsTable <- reactable::renderReactable({
    fxn_nwsTable(inData = nwsData())
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
  
  output$slsDownloadButton <- shiny::renderUI({
    shiny::req(dataETL)
    shiny::downloadButton(
      outputId = "slsDownloadTSV", 
      label = "Download .tsv", 
      class = "btn btn-default btn-blue", 
      type = "button"
    )
  })
  
  output$slsDownloadHelpText <- shiny::renderUI({
    slsDownloadHelpText()
  })
  
  output$slsDownloadTSV <- shiny::downloadHandler(
    filename = function() {
      "AZMet-15-minute-station-level-summaries.tsv"
    },
    
    content = function(file) {
      vroom::vroom_write(
        x = dataETL, 
        file = file, 
        delim = "\t"
      )
    }
  )
  
  output$slsTimeSeries <- shiny::renderPlot({
    fxn_slsTimeSeries(
      inData = dataETL,
      azmetStationGroup = input$azmetStationGroup,
      stationVariable = input$stationVariable
    )
  }, res = 96)
}


# Run --------------------

shinyApp(ui, server)
