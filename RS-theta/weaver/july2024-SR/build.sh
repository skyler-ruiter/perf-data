#!/bin/bash
 
machine="weaver"
run="perf"

source ~/load-${machine}
 
suffix="-gpu"
 
wdir=`pwd`
HOMME=${HOME}/E3SM/components/homme     
echo $HOMME
bld=$wdir/runRS${suffix}
MACH=$HOMME/cmake/machineFiles/${machine}.cmake

qsize=40

mkdir -p $bld
cd $bld

rm -rf CMakeFiles CMakeCache.txt src
echo "running CMAKE to configure the model"

# Compile and Make Homme Build
cmake -C $MACH $HOMME 
make -j32 theta-nlev128-kokkos
 
cd ${wdir}
rm -f gitstat-* CMakeCache.txt-* KokkosCore_config.h-* env-*
 
gitstat=gitstat

cd ${HOMME}
pwd
 
# Collecting Git Info
echo " running stats on clone ${which}"
echo " status is ------------- " > ${gitstat}
git status >> ${gitstat}
echo " branch is ------------- " >> ${gitstat}
git branch >> ${gitstat}
echo " diffs are ------------- " >> ${gitstat}
git diff >> ${gitstat}
echo " last 10 commits are ------------- " >> ${gitstat}
git log --first-parent  --pretty=oneline  HEAD~10..HEAD  >> ${gitstat}
cd $wdir
pwd
 
# Date/Time Provenence
tt=`date +%s`

# Git Provenence
mv ${HOMME}/${gitstat} gitstat-${tt}

# Cmake and Kokkos Provenence
cp ${bld}/CMakeCache.txt CMakeCache.txt-${tt}
cp ${bld}/externals/kokkos/KokkosCore_config.h KokkosCore_config.h-${tt} 

# Environment Provenence
rm -rf env-${tt}
env > env-${tt} 2>&1
