parLinkWin <- as.matrix(read.table("parvaGQ30.meanRecRate.linkageWin.autosomes.txt", sep = "\t", header = TRUE))
tagLinkWin <- as.matrix(read.table("taigaGQ30.meanRecRate.linkageWin.autosomes.txt", sep = "\t", header = TRUE))

linkWin <- as.matrix(read.table("../info_files/Chr.Rec.200kb.5kGap.txt", sep = "\t", header = TRUE))
chrLength <- read.table("../info_files/chrom_lengths.txt", sep = "\t", header = TRUE)

parLink <- as.matrix(merge(parLinkWin[,c(1,2,3,4,6)], linkWin, by.x = c(1,2,3,4), by.y = c(1,2,3,4)))
tagLink <- as.matrix(merge(tagLinkWin[,c(1,2,3,4,6)], linkWin, by.x = c(1,2,3,4), by.y = c(1,2,3,4)))
parTag <- as.matrix(merge(parLinkWin[,c(1,2,3,4,6)], tagLinkWin[,c(1,2,3,4,6)], by.x = c(1,2,3,4), by.y = c(1,2,3,4)))

# Ta bort ofullständiga rader
parLink <- na.omit(parLink)
tagLink <- na.omit(tagLink)
parTag <- na.omit(parTag)


# pearson correlation coefficents
# Hitta korrelationen mellan linkage map och parva
cor.test(as.numeric(parLink[,5]), as.numeric(parLink[,6]))
#Pearson's product-moment correlation
#data:  as.numeric(parLink[, 5]) and as.numeric(parLink[, 6])
#t = 38.515, df = 4950, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.4584642 0.5013338
#sample estimates:
#cor 0.4801857

# Hitta korrelationen mellan linkage map och taiga
cor.test(as.numeric(tagLink[,5]), as.numeric(tagLink[,6]))
#Pearson's product-moment correlation
#data:  as.numeric(tagLink[, 5]) and as.numeric(tagLink[, 6])
#t = 38.915, df = 4951, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.4623518 0.5050138
#sample estimates:
#cor 0.4839703 

# Hitta korrelationen mellan taiga och parva
cor.test(as.numeric(parTag[,5]), as.numeric(parTag[,6]))
#Pearson's product-moment correlation
#data:  as.numeric(parTag[, 5]) and as.numeric(parTag[, 6])
#t = 65.173, df = 5020, p-value < 0.00000000000000022
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.6617304 0.6917046
#sample estimates:
#cor 0.6769981


options(scipen = 10)

pdf("linkWin.pdf", width = 8, height = 3)
par(mfrow = c(1,3), mar=c(4,4,3,0.5), pty="s")
plot(as.numeric(parLink[(as.numeric(parLink[,6]) < 50),5]), as.numeric(parLink[(as.numeric(parLink[,6]) < 50),6]), xlab = "", ylab = "", main = "a.")
title(xlab = "LD estimated rate [1/bp], Red-breasted", ylab = "Linkage map [cM/Mb]", line = 2.5)

plot(as.numeric(tagLink[(as.numeric(tagLink[,6]) < 50),5]), as.numeric(tagLink[(as.numeric(tagLink[,6]) < 50),6]), xlab = "", ylab = "", main = "b.")
title(xlab = "LD estimated rate [1/bp], Taiga", ylab = "Linkage map [cM/Mb]", line = 2.5)

plot(as.numeric(parTag[,5]), as.numeric(parTag[,6]), xlab = "", ylab = "", main = "c.")
title(xlab = "LD estimated rate [1/bp], Red-breasted", ylab = "LD estimated rate [1/bp], Taiga", line = 2.5)
dev.off()

parLink <- as.matrix(merge(parLink, chrLength, by.x = 1, by.y = 1))
tagLink <- as.matrix(merge(tagLink, chrLength, by.x = 1, by.y = 1))
parTag <- as.matrix(merge(parTag, chrLength, by.x = 1, by.y = 1))

# Partial correlation
regEstLenPar <- lm(parLink[,5]~parLink[,7])
resEstLenPar <- residuals(regEstLenPar)

regLinkLenPar <- lm(parLink[,6]~parLink[,7])
resLinkLenPar <- residuals(regLinkLenPar)


regEstLenTag <- lm(tagLink[,5]~tagLink[,7])
resEstLenTag <- residuals(regEstLenTag)

regLinkLenTag <- lm(tagLink[,6]~tagLink[,7])
resLinkLenTag <- residuals(regLinkLenTag)


regparLen <- lm(parTag[,5]~parTag[,7])
resparLen <- residuals(regparLen)

regtagLen <- lm(parTag[,6]~parTag[,7])
restagLen <- residuals(regtagLen)


pdf("residuals.pdf", width = 8, height = 3)
par(mfrow = c(1,3))
par(mar=(c(4,4,3,0.5)))
par(pty="s")

plot(resEstLenPar, resLinkLenPar, xlab = "", ylab = "", main = "a.")
title(xlab = "Residuals, red-breasted", ylab = "Residuals, linkage map", line = 2.5)

plot(resEstLenTag, resLinkLenTag, xlab = "", ylab = "", main = "b.")
title(xlab = "Residuals, taiga", ylab = "Residuals, linkage map", line = 2.5)

plot(resparLen, restagLen, xlab = "", ylab = "", main = "c.")
title(xlab = "Residuals, red-breasted", ylab = "Residuals, taiga", line = 2.5)

dev.off()


cor.test(resEstLenPar, resLinkLenPar)
#Pearson's product-moment correlation
#data:  resEstLenPar and resLinkLenPar
#t = 27.299, df = 4889, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.3391130 0.3877571
#sample estimates:
#cor 0.363683

cor.test(resEstLenTag, resLinkLenTag)
#Pearson's product-moment correlation
#data:  resEstLenTag and resLinkLenTag
#t = 38.619, df = 4890, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.4616701 0.5046263
#sample estimates:
#cor 0.4834392

cor.test(resparLen, restagLen)
#Pearson's product-moment correlation
#data:  resparLen and restagLen
#t = 46.736, df = 4960, p-value < 2.2e-16
#alternative hypothesis: true correlation is not equal to 0
#95 percent confidence interval:
#0.5333140 0.5719592
#sample estimates:
#cor0.5529339
