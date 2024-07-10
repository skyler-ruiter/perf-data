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
   
   srun -n 1 --gpus 1 --gpu-bind=closest -c 128 ./theta-nlev128-kokkos < ${nlname}

   ff=time-theta-xx-HY-weaver-ne${ne}-nmax${nmax}.${SLURM_JOB_ID}
   cp ${nlname} $ff
   head -n 50 HommeTime_stats >> $ff
   #this is for flags
   #head -n 50 ${xff} >> $ff
   rm HommeTime_stats

done

