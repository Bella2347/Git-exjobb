# Calculates the mean numer of missing snps in linkage windows
# Command: [rec. rate] [linkage windows] [missing] [out file]


mean_in_win <- function(linkageWin, snps) {
  # Takes as input a window and the SNPs present on that scaffold
  # Finds all SNPs in that specific window and
  # returns the mean of missing genotypes [missing/SNPs]
  
  snpsInWin <- snps[as.numeric(snps[,1]) >= as.numeric(linkageWin[3]) & 
                    as.numeric(snps[,1]) <= as.numeric(linkageWin[4]),]
  
  if (length(snpsInWin) < 1) {                         # If there are no SNPs in that window, return NA
    meanMissing <- NA
  } else if (length(snpsInWin) == 2) {                 # If there are only one SNP
    meanMissing <- as.numeric(snpsInWin[2])
  } else {                                             # If there are more than one SNP, take the mean
    meanMissing <- mean(as.numeric(snpsInWin[,2]))
  }
  
  win <- c(linkageWin[2:4], meanMissing)
  
  return(win)
  
}


processFile <- function(filepath, linkageWins, pos, outfile) {
  # Reads in a line at a time from a file
  # Finds the mean missing genotypes [missing/SNP] for each linkage window for that scaffold
  # Append to file and process next line
  
  con <- file(filepath, "r")
  
  while ( TRUE ) {
    
    line = readLines(con, n = 1)
    
    if ( length(line) == 0 ) {
      break
    }
    
    missingGeno <- array(unlist(strsplit(line, " ")))
    
    # Extract windows on a specific scaffold (first element on line is the scaffold name)
    linkageScaff <- linkageWins[linkageWins[,2] == missingGeno[1],]
    
    
    # Take only the positions on the same scaffold as the line
    posScaff <- pos[pos[,1] == missingGeno[1],]
    
    if (length(posScaff) > 0) {
      # If zero, go to next line since no recombination were estimated for this scaffold
    
      # Take only the position of all SNPs on that scaffold, 
      # account for the situation when there is only one SNP-pair on the scaffold
      if (length(posScaff) > 4) {
        posSNP <- array(c(posScaff[1,2], posScaff[,3]))
      } else {
        posSNP <- array(c(posScaff[2], posScaff[3]))
      }
    
      # Put together the posistions and missing genotypes, will always have at least the length 2
      snpsInScaff <- cbind(posSNP, missingGeno[2:length(missingGeno)])
    
    
      # For each window find the mean
      # If there are only one linkage window, apply does not work
      if (length(linkageScaff) > 5) {
        missingWin <- as.matrix(apply(linkageScaff, 1, mean_in_win, snps = snpsInScaff))
      } else {
        missingWin <- mean_in_win(linkageScaff, snps = snpsInScaff)
      }
      
      missingWin <- t(missingWin)
      # Append to file
      write.table(missingWin, outfile, sep = "\t", append = TRUE, quote = FALSE, 
                  col.names = FALSE, row.names = FALSE)
    }
  }
  
  close(con)
}

argv <- commandArgs(trailingOnly = TRUE)

recRate <- as.matrix(read.table(argv[1], sep = "\t", header = FALSE))
linkageMapWin <- as.matrix(read.table(argv[2], sep = "\t", header = TRUE))


processFile(argv[3], linkageMapWin, recRate, argv[4])

