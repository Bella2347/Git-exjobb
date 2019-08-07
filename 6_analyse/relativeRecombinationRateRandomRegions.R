#########################################################################
################## Recombination rate at random windows #################
#########################################################################

############################ Input parameters ###########################

# recFirst_i           from meanRecombinationRateInWindows.R
# recLast_i            from meanRecombinationRateInWindows.R
# concatenatedHotspots from hotspotsFromWindows.R
winSizeForRecRateSurr <- 20000  # The size of the window when comparring surroundings of hotspots

########################### Output parameters ###########################
# recRateSurrRandomWin:     The relative recombination rate surrounding each random region
# meanRecRateSurrRandomWin: The mean relative recombination rate over all random regions
############################ Other parameters ###########################
# regionMiddle:    The middle of the random region
# i
# startSurr_i:     The start of the surrounding
# endSurr_i:       The end of the surrounding
# meanRecRateSurr: The mean recombination rate surrounding the i:th hotspot
#########################################################################
#########################################################################

# Dataframe to store the suroundings
recRateSurrRandomWin <- data.frame(array(NA, c(winSizeForRecRateSurr*2+1, dim(concatenatedHotspots)[1])))

for (i in 1:dim(concatenatedHotspots)[1]) {
  regionMiddle <- sample(recFirst_i:recLast_i, 1)
  startSurr_i <- regionMiddle-winSizeForRecRateSurr
  endSurr_i <- regionMiddle+winSizeForRecRateSurr
  
  meanRecRateSurr <- mean(recRatePerBase[startSurr_i:endSurr_i], na.rm=TRUE)
  
  # For each base normalize the recombination rate by dividing by the mean recombintion rate
  recRateSurrRandomWin[,i] <- recRatePerBase[startSurr_i:endSurr_i]/meanRecRateSurr
}

meanRecRateSurrRandomWin <- rowMeans(recRateSurrRandomWin)

plot(c(-winSizeForRecRateSurr:winSizeForRecRateSurr), meanRecRateSurrRandomWin, type="s", 
     xlab="Distance form region center [bp]", ylab="Recombination rate relative to the mean",
     main="Relative recombination rate at random 40kb regions, scaffold N70")

