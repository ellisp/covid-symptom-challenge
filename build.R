# This script should download and tidy data and do necessary analysis
# It functions  like a primitive makefile.


# Setup
source("setup.R")

# Data processing
source("processing/download-data.R")
source("processing/import-data.R")

# Explorations of all variables. Not essential. Uncomment them if you want them.
# source("explore/explore-full-data.R")
# source("explore/explore-regional-data.R")

# Analysis for blog post on 4 October 2020:
source("analysis/0195-covid-symptoms-blogpost.R")