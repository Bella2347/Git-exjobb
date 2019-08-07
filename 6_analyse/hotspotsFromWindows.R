#########################################################################
############################# Find hotspots #############################
#########################################################################

############################ Input parameters ###########################

# flankingWinSize from meanRecombinationRateInWindows.R
# windowSize      from meanRecombinationRateInWindows.R
# meanRecRateWin  from meanRecombinationRateInWindows.R
recTimes <- 10       # The threshold for the recombination rate in hotspots
limitSnpDensity <- 1 # The minimum SNP density in hotspot regions

########################### Output parameters ###########################
# hotspots:             list with all windows that fulfill the hotspot condition
# concatenatedHotspots: adjecent hotspots joined to one
############################ Other parameters ###########################
# nrWinPerFlankingWin:    how many windows that covers the flanking region
# h_i
# flankingWindows:        index of all flanking window which will be averaged
# snpDensity:             density of SNPs in the region
# meanRecRateFlankingWin: the mean recombination rate in the flanking region
# hotspotLength:          the length of the hotspot when concatenated
# i
# n
#########################################################################
#########################################################################

# Calculate how many windows fit in the flanking regions
nrWinPerFlankingWin <- 2*flankingWinSize/windowSize

# Create array to store the hotspots
hotspots <- data.frame(array(NA, c(dim(meanRecRateWin)[1],3)))
colnames(hotspots) <- c("Start position", "End position", "Recombination rate [1/bp]")
# Keep track of the next empty row
h_i <- 1


# Step through all windows and compare them to the mean in the flanking regions
for (i in 1:dim(meanRecRateWin)[1]) {
  # The index of the windows in the flanking regions, non overlapping, including window #i
  flankingWindows <- seq(i-nrWinPerFlankingWin,i+nrWinPerFlankingWin,2)
  
  # If the flanking regions extend beyond the ends remove those "indexes"
  if (any(flankingWindows < 1)) {
    flankingWindows <- flankingWindows[(max(which(flankingWindows < 1))+1):length(flankingWindows)]
  } else if (any(flankingWindows > dim(meanRecRateWin)[1])) {
    flankingWindows <- flankingWindows[1:(min(which(flankingWindows > dim(meanRecRateWin)[1]))-1)]
  }
  
  # Calculate the SNP density [SNP/1kb] in the whole region
  snpDensity <- mean(snpPerBase[meanRecRateWin[min(flankingWindows),1]:meanRecRateWin[max(flankingWindows),2]])*1000
  
  # Remove i from the flanking windows
  flankingWindows <- flankingWindows[flankingWindows != i]
  
  # Calculate the mean recombination rate in the flanking regions
  meanRecRateFlankingWin <- mean(meanRecRateWin[flankingWindows,3])
  
  # If the rate in the window is at least a certain times higher than the average in the flanking regions
  # and the SNP density is at least 1 SNP/1kb, save as a hotspot
  if (meanRecRateWin[i,3] >= (meanRecRateFlankingWin*recTimes) && snpDensity >= limitSnpDensity) {
    
    hotspots[h_i,] <- meanRecRateWin[i,]
    h_i <- h_i + 1
  }
}

# Remove empty rows
hotspots <- hotspots[1:(h_i-1),]

# Concatenate adjecent hotspots
concatenatedHotspots <- data.frame(array(NA, c(dim(hotspots)[1],4)))
h_i <- 1

i <- 1
while (i < dim(hotspots)[1]) {
  n <- 0
  while ((hotspots[(i+n),1]+1000) == hotspots[(i+n+1),1] && (i+n) < dim(hotspots)[1]) {
    n <- n + 1
  }
  hotspotLength <- (hotspots[(i+n),2] - hotspots[i,1]+1)
  
  concatenatedHotspots[h_i,] <- c(hotspots[i,1], hotspots[(i+n),2], hotspotLength, mean(hotspots[i:(i+n),3]))
  h_i <- h_i + 1
  
  i <- i + n + 1
}

# Remove empty rows
concatenatedHotspots <- concatenatedHotspots[1:(h_i-1),]

