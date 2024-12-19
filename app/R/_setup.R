# Load auxilliary files --------------------

azmetStations <- 
  vroom::vroom(
    file = "aux-files/azmet-stations-api-db.csv", 
    delim = ",", 
    col_names = TRUE, 
    show_col_types = FALSE
  )

dataVariables <- 
  vroom::vroom(
    file = "aux-files/azmet-data-variables-15minute.csv", 
    delim = ",", 
    col_names = TRUE, 
    show_col_types = FALSE
  )


# Set global variables --------------------

networkWideNavpanelTitle <- 
  htmltools::h5(
    tags$span(class = "lm-az"),
    #htmltools::HTML("&nbsp;"), 
    "Network-wide Summary"
  )

stationLevelNavpanelTitle <- 
  htmltools::h5(
    tags$span(class = "lm-icons-weatherstation"),
    #htmltools::HTML("&nbsp;"), 
    "Station-level Summaries"
  )
