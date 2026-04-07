# Tabular and graphical summaries of recent 15-minute data to support QA/QC


# PROCESS FOR PWA -----

# dir.create("app/www/pwa")
# Copy `azmet-pwa-icon-###-192x192.png` to `app/www/pwa/`
# Copy `azmet-pwa-icon-###-512x512.png` to `app/www/pwa/`
# Copy `azmet-pwa-icon-###.svg` to `app/www/pwa/`
# Copy `pwa-service-worker.js` to `app/www/pwa/`
# Copy `pwa.html` to `app/www/pwa/`
# Copy `manifest.webmanifest` to `app/www/`
# Add `htmltools::tags$head(includeHTML("www/pwa/pwa.html"))` to `app.R`
# Edit directory information


# UI --------------------


ui <- 
  htmltools::htmlTemplate(
    filename = "azmet-shiny-template.html",
    
    pageDataViewer15Minute = 
      bslib::page(
        title = NULL,
        theme = theme, # `scr##_theme.R`
        
        htmltools::tags$head(htmltools::includeHTML("www/pwa/pwa.html")),
        
        bslib::layout_sidebar(
          sidebar = pageSidebar, # `scr##_slsSidebar.R`
          shiny::uiOutput(outputId = "navsetCardTab")
        ),
        
        htmltools::div(
          shiny::uiOutput(outputId = "refreshDataButton"), # Common, regardless of card tab
          htmltools::HTML("&nbsp;&nbsp;"),
          shiny::uiOutput(outputId = "refreshDataInfo"), # Common, regardless of card tab

          style = "display: flex; align-items: top; gap: 0px;", # Flexbox styling
        ),
        
        shiny::htmlOutput(outputId = "downloadButtonsDiv"),
        shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
      )
  )
    

# Server --------------------


