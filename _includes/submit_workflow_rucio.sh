# actual submission
export INPUT_TAR_DIR_LOCAL=`cat cvmfs.location`

# this sends output directly to $NAMESPACE in rucio

source job_config.sh # pick up the configuration

echo "---- check the configuration ----"
echo "DIRECTORY=$DIRECTORY"
echo "DUNE_VERSION=$DUNE_VERSION"
echo "DUNE_QUALIFIER=$DUNE_QUALIFIER" 
echo "FCL_FILE=$FCL_FILE"
echo "MQL=$MQL" 
echo "APP_TAG=$APP_TAG"
echo "USERF=$USERF" 
echo "NUM_EVENTS=$NUM_EVENTS" 
echo "DESCRIPTION=$DESCRIPTION"
echo "INPUT_TAR_DIR_LOCAL=$INPUT_TAR_DIR_LOCAL"
echo "NAMESPACE=${NAMESPACE}"

if test -e "./${FCL_FILE}"; then
    echo "---- do the submission ----"
    justin simple-workflow \
    --mql "$MQL" \
    --jobscript submit_local_code.jobscript.sh --rss-mb 4000 \
    --output-pattern "*.root:${USER}-output" --env APP_TAG=${APP_TAG} --env DIRECTORY=${DIRECTORY} --scope ${NAMESPACE} --lifetime 700 --env INPUT_TAR_DIR_LOCAL=${INPUT_TAR_DIR_LOCAL} --env DUNE_VERSION=${DUNE_VERSION} --env DUNE_QUALIFIER=${DUNE_QUALIFIER} --env FCL_FILE=${FCL_FILE} --env NUM_EVENTS=${NUM_EVENTS} --env USERF=${USERF} --env NAMESPACE=${NAMESPACE} --description "${DESCRIPTION}" 
else
     echo "FCL_FILE must be in $DIRECTORY for now"
fi