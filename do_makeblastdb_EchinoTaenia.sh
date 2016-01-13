makeblastdb -in ~/blastplus_databases/Echino_rearr.fna \
-input_type fasta \
-dbtype nucl \
-parse_seqids \
-hash_index   \
-logfile ~/blastplus_databases/log_makeblastdb_echino_dec07.txt \
-out ~/blastplus_databases/Echino_taeniae_nov2011/echino_taenia__mito_refseq_nov2011 \
-title "Echinococcus and Taenia Mitochondria, RefSeq, Nov 2011"
