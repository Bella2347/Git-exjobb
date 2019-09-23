# Give positions for hotspots
# Give mean rec. rate
# Should be able to take hotspots found in one species and calculate the surrounding in the other species:

# [unique hotspots parva] [parva rec. rate estimate]
# [unique hotspots parva] [taiga rec. rate estimate]

# [unique hotspots taiga] [taiga rec. rate estimate]
# [unique hotspots taiga] [parva rec. rate estimate]

# [shared hotspots] [parva rec. rate estimate]
# [shared hotspots] [taiga rec. rate estimate]

# [hotspots parva] [parva rec. rate estimate]
# [hotspots taiga] [taiga rec. rate estimate]



# Load mean rec rate
# Load hotspots

# Make array with rec. rate/base

# Find middle of hotspot
# Take the 40kb window that surrounds the middle of the hotspot, if exceeds over end: add NA which are omitted when calculating mean

# Take the mean at each position in the 40kb over all hotspots

# Write data to file
# Plot data