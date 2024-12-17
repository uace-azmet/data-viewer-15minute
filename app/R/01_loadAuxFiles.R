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
