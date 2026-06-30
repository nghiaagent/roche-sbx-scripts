# DO NOT SUBMIT THIS SCRIPT VIA SBATCH
# Log in to setonix-workflow then run it interactively.

# Load modules
module load singularity/4.1.0-slurm
# Make bundled Nextflow executable
chmod +x ./nextflow

# Export appropriate environment variables
export NXF_HOME="${MYSCRATCH}/.nextflow"
export NXF_SINGULARITY_CACHEDIR="${MYSCRATCH}/.nextflow_singularity"
export SINGULARITY_CACHEDIR="${MYSCRATCH}/.singularity"

# Ensure local reference genome directory exists
mkdir -p "${MYSCRATCH}/reference"

# Sync reference index using rsync
rsync -av /scratch/references/human/GRCh38/full_plus_hs38d1/GCA_000001405.15_GRCh38_full_plus_hs38d1_analysis_set.fna.fai "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa.fai"

# Decompress shared reference FASTA if missing
if [ ! -f "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa" ]; then
    echo "Reference FASTA not found. Decompressing from shared references..."
    gzip -d -c /scratch/references/human/GRCh38/full_plus_hs38d1/GCA_000001405.15_GRCh38_full_plus_hs38d1_analysis_set.fna.gz > "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa"
fi

# (Alternative) If downloading/syncing from a remote server/cloud provider:
# module load gcc-native/12 rclone/1.68.1
# rclone copy remote:path/to/reference "${MYSCRATCH}/reference/"

# Execute Nextflow job
./nextflow run workflows/sbxmag/main.nf -profile singularity,pawsey_setonix -resume -c ./nextflow.config --input "${PWD}/data/sample_sheet_bamtofastq.csv" --outdir "${MYSCRATCH}/roche_sbxmag" --fasta "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa"
