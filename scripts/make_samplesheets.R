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

# Read list of existing CRAM files on Setonix
existing_crams <- read_lines(here("data/existing_crams.txt"))

# Extract samples from existing CRAM paths (basename without extension)
samples <- existing_crams |>
  basename()
 |> str_remove("\\.cram$")

# Check that all found samples are present in our local sample sheet metadata
sample_sheet <- read_csv(here("data/sample_sheet.csv"))
if (!all(samples %in% sample_sheet$sample_name)) {
  stop("Some CRAM samples found on Setonix are not in the local sample_sheet.csv metadata")
}

folders <- str_remove(samples, "_L1")

# Use paths directly from existing crams list
paths_cram <- existing_crams

paths_fastq_dir <- str_c(
  "/scratch/",
  project,
  "/",
  username,
  "/roche_sbxmag/reads/",
  sep = ""
)

paths_fastq_files <- str_c(
  "/scratch/",
  project,
  "/",
  username,
  "/roche_sbxmag/reads/",
  samples,
  "_other.fq.gz",
  sep = ""
)

# Build nf-core/bamtofastq and nghiaagent/sbxmag sample sheet
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
  short_reads_platform = "ILLUMINA",
  long_reads_platform = NA
)

# Export files
## bamtofastq and sbxmag
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
