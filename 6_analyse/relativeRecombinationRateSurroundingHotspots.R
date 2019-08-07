#########################################################################
################### Recombination rate at all hotspots ##################
#########################################################################

############################ Input parameters ###########################

recFirst_i
recLast_i
windowSize
winSizeForRecRateSurr <- 20000  # The size of the window when comparring surroundings of hotspots

########################### Output parameters ###########################
############################ Other parameters ###########################

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
     main="Recombination rate at hotspots, scaffold N70")

