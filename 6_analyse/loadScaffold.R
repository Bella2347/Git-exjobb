# Load scaffold

# read.table ...
# N70_rec
# N70_snp_pos

lengthOfScaffold <- 4386343

N70_recRatePerBase <- array(NA, lengthOfScaffold)

for (i in 1:(dim(N70_snp_pos)[1]-1)) {
  N70_recRatePerBase[N70_snp_pos[i,]:N70_snp_pos[(i+1),]] <- N70_rec[i,3]
}