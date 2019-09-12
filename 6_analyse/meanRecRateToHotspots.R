#########################################################################
####################### Read in recombination rate ######################
#########################################################################

############################ Input parameters ###########################

recFilename <- "parva_N00070_out.txt"
lengthOfScaffold <- 4386343

########################### Output parameters ###########################
# recRate:        The recombination for SNP pairs
# recRatePerBase: The recombination for each base
# snpPerBase:     Binary array, if the base is (1) a SNP or not (0)
############################ Other parameters ###########################
# i
#########################################################################
#########################################################################

# Read in the recombination rate
recRate <- read.table(recFilename, sep=" ", skip=2, header=FALSE)
colnames(recRate) <- c("left_snp", "right_snp", "mean", "p0.025", "p0.500", "p0.098")

# The file is indexed from 0, add one to each position to change the indexing to 1
recRate[,1:2] <- recRate[,1:2]+1

# Create an array with the length of the scaffold to store the recombination rate per base
recRatePerBase <- array(NA, lengthOfScaffold)

# For each base write the recombination rate
for (i in 1:(dim(recRate)[1]-1)) {
  recRatePerBase[recRate[i,1]:recRate[i,2]] <- recRate[i,3]
}


# Create an array with the length of the scaffold to store if the base is (1) a SNP or not (0)
snpPerBase <- numeric(lengthOfScaffold)

# For each base write the recombination rate
for (i in 1:(dim(recRate)[1])) {
  snpPerBase[recRate[i,1]] <- 1
}

# The last SNP, since it is not in column 1
snpPerBase[recRate[dim(recRate)[1],2]] <- 1


#########################################################################
###### Average recombination rate in windows with overlapping steps #####
#########################################################################

############################ Input parameters ###########################

#recRatePerBase from loadScaffold.R
#snpPerBase     from loadScaffold.R
stepSize <- 1000          # The length of the steps
windowSize <- 2000        # The length of the window
flankingWinSize <- 100000 # The length of the flanking region

########################### Output parameters ###########################
# meanRecRateWin: the mean recombination rate per window
############################ Other parameters ###########################
# recNonNAindex: get the index of all bases that have an estimated recombination rate
# recFirst_i:    the first base with an estimated recombination rate
# recLast_i:     the last base with an estimated recombination rate
# r_i
# i
#########################################################################
#########################################################################

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


