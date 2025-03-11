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
  
  dataETL <- fxn_dataETL()

  #
  dataRefresh <- FALSE
  
  #dataETLRefresh <- eventReactive(input$nwsRefreshData, {
  #  fxn_dataETL()
    #dataETL <- fxn_dataETL()
  #})
  #
  dataETLRefresh <- reactive() #%>%
  #  shiny::bindEvent(
  #    list(input$nwsRefreshData, input$slsRefreshData), # events
  #    ignoreNULL = TRUE, 
  #    ignoreInit = TRUE
  #  )
 
  # Observables -----
  
  shiny::observe({
    if (shiny::req(input$navsetCardTab) == "network-wide-summary") {
      message("network-wide-summary has been selected")
    }
    
    if (shiny::req(input$navsetCardTab) == "station-level-summaries") {
      message("station-level-summaries has been selected")
    }
  })
  
  shiny::observeEvent(input$nwsRefreshData, {
    message("nwsRefreshData has been requested")
    dataRefresh = TRUE
  })
  
  shiny::observeEvent(input$slsRefreshData, {
    message("slsRefreshData has been requested")
  })
  
  #shiny::observeEvent(nwsData(), {
  #  message("nwsData is running")
  #})
  
  #shiny::observeEvent(output$nwsTable, {
  ##  message("nwsTable is running")
  #})
  
  
  # Reactives -----
  
  # Filter and format 15-minute data for the most recent report from each station
  
  nwsData <- shiny::eventReactive(dataETL, { #Don't need reactive ???
    fxn_nwsData(inData = dataETL)
    #if (is.null(dataETL) == FALSE) {
    #  fxn_nwsData(inData = dataETL)
    #} else {
    #  fxn_nwsData(inData = dataETLRefresh())
    #}
  })
  
  nwsDataRefresh <- shiny::eventReactive(dataETLRefresh(), { #Don't need reactive ???
    fxn_nwsData(inData = dataETLRefresh())
    #if (is.null(dataETL) == FALSE) {
    #  fxn_nwsData(inData = dataETL)
    #} else {
    #  fxn_nwsData(inData = dataETLRefresh())
    #}
  })
  
  #nwsDataRefresh <- shiny::eventReactive(dataETLRefresh(), {
  #  fxn_nwsData(inData = dataETLRefresh())
  #})
  
  # Build download button help text for network-wide summary table
  #nwsDownloadHelpText <- shiny::eventReactive(nwsData(), {
  #  fxn_nwsDownloadHelpText()
  #})
  
  # Build help text for button to refresh data in network-wide summary table
  #nwsRefreshHelpText <- shiny::eventReactive(nwsData(), {
  #  fxn_nwsRefreshHelpText()
  #})
  
  # Outputs -----
  
  output$nwsRefreshData <- shiny::renderUI({
    #shiny::req(dataETL)
    
    if (input$navsetCardTab == "network-wide-summary") {
      shiny::actionButton(
        "nwsRefreshData", 
        label = "REFRESH DATA",
        icon = shiny::icon(name = "rotate-right", lib = "font-awesome"),
        class = "btn btn-block btn-blue"
      )
    } else {
      return(NULL)
    }
  })
  
  output$nwsTable <- reactable::renderReactable({
    if (dataRefresh == FALSE) {
      fxn_nwsTable(inData = nwsData())
    } else {
      fxn_nwsTable(inData = nwsDataRefresh())
    }
  })
  
  #output$nwsTableRefresh <- reactable::renderReactable({
  #  if (dataRefresh == TRUE) {
  #    fxn_nwsTable(inData = nwsDataRefresh())
  #  } else {
  #    return(NULL)
  #  }
  #})
  
  #output$stationGroupsTable <- reactable::renderReactable({
  #  stationGroupsTable
  #})
}


# Run --------------------

shinyApp(ui, server)
