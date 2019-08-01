# Make an array the same length as the scaffold and fill in the recombination rate for each base, bases in begining and en are NA
N70_rec_all_bases <- array(NA, 4386343)

for (i in 1:(dim(N70_snp_pos)[1]-1)) {
  N70_rec_all_bases[N70_snp_pos[i,]:N70_snp_pos[(i+1),]] <- N70_rec[i,3]
}


# Initiate a dataframe to store the detected hotspots
hotspots <- data.frame(array(NA, c(600,6)))
# To know which row to write results to
h_i <- 1


# Step through each line in the recombination rate
for (i in 1:dim(N70_rec)[1]) {

# Save the middle point between two SNPs, from that find the start of window 200 000 bp before and the end of the window 200 000 bp after
  middle_i <- (N70_rec[i,2]-N70_rec[i,1])/2
  start_i <- (N70_rec[i,1]+middle_i)-200000
  end_i <- (N70_rec[i,1]+middle_i)+200000
  
# If the start of the window is before the first recombination rate value just sum from the first value
  if (start_i < 18) {
    avg_rec <- sum(N70_rec_all_bases[18:end_i])/(end_i-18+1)
  } else if (end_i > 4381236) {
# If the end of the window exceds the last recombination rate value use the sum up to the end 
    avg_rec <- sum(N70_rec_all_bases[start_i:4381236])/(4381236-start_i+1)
  } else {
    avg_rec <- sum(N70_rec_all_bases[start_i:end_i])/(end_i-start_i+1)
  }
  
# If the recombination rate between thoose SNPs is at least 10 times higher than the average save it as a hotspot
  if (N70_rec[i,3] >= (avg_rec*10)) {
    hotspots[h_i,] <- (N70_rec[i,])
    h_i <- h_i + 1
  }
}


# Sort out hotspots at least 750 bp from start to end and the SNP density > 1 SNP/1kb
N70_snps_all_bases <- numeric(4386343)

for (i in 1:(dim(N70_snp_pos)[1]-1)) {
  N70_snps_all_bases[N70_snp_pos[i,]] <- 1
}

# Dataframe for the total length of hotspots
hotspots_pos <- data.frame(array(NA, c(24,4)))
hp_i <- 1

# Go through the potential hotspots, find if some hotspots overlap, count the number of overlapping hotspots and save the total length if it is more than 750 bp
i <- 1
while (i <= (dim(hotspots)[1]-1)) {
  n <- 0
  while (hotspots[(i+n),2] == hotspots[(i+n+1),1]) {
    n <- n + 1
  }
  hot_length <- (hotspots[(i+n),2] - hotspots[i,1])
  if (hot_length >= 750 && ((sum(N70_snps_all_bases[hotspots[i,1]:hotspots[(i+n),2]])/hot_length)*1000) >= 1) {
    hotspots_pos[hp_i,] <- c(hotspots[i,1], hotspots[(i+n),2], 1, (hotspots[(i+n),2] - hotspots[i,1]))
    hp_i <- hp_i + 1
  }
  i <- i + n + 1
}

# Plot the recombination rate and the start and end of recombination hotspots
plot(N70_rec[,1],N70_rec[,3], type="s", ylab="Recombination rate [1/bp]", xlim=c(0,4386342), main="Recombination rate and Hotspots", xlab="Position [bp]");
lines(hotspots_pos[,1],hotspots_pos[,3], type="p", pch=20, col="blue");
lines(hotspots_pos[,2],hotspots_pos[,3], type="p", pch=20, col="red");


# Analyse the mean recombination rate in the surounding 20 kb of hotspots
# Dataframe to store the suroundings
hotspots_20kb <- data.frame(array(NA, c(24,40000)))

# Find the middle of the hotspots and then save the recombination rate in a 40 kb window
for (i in 1:24) {
  middle_i <- hotspots_pos[i,1]+hotspots_pos[i,4]/2
  hotspots_20kb[i,] <- N70_rec_all_bases[(middle_i-20000):(middle_i+20000)]
}

# Calculate the mean from all hotspots
hotspots_mean_20kb <- colMeans(hotspots_20kb)
# X-axis
x <- -20000:19999
plot(x,hotspots_mean_20kb, type="l")

