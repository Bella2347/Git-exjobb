#########################################################################
################## Recombination rate at random windows #################
#########################################################################

############################ Input parameters ###########################

# recFirst_i           from meanRecombinationRateInWindows.R
# recLast_i            from meanRecombinationRateInWindows.R
# concatenatedHotspots from hotspotsFromWindows.R
winSizeForRecRateSurr <- 20000  # The size of the window when comparring surroundings of hotspots
nrLoops <- 10

########################### Output parameters ###########################
# recRateSurrRandomWin:     The relative recombination rate surrounding each random region
# meanRecRateSurrRandomWin: The mean relative recombination rate over all random regions
############################ Other parameters ###########################
# regionMiddle:    The middle of the random region
# i
# startSurr_i:     The start of the surrounding
# endSurr_i:       The end of the surrounding
# meanRecRateSurr: The mean recombination rate surrounding the i:th hotspot
# j
#########################################################################
#########################################################################

# Dataframe to store the suroundings
recRateSurrRandomWin <- data.frame(array(NA, c(winSizeForRecRateSurr*2+1, dim(concatenatedHotspots)[1])))
meanRecRateSurrRandomWin <- data.frame(array(NA, c(winSizeForRecRateSurr*2+1, nrLoops)))

for (j in 1:nrLoops) {
  for (i in 1:dim(concatenatedHotspots)[1]) {
    regionMiddle <- sample((recFirst_i+winSizeForRecRateSurr):(recLast_i-winSizeForRecRateSurr), 1)
    startSurr_i <- regionMiddle-winSizeForRecRateSurr
    endSurr_i <- regionMiddle+winSizeForRecRateSurr
    
    meanRecRateSurr <- mean(recRatePerBase[startSurr_i:endSurr_i], na.rm=TRUE)
    
    # For each base normalize the recombination rate by dividing by the mean recombintion rate
    recRateSurrRandomWin[,i] <- recRatePerBase[startSurr_i:endSurr_i]/meanRecRateSurr
  }
  
  meanRecRateSurrRandomWin[,j] <- rowMeans(recRateSurrRandomWin)
}

plot(c(-winSizeForRecRateSurr:winSizeForRecRateSurr), meanRecRateSurrRandomWin[,1], type="s",
     col=rgb(red=0,green=0,blue=0,alpha=0.2), ylim=c(0,27),
     xlab="Distance [bp]", ylab="Recombination rate relative to the mean",
     main="Relative recombination rate, scaffold N70",
     sub=paste("Recombination rate relative to the mean of", dim(concatenatedHotspots)[1], 
               "random 40kb regions,", nrLoops, "runs plotted."))

for (i in 2:dim(meanRecRateSurrRandomWin)[2]) {
  lines(c(-winSizeForRecRateSurr:winSizeForRecRateSurr), meanRecRateSurrRandomWin[,i], type="s",
        col=rgb(red=0,green=0,blue=0,alpha=0.2))
}

