# OUTPUTS

# some pretty graph
# some basic explanation

outputFile <- function(df, filename){
  write.csv(df, paste(filename, ".csv"), row.names = FALSE)
}