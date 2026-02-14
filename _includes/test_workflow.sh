# actual submission
#export INPUT_TAR_DIR_LOCAL=`cat cvmfs.location`
export INPUT_TAR_DIR_LOCAL=$DUNEDATA
source $DIRECTORY/job_config.sh

export NUM_EVENTS=2
echo "DIRECTORY=$DIRECTORY"
echo "DUNE_VERSION=$DUNE_VERSION"
echo "DUNE_QUALIFIER=$DUNE_QUALIFIER" 
echo "FCL_FILE=$FCL_FILE"
echo "MQL=$MQL" 
echo "APP_NAME=$APP_NAME"
echo "USERF=$USERF" 
echo "NUM_EVENTS=$NUM_EVENTS" 
echo "DESCRIPTION=$DESCRIPTION"
echo "INPUT_TAR_DIR_LOCAL=$INPUT_TAR_DIR_LOCAL"


echo "tardir $INPUT_TAR_DIR_LOCAL"
export HERE=$PWD
echo " go up one directory "
cd ..
justin-test-jobscript \
--mql "$MQL" \
--jobscript $DIRECTORY/submit_local_code.jobscript.sh --env PROCESS_TYPE=${PROCESS_TYPE} --env DIRECTORY=${DIRECTORY}  --env INPUT_TAR_DIR_LOCAL=${INPUT_TAR_DIR_LOCAL} --env DUNE_VERSION=${DUNE_VERSION} --env DUNE_QUALIFIER=${DUNE_QUALIFIER} --env FCL_FILE=${FCL_FILE} --env NUM_EVENTS=${NUM_EVENTS} --env USERF=${USER} --env APP_NAME=${APP_NAME} --env NAMESPACE=${NAMESPACE} 
cd $HERE
