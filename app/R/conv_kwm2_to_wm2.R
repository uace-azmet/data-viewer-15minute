# conv_kwm2_to_wm2: convert kilowatts/m^2 to watts/m^2
# @param: valueIn - variable with units of kilowatts/m^2
# @return: valueOut - variable with units of watts/m^2

conv_kwm2_to_wm2 <- function(valueIn) {
  valueOut <- valueIn * 1000
  return(valueOut)
}
