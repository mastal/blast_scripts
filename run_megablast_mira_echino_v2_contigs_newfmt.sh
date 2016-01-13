#!/bin/bash

# run_megablast_mira_echino_v2_contigs_newfmt.sh
# 12/03/2012
# Maria Stalteri

# 12/03/2012 modified to run on the databases with the mira contigs

# 10/03/2012 output formats modified after doing several test runs
# decided to use megablast instead of blastn;
# use eval 1.e-300, percent identity 90.00;
# tabular output to include cols qlen, slen, nident, gaps;
# exclude cols score, btop;

# 09/03/2012 modified to run blast using the contigs databases

# 05/03/2012 modified to run the echino_v2 results;
# modified to do 3 steps - adding a step that extracts
# blast xml format from the asn format;

# script to automate running megablast with results of mira assembly;
# Have results from 9 mira runs:

# the main steps are:
# 1. run megablast, using the NCBI genomes as query and the contig databases for the 
#    appropriate mira run
# 2. extract xml format output from the blast asn output;
# 3. extract table format output from the blast asn output

# initialise variables with path to directories for input/output files
query_file=/home/stalteri/blastplus_databases/18Echino_NCBI_MkII.fna

results_dir=/home/stalteri/blast_contigs_results/Echino_v2_contigs/Echino_v2_mira_contigs

blast_dir=/home/stalteri/blastplus_databases/Echino_v2_contigs/Echino_v2_mira

# run megablast from the output  directory
cd $results_dir

# need 2 loops for mira, cap3
# loop over the flowsim simulations

for i in 1 2 3
do
    # loop over the assembler runs for each simulation
    for j in 1 2 3     
    do       
        # run megablast
        # use a cutoff for evalue, so hopefully I won't get all the short
        # or low percent identity alignments
        # e-100 still gave lots of low-scoring hits, try e-200
        # tried 1.e-300 in the test runs

        # try running both blastn and megablast, see if there is a difference

        blastn -task megablast \
        -db ${blast_dir}/Echino_v2_sim${i}_mira${j}/Echinov2_sim${i}_mira${j} \
        -query $query_file \
        -evalue 1.e-300 \
        -perc_identity 90.00 \
        -parse_deflines \
        -out out.megablast_echinov2_contigdb_mira${j}_sim${i}_new_par.asn \
        -outfmt 11 

        # comment out the blastn for now
  #      blastn -task blastn \
  #      -db ${blast_dir}/Echino_v2_sim${i}_mira${j}/Echinov2_sim${i}_mira${j} \
  #      -query $query_file \
  #      -evalue 1.e-300 \
  #      -perc_identity 90.00 \
  #      -parse_deflines \
  #      -out out.blastn_echinov2_contigdb_mira${j}_sim${i}_new_par.asn \
  #     -outfmt 11
 

        # make the program pause before going on to next step
        sleep 60

        # extract the blast xml format output from the megablast asn file
        blast_formatter -archive ./out.megablast_echinov2_contigdb_mira${j}_sim${i}_new_par.asn \
        -outfmt 5  \
        -out megablast_echinov2_contigdb_mira${j}_sim${i}.xml \
        -parse_deflines

        # not running blastn at the moment
        # extract the blast xml format output from the blastn asn file
  #      blast_formatter -archive ./out.blastn_echinov2_contigdb_mira${j}_sim${i}.asn \
  #      -outfmt 5  \
  #      -out blastn_echinov2_contigdb_mira${j}_sim${i}.xml \
  #      -parse_deflines


        # modify tabular output to also give no. of gaps, not just gap opens;
        # extract the blast table format, from the megablast asn output
        # get columns for qlen, slen, nident, gaps
        blast_formatter -archive ./out.megablast_echinov2_contigdb_mira${j}_sim${i}_new_par.asn \
        -outfmt "7 qseqid qlen sseqid slen pident length nident mismatch gapopen gaps qstart qend sstart send evalue bitscore" \
        -out megablast_echinov2_contigdb_mira${j}_sim${i}_new_par.txt \
        -parse_deflines

        # not running blastn at the moment
        # extract the blast table format, with btop, from the blastn asn output
  #      blast_formatter -archive ./out.blastn_echinov2_contigdb_mira${j}_sim${i}.asn \
  #      -outfmt "7 qseqid qlen sseqid slen pident length nident mismatch gapopen gaps qstart qend sstart send evalue bitscore" \
  #      -out blastn_echinov2_contigdb_mira${j}_sim${i}_new_par.txt \
  #      -parse_deflines

        
        # make the program pause 60 seconds before starting next round of loop
        sleep 60

    done
done

