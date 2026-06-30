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

# Execute Nextflow job
./nextflow run nf-core/mag -r 5.4.2 -profile singularity,pawsey_setonix -resume -c ./nextflow.config -params-file params_mag.yaml --input "${PWD}/data/sample_sheet_mag.csv" --outdir "${MYSCRATCH}/roche_mag" 