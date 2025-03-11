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
library(shinyjs)

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
      #shiny::htmlOutput(outputId = "nwsDownloadHelpText"),
      #shiny::uiOutput(outputId = "nwsDownloadButtonCSV"),
      #shiny::uiOutput(outputId = "nwsDownloadButtonTSV"),
      
      # if (input$navsetCardTab == "station-level-summaries")
      #shiny::htmlOutput(outputId = "slsDownloadHelpText"),
      #shiny::uiOutput(outputId = "slsDownloadButtonCSV"),
      #shiny::uiOutput(outputId = "slsDownloadButtonTSV"),
      
      # Common, regardless of card tab
      shiny::htmlOutput(outputId = "refreshDataHelpText"),
      shiny::uiOutput(outputId = "refreshDataButton"),
      #shiny::htmlOutput(outputId = "pageBottomText")
    )
  )


# Server --------------------

server <- function(input, output, session) {
  shinyjs::useShinyjs(html = TRUE)
  shinyjs::hideElement("refreshDataButton") # Needs to be 'present' on page for `dataETL <- shiny::reactive({})` statement to work on initial page load
  shinyjs::hideElement("refreshDataHelpText")
  
  
  # Observables -----
  
  shiny::observeEvent(dataETL(), {
    shinyjs::showElement("refreshDataButton")
    shinyjs::showElement("refreshDataHelpText")
    
    shiny::updateSelectInput(
      inputId = "azmetStationGroup",
      label = "AZMet Station Group",
      choices = sort(unique(dataETL()$meta_station_group)),
      selected = sort(unique(dataETL()$meta_station_group))[1]
    )
    
    shiny::updateSelectInput(
      inputId = "stationVariable",
      label = "Station Variable",
      choices = 
        sort(
          colnames(
            dplyr::select(
              dataETL(), !c(datetime, meta_station_group, meta_station_name)
            )
          )
        ),
      selected = 
        sort(
          colnames(
            dplyr::select(
              dataETL(), !c(datetime, meta_station_group, meta_station_name)
            )
          )
        )[1]
    )
  })
  
  
  # Reactives -----
  
  dataETL <- shiny::reactive({
    fxn_dataETL()
  }) %>% 
    shiny::bindEvent(
      input$refreshDataButton,
      ignoreNULL = FALSE,
      ignoreInit = TRUE
    )
  
  # Filter and format 15-minute data for the most recent report from each station
  nwsData <- shiny::eventReactive(dataETL(), {
    fxn_nwsData(inData = dataETL())
  })
  
  # Build download button help text for network-wide summary table
  #nwsDownloadHelpText <- shiny::eventReactive(nwsData(), {
  #  fxn_nwsDownloadHelpText()
  #})
  
  # Build help text for button to refresh data in either network-wide summary table or station-level summaries graph
  #refreshDataHelpText <- shiny::eventReactive(dataETL(), {
  #  fxn_refreshDataHelpText()
  #})
  
  # Build download button help text for station-level summaries
  #slsDownloadHelpText <- shiny::eventReactive(dataETL(), {
  #  fxn_slsDownloadHelpText()
  #})
  
  
  # Outputs -----
  
  output$refreshDataButton <- shiny::renderUI({
    #shiny::req(dataETL())
    shiny::actionButton(
      inputId = "refreshDataButton", 
      label = "REFRESH DATA",
      icon = shiny::icon(name = "rotate-right", lib = "font-awesome"),
      class = "btn btn-block btn-blue"
    )
  })
  
  output$nwsTable <- reactable::renderReactable({
    fxn_nwsTable(inData = nwsData())
  })
  
  output$nwsTableFooter <- shiny::renderUI({
    shiny::req(dataETL())
    fxn_nwsTableFooter()
  })
  
  output$nwsTableHelpText <- shiny::renderUI({
    shiny::req(dataETL())
    fxn_nwsTableHelpText()
  })
  
  output$nwsTableTitle <- shiny::renderUI({
    shiny::req(dataETL())
    fxn_nwsTableTitle()
  })
  
  output$refreshDataHelpText <- shiny::renderUI({
    #shiny::req(dataETL())
    fxn_refreshDataHelpText()
  })
  
  output$slsGraph <- plotly::renderPlotly({
    fxn_slsGraph(
      inData = dataETL(),
      azmetStationGroup = input$azmetStationGroup,
      stationVariable = input$stationVariable
    )
  })
  
  output$slsGraphFooter <- shiny::renderUI({
    shiny::req(dataETL())
    fxn_slsGraphFooter()
  })
  
  output$slsGraphHelpText <- shiny::renderUI({
    shiny::req(dataETL())
    fxn_slsGraphHelpText()
  })
  
  output$slsGraphTitle <- shiny::renderUI({
    shiny::req(dataETL())
    fxn_slsGraphTitle()
  })
  
  output$stationGroupsTable <- reactable::renderReactable({
    stationGroupsTable
  })
}


# Run --------------------

shinyApp(ui, server)
