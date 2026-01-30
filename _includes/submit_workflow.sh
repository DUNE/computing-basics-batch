# actual submission
export INPUT_TAR_DIR_LOCAL=`cat cvmfs.location`
echo "tardir $INPUT_TAR_DIR_LOCAL"
justin simple-workflow \
--mql "$MQL" \
--jobscript submit_local_code.jobscript.sh --rss-mb 4000 \
 --output-pattern "*.root:${FNALURL}/${USERF}" --env PROCESS_TYPE=${PROCESS_TYPE} --env DIRECTORY=${DIRECTORY} --scope usertests --lifetime 30 --env INPUT_TAR_DIR_LOCAL=${INPUT_TAR_DIR_LOCAL}