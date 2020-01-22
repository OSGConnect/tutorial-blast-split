#!/bin/bash
  
# get input file from arguments
inputfile=$1

# load stashcp module
module load stashcache

# download database and unzip into new dir
mkdir pdbaa
stashcp /osgconnect/public/jmvera/pdbaa.tar.gz ./
tar -xzvf pdbaa.tar.gz -C pdbaa
rm pdbaa.tar.gz

# run blast query on input file
./blastx -db pdbaa/pdbaa -query $inputfile -out $inputfile.result
