#!/bin/bash



# Variable needed to be pass in by external
# $RAW_DATA_PATH, $UUID, $DATA_BASE_URL
#
# e.g.
#"RAW_DATA_PATH": "2018-05-15/2018-05-15__12-04-43-833",
#"UUID": "5716a146-8d3d-4d80-99b9-6cbf95cfedfb",

CLEANED_META_DIR="cleanmetadata_out/"
TIFS_DIR="bin2tif_out/"

METADATA=${RAW_DATA_PATH}${UUID}"_metadata.json"
BIN=${RAW_DATA_PATH}${UUID}"_rawData.bin"
METADATA_CLEANED=${CLEANED_META_DIR}${UUID}"_metadata_cleaned.json"
TIF=${TIFS_DIR}${UUID}".tif"

set -e

# Make a cleaned copy of the metadata
SENSOR="ps2Top"
METADATA=${METADATA}
WORKING_SPACE=${CLEANED_META_DIR}
USERID=""

ls ${RAW_DATA_PATH}
ls ${METADATA}
ls "cached_betydb/bety_experiments.json"
mkdir -p ${WORKING_SPACE}
BETYDB_LOCAL_CACHE_FOLDER=cached_betydb/ singularity run -B $(pwd):/mnt --pwd /mnt docker://agpipeline/cleanmetadata:latest --metadata ${METADATA} --working_space ${WORKING_SPACE} ${SENSOR} ${USERID}
ls ${CLEANED_META_DIR}
ls ${METADATA_CLEANED}

# Convert LEFT bin/RGB image to TIFF format
BIN=${BIN}
METADATA=${METADATA_CLEANED}
WORKING_SPACE=${TIFS_DIR}

ls ${BIN}
ls ${METADATA_CLEANED}
mkdir -p ${WORKING_SPACE}
singularity run -B $(pwd):/mnt --pwd /mnt docker://zhxu73/ps2top-bin2tif:2.1 --result print --metadata ${METADATA} --working_space ${WORKING_SPACE} ${BIN}
ls ${TIF}
