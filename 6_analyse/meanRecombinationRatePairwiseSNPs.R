# Make an array the same length as the scaffold and fill in the recombination rate for each base, bases in begining and end are NA

flankingWindow <- 200000
recTimes <- 10
recRate <- N70_rec
recRatePerBase <- N70_rec_all_bases



# Find the first and last SNP with a recombination rate
recNonNAindex <- which(!is.na(recRatePerBase))
recFirst_i <- min(recNonNAindex)
recLast_i <- max(recNonNAindex)

# Initiate a dataframe to store the detected hotspots
potentialHotspots <- data.frame(array(NA, c(dim(recRate)[1],6)))
# To know which row to write results to
ph_i <- 1


# Step through each line in the recombination rate
for (i in 1:dim(recRate)[1]) {

  # Save the middle point between two SNPs
  windowMiddle_i <- (recRate[i,2]-recRate[i,1])/2
  # Find the end and start of the flanking region
  flankingWinStart_i <- (recRate[i,1]+middle_i)-flankingWindow
  flankingWinEnd_i <- (recRate[i,1]+middle_i)+flankingWindow
  
  # If the start of the window is before the first recombination rate value just sum from the first value
  if (flankingWinStart_i < recFirst_i) {
    meanRecRateFlankingWin <- sum(recRatePerBase[recFirst_i:flankingWinEnd_i])/(flankingWinEnd_i-recFirst_i+1)
  
  # If the end of the window exceds the last recombination rate value use the sum up to the end
  } else if (flankingWinEnd_i > recLast_i) {
    meanRecRateFlankingWin <- sum(recRatePerBase[flankingWinStart_i:recLast_i])/(recLast_i-flankingWinStart_i+1)
  
  } else {
    meanRecRateFlankingWin <- sum(recRatePerBase[flankingWinStart_i:flankingWinEnd_i])/(flankingWinEnd_i-flankingWinStart_i+1)
  }
  
  # If the recombination rate between thoose SNPs is at least a certain times higher than the average save it as a potential hotspot
  if (recRate[i,3] >= (meanRecRateFlankingWin*recTimes)) {
    potentialHotspots[ph_i,] <- (recRate[i,])
    ph_i <- ph_i + 1
  }
}


# Remove empty rows
potentialHotspots <- potentialHotspots[1:(ph_i-1),]

# Dataframe for the total length of hotspots
hotspots <- data.frame(array(NA, c(dim(potentialHotspots)[1],3)))
h_i <- 1

# Go through the potential hotspots, find if some hotspots overlap, count the number of overlapping hotspots and save the total length if it is more than 750 bp
i <- 1
while (i < dim(potentialHotspots)[1]) {
  n <- 0
  while (potentialHotspots[(i+n),2] == potentialHotspots[(i+n+1),1]) {
    n <- n + 1
  }
  hotspotLength <- (potentialHotspots[(i+n),2] - potentialHotspots[i,1])
  
  if (hotspotLength >= 750) {
    hotspots[h_i,] <- c(potentialHotspots[i,1], potentialHotspots[(i+n),2], (potentialHotspots[(i+n),2] - potentialHotspots[i,1]))
    h_i <- h_i + 1
  }
  i <- i + n + 1
}

# Remove empty rows
hotspots <- hotspots[1:(h_i-1),]

