processFile <- function(filepath, outfile) {
  # Reads in a line at a time from a file
  # Finds the mean missing genotypes [missing/SNP] for each scaffold
  
  con <- file(filepath, "r")
  
  while ( TRUE ) {
    
    line = readLines(con, n = 1)
    
    if ( length(line) == 0 ) {
      break
    }
    
    missingGeno <- array(unlist(strsplit(line, " ")))
    
    missingMean <- mean(as.numeric(missingGeno[2:length(missingGeno)]))
    
    scaff <- c(missingGeno[1], missingMean)
    
    write.table(t(scaff), outfile, append = TRUE, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
  }
  
  close(con)
}

processFile("missingParva.txt", "meanMissingScaffParva.txt")
processFile("missingTaiga.txt", "meanMissingScaffTaiga.txt")

