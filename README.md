# Metagenomic profiling and assembly on the Roche Sequencing By eXpansion (SBX) platform
Mitchell Nguyen

\[!CAUTION\]

This is heavily work-in-progress:! - The code needs to be split in two
(a Nextflow pipeline ready for sharing (potentially a fork of
nf-core/mag), and a small repo of sample sheets and bash scripts). - I
need to decide on pipeline analysis steps!

## Reproduction

These instructions are for the Pawsey Supercomputing Centre.

1.  Clone this repo to your machine, then clone it to your /scratch.

``` {bash}
#| eval: False
# On your local shell
# Manually replace {username} and {project} with your own info!
git clone https://github.com/nghiaagent/roche-sbx-scripts.git
rsync -avzP roche-sbx-scripts/ {username}@setonix.pawsey.org.au:/scratch/{project}/{username}/roche-sbx-scripts
```

2.  Connect to the Setonix Workflow nodes

``` {bash}
#| eval: False
# Manually replace {username} and {project} with your own info!
ssh {username}@setonix-workflow.pawsey.org.au
```

3.  Set workflow activation script to executable, then run.

``` {bash}
#| eval: False
# Manually replace {username} and {project} with your own info!
chmod +x scripts/run_nfcore_bamtofastq_test.sh
scripts/run_nfcore_bamtofastq_test.sh
```
