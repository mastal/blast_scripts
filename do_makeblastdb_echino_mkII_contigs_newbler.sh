#!/bin/bash

# do_makeblastdb_echino_mkII_contigs_newbler.sh

# 08/03/2012 modified to make blastdb with newbler contigs; 

# make blastdabases with contigs from the assembly;
# blast the genomes (query) against the contigs database;
# so need to make a database for each assembly;

# set up variables
# path to newbler results
newbler_base=/home/stalteri/newbler_results/newbler_Echino_mkII

# path to blast databases
database_dir=/home/stalteri/blastplus_databases/Echino_v2_contigs/Echino_v2_newbler

# have 9 newbler assemblies
# 3 runs of newbler (which are identical)  on each of flowsim datasets 1, 2, and 3
# only need one loop

# loop over the 3 flowsim data sets
let i=0
for d in `cat newb_files_echino_mkII.txt`
do 
        
        newbler_dir=`echo -n $d`
        let i=i+1        

        # make each database in its own directory

        makeblastdb -in ${newbler_base}/${newbler_dir}/454AllContigs.fna  \
        -input_type fasta \
        -dbtype nucl \
        -parse_seqids \
        -hash_index   \
        -logfile ${database_dir}/log_makeblastdb_echino_v2_newbler_sim${i}_run1.txt \
        -out ${database_dir}/Echino_v2_sim${i}_newbler_run1/Echinov2_sim${i}_newbler1   \
        -title "Newbler Contigs, Echino v2, Sim${i} Run1"

done
