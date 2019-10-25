# Läs in parva hotspots
# Läs in taiga hotspots

# För varje hotspot hitta mitten
# om mitten - mitten <= 3000 är de gemensamma

in_common <- function(hotspotMiddle, hotspotList) {
  hotspot <- hotspotList[hotspotList[,1] == hotspotMiddle[1] & abs(as.numeric(hotspotList[,2]) - 
                                                                     as.numeric(hotspotMiddle[2])) <= 3000,]
  if (length(hotspot) > 0) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

in_both <- function(fileList) {
  hotspots1 <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
  hotspots2 <- as.matrix(read.table(fileList[2], sep = "\t", header = FALSE))
  
  hotspots1Middle <- hotspots1[,1:2]
  hotspots1Middle[,2] <- as.numeric(hotspots1[,2]) + as.numeric(hotspots1[,4])/2
  
  hotspots2Middle <- hotspots2[,1:2]
  hotspots2Middle[,2] <- as.numeric(hotspots2[,2]) + as.numeric(hotspots2[,4])/2
  
  hotspotsBolean <- apply(hotspots1Middle, 1, in_common, hotspotList = hotspots2Middle)
  
  hotspotsBoth <- hotspots1[hotspotsBolean,]
  
  return(hotspotsBoth)
}

in_one <- function(fileList) {
  hotspots1 <- as.matrix(read.table(fileList[1], sep = "\t", header = FALSE))
  hotspots2 <- as.matrix(read.table(fileList[2], sep = "\t", header = FALSE))
  
  hotspots1Middle <- hotspots1[,1:2]
  hotspots1Middle[,2] <- as.numeric(hotspots1[,2]) + as.numeric(hotspots1[,4])/2
  
  hotspots2Middle <- hotspots2[,1:2]
  hotspots2Middle[,2] <- as.numeric(hotspots2[,2]) + as.numeric(hotspots2[,4])/2
  
  hotspotsBolean <- apply(hotspots1Middle, 1, in_common, hotspotList = hotspots2Middle)
  
  hotspotsOne <- hotspots1[!hotspotsBolean,]
  
  return(hotspotsOne)
}

argv <- c("parvaGQ30.hotspots.autosomes.txt", "taigaGQ30.hotspots.autosomes.txt")

commonHotspotsPar <- in_both(argv)
commonHotspotsTag <- in_both(c("taigaGQ30.hotspots.autosomes.txt", "parvaGQ30.hotspots.autosomes.txt"))

colnames(commonHotspotsPar) <- c("Scaff", "Start", "End", "Length")
colnames(commonHotspotsTag) <- c("Scaff", "Start", "End", "Length")

write.table(commonHotspotsPar, "parHotpsotsInBoth.txt", sep = "\t", quote = FALSE, row.names = FALSE)
write.table(commonHotspotsTag, "tagHotpsotsInBoth.txt", sep = "\t", quote = FALSE, row.names = FALSE)



hotspotsParUnique <- in_one(argv)
hotspotsTagUnique <- in_one(c("taigaGQ30.hotspots.autosomes.txt", "parvaGQ30.hotspots.autosomes.txt"))

colnames(hotspotsParUnique) <- c("Scaff", "Start", "End", "Length")
colnames(hotspotsTagUnique) <- c("Scaff", "Start", "End", "Length")

write.table(hotspotsParUnique, "parHotpsotsUnique.txt", sep = "\t", quote = FALSE, row.names = FALSE)
write.table(hotspotsTagUnique, "tagHotpsotsUnique.txt", sep = "\t", quote = FALSE, row.names = FALSE)


