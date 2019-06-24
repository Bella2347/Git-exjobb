library(vcfR)

parva_n00001 <- read.vcfR("parva_subset_n00001.vcf")

parva_n00001_dp <- extract.gt(parva_n00001, element="DP", as.numeric=TRUE)
parva_n00001_dp_df <- as.data.frame(parva_n00001_dp)
c(n,m) <- dim(parva_n00001_dp_df)


parva_n00001_gt <- extract.gt(parva_n00001, element="GT", as.numeric=FALSE)
parva_n00001_gt[is.na(parva_n00001_gt)] <- FALSE
parva_n00001_gt[parva_n00001_gt != FALSE] <- TRUE
parva_n00001_logi <- as.logical(parva_n00001_gt)
parva_n00001_logi <- data.frame(matrix(parva_n00001_logi, nrow=n, ncol=m))
colnames(parva_n00001_logi) <- colnames(parva_n00001_dp_df)
row.names(parva_n00001_logi) <- row.names(parva_n00001_dp_df)

parva_n00001_dp_df[!parva_n00001_logi] <- ""
parva_n00001_dp_df[] <- lapply(parva_n00001_dp_df, as.numeric)

png("parva_dp.png")
boxplot(parva_n00001_dp_df, use.cols=TRUE)
dev.off()
