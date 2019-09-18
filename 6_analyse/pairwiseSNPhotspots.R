start_time <- Sys.time()

################### Functions ###################
find_start_end_window <- function(firstSNP, secondSNP, windowSize, scaffoldLength) {
  # A function which finds the start and end positions of the background window
  # If the window exceeds over the ends it is truncated
  
  windowMiddle <- as.integer((secondSNP - firstSNP)/2 + firstSNP)
  
  if ((windowMiddle - windowSize/2) < 1) {
    windowStart <- 1
  } else {
    windowStart <- windowMiddle - windowSize/2
  }
  
  if ((windowSize/2 + windowMiddle) > scaffoldLength) {
    windowEnd <- scaffoldLength
  } else {
    windowEnd <- windowSize/2 + windowMiddle
  }
  
  return(c(windowStart, windowEnd))
}


is_hotspot <- function(SNPpair, windowSize, timesRecombinationRate, 
                       minSNPdensity, recombinationRateAllBases, SNParray) {
  # A function which takes two SNPs and if the recombination rate between them is a certain
  # times higher than the background they are returned as a hotspot
  # If they are not a hotspot, nothing is returned
  
  # SNPpair contains: first SNP position, second SNP position, recombination rate between the SNPs
  
  windowStartEnd <- find_start_end_window(SNPpair[1], SNPpair[2], windowSize, dim(recombinationRateAllBases)[1])
  
  meanRecRateWin <- mean(recombinationRateAllBases[windowStartEnd[1]:windowStartEnd[2]], na.rm=TRUE)
  snpDensity <- mean(SNParray[windowStartEnd[1]:windowStartEnd[2]])*1000
  
  if (SNPpair[3] >= meanRecRateWin*timesRecombinationRate && snpDensity >= minSNPdensity) {
    return(c(as.integer(SNPpair[1]), as.integer(SNPpair[2]), as.numeric(SNPpair[3]), meanRecRateWin, snpDensity))
  }
}

hotspots_overlap <- function(firstHotspot, secondHotspot) {
  if (isTRUE(firstHotspot[2] == secondHotspot[1])) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

############################################################

########### INPUT ###############
args <- commandArgs(trailingOnly = TRUE)
recFilename <- args[1]    # Read in recombination rate-file
recTimes <- 10            # The threshold for the recombination rate in hotspots
limitSnpDensity <- 1      # The minimum SNP density in hotspot regions
flankingWinSize <- 200000 # The total length of the flanking region
minHotspotsLen <- 750     # Minimum length of a hotspot
outFilename <- args[2]    # File to write output to



# Read in the recombination rate
recRate <- read.table(recFilename, sep=" ", skip=2, header=FALSE)

# If the scaffold is to small, then no hotspots can be found
stopifnot(recRate[dim(recRate)[1],2] > flankingWinSize*2)

# The file is indexed from 0, add one to each position to change the indexing to 1
recRate[,1:2] <- recRate[,1:2]+1



recRatePerBase <- array(NA, recRate[dim(recRate)[1],2])

# For each base write the recombination rate
for (i in 1:dim(recRate)[1]) {
  recRatePerBase[recRate[i,1]:recRate[i,2]] <- recRate[i,3]
}



# Create an array with the length of the scaffold to store if the base is (1) a SNP or not (0)
snpPerBase <- numeric(recRate[dim(recRate)[1],2])

# For each base set to 1 if it is a SNP
snpPerBase[recRate[,1]] <- 1

# The last SNP, since it is not in column 1
snpPerBase[recRate[dim(recRate)[1],2]] <- 1


potentialHotspots <- apply(recRate, 1, is_hotspot, windowSize = flankingWinSize, timesRecombinationRate = recTimes, 
                           minSNPdensity = limitSnpDensity, recombinationRateAllBases = recRatePerBase, SNParray = snpPerBase)

potentialHotspots <- as.data.frame(matrix(unlist(potentialHotspots), ncol = 5, byrow = TRUE))
colnames(potentialHotspots) <- c("Start SNP", "End SNP", "Rec. rate", "Mean rec. rate in surrounding", "SNP density in surrounding")


# Dataframe for the total length of hotspots
hotspots <- data.frame(array(NA, c(dim(potentialHotspots)[1],3)))
colnames(hotspots) <- c("Start position", "End position", "Hotspot length")
h_i <- 1

# Go through the potential hotspots, find if some hotspots overlap, count the number of overlapping hotspots and save the total length if it is more than 750 bp
i <- 1
while (i <= dim(potentialHotspots)[1]) {
  n <- i
  while (hotspots_overlap(potentialHotspots[n,], potentialHotspots[(n+1),])) {
    n <- n + 1
  }
  
  hotspotLength <- (potentialHotspots[n,2] - potentialHotspots[i,1])
  
  if (hotspotLength >= minHotspotsLen) {
    hotspots[h_i,] <- c(potentialHotspots[i,1], potentialHotspots[n,2], hotspotLength)
    h_i <- h_i + 1
  }
  i <- n + 1
}

# Remove empty rows
hotspots <- hotspots[1:(h_i-1),]

write.table(hotspots, outFilename, append = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)

end_time <- Sys.time()

end_time - start_time
