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
library(htmltools)
library(reactable)
library(shiny)

# Functions 
#source("./R/fxn_ABC.R", local = TRUE)

# Scripts
#source("./R/scr##_DEF.R", local = TRUE)


# UI --------------------

ui <- 
  htmltools::htmlTemplate(
    filename = "azmet-shiny-template.html",
    
    pageNavbar = bslib::page_navbar(
      title = NULL,
      
      # Network-wide Summary -----
      bslib::nav_panel(
        title = navPanelTitleNetworkWide,
        
        reactable::reactableOutput(outputId = "table"),
        
        # TO-DO: Turn into fxn for custom render with HTML class
        htmltools::p(
          htmltools::HTML( 
            "<sup>1</sup> Since midnight local time   <sup>2</sup> Since the top of the hour"
          )
        ),
        
        value = "network-wide-summary"
      ), 
      
      # Station-level summaries -----
      bslib::nav_panel(
        title = navPanelTitleStationLevel,
        
        bslib::layout_sidebar(
          sidebar = sidebarGraph,
          htmltools::p("Coming soon.")
          # options ???
        ),
        
        value = "station-level-summaries"
      )#,
      
    #  collapsible = FALSE,
    #  fillable = TRUE,
    #  fillable_mobile = FALSE,
    #  footer = shiny::htmlOutput(outputId = "reportPageText"),
    #  id = "pageNavbar",
    #  selected = navPanelTitleNetworkWide,
    #  sidebar = NULL
    #  theme = theme, # `scr03_theme.R`
      #title = "TITLE"
      #underline = TRUE,
      #fluid = TRUE,
      #window_title = NULL
    )
  )


# Server --------------------

server <- 
  function(input, output, session) {
    output$table <- reactable::renderReactable({
      table  # TO-DO: Turn into fxn
    })
  }


# Run --------------------

shinyApp(ui, server)
