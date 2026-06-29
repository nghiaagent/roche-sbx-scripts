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

paths_fastq_dir <- str_c(
  "/scratch/",
  project,
  "/",
  username,
  "/roche_fastq/reads/",
  sep = ""
)

paths_fastq_files <- str_c(
  "/scratch/",
  project,
  "/",
  username,
  "/roche_fastq/reads/",
  samples,
  "_other.fq.gz",
  sep = ""
)

# Build nf-core/bamtofastq sample sheet
# Columns specs: sample_id, mapped, index, filetype
sample_sheet_bamtofastq <- data.frame(
  sample_id = samples,
  mapped = paths_cram
) |>
  mutate(index = NA, file_type = "cram")

# Build nf-core/seqinspector sample sheet
# Column specs: sample_id, fastq_1, fastq_2, rundir, tags
sample_sheet_seqinspector <- data.frame(
  sample = samples,
  fastq_1 = paths_fastq_files
) |>
  mutate(
    fastq_2 = NA,
    rundir = paths_fastq_dir,
    tags = NA
  )

# Build nf-core/mag sample sheet
# Column specs: sample,group,short_reads_1,short_reads_2,long_reads,short_reads_platform,long_reads_platform
sample_sheet_mag <- data.frame(
  sample = samples,
  group = 0,
  short_reads_1 = paths_fastq_files,
  short_reads_2 = NA,
  long_reads = NA,
  short_reads_platform = "Illumina",
  long_reads_platform = NA
)

# Export files
## bamtofastq
write_csv(
  sample_sheet_bamtofastq,
  na = "",
  here("data/sample_sheet_bamtofastq.csv")
)

## seqinspector
write_csv(
  sample_sheet_seqinspector,
  na = "",
  here("data/sample_sheet_seqinspector.csv")
)

## mag
write_csv(
  sample_sheet_mag,
  na = "",
  here("data/sample_sheet_mag.csv")
)
