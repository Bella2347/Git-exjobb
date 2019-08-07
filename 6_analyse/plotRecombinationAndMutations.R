# Plot the recombination rate and the density of missense SNPs

par(mar = c(5,5,2,5));
plot(N70_rec[,1],N70_rec[,3], type="s", ylab="Recombination rate [1/bp]", xlim=c(0,4386342), main="Recombination rate and missense SNP density", xlab="Position [bp]");
par(new=T);
plot(density(N70_missense_pos), axes=F, ylab=NA, xlab=NA, main=NA, col="red");axis(side=4);mtext(side=4, line=3, "Missense SNP density");
legend("topright", legend=c("Recombination rate", "Missense SNP density"), lty=c(1,1), col=c("black","red"))

