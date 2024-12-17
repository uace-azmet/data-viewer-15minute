# Remove some datetime-, leaf-wetness, and meta-related variables from lineup, as they won't be used in display
dataVariables <- dataVariables |>
  dplyr::filter(! variable %in% c(
    "date_doy",
    "date_hour",
    "date_seconds",
    "date_year",
    "dwpt_30cm",
    "lw1_mV",
    "lw1_total_con_mins",
    "lw1_total_dry_mins",
    "lw1_total_wet_mins",
    "lw2_mV",
    "lw2_total_con_mins",
    "lw2_total_dry_mins",
    "lw2_total_wet_mins",
    "meta_needs_review",
    "meta_station_id",
    "meta_station_name",
    "meta_version",
    "relative_humidity_30cm",
    "sol_rad_total",
    "temp_air_30cmC"
  ))

stationLevelSidebar <- 
  bslib::sidebar(
    width = 300,
    position = "left",
    open = list(desktop = "open", mobile = "always-above"),
    id = "sidebar",
    title = NULL,
    bg = "#FFFFFF",
    fg = "#000000",
    class = NULL,
    max_height_mobile = NULL,
    gap = NULL,
    padding = NULL,
    
    bslib::accordion(
      id = "accordion",
      #open = "DATE SELECTION",
      #multiple = TRUE,
      class = NULL,
      width = "auto",
      height = "auto",
      
      bslib::accordion_panel(
        title = "DATA DISPLAY",
        value = "dataDisplay",
        icon = bsicons::bs_icon("graph-up"),
        
        shiny::helpText(shiny::em(
          "Specify an AZMet station to highlight, and battery and weather variables to show in the graph."
        )),
        
        htmltools::br(),
        
        shiny::selectInput(
          inputId = "azmetStationGroup", 
          label = "AZMet Station Group",
          #choices = sort(unique(azmetStations$stationGroup)),
          choices = sort(unique(azmetStations$stationName)),
          selected = "Group 1"
        ),
        
        shiny::selectInput(
          inputId = "stationVariable", 
          label = "Station Variable",
          choices = sort(unique(dataVariables$variable)),
          selected = "relative_humidity"
        )
      ) # bslib::accordion_panel()
    ), # bslib::accordion()
  ) # bslib::sidebar()
