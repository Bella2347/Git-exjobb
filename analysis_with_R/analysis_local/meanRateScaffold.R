sum_SNP_pair <- function(pairSNP) {
  # Takes a pair of SNPs and calculates the rate/SNP pair
  # The value is dependen on the distance between the SNPs
  
  lengthSNP <- as.numeric(pairSNP[3]) - as.numeric(pairSNP[2])
  
  rateSum <- lengthSNP*as.numeric(pairSNP[4])
  
  return(rateSum)
}

mean_of_scaff <- function(scaffRate) {
  # Takes a scaffold and calculates the mean rate
  
  lengthScaff <- scaffRate[dim(scaffRate)[1],3] - scaffRate[1,2]
  meanScaff <- sum(apply(scaffRate, 1, sum_SNP_pair)) / lengthScaff
  
  return(meanScaff)
  
}


parRate <- read.table("parvaGQ30.meanRecRate.autosomes.txt", sep = "\t", header = FALSE)
tagRate <- read.table("taigaGQ30.meanRecRate.autosomes.txt", sep = "\t", header = FALSE)
scaffLengths <- read.table("../info_files/fAlb15.chrom.all.scaffs.txt", sep = "\t", header = FALSE)

parRateScaff <- split(parRate, f = parRate$V1)
tagRateScaff <- split(tagRate, f = tagRate$V1)

parMeanScaff <- sapply(parRateScaff, mean_of_scaff)
tagMeanScaff <- sapply(tagRateScaff, mean_of_scaff)



parScaffs <- merge(parMeanScaff, scaffLengths, by.x = 0, by.y = 2)
colnames(parScaffs) <- c("Scaff", "Mean_rate", "Chr", "Length", "Orientation")

tagScaffs <- merge(tagMeanScaff, scaffLengths, by.x = 0, by.y = 2)
colnames(tagScaffs) <- c("Scaff", "Mean_rate", "Chr", "Length", "Orientation")

write.table(parScaffs, "parvaMeanRateScaffolds.txt", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
write.table(tagScaffs, "taigaMeanRateScaffolds.txt", sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)

parScaffs <- read.table("parvaMeanRateScaffolds.txt", sep = "\t", header = TRUE)
tagScaffs <- read.table("taigaMeanRateScaffolds.txt", sep = "\t", header = TRUE)

parChr <- split(parScaffs, f = parScaffs$Chr)
tagChr <- split(tagScaffs, f = tagScaffs$Chr)


parMeanChr <- sapply(parChr, function(x) (mean(x$x)))
parMeanChrDf <- as.data.frame(parMeanChr)

tagMeanChr <- sapply(tagChr, function(x) (mean(x$x)))
tagMeanChrDf <- as.data.frame(tagMeanChr)

pdf("meanChr.pdf", width = 8, height = 5)
par(mar=c(4,2.5,2,0.5), mfrow = c(1,2), pty="m")
par(cex=0.8)
boxplot(parChr[[1]][,2], parChr[[11]][,2], parChr[[12]][,2],  parChr[[22]][,2], parChr[[23]][,2], 
        parChr[[24]][,2], parChr[[25]][,2], parChr[[26]][,2], parChr[[27]][,2], parChr[[28]][,2], 
        parChr[[29]][,2], parChr[[2]][,2], parChr[[3]][,2], parChr[[4]][,2], parChr[[5]][,2],
        parChr[[6]][,2], parChr[[7]][,2], parChr[[8]][,2], parChr[[9]][,2], parChr[[10]][,2],
        parChr[[13]][,2], parChr[[14]][,2], parChr[[15]][,2], parChr[[16]][,2], parChr[[17]][,2],
        parChr[[18]][,2], parChr[[19]][,2], parChr[[20]][,2], parChr[[21]][,2], parChr[[30]][,2], 
        parChr[[31]][,2], parChr[[32]][,2], parChr[[33]][,2], xaxt = "n", xlab = "",
        ylab = "Recombination rate [1/bp]", main = "a.")
par(cex=0.6)
axis(1, at=1:33, labels = row.names(parMeanChrDf)[c(1,11,12,22,23,24,25,26,27,28,29,2,3,4,5,6,7,8,
                                                    9,10,13,14,15,16,17,18,19,20,21,30,31,32,33)], las = 2)
par(cex=0.8)
boxplot(tagChr[[1]][,2], tagChr[[11]][,2], tagChr[[12]][,2],  tagChr[[22]][,2], tagChr[[23]][,2], 
        tagChr[[24]][,2], tagChr[[25]][,2], tagChr[[26]][,2], tagChr[[27]][,2], tagChr[[28]][,2], 
        tagChr[[29]][,2], tagChr[[2]][,2], tagChr[[3]][,2], tagChr[[4]][,2], tagChr[[5]][,2],
        tagChr[[6]][,2], tagChr[[7]][,2], tagChr[[8]][,2], tagChr[[9]][,2], tagChr[[10]][,2],
        tagChr[[13]][,2], tagChr[[14]][,2], tagChr[[15]][,2], tagChr[[16]][,2], tagChr[[17]][,2],
        tagChr[[18]][,2], tagChr[[19]][,2], tagChr[[20]][,2], tagChr[[21]][,2], tagChr[[30]][,2], 
        tagChr[[31]][,2], tagChr[[32]][,2], tagChr[[33]][,2], xaxt = "n", xlab = "",
        ylab = "Recombination rate [1/bp]", main = "b.")
par(cex=0.6)
axis(1, at=1:33, labels = row.names(tagMeanChrDf)[c(1,11,12,22,23,24,25,26,27,28,29,2,3,4,5,6,7,8,
                                                    9,10,13,14,15,16,17,18,19,20,21,30,31,32,33)], las = 2)
dev.off()



