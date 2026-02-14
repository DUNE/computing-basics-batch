export FCL_FILE="run_analyseEvents.fcl" # fcl file
export OUTPUT_DATA_TIER1="full-reconstructed" # tier for artroot output
export OUTPUT_DATA_TIER2="root-tuple" # tier for root output
export MQL="files where dune.workflow['workflow_id']=3923 and core.data_tier=full-reconstructed limit 2 ordered " # metacat query for files
export APP_NAME="ana" # application name
export DESCRIPTION="$APP_NAME using $FCL_FILE" # appears as jobname in justin
export USERF=${USER} # make certain the grid knows who your are
export NUM_EVENTS=-1 # process them all
export FNALURL='https://fndcadoor.fnal.gov:2880/dune/scratch/users' # sends output to scratch
export NAMESPACE="usertests" # don't change this unless doing production
