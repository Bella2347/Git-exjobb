# Mean rec rate
# Läs in mean rate
parPhase1 <- read.table("re-phase/MeanRate/parvaGQ30.phase1.meanRecRate.N100.txt", sep = "\t", header = FALSE)
parPhase2 <- read.table("re-phase/MeanRate/parvaGQ30.phase2.meanRecRate.txt", sep = "\t", header = FALSE)
parPhase2noIm <- read.table("re-phase/MeanRate/parvaGQ30.notIm.phase2.meanRecRate.txt", sep = "\t", header = FALSE)

tagPhase1 <- read.table("re-phase/MeanRate/taigaGQ30.phase1.meanRecRate.N100.txt", sep = "\t", header = FALSE)
tagPhase2 <- read.table("re-phase/MeanRate/taigaGQ30.phase2.meanRecRate.txt", sep = "\t", header = FALSE)
tagPhase2noIm <- read.table("re-phase/MeanRate/taigaGQ30.notIm.phase2.meanRecRate.txt", sep = "\t", header = FALSE)

tagPhase <- merge(tagPhase1[,2:4], tagPhase2[,2:4], by = c(1,2))
tagPhase <- merge(tagPhase, tagPhase2noIm[,2:4], by = c(1,2))

parPhase <- merge(parPhase1[,2:4], parPhase2[,2:4], by = c(1,2))
parPhase <- merge(parPhase, parPhase2noIm[,2:4], by = c(1,2))

options(scipen = 50)

# Plotta de mot varandra
pdf("rePhaseScatt.pdf", width = 8, height = 7)
par(mar=c(4,4,3,0.5), mfrow = c(2,3), pty="s", oma = c(0,0,0,0))

plot(parPhase[,3], parPhase[,4], xlab = "", ylab = "", main = "a.", asp = 1, ylim = c(0,9), xlim = c(0,9))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 1 with imputation [1/bp]", ylab = "Phasing 2 with imputation [1/bp]", line = 2.5)

plot(parPhase[,3], parPhase[,5], xlab = "", ylab = "", main = "b.", asp = 1, ylim = c(0,13), xlim = c(0,13))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 1 with imputation [1/bp]", ylab = "Phasing 3 without imputation [1/bp]", line = 2.5)

plot(parPhase[,4], parPhase[,5], xlab = "", ylab = "", main = "c.", asp = 1, ylim = c(0,13), xlim = c(0,13))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 2 with imputation [1/bp]", ylab = "Phasing 3 without imputation [1/bp]", line = 2.5)

plot(tagPhase[,3], tagPhase[,4], xlab = "", ylab = "", main = "d.", asp = 1, ylim = c(0,13), xlim = c(0,13))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 1 with imputation [1/bp]", ylab = "Phasing 2 with imputation [1/bp]", line = 2.5)

plot(tagPhase[,3], tagPhase[,5], xlab = "", ylab = "", main = "e.", asp = 1, ylim = c(0,13), xlim = c(0,13))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 1 with imputation [1/bp]", ylab = "Phasing 3 without imputation [1/bp]", line = 2.5)

plot(tagPhase[,4], tagPhase[,5], xlab = "", ylab = "", main = "f.", asp = 1, ylim = c(0,12), xlim = c(0,12))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 2 with imputation [1/bp]", ylab = "Phasing 3 without imputation [1/bp]", line = 2.5)
dev.off()


# Beräkna korrelationen mellan ratsen
cor.test(parPhase[,3], parPhase[,4])
#Pearson's product-moment correlation
#data:  parPhase[, 3] and parPhase[, 4]
#t = 85.008, df = 50197, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.3470748 0.3623689
#sample estimates:
#cor 0.3547456

cor.test(parPhase[,3], parPhase[,5])
#Pearson's product-moment correlation
#data:  parPhase[, 3] and parPhase[, 5]
#t = 69.742, df = 50197, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.2892184 0.3051688
#sample estimates:
#cor 0.2972143

