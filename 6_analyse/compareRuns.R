missensePos <- read.table("parva_missense_pos_N00070.txt",header=FALSE)



recRate_snpSeq <- read.table("parva_N00070_out.txt", skip=2, header=FALSE, sep=" ")
recRate_fasta <- read.table("parva_N00070_out_fasta.txt", skip=2, header=FALSE, sep=" ")
recRate_fasta_v1.7_1 <- read.table("parva_N00070_out_1fasta_v1.7.txt", skip=2, header=FALSE, sep=" ")
recRate_fasta_v1.7_2 <- read.table("parva_N00070_out_2fasta_v1.7.txt", skip=2, header=FALSE, sep=" ")

par(mfrow=c(2,2))

plot(recRate_snpSeq[,1], recRate_snpSeq[,3], type="s", main="SNP seq", xlab="Position [bp]", 
     ylab="Recombination rate [1/bp]")

plot(recRate_fasta_v1.7_1[,1], recRate_fasta_v1.7_1[,3], type="s", main="Fasta, LDhelmet v1.7, run 1", xlab="Position [bp]", 
     ylab="Recombination rate [1/bp]")

plot(recRate_fasta[,1], recRate_fasta[,3], type="s", main="Fasta", xlab="Position [bp]", 
     ylab="Recombination rate [1/bp]")

plot(recRate_fasta_v1.7_2[,1], recRate_fasta_v1.7_2[,3], type="s", main="Fasta, LDhelmet v1.7, run 2", xlab="Position [bp]", 
     ylab="Recombination rate [1/bp]")

