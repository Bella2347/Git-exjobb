#########################################################################
################### Recombination rate at all hotspots ##################
#########################################################################

############################ Input parameters ###########################

# concatenatedHotspots from hotspotsFromWindows.R
winSizeForRecRateSurr <- 20000  # The size of the window when comparring surroundings of hotspots

########################### Output parameters ###########################
# recRateSurrHotspots:     The relative recombination rate surrounding each hotspot
# meanRecRateSurrHotspots: The mean relative recombination rate over all hotspots
############################ Other parameters ###########################
# hotspotMiddle:   The middle of the hotspot
# i
# startSurr_i:     The start of the surrounding
# endSurr_i:       The end of the surrounding
# meanRecRateSurr: The mean recombination rate surrounding the i:th hotspot
#########################################################################
#########################################################################

# Dataframe to store the suroundings
recRateSurrHotspots <- data.frame(array(NA, c(winSizeForRecRateSurr*2+1, dim(concatenatedHotspots)[1])))

for (i in 1:dim(concatenatedHotspots)[1]) {
  hotspotMiddle <- (concatenatedHotspots[i,3]/2+concatenatedHotspots[i,1])
  startSurr_i <- hotspotMiddle-winSizeForRecRateSurr
  endSurr_i <- hotspotMiddle+winSizeForRecRateSurr
  
  meanRecRateSurr <- mean(recRatePerBase[startSurr_i:endSurr_i], na.rm=TRUE)
  
  # For each base normalize the recombination rate by dividing by the mean recombintion rate
  recRateSurrHotspots[,i] <- recRatePerBase[startSurr_i:endSurr_i]/meanRecRateSurr
}

meanRecRateSurrHotspots <- rowMeans(recRateSurrHotspots)

plot(c(-winSizeForRecRateSurr:winSizeForRecRateSurr), meanRecRateSurrHotspots, type="s", 
     xlab="Distance form hotspot center [bp]", ylab="Recombination rate relative to the mean",
     main="Relative recombination rate at hotspots, scaffold N70")

