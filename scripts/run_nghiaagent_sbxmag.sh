# DO NOT SUBMIT THIS SCRIPT VIA SBATCH
# Log in to setonix-workflow then run it interactively.

# Load modules
module load singularity/4.1.0-slurm rclone/1.68.1
# Make bundled Nextflow executable
chmod +x ./nextflow

# Export appropriate environment variables
export NXF_HOME="${MYSCRATCH}/.nextflow"
export NXF_SINGULARITY_CACHEDIR="${MYSCRATCH}/.nextflow_singularity"
export SINGULARITY_CACHEDIR="${MYSCRATCH}/.singularity"

# Ensure local reference genome directory exists
mkdir -p "${MYSCRATCH}/reference"
mkdir -p "${MYSCRATCH}/deacon_index"
mkdir -p "${MYSCRATCH}/sylph_databases"

# Sync reference index using rsync
rsync -av /scratch/references/human/GRCh38/full_plus_hs38d1/GCA_000001405.15_GRCh38_full_plus_hs38d1_analysis_set.fna.fai "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa.fai"
rclone copy pawsey1172:metagenomic-databases/sylph_databases ${MYSCRATCH}/sylph_databases --verbose --checksum

# Download deacon index from Oracle Cloud if not already present
DEACON_INDEX="${MYSCRATCH}/deacon_index/panhuman-1.k31w15.idx"
if [ ! -f "${DEACON_INDEX}" ]; then
    echo "Deacon index not found. Downloading from Oracle Cloud..."
    wget -q --show-progress -O "${DEACON_INDEX}" \
        "https://objectstorage.uk-london-1.oraclecloud.com/n/lrbvkel2wjot/b/human-genome-bucket/o/deacon/3/panhuman-1.k31w15.idx"
    echo "Deacon index downloaded."
else
    echo "Deacon index already present: ${DEACON_INDEX}"
fi

# Decompress shared reference FASTA if missing
if [ ! -f "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa" ]; then
    echo "Reference FASTA not found. Decompressing from shared references..."
    gzip -d -c /scratch/references/human/GRCh38/full_plus_hs38d1/GCA_000001405.15_GRCh38_full_plus_hs38d1_analysis_set.fna.gz > "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa"
fi

# Execute Nextflow job
./nextflow run workflows/sbxmag/main.nf -profile singularity,pawsey_setonix -resume -c ./nextflow.config --input "${PWD}/data/sample_sheet_bamtofastq.csv" --outdir "${MYSCRATCH}/roche_sbxmag" --fasta "${MYSCRATCH}/reference/Homo_sapiens.GRCh38_15_plus_hs38d1.fa" --deacon_index "${MYSCRATCH}/deacon_index/panhuman-1.k31w15.idx" --sylph_profile_index "${MYSCRATCH}/sylph_databases/gtdb_95_DB/gtdb-r220-c200-dbv1.syldb" --sylph_query_index "${MYSCRATCH}/sylph_databases/gtdb_99_ordered_DB/gtdb_ordered_99.syldb"
