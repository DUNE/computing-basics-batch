#!/bin/bash
:<<'EOF'

To use this jobscript to process 5 files from the dataset fardet-hd__fd_mc_2023a_reco2__full-reconstructed__v09_81_00d02__standard_reco2_dune10kt_nu_1x2x6__prodgenie_nu_dune10kt_1x2x6__out1__validation
data and put the output logs in the `usertests` namespace and saves the output in /scratch

Use these commands to set up ahead of time:

export DUNE_VERSION=<dune version>
export DUNE_QUALIFIER=<dune qualifier>
export FCL_FILE=<top level fcl>
export INPUT_TAR_DIR_LOCAL=<cvmfs directory returned by cvmfs>
export MQL=<your file query>
export DIRECTORY=<directory name inside the tar file>

(see jobs_config.sh for the full list)

Use this command to create the workflow:

justin simple-workflow \
--mql "$MQL" \
--jobscript submit_local_code.jobscript.sh --rss-mb 4000 \
 --output-pattern "*.root:${FNALURL}/${USERF}" --output-pattern "*.root.json:${FNALURL}/${USERF}" --env APP_TAG=${APP_TAG} --env DIRECTORY=${DIRECTORY} --scope $NAMESPACE --lifetime 30 --env INPUT_TAR_DIR_LOCAL=${INPUT_TAR_DIR_LOCAL} --env DUNE_VERSION=${DUNE_VERSION} --env DUNE_QUALIFIER=${DUNE_QUALIFIER} --env FCL_FILE=${FCL_FILE} --env NUM_EVENTS=${NUM_EVENTS} --env USERF=${USERF} --env NAMESPACE=${NAMESPACE} --description "${DESCRIPTION}" 

see job_config.sh for explanations

EOF

