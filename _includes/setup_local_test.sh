# setup_local_code.txt for example
export DUNE_VERSION=v09_91_02d01
export DUNE_QUALIFIER=e26:prof
export FCL_FILE=run_analyseEvents.fcl
export INPUT_TAR_DIR_LOCAL=$PWD
export MQL="files where dune.workflow['workflow_id']=3923 and core.data_tier=full-reconstructed limit 1 ordered "
export PROCESS_TYPE=analyze 
export USERF=$USER 

# try doing a local setup for testing
echo "I am here now: `pwd`"
export localProductsdir=`ls -c1d $PWD/localProducts*`
echo "Local products directory is ${localProductsdir}"
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
export PRODUCTS="${localProductsdir}/:$PRODUCTS"
mv ${localProductsdir}/setup ${localProductsdir}/setup.bak
cp setup-local ${localProductsdir}/setup
# Then we can set up our local products
setup duneana "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
setup dunesw "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
mrbslp
source ${localProductsdir}/setup

