echo "----------------------------------------------------------------"
echo "setup_before_submit.sh"

export DIRECTORY="$(basename "${PWD}")"
export DUNE_VERSION=v09_91_02d01
export DUNE_QUALIFIER=e26:prof
export DUNE_QUALIFIER_STRING=`echo ${DUNE_QUALIFIER} | tr : _`

## set up locally just as a check
source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
setup duneana "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
setup dunesw "$DUNE_VERSION" -q "$DUNE_QUALIFIER"
setup metacat
export METACAT_SERVER_URL=https://metacat.fnal.gov:9443/dune_meta_prod/app
export METACAT_AUTH_SERVER_URL=https://metacat.fnal.gov:8143/auth/dune
setup justin
echo " code set up"
justin time
echo " you may need to authorize this computer to run the justin command - check to see if there is a URL above and go there to authenticate"
justin get-token


export localProductsdir="${PWD}/localProducts_larsoft_${DUNE_VERSION}_${DUNE_QUALIFIER_STRING}"
echo " localProductsdir ${localProductsdir}"

cp setup-grid $localProductsdir/setup-grid

echo "Now you should:"
echo "./maketar.sh $DIRECTORY"
echo "./makercds.sh $DIRECTORY"
echo "# edit job_config.sh"
echo "./submit_workflow.sh"
echo "----------------------------------------------------------------"