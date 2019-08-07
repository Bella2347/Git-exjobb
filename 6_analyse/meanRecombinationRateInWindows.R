#########################################################################
###### Average recombination rate in windows with overlapping steps #####
#########################################################################

############################ Input parameters ###########################

#recRatePerBase from loadScaffold.R
#snpPerBase     from loadScaffold.R
stepSize <- 1000          # The length of the steps
windowSize <- 2000        # The length of the window
flankingWinSize <- 100000 # The length of the flanking region

########################### Output parameters ###########################
# meanRecRateWin: the mean recombination rate per window
############################ Other parameters ###########################
# recNonNAindex: get the index of all bases that have an estimated recombination rate
# recFirst_i:    the first base with an estimated recombination rate
# recLast_i:     the last base with an estimated recombination rate
# r_i
# i
#########################################################################
#########################################################################

# Find the first and last SNP with a recombination rate
recNonNAindex <- which(!is.na(recRatePerBase))
recFirst_i <- min(recNonNAindex)
recLast_i <- max(recNonNAindex)

# Create a data frame to store the average recombination rate in
meanRecRateWin <- data.frame(array(NA, c(((recLast_i-recFirst_i)/stepSize),3)))
colnames(meanRecRateWin) <- c("Start position", "End position", "Recombination rate [1/bp]")
# Use this to know the next empty row
r_i <- 1

# Calculate the mean recombination rate for each window
for (i in seq(recFirst_i,recLast_i,stepSize)) {
  
  # If the window extends over the take the mean to the end even if it is less than the window size
  if ((recLast_i-i) < (windowSize-1) && (recLast_i-i) > (stepSize-1)) {
    # Take the mean of the window and store it with the positions for the window
    meanRecRateWin[r_i,] <- c(i, recLast_i, mean(recRatePerBase[i:recLast_i]))
  
  } else if ((recLast_i-i) > (windowSize-1) && (recLast_i-i) > (stepSize-1)) {
    meanRecRateWin[r_i,] <- c(i, (windowSize-1+i), mean(recRatePerBase[i:(windowSize-1+i)]))
  } 
  
  # Add one to keep track of the next empty row
  r_i <- r_i +1
}