# Takes a file with the mean recombination rate between SNPs and a list of windows
# Outputs the mean in those window using the rate in the first file

# Commandline argumenst:
# [recombination rate] [linkage map windows] [out file]

recombination_rate_each_base <- function(recombinationRate, win) {
  # Returns an array were each value represents one base and the recombination rate at that base
  
  windowLength <- win[2] - win[1] + 1
  
  recombinationRate[,2] <- as.numeric(recombinationRate[,2]) - win[1] + 1
  recombinationRate[,3] <- as.numeric(recombinationRate[,3]) - win[1] + 1
  
  if (as.numeric(recombinationRate[dim(recombinationRate)[1],3]) > windowLength) {
    recombinationRate[dim(recombinationRate)[1],3] <- windowLength + 1
  }
  
  if (as.numeric(recombinationRate[1,2]) < 1) {
    recombinationRate[1,2] <- 1
  }
  
  # An array that is as long as the window
  recombinationRateArray <- array(NA, windowLength)
  
  # For each base write the recombination rate
  for (i in 1:dim(recombinationRate)[1]) {
    recombinationRateArray[as.numeric(recombinationRate[i,2]):(as.numeric(recombinationRate[i,3])-1)] <- recombinationRate[i,4]
  }
  
  return(recombinationRateArray)
}


mean_in_win <- function(linkageWin, recombinationRate, outFile) {
  # Takes a window and computes the mean recombination rate in that window
  
  # Takes all SNP pairs in the linkage win
  snpsWin <- recombinationRate[recombinationRate[,1] == linkageWin[2] &  
                                 as.numeric(recombinationRate[,2]) <= as.numeric(linkageWin[4]) &
                                 as.numeric(recombinationRate[,3]) > as.numeric(linkageWin[3]), ]
  
  
  
  # If no SNP pairs are returned, or there are no SNPs in the window
  # NA is returned
  if (length(snpsWin) == 0) {
    
    meanRecRateWin <- c(linkageWin[1:4], "NA", "NA", "NA")
    
  } else if (length(snpsWin) > 4) {
    
    recRateVar <- var(as.numeric(snpsWin[,4]))
    
    baseArray <- recombination_rate_each_base(snpsWin, c(as.numeric(linkageWin[3]), as.numeric(linkageWin[4])))

    meanRecRate <- mean(as.numeric(baseArray), na.rm = TRUE)
    
    meanRecRateWin <- c(linkageWin[1:4], dim(snpsWin)[1], meanRecRate, recRateVar)
  
  } else if (length(snpsWin) == 4) {
    
    meanRecRateWin <- c(linkageWin[1:4], "1", snpsWin[4], "NA")
    
  }

  write.table(t(meanRecRateWin), outFile, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
  
}

main <- function(fileList) {
  # Main script that takes names of the files and writes the results to an outfile
  
  # Read in recombination rate
  recRate <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
  
  # Read in linkage windows
  linkageMapWin <- as.matrix(read.table(fileList[2], sep = "\t", header = TRUE))
  
  write("Chr\tScaffold\tLinkWin_start\tLinkWin_end\tNumber_of_SNPs\tMean_recRate\tVariance", fileList[3], append = FALSE)
  
  # Get the mean recombination rate for all windows
  apply(linkageMapWin, 1, mean_in_win, recombinationRate = recRate, outFile = fileList[3])
  
}


argv <- commandArgs(trailingOnly = TRUE)

main(argv)

