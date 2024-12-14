# conv_mps_to_mph: convert meters/second to miles/hour
# @param: valueIn - variable with units of meters/second
# @return: valueOut - variable with units of miles/hour

conv_mps_to_mph <- function(valueIn) {
  valueOut <- valueIn * 2.237
  return(valueOut)
}
