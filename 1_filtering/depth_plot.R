library(vcfR)

vcf <- read.vcfR("../4_test_ind_depth_filter/parva_n00001_filtered.vcf")

dp <- extract.gt(vcf, element="DP", as.numeric=TRUE)
dp_df <- as.data.frame(dp)
n <- dim(dp_df)


gt <- extract.gt(vcf, element="GT", as.numeric=FALSE)
gt[is.na(gt)] <- FALSE
gt[gt != FALSE] <- TRUE
logi <- as.logical(gt)
logi <- data.frame(matrix(logi, nrow=n[1], ncol=n[2]))
#colnames(logi) <- colnames(dp_df)
#row.names(logi) <- row.names(dp_df)

dp_df[!logi] <- ""
dp_df[] <- lapply(dp_df, as.numeric)


png("parva_filtered_dp_n00001.png")
par(mar=c(9,4,1,4))
boxplot(dp_df, las=2)
title(main="Filtered variant depth for N00001 in Parva", ylab="DP")
dev.off()

