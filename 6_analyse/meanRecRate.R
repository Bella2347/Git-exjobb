# Command-line argument:
# Rscript meanRecRate [Linkage-map_windows] [species] [scaffold_name] [recombination_rate_run1] [recombination_rate_run2] [run3] [run4] [run5]

winMean <- function(snpInfo, recombinationRatePerBase) {
  meanInWin <- mean(recombinationRatePerBase[snpInfo[3]:snpInfo[4]], na.rm = TRUE)
  return(meanInWin)
}

#####

argv <- commandArgs(trailingOnly = TRUE)

linkageMapWin <- read.table(argv[1], sep = "\t", header = TRUE)
species <- argv[2]
scaffoldName <- argv[3]
run1 <- read.table(argv[4], sep = " ", skip = 2, header = FALSE)
run2 <- read.table(argv[5], sep = " ", skip = 2, header = FALSE)
run3 <- read.table(argv[6], sep = " ", skip = 2, header = FALSE)
run4 <- read.table(argv[7], sep = " ", skip = 2, header = FALSE)
run5 <- read.table(argv[8], sep = " ", skip = 2, header = FALSE)

######
# linkageMapWin <- read.table("200kb-win/Chr.Rec.200kb.5kGap.txt", sep = "\t", header = TRUE)
# species <- "parva"
# scaffoldName <- "N00001"
# 
# run1filename <- "recRate/parvaGQ30.recRate.chr-N00001.txt"
# run2filename <- "recRate/parvaGQ30.recRate.chr-N00001.run2.txt"
# run3filename <- "recRate/parvaGQ30.recRate.chr-N00001.run3.txt"
# run4filename <- "recRate/parvaGQ30.recRate.chr-N00001.run4.txt"
# run5filename <- "recRate/parvaGQ30.recRate.chr-N00001.run5.txt"
# 
# run1 <- read.table(run1filename, sep=" ", skip=2, header = FALSE)
# run2 <- read.table(run2filename, sep=" ", skip=2, header = FALSE)
# run3 <- read.table(run3filename, sep=" ", skip=2, header = FALSE)
# run4 <- read.table(run4filename, sep=" ", skip=2, header = FALSE)
# run5 <- read.table(run5filename, sep=" ", skip=2, header = FALSE)
##########

# The file is indexed from 0, add one to each position to change the indexing to 1
run1[,1:2] <- run1[,1:2]+1
run2[,1:2] <- run2[,1:2]+1
run3[,1:2] <- run3[,1:2]+1
run4[,1:2] <- run4[,1:2]+1
run5[,1:2] <- run5[,1:2]+1

allRuns <- as.data.frame(cbind(run1[,3], run2[,3], run3[,3], run4[,3], run5[,3]))

recRate <- apply(allRuns, 1, mean)

recRate <- cbind(run1[,1:2], recRate)
colnames(recRate) <- c("Start SNP", "End SNP", "Mean rec. rate over all runs")

# Write mean rec. rate to file
write.table(recRate, paste(species, "GQ30meanRecRate.chr-", scaffoldName, ".txt", sep = ""), 
            append = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)


recRatePerBase <- array(NA, recRate[dim(recRate)[1],2])

# For each base write the recombination rate
for (i in 1:dim(recRate)[1]) {
  recRatePerBase[recRate[i,1]:recRate[i,2]] <- recRate[i,3]
}

linkMapWin <- linkageMapWin[linkageMapWin$scaf == scaffoldName,]

recRateMeanWin <- apply(linkMapWin, 1, winMean, recombinationRatePerBase = recRatePerBase)
recRateMeanWin <- cbind(linkMapWin[,3:4], unlist(recRateMeanWin))

write.table(recRateMeanWin, paste(species, "GQ30meanRecRateLinkageWin.chr-", scaffoldName, ".txt", sep = ""), 
            append = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
