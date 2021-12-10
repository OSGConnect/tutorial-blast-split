#!/bin/bash
  
# get input file from arguments
inputfile=$1

# Prepare our database
tar -xzvf pdbaa.tar.gz
rm pdbaa.tar.gz

# run blast query on input file
./blastx -db pdbaa/pdbaa -query $inputfile -out $inputfile.result
