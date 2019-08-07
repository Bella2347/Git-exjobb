# Plot 2kb average in two plots without overlap
par(mfrow=c(2,1))
options(scipen = 5)
plot(meanRecRateWin[seq(1,dim(meanRecRateWin)[1],2),1], meanRecRateWin[seq(1,dim(meanRecRateWin)[1],2),3], type="s", 
       ylim=c(0,3), xlab="Start position of odd window numbers [bp]", ylab="Recombination rate [1/bp]", 
       main="Average recombination in 2kb windows, Scaffold N70")
plot(meanRecRateWin[seq(2,dim(meanRecRateWin)[1],2),1], meanRecRateWin[seq(2,dim(meanRecRateWin)[1],2),3], type="s", 
       ylim=c(0,3), xlab="Start position of even window numbers [bp]", ylab="Recombination rate [1/bp]", 
       main="Average recombination in 2kb windows, Scaffold N70")

# Plot 2kb windows, odd in black and even in blue and plot recombination hotspots with a red circle
par(mfrow=c(1,1))
par(mar=c(6,4,4,2))
plot(meanRecRateWin[,1], meanRecRateWin[,3], type="s", ylim=c(0,3), xlab="Start position of window [bp]", 
     ylab="Recombination rate [1/bp]", main="Average recombination in overlapping windows, Scaffold N70", 
     sub=paste("step size:", stepSize, "bp, window size:", windowSize, "bp, flanking window:", flankingWinSize, "bp"))

for (i in 1:dim(hotspots)[1]) {
  lines(hotspots[i,1],hotspots[i,3], type="p", col="red")
}
legend("topleft", legend="Hotspots", col="red", pch=1)



#######################################################################
############## Variables not longer up to date ########################
#######################################################################

# Plot recombination rate and remove potential hotspots and then add hotspots in red
plot(N70_rec[,1],N70_rec[,3], type="s", ylab="Recombination rate [1/bp]", xlim=c(0,4386342), main="Recombination rate and Hotspots", xlab="Position [bp]");

for (i in 1:dim(hotspots)[1]) {
  lines(c(hotspots[i,1]:hotspots[i,2]),N70_rec_all_bases[hotspots[i,1]:hotspots[i,2]], type="l", col="white")
}

for (i in 1:dim(hotspots_pos)[1]) {
  lines(c(hotspots_pos[i,1]:hotspots_pos[i,2]),N70_rec_all_bases[hotspots_pos[i,1]:hotspots_pos[i,2]], type="l", col="red")
}


########################################################################

# Plot the recombination rate and the start and end of recombination hotspots
options(scipen=5)
plot(recRate[,1],recRate[,3], type="s", ylab="Recombination rate [1/bp]", xlim=c(0,4386342), main="Recombination rate and Hotspots", xlab="Position [bp]");
lines(hotspots[,1],hotspots[,3], type="p", pch=20, col="blue");
lines(hotspots[,2],hotspots[,3], type="p", pch=20, col="red");

for (i in 1:dim(hotspots)[1]) {
  lines(c(hotspots[i,1]:hotspots[i,2]),recRatePerBase[hotspots[i,1]:hotspots[i,2]], type="l", col="red")
}


