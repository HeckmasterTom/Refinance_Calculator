# INPUTS

# read in the input .csv file into a data.frame
readInputFile <- function(inputFile){
  return(read.csv("inputFile.csv", stringsAsFactors = FALSE))
}