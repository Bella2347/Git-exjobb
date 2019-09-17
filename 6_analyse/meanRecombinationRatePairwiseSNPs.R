########### INPUT ###############
args <- commandArgs(trailingOnly = TRUE)
recFilename <- args[1]    # Read in recombination rate-file
recTimes <- 10            # The threshold for the recombination rate in hotspots
limitSnpDensity <- 1      # The minimum SNP density in hotspot regions
flankingWinSize <- 100000 # The total length of the flanking region
minHotspotsLen <- 750
outFilename <- args[2]    # File to write output to

########### Read in file ################
# Read in the recombination rate
recRate <- read.table(recFilename, sep=" ", skip=2, header=FALSE)

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
for (i in 1:(dim(recRate)[1])) {
  snpPerBase[recRate[i,1]] <- 1
}

# The last SNP, since it is not in column 1
snpPerBase[recRate[dim(recRate)[1],2]] <- 1



# Initiate a dataframe to store the detected hotspots
potentialHotspots <- data.frame(array(NA, c(dim(recRate)[1],5)))
colnames(potentialHotspots) <- c("Start position", "End position", "Mean recombination rate [1/bp]", 
                                 "Mean recombination rate in flanking region [1/bp]", "SNP density in flanking region [SNP/1kb]")
# To know which row to write results to
ph_i <- 1

# Step through each line in the recombination rate
for (i in 1:dim(recRate)[1]) {

  # Save the middle point between two SNPs
  windowMiddle_i <- (recRate[i,2]-recRate[i,1])/2+recRate[i,1]
  # Find the end and start of the flanking region
  flankingWinStart_i <- windowMiddle_i-flankingWinSize/2
  flankingWinEnd_i <- windowMiddle_i+flankingWinSize/2
  
  # If the start of the window is before the first recombination rate value just sum from the first value
  if (flankingWinStart_i < recRate[1,1]) {
    meanRecRateFlankingWin <- mean(recRatePerBase[recRate[1,1]:flankingWinEnd_i])
    snpDensity <- mean(snpPerBase[recRate[1,1]:flankingWinEnd_i])*1000
  
  # If the end of the window exceds the last recombination rate value use the sum up to the end
  } else if (flankingWinEnd_i > dim(recRatePerBase)[1]) {
    meanRecRateFlankingWin <- mean(recRatePerBase[flankingWinStart_i:dim(recRatePerBase)[1]])
    snpDensity <- mean(snpPerBase[flankingWinStart_i:dim(recRatePerBase)[1]])*1000
  
  } else {
    meanRecRateFlankingWin <- mean(recRatePerBase[flankingWinStart_i:flankingWinEnd_i])
    snpDensity <- mean(snpPerBase[flankingWinStart_i:flankingWinEnd_i])*1000
  }
  
  # If the recombination rate between thoose SNPs is at least a certain times higher than the average save it as a potential hotspot
  if (recRate[i,3] >= (meanRecRateFlankingWin*recTimes) && snpDensity >= limitSnpDensity) {
    potentialHotspots[ph_i,] <- c(recRate[i,1:3], meanRecRateFlankingWin, snpDensity)
    ph_i <- ph_i + 1
  }
}

# Remove empty rows
potentialHotspots <- potentialHotspots[1:(ph_i-1),]



# Dataframe for the total length of hotspots
hotspots <- data.frame(array(NA, c(dim(potentialHotspots)[1],3)))
colnames(hotspots) <- c("Start position", "End position", "Hotspot length")
h_i <- 1

# Go through the potential hotspots, find if some hotspots overlap, count the number of overlapping hotspots and save the total length if it is more than 750 bp
i <- 1
while (i < dim(potentialHotspots)[1]) {
  n <- 0
  while (potentialHotspots[(i+n),2] == potentialHotspots[(i+n+1),1]) {
    n <- n + 1
  }
  hotspotLength <- (potentialHotspots[(i+n),2] - potentialHotspots[i,1])
  
  if (hotspotLength >= minHotspotsLen) {
    hotspots[h_i,] <- c(potentialHotspots[i,1], potentialHotspots[(i+n),2], (potentialHotspots[(i+n),2] - potentialHotspots[i,1]))
    h_i <- h_i + 1
  }
  i <- i + n + 1
}

# Remove empty rows
hotspots <- hotspots[1:(h_i-1),]

