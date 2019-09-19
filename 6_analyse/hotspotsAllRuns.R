minHotspotLen <- 750

overlap <- function(listOfHotspots) {
  
  if (min(listOfHotspots[,2]) - max(listOfHotspots[,1]) >= minHotspotLen) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

args <- commandArgs(trailingOnly = TRUE)

run1filename <- args[1]
run2filename <- args[2]
run3filename <- args[3]
run4filename <- args[4]
run5filename <- args[5]
outFilename <- args[6]

hrun1 <- read.table(run1filename, sep = "\t", header = TRUE)
hrun2 <- read.table(run2filename, sep = "\t", header = TRUE)
hrun3 <- read.table(run3filename, sep = "\t", header = TRUE)
hrun4 <- read.table(run4filename, sep = "\t", header = TRUE)
hrun5 <- read.table(run5filename, sep = "\t", header = TRUE)

hruns <- rbind(hrun1, hrun2, hrun3, hrun4, hrun5)
hruns <- hruns[order(hruns$Start.position),]


hotspots <- as.data.frame(matrix(NA, dim(hrun1)[1],3))
colnames(hotspots) <- colnames(hruns)
h_i <- 1

for (i in 1:(dim(hruns)[1]-4)) {

  if (overlap(hruns[i:(i+4),])) {
    hotspots[h_i,] <- c(max(hruns[i:(i+4),1]), min(hruns[i:(i+4),2]), min(hruns[i:(i+4),2]) - max(hruns[i:(i+4),1]))
    h_i <- h_i + 1
  }
}

hotspots <- hotspots[1:(h_i-1),]

write.table(hotspots, outFilename, append = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
