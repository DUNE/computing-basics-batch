# actual submission - this one uses rucio as output location

export INPUT_TAR_DIR_LOCAL=`cat cvmfs.location`

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
echo "Output NAMESPACE=$NAMESPACE"


echo "tardir $INPUT_TAR_DIR_LOCAL"
justin simple-workflow \
--mql "$MQL" \
--jobscript submit_local_code_rucio.jobscript.sh --rss-mb 4000 \
 --output-pattern "*.root:${USER}-output"  --env APP_TAG=${APP_TAG} --env DIRECTORY=${DIRECTORY} --scope usertests --lifetime 30 --env INPUT_TAR_DIR_LOCAL=${INPUT_TAR_DIR_LOCAL} --env DUNE_VERSION=${DUNE_VERSION} --env DUNE_QUALIFIER=${DUNE_QUALIFIER} --env FCL_FILE=${FCL_FILE} --env NUM_EVENTS=${NUM_EVENTS} --env NAMESPACE=${NAMESPACE} --description "${DESCRIPTION}"