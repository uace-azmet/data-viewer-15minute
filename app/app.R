# Tabular and graphical summaries of recent 15-minute data to support QA/QC


# Libraries
library(azmetr)
library(bsicons)
library(bslib)
library(dplyr)
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
          title = "Network-wide Summary",
          
          shiny::htmlOutput(outputId = "nwsTableTitle"),
          shiny::htmlOutput(outputId = "nwsTableHelpText"),
          reactable::reactableOutput(outputId = "nwsTable"),
          shiny::htmlOutput(outputId = "nwsTableFooter"),
          
          value = "network-wide-summary"
        ),
        
        # Station-level summaries (sls) -----
        
        bslib::nav_panel(
          title = "Station-level Summaries",
          
          bslib::layout_sidebar(
            sidebar = slsSidebar, # `scr##_slsSidebar.R`
            
            shiny::htmlOutput(outputId = "slsGraphTitle"),
            shiny::htmlOutput(outputId = "slsGraphHelpText"),
            plotly::plotlyOutput(outputId = "slsGraph"),
            shiny::htmlOutput(outputId = "slsGraphFooter"),
            
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
      
      shiny::htmlOutput(outputId = "refreshDataHelpText"), # Common, regardless of card tab
      shiny::uiOutput(outputId = "refreshDataButton"), # Common, regardless of card tab
      shiny::htmlOutput(outputId = "dataDownloadHelpText"), # Common, regardless of card tab
      shiny::uiOutput(outputId = "nwsDownloadButtonCSV"), # if (input$navsetCardTab == "network-wide-summary")
      shiny::uiOutput(outputId = "nwsDownloadButtonTSV"), # if (input$navsetCardTab == "network-wide-summary")
      shiny::uiOutput(outputId = "slsDownloadButtonCSV"), # if (input$navsetCardTab == "station-level-summaries")
      shiny::uiOutput(outputId = "slsDownloadButtonTSV"), # if (input$navsetCardTab == "station-level-summaries")
      shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
    )
  )


# Server --------------------

server <- function(input, output, session) {
  shinyjs::useShinyjs(html = TRUE)
  shinyjs::hideElement("dataDownloadHelpText")
  shinyjs::hideElement("nwsDownloadButtonCSV")
  shinyjs::hideElement("nwsDownloadButtonTSV")
  shinyjs::hideElement("pageBottomText")
  shinyjs::hideElement("refreshDataButton") # Needs to be 'present' on page for `dataETL <- shiny::reactive({})` statement to work on initial page load
  shinyjs::hideElement("refreshDataHelpText")
  shinyjs::hideElement("slsDownloadButtonCSV")
  shinyjs::hideElement("slsDownloadButtonTSV")
  
  
  # Observables -----
  
  shiny::observeEvent(dataETL(), {
    shinyjs::showElement("dataDownloadHelpText")
    shinyjs::showElement("nwsDownloadButtonCSV")
    shinyjs::showElement("nwsDownloadButtonTSV")
    shinyjs::showElement("pageBottomText")
    shinyjs::showElement("refreshDataButton")
    shinyjs::showElement("refreshDataHelpText")
    shinyjs::showElement("slsDownloadButtonCSV")
    shinyjs::showElement("slsDownloadButtonTSV")
    
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
  
  
  # Outputs -----
  
  output$dataDownloadHelpText <- shiny::renderUI({
    #shiny::req(dataETL())
    fxn_dataDownloadHelpText()
  })
  
  output$nwsDownloadButtonCSV <- shiny::renderUI({
    #shiny::req(dataETL())
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
    #shiny::req(dataETL())
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
    filename = function() {"AZMet-15-minute-network-wide-summary.csv"},
    content = function(file) {
      vroom::vroom_write(x = nwsData(), file = file, delim = ",")
    }
  )
  
  output$nwsDownloadTSV <- shiny::downloadHandler(
    filename = function() {"AZMet-15-minute-network-wide-summary.tsv"},
    content = function(file) {
      vroom::vroom_write(x = nwsData(), file = file, delim = "\t")
    }
  )
  
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
  
  output$pageBottomText <- shiny::renderUI({
    #shiny::req(dataETL())
    fxn_pageBottomText()
  })
  
  output$refreshDataButton <- shiny::renderUI({
    #shiny::req(dataETL())
    shiny::actionButton(
      inputId = "refreshDataButton", 
      label = "REFRESH DATA",
      icon = shiny::icon(name = "rotate-right", lib = "font-awesome"),
      class = "btn btn-block btn-blue"
    )
  })
  
  output$refreshDataHelpText <- shiny::renderUI({
    #shiny::req(dataETL())
    fxn_refreshDataHelpText(activeTab = input$navsetCardTab)
  })
  
  output$slsDownloadButtonCSV <- shiny::renderUI({
    #shiny::req(dataETL())
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
    #shiny::req(dataETL())
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
    filename = function() {"AZMet-15-minute-station-level-summaries.csv"},
    content = function(file) {
      vroom::vroom_write(x = dataETL(), file = file, delim = ",")
    }
  )
  
  output$slsDownloadTSV <- shiny::downloadHandler(
    filename = function() {"AZMet-15-minute-station-level-summaries.tsv"},
    content = function(file) {
      vroom::vroom_write(x = dataETL(), file = file, delim = "\t")
    }
  )
  
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
