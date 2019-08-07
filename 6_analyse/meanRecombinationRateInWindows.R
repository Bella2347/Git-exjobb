# Compute the average recombination rate in 2kb windows with 1kb stepsize
# Parameters to change
stepSize <- 1000
windowSize <- 2000
flankingWinSize <- 100000
recTimes <- 10
recRatePerBase <- N70_rec_all_bases
winSizeForRecRateSurr <- 20000


# Find the first and last SNP with a recombination rate
recNonNAindex <- which(!is.na(recRatePerBase))
recFirst_i <- min(recNonNAindex)
recLast_i <- max(recNonNAindex)

# Create a data frame to store the average recombination rate in
meanRecRateWin <- data.frame(array(NA, c(((recLast_i-recFirst_i)/stepSize),3)))
colnames(meanRecRateWin) <- c("Start position", "End position", "Recombination rate [1/bp]")
# Use this to know the next empty row
r_i <- 1

# Calculate the mean recombination rate for each window
for (i in seq(recFirst_i,recLast_i,stepSize)) {
  
  # If the window extends over the take the mean to the end even if it is less than the window size
  if ((recLast_i-i) < (windowSize-1) && (recLast_i-i) > (stepSize-1)) {
    # Take the mean of the window and store it with the positions for the window
    meanRecRateWin[r_i,] <- c(i, recLast_i, mean(recRatePerBase[i:recLast_i]))
  
  } else if ((recLast_i-i) > (windowSize-1) && (recLast_i-i) > (stepSize-1)) {
    meanRecRateWin[r_i,] <- c(i, (windowSize-1+i), mean(recRatePerBase[i:(windowSize-1+i)]))
  } 
  
  # Add one to keep track of the next empty row
  r_i <- r_i +1
}

# Calculate how many windows fit in the flanking regions
nrWinPerFlankingWin <- 2*flankingWinSize/windowSize
nrWinPerHotspotSurr <- 2*winSizeForRecRateSurr/windowSize

# Create array to store the hotspots
hotspots <- data.frame(array(NA, c(dim(meanRecRateWin)[1],3)))
colnames(hotspots) <- c("Start position", "End position", "Recombination rate [1/bp]")
# Keep track of the next empty row
h_i <- 1

# Dataframe to store the suroundings
recRateSurrHotspots <- data.frame(array(NA, c(dim(meanRecRateWin)[1],nrWinPerHotspotSurr*2)))

# Step through all windows and compare them to the mean in the flanking regions
for (i in 1:dim(meanRecRateWin)[1]) {
  # The number of the windows in the flanking regions, non overlapping, not including window #i
  flankingWindows <- c(seq(i-nrWinPerFlankingWin,i-2,2), seq(i+2,i+nrWinPerFlankingWin,2))
  
  # If the flanking regions extend beyond the ends remove those "indexes"
  if (any(flankingWindows < 1)) {
    flankingWindows <- flankingWindows[(max(which(flankingWindows < 1))+1):length(flankingWindows)]
  } else if (any(flankingWindows > dim(meanRecRateWin)[1]-1)) { # Do not use last window since it is less than 2000kb
    flankingWindows <- flankingWindows[1:(min(which(flankingWindows > dim(meanRecRateWin)[1]))-1)]
  }
  
  # Calculate the mean recombination rate in the flanking regions
  meanRecRateFlankingWin <- mean(meanRecRateWin[flankingWindows,3])
  
  # If the rate in the window is a certain times higher than the average in the flanking regions, save as a hotspot
  if (meanRecRateWin[i,3] > (meanRecRateFlankingWin*recTimes)) {
    hotspots[h_i,] <- meanRecRateWin[i,]
    
    # Add conditions for the ends, ignore them that don't have that length of flanking region?
    # recRateSurrHotspots[h_i,] <- meanRecRateWin[seq(i-nrWinPerHotspotSurr+1,i+nrWinPerHotspotSurr-1,2),3]
    
    h_i <- h_i + 1
  }
}

# Remove empty rows
hotspots <- hotspots[1:(h_i-1),]

# Concatenate adjecent hotspots
concatenateHotspots <- data.frame(array(NA, c(dim(hotspots)[1],4)))
h_i <- 1

i <- 1
while (i < dim(hotspots)[1]) {
  n <- 0
  while ((hotspots[(i+n),1]+1000) == hotspots[(i+n+1),1] && (i+n) < dim(hotspots)[1]) {
    n <- n + 1
  }
  hotspotLength <- (hotspots[(i+n),2] - hotspots[i,1])

  concatenateHotspots[h_i,] <- c(hotspots[i,1], hotspots[(i+n),2], hotspotLength, mean(hotspots[i:(i+n),3]))
  h_i <- h_i + 1

  i <- i + n + 1
}

# Remove empty rows
concatenateHotspots <- concatenateHotspots[1:(h_i-1),]


# Plot 2kb windows and recombination hotspots with a red circle
par(mfrow=c(1,1))
par(mar=c(6,4,4,2))
plot(meanRecRateWin[,1], meanRecRateWin[,3], type="s", ylim=c(0,3), xlab="Start position of window [bp]", 
     ylab="Recombination rate [1/bp]", main="Average recombination in overlapping windows, Scaffold N70", 
     sub=paste("step size:", stepSize, "bp, window size:", windowSize, "bp, flanking window:", flankingWinSize, "bp"))

for (i in 1:dim(concatenateHotspots)[1]) {
  lines(concatenateHotspots[i,1],concatenateHotspots[i,4], type="p", col="red")
}
legend("topleft", legend="Hotspots", col="red", pch=1)

