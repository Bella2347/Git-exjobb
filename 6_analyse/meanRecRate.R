# Command-line argument:
# [out file] [recombination_rate_run1] [recombination_rate_run2] [run3] [run4] [run5]

index_from_one <- function(recombinationRate) {
  # Increases the positions with one to make the indexing from 1
  
  positionsIndexedOne <- recombinationRate[,1:2]+1
  recombinationRateNewPos <- cbind(positionsIndexedOne, recombinationRate[,3])
  return(recombinationRateNewPos)
}

#####

argv <- commandArgs(trailingOnly = TRUE)

outfile <- argv[1]

infiles <- lapply(argv[2:6], read.table, sep = " ", skip = 2, header = FALSE)

##########

# The file is indexed from 0, add one to each position to change the indexing to 1
infilesIndexOne <- lapply(infiles, index_from_one)

# Bind all columns
allRuns <- do.call(cbind, infilesIndexOne)

# Save the positions
recRate <- allRuns[,1:2]

# Creat data frame with only the rec rate
allRunsRecRate <- allRuns[,c(3,6,9,12,15)]

# Calculate the mean rec rate for each SNP pair
meanRecRate <- apply(allRunsRecRate, 1, mean)

# Bind the mean rec rate to the positions
recRate <- cbind(recRate, meanRecRate)
colnames(recRate) <- c("Start SNP", "End SNP", "Mean rec. rate over all runs")

# Write mean rec. rate to file, no column names since we append
write.table(recRate, outfile, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE)
