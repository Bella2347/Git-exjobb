####### About ###############
# Takes as input:
# [out file] [hotspots in file1] [file2] ...
# Writes the hotspots which are present in all infiles to the out file
# Works for any number of infiles


######### FUNCTIONS ###################

overlap <- function(listOfHotspots) {
  minHotspotLen <- 750
  
  if (min(listOfHotspots[,3]) - max(listOfHotspots[,2]) >= minHotspotLen) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

get_hotspots <- function(hotspotsList, nrFiles) {
  
  hotspots <- as.data.frame(matrix(NA, dim(hotspotsList)[1],3))
  colnames(hotspots) <- c("Start_SNP", "End_SNP", "Hotspot_length")
  
  for (i in 1:(dim(hotspotsList)[1] - nrFiles + 1)) {
    
    if (overlap(hotspotsList[i:(i + nrFiles - 1),])) {
      hotspots[i,] <- c(max(hotspotsList[i:(i + nrFiles - 1),2]), min(hotspotsList[i:(i + nrFiles - 1),3]), 
                        min(hotspotsList[i:(i + nrFiles - 1),3]) - max(hotspotsList[i:(i + nrFiles - 1),2]))
    }
  }
  
  hotspots <- na.omit(hotspots)
  return(hotspots)
}

main <- function(argv) {
  argv <- commandArgs(trailingOnly = TRUE)
  
  outFilename <- argv[1]
  write("#Start_pos\tEnd_post\tLength_of_hotspot", outFilename)
  
  # Read in the files
  hotspotsRuns <- lapply(argv[2:length(argv)], read.table, sep = "\t", header = FALSE)
  
  # rbind the datframes to one
  hotspotsAll <- do.call(rbind, hotspotsRuns)
  colnames(hotspotsAll) <- c("Scaffold", "Start_SNP", "End_SNP", "Hotspot_length")
  
  # sort on scaffoldname and start position
  hotspotsAllSorted <- hotspotsAll[order(hotspotsAll$Scaffold, hotspotsAll$Start_SNP),]
  
  # Count how many infiles there are
  nrInputFiles <- length(argv) - 1
  
  # if five enteries next to each other overlap, return as hotspot if the overlap is at least 750
  hotspots <- get_hotspots(hotspotsAllSorted, nrInputFiles)
  
  # if we got any hotspots append to file with: scaffoldname, start, end, length
  if (length(unlist(hotspots)) > 0) {
    write.table(hotspots, outFilename, append = TRUE, sep = "\t", row.names = FALSE, col.names = FALSE)
  }
}


########## Execution ######################

main()




