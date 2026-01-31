# give me the directory name as argument
export HERE=`pwd`
# put the tar file on a bigger disk 
export THERE=/exp/dune/data/users/$USER/
cd .. # go up one
echo " make tar file"
tar --exclude '.git' --exclude build_slf7.x86_64 -czf $THERE/$1.tar.gz $1
ls -lrt $THERE/$1.tar.gz
echo " upload tar file to cvmfs"
export INPUT_TAR_DIR_LOCAL=`justin-cvmfs-upload $THERE/$1.tar.gz`
echo $INPUT_TAR_DIR_LOCAL
echo $INPUT_TAR_DIR_LOCAL > $1/cvmfs.location
cd $HERE