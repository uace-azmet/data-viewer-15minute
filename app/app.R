# Tables and time series of 15-minute data to support QA/QC


# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->

# Libraries
library(azmetr)
library(bsicons)
library(bslib)
library(dplyr)
library(ggplot2)
library(htmltools)
library(plotly)
library(RColorBrewer)
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
    
    # Apparent bug in `bslib`, see: https://github.com/rstudio/bslib/issues/834
    #pageNavbar = bslib::page_navbar(
    #navsetTab = bslib::navset_tab(
    #navsetCardTab = bslib::navset_card_tab(
    
    # Work-around by placing the navset in `bslib::page()`, which correctly renders tabs on webpage
    navsetCardTab = bslib::page(
      
      title = NULL,
      theme = theme, # `scr##_theme.R`
      #lang = "en",
      
      bslib::navset_card_tab(
        id = "navsetCardTab",
        selected = "network-wide-summary",
        title = NULL,
        sidebar = NULL,
        header = NULL,
        footer = NULL,
        #height = 600,
        full_screen = TRUE,
        wrapper = card_body,
        
        # Network-wide Summary (nws) -----
        
        bslib::nav_panel(
          #title = nwsNavpanelTitle, # `_setup.R`
          title = "Network-wide Summary",
          
          shiny::htmlOutput(outputId = "nwsTableTitle"),
          shiny::htmlOutput(outputId = "nwsTableHelpText"),
          reactable::reactableOutput(outputId = "nwsTable"),
          shiny::htmlOutput(outputId = "nwsTableFooter"),
          
          value = "network-wide-summary"
        ),
        
        # Station-level summaries (sls) -----
        
        bslib::nav_panel(
          #title = slsNavpanelTitle, # `_setup.R``
          title = "Station-level Summaries",
          
          bslib::layout_sidebar(
            sidebar = slsSidebar, # `scr_slsSidebar.R`
            
            shiny::htmlOutput(outputId = "slsGraphTitle"),
            shiny::htmlOutput(outputId = "slsGraphHelpText"),
            plotly::plotlyOutput(outputId = "slsGraph"),
            shiny::htmlOutput(outputId = "slsGraphFooter"),
            
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
          
          value = "station-level-summaries"
        )
      ) |>
        htmltools::tagAppendAttributes(
          #https://getbootstrap.com/docs/5.0/utilities/api/
          class = "border-0 rounded-0 shadow-none"
        ),
      
      # if (input$navsetCardTab == "network-wide-summary")
      shiny::htmlOutput(outputId = "nwsRefreshHelpText"),
      shiny::uiOutput(outputId = "nwsRefreshData"),
      shiny::htmlOutput(outputId = "nwsDownloadHelpText"),
      shiny::uiOutput(outputId = "nwsDownloadButtonCSV"),
      shiny::uiOutput(outputId = "nwsDownloadButtonTSV"),
      
      # if (input$navsetCardTab == "station-level-summaries")
      shiny::htmlOutput(outputId = "slsRefreshHelpText"),
      shiny::uiOutput(outputId = "slsRefreshData"),
      shiny::htmlOutput(outputId = "slsDownloadHelpText"),
      shiny::uiOutput(outputId = "slsDownloadButtonCSV"),
      shiny::uiOutput(outputId = "slsDownloadButtonTSV"),
      
      shiny::htmlOutput(outputId = "pageBottomText")
    )
  )


# Server --------------------

