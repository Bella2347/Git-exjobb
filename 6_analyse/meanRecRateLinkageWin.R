# Takes a file with the mean recombination rate between SNPs and a list of windows
# Outputs the mean in those window using the rate in the first file

# Commandline argumenst:
# [recombination rate] [linkage map windows] [out file]

sum_rec_rate <- function(snp, startIndex, endIndex) {
  # Returns the sum of the recombination rate at bases for a pair of SNPs
  # which are inside the window, it the SNP pair wraps the ends,
  # only the bases until the window end is sumed
  
  # Add 1 to the end so the end is included
  endIndex <- endIndex + 1
  
  # If there is no overlap, return 0
  if (as.numeric(snp[1]) >= endIndex || as.numeric(snp[2]) <= startIndex) {
    return(0)
  }
  
  # If start SNP is after the window start, use the SNP position
  if (as.numeric(snp[1]) >= startIndex) {
    startIndex <- as.numeric(snp[1])
  }
  
  # If the last SNP is before the end, use that SNP position
  if (as.numeric(snp[2]) < endIndex) {
    endIndex <- as.numeric(snp[2])
  }
  
  # Take the rec rate times the number of bases between the SNPs that are in the window
  sumrate <- (endIndex - startIndex)*as.numeric(snp[3])
  
  return(sumrate)
}


mean_in_win <- function(linkageWin, recombinationRate) {
  # Takes a window and computes the mean recombination rate in that window
  
  # Takes all SNP pairs in a certain scaffold
  recRateScaffold <- recombinationRate[recombinationRate[,1] == linkageWin[2], ]
  
  # If no SNP pairs are returned NA is returned
  if (dim(recRateScaffold)[1] != 0) {
    # For each SNP pair, get the sum over bases that are in the window
    recRateSum <- sum(apply(recRateScaffold[,2:4], 1, sum_rec_rate, startIndex = as.integer(linkageWin[3]), 
                            endIndex = as.integer(linkageWin[4])))

    # Get the end SNP
    endSNP <- as.numeric(max(recRateScaffold[as.numeric(recRateScaffold[,2]) <= as.numeric(linkageWin[4]),][,3]))

    startSNP <- as.numeric(min(recRateScaffold[as.numeric(recRateScaffold[,3]) > as.numeric(linkageWin[3]),][,2]))

    if (endSNP > as.numeric(linkageWin[4])) {
      endSNP <- as.numeric(linkageWin[4]) + 1
    }

    if (startSNP < as.numeric(linkageWin[3])) {
      startSNP <- as.numeric(linkageWin[3])
    }

    meanRecRate <- recRateSum/(endSNP - startSNP)

    meanRecRateWin <- c(linkageWin[1:4], startSNP, endSNP, meanRecRate)

  } else {

    meanRecRateWin <- c(linkageWin[1:4], "NA", "NA", "NA")
  }

  return(meanRecRateWin)
  
}

main <- function(fileList) {
  # Main script that takes names of the files and writes the results to an outfile
  
  # Read in recombination rate
  recRate <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
  
  # Read in linkage windows
  linkageMapWin <- as.matrix(read.table(fileList[2], sep = "\t", header = TRUE))
  
  outfile <- fileList[3]
  
  # Get the mean recombination rate for all windows
  meanRecRateWin <- apply(linkageMapWin, 1, mean_in_win, recombinationRate = recRate)
  
  # Transform to a data.frame and add column names
  meanRecRateWin <- as.data.frame(t(meanRecRateWin))
  colnames(meanRecRateWin) <- c("Chr", "Scaffold", "LinkWin_start", "LinkWin_end", "RecWin_start", "RecWin_end", "Mean_recRate")
  
  # Sort the results on scaffold
  meanRecRateWin <- meanRecRateWin[order(meanRecRateWin$Scaffold, meanRecRateWin$LinkWin_start),]
  
  write.table(meanRecRateWin, outfile, append = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
}


argv <- commandArgs(trailingOnly = TRUE)

main(argv)

