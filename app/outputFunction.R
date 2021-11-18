# OUTPUTS

# Write df to an output file
outputFile <- function(df, filename){
  write.csv(df, paste(filename, ".csv"), row.names = FALSE)
}