cor.test(parPhase[,4], parPhase[,5])
#Pearson's product-moment correlation
#data:  parPhase[, 4] and parPhase[, 5]
#t = 228.93, df = 50197, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.7103850 0.7189445
#sample estimates:
#cor 0.7146915


cor.test(tagPhase[,3], tagPhase[,4])
#Pearson's product-moment correlation
#data:  tagPhase[, 3] and tagPhase[, 4]
#t = 261.64, df = 80993, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.6730408 0.6805057
#sample estimates:
#cor 0.6767907

cor.test(tagPhase[,3], tagPhase[,5])
#Pearson's product-moment correlation
#data:  tagPhase[, 3] and tagPhase[, 5]
#t = 190.7, df = 80993, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.5518871 0.5613929
#sample estimates:
#cor 0.5566582

cor.test(tagPhase[,4], tagPhase[,5])
#Pearson's product-moment correlation
#data:  tagPhase[, 4] and tagPhase[, 5]
#t = 342.34, df = 80993, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.7661548 0.7717837
#sample estimates:
#cor 0.7689841


parLink1 <- read.table("re-phase/LinkWin/parvaGQ30.phase1.meanLinkWin.N100.txt", sep = "\t", skip = 1)
parLink2 <- read.table("re-phase/LinkWin/parva.phase2.meanRecRate.linkWin.N100.txt", sep = "\t", header = FALSE)
parLink2noIm <- read.table("re-phase/LinkWin/parva.notIm.phase2.meanRecRate.linkWin.N100.txt", sep = "\t", header = FALSE)

parLink <- merge(parLink1[,c(3,4,6)], parLink2[,c(3,4,6)], by = c(1,2))
parLink <- merge(parLink, parLink2noIm[,c(3,4,6)], by = c(1,2))

pdf("rePhaseScattLinkParva.pdf", width = 8, height = 3.2)
par(mar=c(4,4,3,0.5), mfrow = c(1,3), pty="s", oma = c(0,0,0,0))

plot(parLink[,3], parLink[,4], xlab = "", ylab = "", main = "a.", asp = 1, ylim = c(0,0.35), xlim = c(0,0.35))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 1 with imputation [1/bp]", ylab = "Phasing 2 with imputation [1/bp]", line = 2.5)

plot(parLink[,3], parLink[,5], xlab = "", ylab = "", main = "b.", asp = 1, ylim = c(0,0.18), xlim = c(0,0.18))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 1 with imputation [1/bp]", ylab = "Phasing 3 without imputation [1/bp]", line = 2.5)

plot(parLink[,4], parLink[,5], xlab = "", ylab = "", main = "c.", asp = 1, ylim = c(0,0.35), xlim = c(0,0.35))
abline(coef = c(0,1), lty = 2)
title(xlab = "Phasing 2 with imputation [1/bp]", ylab = "Phasing 3 without imputation [1/bp]", line = 2.5)
dev.off()


# Beräkna korrelationen mellan ratsen
cor.test(parLink[,3], parLink[,4])
#Pearson's product-moment correlation
#data:  parLink[, 3] and parLink[, 4]
#t = 13.682, df = 14, p-value = 0.000000001708
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.8984804 0.9879158
#sample estimates:
#cor 0.9645797

cor.test(parLink[,3], parLink[,5])
#Pearson's product-moment correlation
#data:  parLink[, 3] and parLink[, 5]
#t = 13.711, df = 14, p-value = 0.000000001661
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.8988733 0.9879647
#sample estimates:
#cor 0.9647216

cor.test(parLink[,4], parLink[,5])
#Pearson's product-moment correlation
#data:  parLink[, 4] and parLink[, 5]
#t = 11.668, df = 14, p-value = 0.0000000134
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.8646914 0.9836372
#sample estimates:
#cor 0.9522372





