# give me the directory name as argument
echo "----------------------------------------------------------------"
echo "makercds.sh $1"
if [ "$1" == "" ] ; then
    echo "need to enter the directory name that was used for your tar file"
else 
    echo "first ensure you have a justin token"
    justin time
    justin get-token
    export HERE=`pwd`
    # put the tar file on a bigger disk 
    export THERE=/exp/dune/data/users/$USER/
    date
    ls -lrt $THERE/$1.tar.gz
    echo " upload tar file to cvmfs and store location in cvmfs.location file"
    export INPUT_TAR_DIR_LOCAL=`justin-cvmfs-upload $THERE/$1.tar.gz`
    echo "file uploaded to $INPUT_TAR_DIR_LOCAL"
    echo $INPUT_TAR_DIR_LOCAL > $HERE/cvmfs.location
    echo "return to previous directory"
    cd $HERE
    echo "----------------------------------------------------------------"
fi