server <- function(input, output, session) {
  # Download AZMet data at initial loading of page
  dataETL <- fxn_dataETL()
  
  # Observables -----
  
  shiny::observe({
    if (shiny::req(input$navsetCardTab) == "network-wide-summary") {
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
    
    if (shiny::req(input$navsetCardTab) == "station-level-summaries") {
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
  
  shiny::observeEvent(input$nwsRefreshData, {
    dataETL <- NULL
    dataETL <- fxn_dataETL()
  })
  
  shiny::observeEvent(input$slsRefreshData, {
    dataETL <- NULL
    dataETL <- fxn_dataETL()
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
  
  # Build help text for button to refresh data in network-wide summary table
  nwsRefreshHelpText <- shiny::eventReactive(nwsData, {
    fxn_nwsRefreshHelpText()
  })
  
  # Build download button help text for station-level summaries
  slsDownloadHelpText <- shiny::eventReactive(dataETL, {
    fxn_slsDownloadHelpText()
  })
  
  # Build help text for button to refresh data in station-level summaries graph
  slsRefreshHelpText <- shiny::eventReactive(dataETL, {
    fxn_slsRefreshHelpText()
  })
  
  # Outputs -----
  
  output$nwsDownloadButtonCSV <- shiny::renderUI({
    shiny::req(nwsData)
    
    if (input$navsetCardTab == "network-wide-summary") {
      shiny::downloadButton(
        "nwsDownloadCSV", 
        label = "Download .csv", 
        class = "btn btn-default btn-blue", 
        type = "button"
      )
    } else {
      return(NULL)
    }
    
  })
  
  output$nwsDownloadButtonTSV <- shiny::renderUI({
    shiny::req(nwsData)
    
    if (input$navsetCardTab == "network-wide-summary") {
      shiny::downloadButton(
        "nwsDownloadTSV", 
        label = "Download .tsv", 
        class = "btn btn-default btn-blue", 
        type = "button"
      )
    } else {
      return(NULL)
    }
  })
  
  output$nwsDownloadCSV <- shiny::downloadHandler(
    filename = function() {
      "AZMet-15-minute-network-wide-summary.csv"
    },
    
    content = function(file) {
      vroom::vroom_write(
        x = nwsData(),
        file = file, 
        delim = ","
      )
    }
  )
  
  output$nwsDownloadHelpText <- shiny::renderUI({
    if (input$navsetCardTab == "network-wide-summary") {
      nwsDownloadHelpText()
    } else {
      return(NULL)
    }
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
  
  output$nwsRefreshData <- shiny::renderUI({
    if (input$navsetCardTab == "network-wide-summary") {
      shiny::actionButton(
        inputId = "nwsRefreshData", 
        label = 
          htmltools::HTML(
            paste(
              bsicons::bs_icon("arrow-clockwise"), "REFRESH DATA", 
              sep = " "
            )
          ),
        class = "btn btn-block btn-blue"
      )
    } else {
      return(NULL)
    }
  })
  
  output$nwsRefreshHelpText <- shiny::renderUI({
    if (input$navsetCardTab == "network-wide-summary") {
      nwsRefreshHelpText()
    } else {
      return(NULL)
    }
  })
  
  output$nwsTable <- reactable::renderReactable({
    #input$nwsRefreshData
    #shiny::invalidateLater(1000, session)
    #shiny::req(nwsData)
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
  
  output$pageBottomText <- shiny::renderUI({
    fxn_pageBottomText()
  })
  
  output$slsDownloadButtonCSV <- shiny::renderUI({
    shiny::req(dataETL)
    
    if (input$navsetCardTab == "station-level-summaries") {
      shiny::downloadButton(
        outputId = "slsDownloadCSV", 
        label = "Download .csv", 
        class = "btn btn-default btn-blue", 
        type = "button"
      )
    } else {
      return(NULL)
    }
  })
  
  output$slsDownloadButtonTSV <- shiny::renderUI({
    shiny::req(dataETL)
    
    if (input$navsetCardTab == "station-level-summaries") {
      shiny::downloadButton(
        outputId = "slsDownloadTSV", 
        label = "Download .tsv", 
        class = "btn btn-default btn-blue", 
        type = "button"
      )
    } else {
      return(NULL)
    }
  })
  
  output$slsDownloadCSV <- shiny::downloadHandler(
    filename = function() {
      "AZMet-15-minute-station-level-summaries.csv"
    },
    
    content = function(file) {
      vroom::vroom_write(
        x = dataETL, 
        file = file, 
        delim = ","
      )
    }
  )
  
  output$slsDownloadHelpText <- shiny::renderUI({
    if (input$navsetCardTab == "station-level-summaries") {
      slsDownloadHelpText()
    } else {
      return(NULL)
    }
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
  
  output$slsGraphHelpText <- shiny::renderUI({
    fxn_slsGraphHelpText()
  })
  
  output$slsGraphTitle <- shiny::renderUI({
    fxn_slsGraphTitle()
  })
  
  output$slsRefreshData <- shiny::renderUI({
    if (input$navsetCardTab == "station-level-summaries") {
      shiny::actionButton(
        inputId = "slsRefreshData", 
        label = 
          htmltools::HTML(
            paste(
              bsicons::bs_icon("arrow-clockwise"), "REFRESH DATA", 
              sep = " "
            )
          ),
        class = "btn btn-block btn-blue"
      )
    } else {
      return(NULL)
    }
  })
  
  output$slsRefreshHelpText <- shiny::renderUI({
    if (input$navsetCardTab == "station-level-summaries") {
      slsRefreshHelpText()
    } else {
      return(NULL)
    }
  })
  
  output$slsGraph <- plotly::renderPlotly({
    #input$nwsRefreshData
    #shiny::invalidateLater(1000, session)
    #shiny::req(nwsData)
    fxn_slsGraph(
      inData = dataETL,
      azmetStationGroup = input$azmetStationGroup,
      stationVariable = input$stationVariable
    )
  })
  
  output$slsGraphFooter <- shiny::renderUI({
    fxn_slsGraphFooter()
  })
  
  output$stationGroupsTable <- reactable::renderReactable({
    stationGroupsTable
  })
}


# Run --------------------

shinyApp(ui, server)
