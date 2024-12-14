# conv_c_to_f: convert degrees Celsius to degrees Fahrenheit
# @param: valueIn - variable with units of Celsius
# @return: valueOut - variable with units of Fahrenheit


conv_c_to_f <- function(valueIn) {
  valueOut <- (valueIn * (9/5)) + 32
  return(valueOut)
}
