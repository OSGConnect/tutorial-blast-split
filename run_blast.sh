#!/bin/bash

# get input file from arguments
inputfile=$1

# download database and unzip
stashcp /user/ckoch5/public/blast/pdbaa.tar.gz ./
tar -xzvf pdbaa.tar.gz
rm pdbaa.tar.gz

# run blast query on input file
./blastx -db pdbaa/pdbaa -query $inputfile -out $inputfile.result
