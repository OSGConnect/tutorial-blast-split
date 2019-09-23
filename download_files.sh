#!/bin/bash

# retrieved from: ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/
wget http://proxy.chtc.wisc.edu/SQUID/osgschool19/ncbi-blast-2.9.0+-x64-linux.tar.gz
# retrieved from ftp://ftp.ncbi.nlm.nih.gov/blast/db/
#wget http://proxy.chtc.wisc.edu/SQUID/osgschool19/pdbaa.tar.gz
wget http://proxy.chtc.wisc.edu/SQUID/osgschool19/gt-1.5.10-Linux_x86_64-64bit-complete.tar.gz
wget http://proxy.chtc.wisc.edu/SQUID/osgschool19/mouse_rna.tar.gz

tar -xzf ncbi-blast-2.9.0+-x64-linux.tar.gz
tar -xzf mouse_rna.tar.gz
tar -xzf gt-1.5.10-Linux_x86_64-64bit-complete.tar.gz

rm ncbi-blast-2.9.0+-x64-linux.tar.gz mouse_rna.tar.gz gt-1.5.10-Linux_x86_64-64bit-complete.tar.gz
