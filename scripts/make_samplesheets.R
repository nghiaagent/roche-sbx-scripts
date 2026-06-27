######################
# In this script, I create my sample sheets automatically
# For nf-core/bamtofastq
# And nf-core/seqinspector
######################

# Declare location

# Import packages
library(tidyverse)
library(here)

# Define current project and username
project <- "pawsey1172"
username <- "nghiaagent"

# Define samples that are in use at the moment
samples <- c(
  "50918036C_HPSID_002",
  "50918124C_HPSID_004",
  "50918402C_HPSID_005",
  "50918538C_HPSID_006",
  "50918870C_HPSID_007"
)

# Calculate paths to where files should be ($MYSCRATCH/roche)
paths_bam <- str_c(
  "/scratch/",
  project,
  "/",
  username,
  "/roche/",
  samples,
  "/",
  samples,
  "_L1.cram",
  sep = ""
)

# Build nf-core/bamtofastq sample sheet
# Columns specs: sample_id, mapped, index, filetype
sample_sheet_bamtofastq <- data.frame(
  sample_id = samples,
  mapped = paths_bam
) |>
  mutate(index = NA, file_type = "cram")

# Export files
## bamtofastq
write_csv(
  sample_sheet_bamtofastq,
  na = "",
  here("data/sample_sheet_bamtofastq.csv")
)

## seqinspector
