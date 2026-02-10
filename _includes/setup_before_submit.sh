echo "----------------------------------------------------------------"
echo "setup_before_submit.sh"
export DIRECTORY="$(basename "${PWD}")"
export DUNE_VERSION=v09_91_02d01
export DUNE_QUALIFIER=e26:prof
export FCL_FILE=run_analyseEvents.fcl
export MQL="files where dune.workflow['workflow_id']=3923 and core.data_tier=full-reconstructed limit 5 ordered "
export PROCESS_TYPE=ana 
export DESCRIPTION="$PROCESS_TYPE using $FCL_FILE"
export USERF=$USER
export NUM_EVENTS=1 
export FNALURL='https://fndcadoor.fnal.gov:2880/dune/scratch/users'

## set up locally just as a check
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup duneana "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
setup dunesw "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
setup justin
echo " code set up"
justin time
justin get-token
echo " got a token from justin"

# make certain the setup script in localProducts is what you want
export localProductsdir=`ls -c1d $PWD/localProducts*`
cp setup-grid $localProductsdir/setup

echo "Now you should ./makercds.sh $DIRECTORY"
echo "and then submit with ./submit_workflow.sh"
echo "----------------------------------------------------------------"


