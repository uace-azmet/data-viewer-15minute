# View 15-minute data in tables and time series

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->
# 'azmet-shiny-template.html': <!-- CSS specific to this AZMet Shiny app -->

# Edit the following [in square brackets]:
# 
# 'azmet-shiny-template.html': <h1 class="mt-4 d-inline">[Web Tool Name]</h1>
# 'azmet-shiny-template.html': <h4 class="mb-0 mt-2">[High-level text summary]</h4>


# Libraries
library(azmetr)
library(bslib)
library(common)
library(dplyr)
library(htmltools)
library(reactable)
library(shiny)

# Functions 
#source("./R/fxn_ABC.R", local = TRUE)

# Scripts
#source("./R/scr##_DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  "azmet-shiny-template.html",
  
  pageNavbar = bslib::page_navbar(
    #title = "TITLE",
    
    bslib::nav_panel(
      title = htmltools::h6(
        tags$span(class = "lm-az"),
        #htmltools::HTML("&nbsp;"), 
        "Network-wide Summary"
      ),
      #p("First tab content."), 
      reactable::reactableOutput(outputId = "table")
    ),
    
    
    bslib::nav_panel(
      title = htmltools::h6(
        tags$span(class = "lm-icons-weatherstation"),
        #htmltools::HTML("&nbsp;"), 
        "Station-level Summaries"
      ), 
      bslib::layout_columns(
        cardsCurrentConditions[[1]], 
        cardsCurrentConditions[[2]], 
        cardsCurrentConditions[[3]], 
        cardsCurrentConditions[[4]], 
        cardsCurrentConditions[[5]],
        
        col_widths = breakpoints(sm = c(12), md = c(6, 6), lg = c(4, 4, 4))
      ),
      value = "Current Conditions"
    ),
    #bslib::nav_panel(
    #  title = htmltools::h6(tags$span(class = "lm-cogs"),
    #                        "Past 48 Hours"), 
    #  htmltools::p("Second tab content."),
    #  value = "Past 48 Hours"
    #),
    
    
    collapsible = FALSE,
    fillable = TRUE,
    fillable_mobile = FALSE,
  #  footer = shiny::htmlOutput(outputId = "reportPageText"),
  #  id = "pageNavbar",
    selected = htmltools::h6(
      tags$span(class = "lm-az"),
      #htmltools::HTML("&nbsp;"), 
      "Network-wide Summary"
    ),
    sidebar = NULL
  #  theme = theme, # `scr03_theme.R`
    #title = "TITLE"
    #underline = TRUE,
    #fluid = TRUE,
    #window_title = "Leaf Wetness Report"
    #)
  )
)


# Server --------------------

server <- function(input, output, session) {
  output$table <- reactable::renderReactable({
    table
  })
}


# Run --------------------

shinyApp(ui, server)
