#' `fxn_mm_to_in.R`: convert millimeters to inches
#' @param: `valueIn` - variable with units of millimeters
#' @return: `valueOut` - variable with units of inches


fxn_mm_to_in <- function(valueIn) {
  valueOut <- valueIn / 25.4
  return(valueOut)
}
