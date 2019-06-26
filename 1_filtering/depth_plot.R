library(vcfR)

vcf <- read.vcfR("../4_test_ind_depth_filter/taiga_n00001_filtered.vcf")

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

png("taiga_filtered_dp_n00001.png", width=500, height=350, unit="px")
boxplot(dp_df, use.cols=TRUE, names=colnames(dp_df))
title(main="Filtered variant depth for N00001 in Taiga", ylab="DP", xlab="Samples")
dev.off()

