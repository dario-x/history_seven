
# set the working directory to directory of the script
setwd(dirname(rstudioapi::getSourceEditorContext()$path))


# read in the history data
district_data = read.csv("./data/district_data.csv", sep=";")

# Save an object to a file
saveRDS(district_data, file = "./data/district_data.rds")

# Restore the object
district_data = readRDS(file = "./data/district_data.rds")



# get the boundaries of the 7th district
vienna_boundaries = read.csv("./data/BEZIRKSGRENZEOGD.csv")
# Save an object to a file
saveRDS(vienna_boundaries, file = "./data/vienna_boundaries.rds")

# Restore the object
vienna_boundaries = readRDS(file = "./data/vienna_boundaries.rds")