server <- function(input, output, session) {
  
  shinyjs::useShinyjs(html = TRUE)
  
  shinyjs::hideElement("downloadButtonsDiv")
  shinyjs::hideElement("navsetCardTab")
  shinyjs::hideElement("pageBottomText")
  shinyjs::hideElement("refreshDataButton") # Needs to be 'present' on page for `dataETL <- shiny::reactive({})` statement to work on initial page load
  shinyjs::hideElement("refreshDataInfo")
  
  
  # Observables -----
  
  shiny::observeEvent(input$retrieve15minuteData, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr##_datepickerErrorModal.R`
    }
  })
  
  shiny::observeEvent(az15min(), {
    shinyjs::showElement("downloadButtonsDiv")
    shinyjs::showElement("navsetCardTab")
    shinyjs::showElement("pageBottomText")
    shinyjs::showElement("refreshDataButton")
    shinyjs::showElement("refreshDataInfo")
    
    showNavsetCardTab(TRUE)
    showPageBottomText(TRUE)
    
    shiny::updateSelectInput(
      inputId = "azmetStationGroup",
      label = "AZMet Station Group",
      choices = sort(unique(az15min()$meta_station_group)),
      selected = sort(unique(az15min()$meta_station_group))[1]
    )
    
    shiny::updateSelectInput(
      inputId = "stationVariable",
      label = "Station Variable",
      choices = 
        sort(
          colnames(
            dplyr::select(
              az15min(), !c(datetime, meta_station_group, meta_station_name)
            )
          )
        ),
      selected = 
        sort(
          colnames(
            dplyr::select(
              az15min(), !c(datetime, meta_station_group, meta_station_name)
            )
          )
        )[1]
    )
  })
  
   
  # Reactives -----
  
  az15min <- 
    shiny::eventReactive(input$retrieve15minuteData, {
      shiny::validate(
        shiny::need(
          expr = input$startDate <= input$endDate,
          message = FALSE # Failing validation test
        )
      )
      
      idRetrieving15minuteData <- 
        shiny::showNotification(
          ui = "Retrieving 15-minute data . . .", 
          action = NULL, 
          duration = NULL, 
          closeButton = FALSE,
          id = "idRetrieving15minuteData",
          type = "message"
        )
      
      on.exit(
        shiny::removeNotification(id = idRetrieving15minuteData), 
        add = TRUE
      )
      
      fxn_az15min(
        startDate = input$startDate,
        endDate = input$endDate
      )
  })
  
  # Filter and format 15-minute data for the most recent report from each station
  nwsData <- 
    shiny::eventReactive(az15min(), {
      fxn_nwsData(inData = az15min())
    })
  
  
  # Outputs -----
  
  output$navsetCardTab <- 
    shiny::renderUI({
      shiny::req(showNavsetCardTab())
      navsetCardTab # `scr##_navsetCardTab.R`
    })
  
  output$downloadButtonsDiv <- 
    shiny::renderUI({
      fxn_downloadButtonsDiv(activeTab = input$navsetCardTab)
    })
  
  output$nwsDownloadCSV <- 
    shiny::downloadHandler(
      filename = function() {"AZMet-15-minute-network-wide-summary.csv"},
      content = function(file) {
        vroom::vroom_write(x = nwsData(), file = file, delim = ",")
      }
    )
  
 output$nwsDownloadTSV <- 
   shiny::downloadHandler(
      filename = function() {"AZMet-15-minute-network-wide-summary.tsv"},
      content = function(file) {
        vroom::vroom_write(x = nwsData(), file = file, delim = "\t")
      }
    )
  
  output$nwsTable <- 
    reactable::renderReactable({
      fxn_nwsTable(inData = nwsData())
    })
  
  output$nwsTableFooter <- 
    shiny::renderUI({
      shiny::req(az15min())
      fxn_nwsTableFooter()
    })
  
  output$nwsTableTitle <- 
    shiny::renderUI({
      shiny::req(az15min())
      fxn_nwsTableTitle()
    })
  
  output$pageBottomText <- 
    shiny::renderUI({
      #shiny::req(az15min())
      fxn_pageBottomText()
    })
  
  # output$refreshDataButton <- 
  #   shiny::renderUI({
  #     #shiny::req(az15min())
  #     shiny::actionButton(
  #       inputId = "refreshDataButton", 
  #       label = "REFRESH DATA",
  #       icon = shiny::icon(name = "rotate-right", lib = "font-awesome"),
  #       class = "btn btn-block btn-blue"
  #     )
  #   })
  # 
  # output$refreshDataInfo <- 
  #   shiny::renderUI({
  #     #req(az15min())
  #     bslib::tooltip(
  #       bsicons::bs_icon("info-circle"),
  #       fxn_refreshDataHelpText(activeTab = input$navsetCardTab),
  #       id = "refreshDataInfo",
  #       placement = "right"
  #     )
  #   })
  
  output$slsDownloadCSV <- 
    shiny::downloadHandler(
      filename = function() {"AZMet-15-minute-station-level-summaries.csv"},
      content = function(file) {
        vroom::vroom_write(x = az15min(), file = file, delim = ",")
      }
    )
  
  output$slsDownloadTSV <- 
    shiny::downloadHandler(
      filename = function() {"AZMet-15-minute-station-level-summaries.tsv"},
      content = function(file) {
        vroom::vroom_write(x = az15min(), file = file, delim = "\t")
      }
    )
  
  output$slsGraph <- 
    plotly::renderPlotly({
      fxn_slsGraph(
        inData = az15min(),
        azmetStationGroup = input$azmetStationGroup,
        stationVariable = input$stationVariable
      )
    })
  
  output$slsGraphFooter <- 
    shiny::renderUI({
      shiny::req(az15min())
      fxn_slsGraphFooter()
    })
  
  output$slsGraphTitle <- 
    shiny::renderUI({
      shiny::req(az15min())
      fxn_slsGraphTitle()
    })
  
  output$stationGroupsTable <- 
    reactable::renderReactable({
      stationGroupsTable
    })
}


# Run --------------------


shinyApp(ui, server)
