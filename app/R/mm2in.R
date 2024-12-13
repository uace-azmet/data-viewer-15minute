# mm2in: convert millimeters to inches
# @param: valueIn - variable with units of millimeters
# @return: valueOut - variable with units of inches

mm2in <- function(valueIn) {
  valueOut <- valueIn / 25.4
  return(valueOut)
}
