# missensePos

# snpPos <- c(recRate[,1], recRate[dim(recRate)[1],2])

par(mfrow=c(1,1))
par(mar = c(5,5,2,5))

plot(density(snpPos), main="Density plot over SNPs and missense mutations", xlab="Position on scaffold N70 [bp]",
     ylim=c(0,0.00000040), xlim=c(0,lengthOfScaffold))
par(new=T)
plot(density(missensePos[,1]), xlab=NA, ylab=NA, main=NA, axes=F, col="red", ylim=c(0,0.00000090), xlim=c(0,lengthOfScaffold))
axis(side=4)
mtext(side=4, line=3, "Density")
legend("topleft", legend=c("SNP density", "Missense mutations density"), lty=c(1,1), col=c("black","red"))

rug(missensePos[,1], col="red", side=1)
