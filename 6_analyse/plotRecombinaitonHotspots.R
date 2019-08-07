#########################################################################
############ Plot recombination rate in windows and hotspots ############
#########################################################################

############################ Input parameters ###########################

# meanRecRateWin       from meanRecombinationRateInWindows.R
# stepSize             from meanRecombinationRateInWindows.R
# windowSize           from meanRecombinationRateInWindows.R
# flankingWinSize      from meanRecombinationRateInWindows.R
# concatenatedHotspots from hotspotsFromWindows.R

########################### Output parameters ###########################
############################ Other parameters ###########################
# i
#########################################################################
#########################################################################

par(mfrow=c(1,1))
par(mar=c(6,4,4,2))
plot(meanRecRateWin[,1], meanRecRateWin[,3], type="s", ylim=c(0,3), xlab="Start position of window [bp]", 
     ylab="Recombination rate [1/bp]", main="Average recombination in overlapping windows, Scaffold N70", 
     sub=paste("step size:", stepSize, "bp, window size:", windowSize, "bp, flanking window:", flankingWinSize, "bp"))

for (i in 1:dim(concatenatedHotspots)[1]) {
  lines(concatenatedHotspots[i,1],concatenatedHotspots[i,4], type="p", col="red")
}
legend("topleft", legend="Hotspots", col="red", pch=1)
