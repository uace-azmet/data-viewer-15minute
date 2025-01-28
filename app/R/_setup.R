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

stationGroups <- 
  tibble::tibble(
    group1 = c("Ft Mohave CA", "Mohave", "Mohave ETo", "Mohave-2", "Parker", "Parker-2"),
    group2 = c("Roll", "Wellton ETo", "Yuma N.Gila", "Yuma South", "Yuma Valley", "Yuma Valley ETo"),
    group3 = c("Aguila", "Buckeye", "Harquahala", "Paloma", "Salome", NA),
    group4 = c("Desert Ridge", "Phoenix Encanto", "Phoenix Greenway", "Payson", NA, NA),
    group5 = c("Coolidge", "Maricopa", "Queen Creek", "Sahuarita", "Tucson", NA),
    group6 = c("Bonita", "Bowie", "Safford", "San Simon", "Willcox Bench", NA)
  )

stationGroupsTable <- stationGroups |>
  reactable::reactable(
    columns = list(
      group1 = reactable::colDef(
        name = "Group 1",
        minWidth = 150,
        #aggregate = NULL,
        #sortable = NULL,
        #resizable = NULL,
        #filterable = NULL,
        #searchable = NULL,
        #filterMethod = NULL,
        #show = TRUE,
        #defaultSortOrder = NULL,
        #sortNALast = FALSE,
        #format = NULL,
        #cell = NULL,
        #grouped = NULL,
        #aggregated = NULL,
        #header = NULL,
        #footer = NULL,
        #details = NULL,
        #filterInput = NULL,
        html = TRUE,
        na = "",
        rowHeader = TRUE
        #minWidth = 100,
        #maxWidth = NULL,
        #width = NULL,
        #align = NULL,
        #vAlign = NULL,
        #headerVAlign = NULL,
        #sticky = NULL,
        #class = NULL,
        #style = NULL,
        #headerClass = NULL,
        #headerStyle = NULL,
        #footerClass = NULL,
        #footerStyle = NULL
      ), 
      group2 = reactable::colDef(
        name = "Group 2",
        minWidth = 150,
        html = TRUE,
        na = "",
        rowHeader = TRUE
      ),
      group3 = reactable::colDef(
        name = "Group 3",
        minWidth = 150,
        html = TRUE,
        na = "",
        rowHeader = TRUE
      ),
      group4 = reactable::colDef(
        name = "Group 4",
        minWidth = 150,
        html = TRUE,
        na = "",
        rowHeader = TRUE
      ),
      group5 = reactable::colDef(
        name = "Group 5",
        minWidth = 150,
        html = TRUE,
        na = "",
        rowHeader = TRUE
      ),
      group6 = reactable::colDef(
        name = "Group 6",
        minWidth = 150,
        html = TRUE,
        na = "",
        rowHeader = TRUE
      )
    ),
    #columnGroups = NULL,
    rownames = FALSE,
    #groupBy = NULL,
    sortable = FALSE,
    resizable = FALSE,
    filterable = FALSE,
    searchable = FALSE,
    searchMethod = NULL,
    #defaultColDef = NULL,
    #defaultColGroup = NULL,
    #defaultSortOrder = "asc",
    #defaultSorted = NULL,
    pagination = FALSE,
    #defaultPageSize = 10,
    showPageSizeOptions = FALSE,
    #pageSizeOptions = c(10, 25, 50, 100),
    #paginationType = "numbers",
    showPagination = NULL,
    showPageInfo = FALSE,
    #minRows = 1,
    #paginateSubRows = FALSE,
    #details = NULL,
    defaultExpanded = TRUE,
    selection = NULL,
    defaultSelected = NULL,
    onClick = NULL,
    highlight = TRUE,
    outlined = FALSE,
    bordered = TRUE,
    #borderless = FALSE,
    striped = TRUE,
    compact = TRUE,
    #wrap = TRUE,
    #showSortIcon = TRUE,
    #showSortable = FALSE,
    #class = NULL,
    #style = NULL,
    #style = list(fontFamily = "Work Sans, sans-serif", fontSize = "0.875rem"),
    #style = list(fontFamily = "monospace", fontSize = "0.875rem"),
    #rowClass = NULL,
    #rowStyle = NULL,
    fullWidth = TRUE,
    width = "auto",
    height = 400,
    theme = 
      reactable::reactableTheme(
        color = NULL,
        backgroundColor = NULL,
        borderColor = NULL,
        borderWidth = NULL,
        stripedColor = NULL,
        highlightColor = NULL,
        cellPadding = NULL,
        style = NULL,
        tableStyle = NULL,
        headerStyle = NULL,
        groupHeaderStyle = NULL,
        tableBodyStyle = NULL,
        rowGroupStyle = NULL,
        rowStyle = NULL,
        rowStripedStyle = NULL,
        rowHighlightStyle = NULL,
        rowSelectedStyle = NULL,
        #cellStyle = list(fontFamily = "monospace", fontSize = "0.8rem"),
        footerStyle = NULL,
        inputStyle = NULL,
        filterInputStyle = NULL,
        searchInputStyle = NULL,
        selectStyle = NULL,
        paginationStyle = NULL,
        pageButtonStyle = NULL,
        pageButtonHoverStyle = NULL,
        pageButtonActiveStyle = NULL,
        pageButtonCurrentStyle = NULL
      ),
    #language = getOption("reactable.language"),
    #meta = NULL,
    #elementId = NULL,
    #  static = getOption("reactable.static", FALSE)
    #selectionId = NULL
  )
      