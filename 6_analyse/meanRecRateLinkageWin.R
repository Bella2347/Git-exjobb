# print number of SNPs in each window (to see how well the ends are covered)
# print SNP density
# what if window is outside estimation (handle error?)
# Commandline argumenst:
# [linkage map windows] [recombination rate] [out file]

winMean <- function(snpInfo, recombinationRatePerBase) {
  meanInWin <- mean(recombinationRatePerBase[snpInfo[3]:snpInfo[4]], na.rm = TRUE)
  return(meanInWin)
}

recombination_rate_each_base <- function(recombinationRate) {
  # Returns an array were each value represents one base and the recombination rate at that base
  
  recombinationRateArray <- array(NA, recombinationRate[dim(recombinationRate)[1],2])
  
  # For each base write the recombination rate
  for (i in 1:dim(recombinationRate)[1]) {
    recombinationRateArray[recombinationRate[i,1]:recombinationRate[i,2]] <- recombinationRate[i,3]
  }
  
  return(recombinationRateArray)
}



argv <- commandArgs(trailingOnly = TRUE)

# Read in input files
recRate <- read.table(argv[1], sep = "\t", header = FALSE)

linkageMapWin <- read.table(argv[2], sep = "\t", header = TRUE)

outfile <- argv[3]


# Get an array with the recombination rate for each base
recRatePerBase <- recombination_rate_each_base(recRate)


linkMapWin <- linkageMapWin[linkageMapWin$scaf == scaffoldName,]

recRateMeanWin <- apply(linkMapWin, 1, winMean, recombinationRatePerBase = recRatePerBase)
recRateMeanWin <- cbind(linkMapWin[,3:4], unlist(recRateMeanWin))

write.table(recRateMeanWin, paste(species, "GQ30meanRecRateLinkageWin.chr-", scaffoldName, ".txt", sep = ""), 
            append = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
