navsetCardTab <- 
  bslib::navset_card_tab(
    id = "navsetCardTab",
    selected = "network-wide-summary",
    title = NULL,
    sidebar = NULL,
    header = NULL,
    footer = NULL,
    height = 820,
    full_screen = TRUE,
    # wrapper = card_body,
    
    
    # Network-wide Summary (nws) -----
    
    bslib::nav_panel(
      title = "Network-wide Summary",
      value = "network-wide-summary",
      
      shiny::htmlOutput(outputId = "nwsTableTitle"),
      reactable::reactableOutput(outputId = "nwsTable"),
      shiny::htmlOutput(outputId = "nwsTableFooter")
    ),
    
    
    # Station-level summaries (sls) -----
    
    bslib::nav_panel(
      title = "Station-level Summaries",
      value = "station-level-summaries",
      
      bslib::layout_sidebar(
        sidebar = slsSidebar, # `scr##_slsSidebar.R`
        
        shiny::htmlOutput(outputId = "slsGraphTitle"),
        plotly::plotlyOutput(outputId = "slsGraph"),
        shiny::htmlOutput(outputId = "slsGraphFooter")
      )
    ) 
  ) |>
    htmltools::tagAppendAttributes(
      #https://getbootstrap.com/docs/5.0/utilities/api/
      class = "border-0 rounded-0 shadow-none"
    )
