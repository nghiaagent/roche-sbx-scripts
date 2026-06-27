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
  "50918036C_HPSID_002_L1",
  "50918124C_HPSID_004_L1"
)

folders <- str_remove(samples, "_L1")

# Check that all samples are present
sample_sheet <- read_csv(here("data/sample_sheet.csv"))

if (!all(samples %in% sample_sheet$sample_name)) {
  stop("One or more samples are not present in provided sample sheet")
}

# Calculate paths to where files should be ($MYSCRATCH/roche and $MYSCRATCH/roche_fastq)
paths_cram <- str_c(
  "/scratch/",
  project,
  "/",
  username,
  "/roche/",
  folders,
  "/",
  samples,
  ".cram",
  sep = ""
)

#### TODO: FastQ paths

# Build nf-core/bamtofastq sample sheet
# Columns specs: sample_id, mapped, index, filetype
sample_sheet_bamtofastq <- data.frame(
  sample_id = samples,
  mapped = paths_cram
) |>
  mutate(index = NA, file_type = "cram")

# Build nf-core/seqinspector sample sheet
# TODO!!!

# Export files
## bamtofastq
write_csv(
  sample_sheet_bamtofastq,
  na = "",
  here("data/sample_sheet_bamtofastq.csv")
)

## seqinspector
