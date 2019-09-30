# Give positions for hotspots
# Give mean rec. rate
# Should be able to take hotspots found in one species and calculate the surrounding in the other species:

# [unique hotspots parva] [parva rec. rate estimate]
# [unique hotspots parva] [taiga rec. rate estimate]

# [unique hotspots taiga] [taiga rec. rate estimate]
# [unique hotspots taiga] [parva rec. rate estimate]

# [shared hotspots] [parva rec. rate estimate]
# [shared hotspots] [taiga rec. rate estimate]

# [hotspots parva] [parva rec. rate estimate]
# [hotspots taiga] [taiga rec. rate estimate]

recRate_at_bases_in_win <- function(window, recombinationRateArray) {
  # WinEnd is inclusive
  
  recRateScaffold <- recombinationRateArray[recombinationRateArray[,1] == window[1], ]
  
  snps <- recRateScaffold[as.numeric(recRateScaffold[,2]) <= as.numeric(window[3]) & 
                            as.numeric(recRateScaffold[,3]) > as.numeric(window[2]),]
  
  baseArray <- array(NA, (as.numeric(window[3]) - as.numeric(window[2])))
  
  for (i in 1:dim(snps)[1]) {
    
    startIndex <- (as.numeric(snps[i,2]) - as.numeric(window[2]) + 1)
    endIndex <- (as.numeric(snps[i,3]) - as.numeric(window[2]))

    if (startIndex < 1) {
      startIndex <- 1
    }
    if (endIndex > as.numeric(window[2])) {
      endIndex <- as.numeric(window[2])
    }
    
    baseArray[startIndex:endIndex] <- snps[i,4]
    
  }
  
  return(baseArray)
  
}

main <- function(fileList) {
  
  hotspots <- as.matrix(read.table(fileList[2], sep = "\t", header = FALSE))
  
  recRate <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
  
  surrAllHotspots <- apply(hotspots, 1, recRate_at_bases_in_win, recombinationRateArray = recRate)
  
  meanSurr <- apply(surrAllHotspots, 2, mean, na.rm = TRUE)
  
}

# Load mean rec rate
# Load hotspots

# Make array with rec. rate/base

# Find middle of hotspot
# Take the 40kb window that surrounds the middle of the hotspot, if exceeds over end: add NA which are omitted when calculating mean

# Take the mean at each position in the 40kb over all hotspots

# Write data to file
# Plot data

argv <- commandArgs(trailingOnly = TRUE)

main(argv)





