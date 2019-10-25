options(scipen = 20)


# Make a histogram over the permutation test to confirm the expected number of overlapping hotspots by chance
perTest <- read.table("hotspots/nrOverlappingRandomHotpsots.txt", header = FALSE)

pdf("perTestRandomHotspots.pdf", width = 6, height = 4)
par(mar=c(4,4,3,2), pty="m")
hist(perTest[,1], xlab = "", ylab = "", breaks = 20, xlim = c(10, 180), 
     main = "Permutation test")
axis(1, at=seq(10,180,10))
title(xlab = "Number of overlapping", ylab = "Frequency", line = 2.5)
abline(v = 175, col = "red")
abline(v = 176, col = "blue")
legend("top", legend = c("Red-breasted", "Taiga"), 
       pch = c("|", "|"), col = c("red", "blue"))
dev.off()

# p-value
#0.001
perTestSorted <- sort(perTest[,1])
perLow <- perTestSorted[50]
perHi <- perTestSorted[950]
# Conf. interval
#23-40
# Mean
mean(perTestSorted)
# 31.028

# Plot how the window size effect the detection of hotspots
windowEffect <- data.frame(matrix(c(10,20,30,40,50,100,150,200,250,300,350,400,
                                    0,5,7,8,7,10,10,11,11,12,11,11,3,24,41,56,55,68,72,77,75,74,77,77), ncol = 3 ))
windowEffect[,2] <- windowEffect[,2]/max(windowEffect[,2])
windowEffect[,3] <- windowEffect[,3]/max(windowEffect[,3])

pdf("hotspotsAsFunctionOfWinSize.pdf", width = 6, height = 4)
par(mar=(c(4,4,3,2)))
par(pty="m")
plot(windowEffect[,1], windowEffect[,2], type = "l", main = "Hotspot detection",
     xlab = "", ylab = "")
title(xlab = "Window size [bp]", ylab = "Relative number of hotspots", line = 2)
lines(windowEffect[,1], windowEffect[,3], type = "l", col = "blue")
legend("bottomright", legend = c("Scaffold N00100", "Scaffold N00001"), pch = c(151, 151), col = c("black", "blue"))
dev.off()


# Scatterplot linkage map vs parva vs taiga
# Scatterplot residuals
source("linkageMap.R")


# Table correlation, partial correlation, p-value...

# Plot chromosome length and rate
# Done, meanScaffRate.R


# SNP surrounding
inboth_phpl <- read.table("hotspots/inboth.parHotParRate.txt")
inboth_thtl <- read.table("hotspots/inboth.tagHotTagRate.txt")
unique_thtl <- read.table("hotspots/unique.tagHotTagRate.txt")
unique_thpl <- read.table("hotspots/unique.tagHotParRate.txt")
unique_phpl <- read.table("hotspots/unique.parHotParRate.txt")
unique_phtl <- read.table("hotspots/unique.parHotTagRate.txt")

pdf("surrhotspots.pdf", width = 8, height = 3.2)
par(mar=c(0,1.5,2,1), mfrow = c(1,3), pty="s", oma = c(2,2,0,0))

plot(-20000:20000, inboth_phpl[,1], type = "l", ylab = "", xlab = "", 
     xlim = c(-20000, 20000), main = "a.", ylim = c(0,17))
lines(-20000:20000, inboth_thtl[,1], col = "blue", type = "l")
legend("topleft", legend = c("Red-breasted", "Taiga"), pch = c(151, 151), col = c("black", "blue"))

plot(-20000:20000, unique_phpl[,1], type = "l", ylab = "", xlab = "", 
     xlim = c(-20000, 20000), main = "b.", ylim = c(0,17))
lines(-20000:20000, unique_phtl[,1], col = "blue", type = "l")
legend("topleft", legend = c("Red-breasted", "Taiga"), pch = c(151, 151), col = c("black", "blue"))

plot(-20000:20000, unique_thtl[,1], type = "l", ylab = "", xlab = "", 
     xlim = c(-20000, 20000), main = "c.", ylim = c(0,17), col = "blue")
lines(-20000:20000, unique_thpl[,1], type = "l")
legend("topleft", legend = c("Red-breasted", "Taiga"), pch = c(151, 151), col = c("black", "blue"))

title(xlab = "Physical distance [bp]", ylab = "Relative LD recombination rate", outer = TRUE, line = 1)
dev.off()



# Re-phasing
# Table correlation SNP pairs, windows

# Hotspots shared between phases
# Plot placing of hotspots (to see if they are related or random)

# Scatterplots SNP pairs
# Scatterplots windows
source("rePhasing.R")

# Hotspots length
hotspots1 <- read.table("hotspots/parvaGQ30.hotspots.autosomes.txt", sep = "\t", header = FALSE)
hotspots2 <- read.table("hotspots/taigaGQ30.hotspots.autosomes.txt", sep = "\t", header = FALSE)

mean(hotspots1[,4])
#1570.274

mean(hotspots2[,4])
#1589.051


# Scatterplot missing vs variance (all)
# Missing vs variance (no impute)
# Missing vs varaince (phase1)
# Missing vs varaince (phase2)

parMissing <- read.table("parvaMeanMissingWin.autosomes.txt", sep = "\t", header = FALSE)
tagMissing <- read.table("taigaMeanMissingWin.autosomes.txt", sep = "\t", header = FALSE)
parLinkWin <- read.table("parvaGQ30.meanRecRate.linkageWin.autosomes.txt", sep = "\t", header = TRUE)
tagLinkWin <- read.table("taigaGQ30.meanRecRate.linkageWin.autosomes.txt", sep = "\t", header = TRUE)

par <- merge(parLinkWin[,c(2,3,4,7)], parMissing, by = c(1,2,3))
tag <- merge(tagLinkWin[,c(2,3,4,7)], tagMissing, by = c(1,2,3))

par <- na.omit(par)
tag <- na.omit(tag)

plot(par[,4], par[,5], xlab = "Variance", ylab = "Mean missing genotypes/SNP")
plot(tag[,4], tag[,5], xlab = "Variance", ylab = "Mean missing genotypes/SNP")

cor(par[,4], par[,5])
# 0.3615064
cor(tag[,4], tag[,5])
# 0.3023479


parLink1 <- read.table("re-phase/LinkWin/parvaGQ30.phase1.meanLinkWin.N100.txt", sep = "\t", skip = 1)
parLink2 <- read.table("re-phase/LinkWin/parva.phase2.meanRecRate.linkWin.N100.txt", sep = "\t", header = FALSE)
parLink2noIm <- read.table("re-phase/LinkWin/parva.notIm.phase2.meanRecRate.linkWin.N100.txt", sep = "\t", header = FALSE)
parMissing1 <- read.table("re-phase/LinkWin/parvaGQ30.meanMissing.N100.txt", sep = "\t", header = FALSE)

parLink <- merge(parLink1[,c(3,4,7)], parLink2[,c(3,4,7)], by = c(1,2))
parLink <- merge(parLink, parLink2noIm[,c(3,4,7)], by = c(1,2))
parLink <- merge(parLink, parMissing1[,2:4], by = c(1,2))

par(mfrow=c(1,3))
plot(parLink[,6], parLink[,3])
plot(parLink[,6], parLink[,4])
plot(parLink[,6], parLink[,5])

cor(parLink[,6], parLink[,3])
# 0.9469868
cor(parLink[,6], parLink[,4])
# 0.7952307
cor(parLink[,6], parLink[,5])
# 0.8212434

# Table of correlation with missing vs variance
