# give me the directory name as argument
echo "----------------------------------------------------------------"
echo "maketar.sh"
export HERE=`pwd`
# put the tar file on a bigger disk 
export THERE=/exp/dune/data/users/$USER/
cd .. # go up one from current directory
date
echo " make tar file"
tar --exclude '.git' --exclude build_slf7.x86_64  -cf $THERE/$1.tar $1
date
echo " gzip step "
gzip -f $THERE/$1.tar
date
echo " tar file is at $THERE/$1.tar.gz"
echo "----------------------------------------------------------------"
