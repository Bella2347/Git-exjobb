# Command-line argument:
# [out file] [recombination_rate_run1] [recombination_rate_run2] [run3] [run4] [run5]

index_from_one <- function(recombinationRate) {
  # Increases the positions with one to make the indexing from 1
  
  positionsIndexedOne <- recombinationRate[,1:2]+1
  recombinationRateNewPos <- cbind(positionsIndexedOne, recombinationRate[,3])
  return(recombinationRateNewPos)
}

main <- function(fileList) {
  
  outfile <- fileList[1]
  
  # Read in the input files
  infiles <- lapply(fileList[2:6], read.table, sep = " ", skip = 2, header = FALSE)
  
  # The file is indexed from 0, add one to each position to change the indexing to 1
  infilesIndexOne <- lapply(infiles, index_from_one)
  
  # Bind all columns
  allRuns <- do.call(cbind, infilesIndexOne)
  
  # Get the scaffold
  scaffold <- regmatches(fileList[2], regexpr("N\\d+", fileList[2]))
  
  # Save the positions and which scaffold it is
  recRate <- cbind(scaffold, allRuns[,1:2])
  
  # Creat data frame with only the rec rate
  allRunsRecRate <- allRuns[,c(3,6,9,12,15)]
  
  # Calculate the mean rec rate for each SNP pair
  meanRecRate <- apply(allRunsRecRate, 1, mean)
  
  # Bind the mean rec rate to the scaffold and positions
  recRate <- cbind(recRate, meanRecRate)
  
  # Write mean rec. rate to file, no column names since we append
  write.table(recRate, outfile, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
  
}

#####

argv <- commandArgs(trailingOnly = TRUE)

main(argv)
