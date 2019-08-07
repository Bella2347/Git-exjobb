#########################################################################
####################### Read in recombination rate ######################
#########################################################################

############################ Input parameters ###########################

recFilename <- "parva_N00070_out.txt"
lengthOfScaffold <- 4386343

########################### Output parameters ###########################
# recRate:        The recombination for SNP pairs
# recRatePerBase: The recombination for each base
# snpPerBase:     Binary array, if the base is (1) a SNP or not (0)
############################ Other parameters ###########################
# i
#########################################################################
#########################################################################

# Read in the recombination rate
recRate <- read.table(recFilename, sep=" ", skip=2, header=FALSE)
colnames(recRate) <- c("left_snp", "right_snp", "mean", "p0.025", "p0.500", "p0.098")

# The file is indexed from 0, add one to each position to change the indexing to 1
recRate[,1:2] <- recRate[,1:2]+1

# Create an array with the length of the scaffold to store the recombination rate per base
recRatePerBase <- array(NA, lengthOfScaffold)

# For each base write the recombination rate
for (i in 1:(dim(recRate)[1]-1)) {
  recRatePerBase[recRate[i,1]:recRate[i,2]] <- recRate[i,3]
}


# Create an array with the length of the scaffold to store if the base is (1) a SNP or not (0)
snpPerBase <- numeric(lengthOfScaffold)

# For each base write the recombination rate
for (i in 1:(dim(recRate)[1])) {
  snpPerBase[recRate[i,1]] <- 1
}

# The last SNP, since it is not in column 1
snpPerBase[recRate[dim(recRate)[1],2]] <- 1
