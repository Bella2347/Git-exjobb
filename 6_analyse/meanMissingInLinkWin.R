
mean_in_win <- function(linkageWin, snps) {
  # Takes as input a window and the SNPs present on that scaffold
  # Finds all SNPs in that specific window and
  # returns the mean of missing genotypes [missing/SNPs]
  
  snpsInWin <- snps[as.numeric(snps[,1]) >= as.numeric(linkageWin[3]) & 
                    as.numeric(snps[,1]) <= as.numeric(linkageWin[4]),]
  
  if (length(snpsInWin) < 1) {                         # If there are no SNPs in that window, return NA
    return()
  } else if (length(snpsInWin) == 2) {                 # If there are only one SNP
    meanMissing <- as.numeric(snpsInWin[2])
  } else {                                             # If there are more than one SNP, take the mean
    meanMissing <- mean(as.numeric(snpsInWin[,2]))
  }
  
  win <- c(linkageWin[2:4], meanMissing)
  
  return(win)
  
}


processFile <- function(filepath, linkageWins, pos) {
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
    
    # Take only the position of all SNPs on that scaffold, 
    # account for the situation when there is only one SNP-pair on the scaffold
    if (dim(posScaff)[1] > 1) {
      posSNP <- array(c(posScaff[1,2], posScaff[,3]))
    } else if (dim(posScaff)[1] == 1) {
      posSNP <- array(c(posScaff[2], posScaff[3]))
    } else {
      # Hop to next line... since I counted missing for all scaff but did not get estimates for all
    }
    
    # Put together the posistions and missing genotypes, will always have at least the length 2
    snpsInScaff <- cbind(posSNP, missingGeno[2:length(missingGeno)])
    
    
    # For each window find the mean
    missingWin <- as.matrix(apply(linkageScaff, 1, mean_in_win, snps = snpsInScaff))
    missingWin <- t(missingWin)
    
    # Append to file
    write.table(missingWin, "out.txt", sep = "\t", append = TRUE, quote = FALSE, 
                col.names = FALSE, row.names = FALSE)
  }
  
  close(con)
}


linkageMapWin <- as.matrix(read.table("../Data/200kb-win/Chr.Rec.200kb.5kGap.txt", sep = "\t", header = TRUE))
recRate <- as.matrix(read.table("parvaGQ30.meanRecRate.txt", sep = "\t", header = FALSE))

processFile("missingParva.txt", linkageMapWin, recRate)

