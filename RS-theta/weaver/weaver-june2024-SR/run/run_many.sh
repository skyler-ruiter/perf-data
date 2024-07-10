nmax=500
mode=".true."
ttype=5
wdir=`pwd`
exec=theta-nlev128-kokkos

#for ne in 2 3 ; do
for ne in 2 3 4 6 10 15 16 18 24; do

   nlname=xx-thetaHY-ne${ne}.nl

   sed -e s/NE/${ne}/ -e s/NMAX/${nmax}/ -e s/MODE/${mode}/ -e s/TTYPE/${ttype}/  \
        xxinput-theta-rs.nl > ${nlname};

   #MACHINE DEPENDANT
   #for weaver --  mpiexex … 1 GPU
   mpiexec --map-by ppr:1:node:pe=1 --bind-to core ./theta-nlev128-kokkos < ${nlname}
   
   # srun -l -K -n 1 --gpus-per-node=8  --gpu-bind=closest -c 1 ./theta-nlev128-kokkos < ${nlname}

   ff=time-theta-xx-HY-weaver-ne${ne}-nmax${nmax}.${LSB_JOBID}
   cp ${nlname} $ff
   head -n 50 HommeTime_stats >> $ff
   #this is for flags
   #head -n 50 ${xff} >> $ff
   rm HommeTime_stats

done
