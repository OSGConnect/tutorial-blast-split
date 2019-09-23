#!/bin/bash

# retrieved from: ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/
wget http://stash.osgconnect.net/~ckoch5/blast/ncbi-blast-2.9.0+-x64-linux.tar.gz
# retrieved from ftp://ftp.ncbi.nlm.nih.gov/blast/db/
#wget http://stash.osgconnect.net/~ckoch5/blast/pdbaa.tar.gz
wget http://stash.osgconnect.net/~ckoch5/blast/gt-1.5.10-Linux_x86_64-64bit-complete.tar.gz
wget http://stash.osgconnect.net/~ckoch5/blast/mouse_rna.tar.gz

tar -xzf ncbi-blast-2.9.0+-x64-linux.tar.gz
tar -xzf mouse_rna.tar.gz
tar -xzf gt-1.5.10-Linux_x86_64-64bit-complete.tar.gz

rm ncbi-blast-2.9.0+-x64-linux.tar.gz mouse_rna.tar.gz gt-1.5.10-Linux_x86_64-64bit-complete.tar.gz
