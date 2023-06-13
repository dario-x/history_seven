library(xtable)

# Define the list of participants
participants = paste0("participant_", 1:12)

# Set the number of groups and blocks
numGroups = 2
numBlocks = length(participants) / numGroups

# Randomly assign participants to groups within blocks
assignment = rep(c("VR_first", "2D_first"), each = numBlocks)
# Set the Seed to make the results reproducible
set.seed(24)
# Assign the participants
assignment = sample(assignment)

# Create the data frame with assignments
df = data.frame(patient_name = participants, group_name = assignment)

# Print the assignment data frame
print(df)
print(xtable(df))

