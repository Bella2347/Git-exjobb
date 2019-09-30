# Takes an estimated recombination rate and hotspots and calculates the mean in the surrounding of the hotspots
# Can take any file of recombination rate and hotspots, does not have to be the same species

# Input:
# [Recombination rate] [Hotspots] [Prefix for output]

##### Functions #####

recRate_at_bases_in_win <- function(hotspot, recombinationRateArray) {
  # Takes a hotspot and finds the surrounding rate
  # Outputs the rate normalized to the mean of the surrounding
  
  hotspotMiddle <- as.numeric(hotspot[4])/2 + as.numeric(hotspot[2])
  windowLength <- 40000
  # Start and stop of window
  window <- c((hotspotMiddle - windowLength/2), (hotspotMiddle + windowLength/2))
  
  recRateScaffold <- recombinationRateArray[recombinationRateArray[,1] == hotspot[1], ]
  
  snps <- recRateScaffold[as.numeric(recRateScaffold[,2]) <= window[2] & 
                            as.numeric(recRateScaffold[,3]) > window[1],]
  
  baseArray <- array(NA, (windowLength + 1))
  
  for (i in 1:dim(snps)[1]) {
    
    startIndex <- (as.numeric(snps[i,2]) - window[1] + 1)
    endIndex <- (as.numeric(snps[i,3]) - window[1])

    if (startIndex < 1) {
      startIndex <- 1
    }
    if (endIndex > (windowLength + 1)) {
      endIndex <- windowLength + 1
    }
    
    baseArray[startIndex:endIndex] <- as.numeric(snps[i,4])
    
  }
  
  baseArrayNorm <- baseArray/mean(baseArray, na.rm = TRUE)
  
  return(baseArrayNorm)
  
}

main <- function(fileList) {
  # Takes input files and finds the surrounding for each hotspot and
  # then take the mean over all hotspots
  # Write surrounding to file and plot
  
  recRate <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
  
  hotspots <- as.matrix(read.table(fileList[2], sep = "\t", header = FALSE))
  
  outPrefix <- fileList[3]
  
  surrAllHotspots <- apply(hotspots, 1, recRate_at_bases_in_win, recombinationRateArray = recRate)
  
  meanSurr <- apply(surrAllHotspots, 1, mean, na.rm = TRUE)
  
  write.table(meanSurr, paste(outPrefix, "txt", sep = "."), append = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
  
  png(paste(outPrefix, "png", sep = "."))
  plot(-20000:20000, meanSurr, type = "s", ylab = "Relative recombination rate", xlab = "Physical distance (bp)", 
       xlim = c(-20000, 20000), main = "Mean recombination rate surrounding hotspots")
  dev.off()
  
}

argv <- commandArgs(trailingOnly = TRUE)

main(argv)
