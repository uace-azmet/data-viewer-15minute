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
  #dataETL <- reactive({fxn_dataETL()})
  
  #dataETL <- shiny::eventReactive(
  #  list(input$nwsRefreshData, input$slsRefreshData),
  #  ignoreNULL = FALSE,
  #  ignoreInit = TRUE, {
  #    fxn_dataETL()
  #  }
  #)
  #refreshData <- reactive({
  #  list(input$nwsRefreshData, input$slsRefreshData) # events
  #})
  
  
  #dataETLRefresh <- shiny::reactive({
  #  fxn_dataETL()
  #}) %>%
  #  shiny::bindEvent(
  #    list(input$nwsRefreshData, input$slsRefreshData), # reactive sources, events
  #  )

  #fxn_dataETL(),
  #  list(input$nwsRefreshData, input$slsRefreshData), # events
  #refreshData(),
  #  ignoreNULL = FALSE, 
  #  ignoreInit = TRUE
  #)
  
  
  #dataETL <- reactive({
  #  fxn_dataETL()
  #})
  
  #observeEvent(input$nwsRefreshData, {
  #  dataETL <- NULL
  #  dataETL <- fxn_dataETL()
  #},
  #  ignoreNULL = FALSE,
  #  ignoreInit = TRUE
  #)
  
  #reactive({bindEvent(list(input$nwsRefreshData, input$slsRefreshData), {
  #  dataETL()
  #})
    #dataETL,
     # events
  #)
  
  
  # If page load is initial, then
  dataETL <- reactive({
    fxn_dataETL()
  }) %>%
    shiny::bindEvent(
      #fxn_dataETL(),
      list(input$nwsRefreshData, input$slsRefreshData), # events
      ignoreNULL = TRUE, 
      ignoreInit = TRUE
    )
  
  # Else
  #dataETL <- shiny::eventReactive(input$nwsRefreshData, {
  #  fxn_dataETL()
  #})
  
  #dataETL <- reactive({
  #  if (shiny::req(input$nwsRefreshData) == 0) {
  #    dataETL <- fxn_dataETL()
  #  } else {
  #    dataETL <- fxn_dataETL() %>%
  #      shiny::bindEvent(
  #        list(input$nwsRefreshData, input$slsRefreshData), # events
  #        ignoreNULL = FALSE, 
  #        ignoreInit = TRUE
  #      )
  #  }
  #})
  
  
  
  
  
  
  
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
  })
  
  shiny::observeEvent(nwsData(), {
    message("nwsData has been requested")
  })
  
  
  # Does not refresh displays, download files
  shiny::observe({
    if (shiny::req(input$slsRefreshData)) {
      message("slsRefreshData has been requested")
      #
      #dataETL <- NULL
      #dataETL <- fxn_dataETL()
    }
  })
  
  # Does not refresh displays, download files
  #shiny::observe(input$slsRefreshData, {
    #if (shiny::req(input$navsetCardTab) == "network-wide-summary") {
  #  message("slsRefreshData has been requested")
    #}
    #dataETL <- NULL
    #dataETL <- fxn_dataETL()
  #})
  
  # Does not re-download data
  #shiny::eventReactive(input$nwsRefreshData, {
  #  dataETL <- NULL
  #  dataETL <- fxn_dataETL()
  #})
  
  # Does not re-download data
  #shiny::eventReactive(input$slsRefreshData, {
  #  dataETL <- NULL
  #  dataETL <- fxn_dataETL()
  #})
  
  #dataETL <- shiny::eventReactive(input$refresh)
  
  
  # Reactives -----
  
  
  #dataETLRefresh <- shiny::eventReactive(
  #  input$nwsRefreshData, # reactive sources, events
  #  ignoreNULL = TRUE,
  #  ignoreInit = TRUE, {
  #    fxn_dataETL()
  #  }
  #)
  
  
  
  # Filter and format 15-minute data for the most recent report from each station
  nwsData <- shiny::eventReactive(dataETL(), {
    fxn_nwsData(inData = dataETL())
  })
  
  # Build download button help text for network-wide summary table
  nwsDownloadHelpText <- shiny::eventReactive(nwsData(), {
    fxn_nwsDownloadHelpText()
  })
  
  # Build help text for button to refresh data in network-wide summary table
  nwsRefreshHelpText <- shiny::eventReactive(nwsData(), {
    fxn_nwsRefreshHelpText()
  })
  
  # Outputs -----
  
  output$nwsDownloadButtonCSV <- shiny::renderUI({
    shiny::req(nwsData())
    
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
    shiny::req(nwsData())
    
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
    #shiny::req(nwsData())
    
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
  
  output$nwsRefreshHelpText <- shiny::renderUI({
    if (input$navsetCardTab == "network-wide-summary") {
      nwsRefreshHelpText()
    } else {
      return(NULL)
    }
  })
  
  output$nwsTable <- reactable::renderReactable({
    fxn_nwsTable(inData = nwsData())
  })
  
  output$stationGroupsTable <- reactable::renderReactable({
    stationGroupsTable
  })
}


# Run --------------------

shinyApp(ui, server)
