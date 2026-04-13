# give me the directory name as argument
echo "----------------------------------------------------------------"
echo "maketar.sh"
export HERE=`pwd`
# put the tar file on a bigger disk 
export THERE=/exp/dune/data/users/$USER/
cd .. # go up one from current directory
date
if [ "$1" == "" ] ; then
    echo "need to enter the directory name and be in that directory"
else 
    echo " make tar file from $1, excluding build_slf7... "
    tarname=$(basename $1)
    echo "$tarname"
    tar --exclude '.git' --exclude build_slf7.x86_64  -cf ${THERE}/${tarname}.tar $1
    date
    echo " gzip step "
    gzip -f $THERE/${tarname}.tar
    date
    echo " tar file is at $THERE/${tarname}.tar.gz"
    cd $HERE
    echo "----------------------------------------------------------------"
fi

