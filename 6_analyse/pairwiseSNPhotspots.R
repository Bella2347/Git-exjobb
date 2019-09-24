####### About ###############
# Takes as input:
# [out file] [estimated recombination rate file1] [file2] ...
# And finds hotspots for all files and output them to the same out file


####### Functions ###########

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


potential_hotspot <- function(SNPpair, windowSize, timesRecombinationRate, 
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
  # Checks if two hotspots overlap
  
  if (isTRUE(firstHotspot[2] == secondHotspot[1])) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

recombination_rate_each_base <- function(recombinationRate) {
  # Returns an array were each value represents one base and the recombination rate at that base
  
  recombinationRateArray <- array(NA, recombinationRate[dim(recombinationRate)[1],2])
  
  # For each base write the recombination rate
  for (i in 1:dim(recombinationRate)[1]) {
    recombinationRateArray[recombinationRate[i,1]:recombinationRate[i,2]] <- recombinationRate[i,3]
  }
  
  return(recombinationRateArray)
}

index_from_one <- function(recombinationRate) {
  # Increases the positions with one to make the indexing from 1
  
  positionsIndexedOne <- recombinationRate[,1:2]+1
  recombinationRateNewPos <- cbind(positionsIndexedOne, recombinationRate[,3])
  return(recombinationRateNewPos)
}

make_snp_array <- function(recombinationRate) {
  # Returns an array as long as the scaffold with a 1 representing a SNP
  
  snpArray <- numeric(recombinationRate[dim(recombinationRate)[1],2])
  
  snpArray[recombinationRate[,1]] <- 1
  snpArray[recombinationRate[dim(recombinationRate)[1],2]] <- 1
  
  return(snpArray)
}

concatenate_hotspots <- function(potentialHotspots, minimumHotspotLength) {
  # Checks if two hotspots overlap, if they do, they are joined
  
  # Dataframe for the total length of hotspots
  hotspots <- data.frame(array(NA, c(dim(potentialHotspots)[1],3)))
  colnames(hotspots) <- c("Start position", "End position", "Hotspot length")
  
  i <- 1
  while (i <= dim(potentialHotspots)[1]) {
    n <- i
    
    # As long as the hotspots overlap, check if next hotspot also overlap
    while (hotspots_overlap(potentialHotspots[n,], potentialHotspots[(n+1),])) {
      n <- n + 1
    }
    
    hotspotLength <- (potentialHotspots[n,2] - potentialHotspots[i,1])
    
    if (hotspotLength >= minimumHotspotLength) {
      hotspots[i,] <- c(potentialHotspots[i,1], potentialHotspots[n,2], hotspotLength)
    }
    i <- n + 1
  }
  
  hotspots <- na.omit(hotspots)
  
  return(hotspots)
}

stop_quietly <- function(...) {
  blankMsg <- sprintf("\r%s\r", paste(rep(" ", getOption("width")-1L), collapse=" "));
  stop(simpleError(blankMsg));
}

############# Main function ###############

main <- function(filename, recTimes, snpDensityLimit, flankingWinSize, minHotspotsLen, outFilename) {
  # Main function which finds hotspots and appends them to a file
  
  # Read file with estimated recombination rate
  recRate <- read.table(filename, sep=" ", skip=2, header=FALSE)
  
  # The file is indexed from 0, add one to each position to change the indexing to 1
  recRateIndexOne <- index_from_one(recRate)
  
  # Get an array with the recombination rate for each base
  recRatePerBase <- recombination_rate_each_base(recRateIndexOne)
  
  # Create an array with the length of the scaffold to store if the base is (1) a SNP or not (0)
  snpPerBase <- make_snp_array(recRateIndexOne)
  
  # Find potential hotspots
  potentialHotspots <- apply(recRateIndexOne, 1, potential_hotspot, windowSize = flankingWinSize, timesRecombinationRate = recTimes, 
                             minSNPdensity = snpDensityLimit, recombinationRateAllBases = recRatePerBase, SNParray = snpPerBase)
  
  
  # If potential hotspots were found, continue
  if (length(unlist(potentialHotspots)) > 0) {
    potentialHotspots <- as.data.frame(matrix(unlist(potentialHotspots), ncol = 5, byrow = TRUE))
    colnames(potentialHotspots) <- c("Start SNP", "End SNP", "Rec. rate", "Mean rec. rate in surrounding", "SNP density in surrounding")
    
    # Join hotspots that overlap
    hotspots <- concatenate_hotspots(potentialHotspots, minHotspotsLen)
    
    # If hotspots were found, write them to file
    if (dim(hotspots)[1] > 0) {
      hotspots <- cbind(filename, hotspots)
      write.table(hotspots, outFilename, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE)
    }
  }
}

########### Execution ################

# Read in input from command-line
argv <- commandArgs(trailingOnly = TRUE)

# Write header to outfile
outFile <- argv[1]
write("#Filename\tStart_pos\tEnd_post\tLength_of_hotspot", outFile)

# Find hotspots for each file
lapply(argv[2:length(argv)], main, recTimes = 10, snpDensityLimit = 1, flankingWinSize = 200000, minHotspotsLen = 750, outFilename = outFile)
