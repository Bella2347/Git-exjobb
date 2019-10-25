in_common <- function(hotspotMiddle, hotspotList) {
  hotspot <- hotspotList[hotspotList[,1] == hotspotMiddle[1] & abs(as.numeric(hotspotList[,2]) - 
                                                                     as.numeric(hotspotMiddle[2])) <= 3000,]
  if (length(hotspot) > 0) {
    return(1)
  } else {
    return(0)
  }
}

random_hotspots <- function(scaff) {
  
  scaffoldLen <- as.numeric(scaff[3])
  nrHotspots <- as.numeric(scaff[5])
  
  hotspots <- floor(runif(nrHotspots)*scaffoldLen)
  hotspots <- cbind(scaff[1], hotspots)
  
  return(hotspots)
}

generate_hotspots <- function(listHotspots1, listHotspots2) {
  randomHot1 <- apply(listHotspots1, 1, random_hotspots)
  randomHot2 <- apply(listHotspots2, 1, random_hotspots)
  
  randomHot1 <- do.call(rbind, randomHot1)
  randomHot2 <- do.call(rbind, randomHot2)
  
  
  nrHot1 <- sum(apply(randomHot1, 1, in_common, hotspotList = hotspots2))
  nrHot2 <- sum(apply(randomHot2, 1, in_common, hotspotList = hotspots1))
  
  nrHot <- floor(mean(nrHot1, nrHot2))
  
  return(nrHot)
}



fileList <- c("hotspots/parvaGQ30.hotspots.autosomes.txt", "hotspots/taigaGQ30.hotspots.autosomes.txt")

hotspots1 <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
hotspots2 <- as.matrix(read.table(fileList[2], sep = "\t", header = FALSE))

countHot1 <- data.frame(table(hotspots1[,1]))
countHot2 <- data.frame(table(hotspots2[,1]))

scaffLength <- read.table("../info_files/fAlb15.chrom.all.scaffs.txt", sep = "\t", header = FALSE)

scaffHot1 <- merge(scaffLength, countHot1, by.x = 2, by.y = 1)
scaffHot2 <- merge(scaffLength, countHot2, by.x = 2, by.y = 1)

nrHotspots <- replicate(1000, generate_hotspots(scaffHot1, scaffHot2))

hist(nrHotspots)

write.table(nrHotspots, "nrOverlappingRandomHotpsots.txt", quote = FALSE, row.names = FALSE,
            col.names = FALSE)