# fcl file and DUNE software version/qualifier to be used
FCL_FILE=${FCL_FILE:-${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/my_code/fcls/my_reco.fcl}
APP_TAG=${APP_TAG:-unknown}
#DUNE_VERSION=${DUNE_VERSION:-v09_85_00d00}
#DUNE_QUALIFIER=${DUNE_QUALIFIER:-e26:prof}

echo "------ set things up -------"
echo "Check environment"
echo "DIRECTORY=$DIRECTORY"
echo "DUNE_VERSION=$DUNE_VERSION"
echo "DUNE_QUALIFIER=$DUNE_QUALIFIER" 
echo "FCL_FILE=$FCL_FILE"
echo "MQL=$MQL" 
echo "APP_TAG=$APP_TAG"
echo "USERF=$USERF" 
echo "NUM_EVENTS=$NUM_EVENTS" 
echo "INPUT_TAR_DIR_LOCAL=$INPUT_TAR_DIR_LOCAL"
echo "NAMESPACE=$NAMESPACE"



echo "Current working directory is `pwd`"


# number of events to process from the input file
if [ "$NUM_EVENTS" != "" ] ; then
 events_option="-n $NUM_EVENTS"
fi

# First get an unprocessed file from this stage
did_pfn_rse=`$JUSTIN_PATH/justin-get-file`


if [ "$did_pfn_rse" = "" ] ; then
  echo "Nothing to process - exit jobscript"
  exit 0
fi

# Keep a record of all input DIDs, for pdjson2meta file -> DID mapping
echo "$did_pfn_rse" | cut -f1 -d' ' >>all-input-dids.txt

# pfn is also needed when creating justin-processed-pfns.txt
pfn=`echo $did_pfn_rse | cut -f2 -d' '`
did=`echo $did_pfn_rse | cut -f1 -d' '`

echo "Input PFN = $pfn"

echo "TARDIR ${INPUT_TAR_DIR_LOCAL}"
echo "CODE DIR ${DIRECTORY}"

# Setup DUNE environment
localProductsdir=`ls -c1d ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/localProducts*`

echo "localProductsdir ${localProductsdir}"


# seems to require the right name for the setup script 

echo " check that there is a setup in ${localProductsdir}"
ls -lrt  ${localProductsdir}/setup-grid
ls -lrt ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/$FCL_FILE
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
export PRODUCTS="${localProductsdir}/:$PRODUCTS"

# Then we can set up our local products
setup duneana "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
setup dunesw "$DUNE_VERSION" -q "$DUNE_QUALIFIER"

setup metacat
export METACAT_SERVER_URL=https://metacat.fnal.gov:9443/dune_meta_prod/app
export METACAT_AUTH_SERVER_URL=https://metacat.fnal.gov:8143/auth/dune

source ${localProductsdir}/setup-grid
mrbslp

#echo "----- code is set up -----"

# Construct outFile from input $pfn 
now=$(date -u +"%Y%m%d%H%M%SZ")
Ffname=`echo $pfn | awk -F/ '{print $NF}'`
fname=`echo $Ffname | awk -F. '{print $1}'`
# outFile1 is artroot format
# outFile2 is root format for analysis
export outFile1=${fname}_${APP_TAG}_${now}.root
export outFile2=${fname}_${APP_TAG}_tuple_${now}.root

# echo "make $outFile1"
campaign="justIN.w${JUSTIN_WORKFLOW_ID}s${JUSTIN_STAGE_ID}"

# Here is where the LArSoft command is call it 
(
# Do the scary preload stuff in a subshell!
export LD_PRELOAD=${XROOTD_LIB}/libXrdPosixPreload.so
# echo "$LD_PRELOAD"



#sam_metadata_dumper $pfn

echo "-----  now run lar ------"

echo "lar -c ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/$FCL_FILE $events_option -o ${outFile1} -T ${outFile2} "$pfn" > ${fname}_${APP_TAG}_${now}.log 2>&1"

lar -c ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/$FCL_FILE $events_option -o ${outFile1} -T ${outFile2} "$pfn" > ${fname}_${APP_TAG}_${now}.log 2>&1
)

larExit=$?


# Subshell exits with exit code of last command


echo "lar exit code $larExit"

echo '=== Start last 1000 lines of lar log file ==='
tail -1000 ${fname}_${APP_TAG}_${now}.log
echo '=== End last 1000 lines of lar log file ==='


echo "$did" > justin-input-dids.txt

echo "--------make metadata---------"

#sam_metadata_dumper ${outFile1}

FCL_FILE_NAME=$(basename $FCL_FILE)

echo "python ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/extractor_new.py --infile=${outFile1} --appversion=$DUNE_VERSION --appname=${APP_TAG} --appfamily=larsoft --no_crc --inputDidsFile=justin-input-dids.txt --data_tier='full-reconstructed' --file_format='artroot' --fcl_file=${FCL_FILE_NAME}  --namespace=${NAMESPACE} # > $outFile1.json"

python ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/extractor_new.py --infile=$outFile1 --appversion=$DUNE_VERSION --appname=${APP_TAG}  --appfamily=larsoft --no_crc --inputDidsFile=justin-input-dids.txt  --data_tier='full-reconstructed' --file_format='artroot' --fcl_file=${FCL_FILE_NAME} --namespace=${NAMESPACE} #> $outFile1.json

file1Exit=$?

#cat ${outFile1}.json

echo "------------ non-artroot metadata -----------"
# here for non-artroot files, salvage what you can from outFile1

oldjson=${outFile1}.json

echo " python ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/extractor_new.py --infile=$outFile2 --appversion=$DUNE_VERSION  --appname=${APP_TAG} --appfamily=larsoft --no_crc --inputDidsFile=justin-input-dids.txt  --data_tier='root-tuple' --file_format='root' --fcl_file=${FCL_FILE_NAME} --no_extract --input_json=${PWD}/${oldjson}  --namespace=${NAMESPACE} # > ${outFile2}.json"

python ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/extractor_new.py --infile=$outFile2 --appversion=$DUNE_VERSION   --appname=${APP_TAG}  --appfamily=larsoft --no_crc --inputDidsFile=justin-input-dids.txt  --data_tier='root-tuple' --file_format='root' --fcl_file=${FCL_FILE_NAME} --no_extract --input_json=${PWD}/${oldjson} --namespace=${NAMESPACE} # > ${outFile2}.json

file2Exit=$?

echo "------- finish up ------"
if [ $larExit -eq 0 ] ; then
  # Success !
  echo "$pfn" > justin-processed-pfns.txt
  jobscriptExit=0
else
  # Oh !
  jobscriptExit=1
fi

# Create compressed tar file with all log files 
tar zcf `echo "$JUSTIN_JOBSUB_ID.logs.tgz" | sed 's/@/_/g'` *.log
exit $jobscriptExit
