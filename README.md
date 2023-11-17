---
ospool:
    path: software_examples/bioinformatics/tutorial-blast-split/README.md
---

# High-Throughput BLAST

This tutorial will put together several OSG tools and ideas - handling a larger 
data file, splitting a large file into smaller pieces, and transferring a portable 
software program. 

## Job components and plan

To run BLAST, we need three things: 

1. the BLAST program (specifically the `blastx` binary)
2. a reference database (this is usually a larger file)
3. the input file we want to query against the database

The database and the input file will each get special treatment. 

The input file is large enough that 
a) it is near the upper limit of what is practical to transfer, 
b) it would take hours to complete a single `blastx` analysis for it, and 
c) the resulting output file would be huge. 
While we may technically be able to use the input file as it is, in practice it is much more 
effective to split the input file into smaller pieces and run one job per piece. 
In this case, because the BLAST program processes the contents of the input file line by line, 
splitting apart the input file will have no affect on the final results.
While we will need to combine the results of the many individual jobs to achieve the results, 
we gain a large advantage because the smaller jobs can be distributed across many computers.

The database we are using is large enough that we will want to use the 
[OSDF](https://portal.osg-htc.org/documentation/htc_workloads/managing_data/osdf/) to handle the file transfer.
Unlike the input file, BLAST databases should not be split because the BLAST output includes 
a score value for each sequence that is calculated relative to the entire length of the database.

## Get materials and set up files

Run the tutorial command:

	tutorial blast-split

Once the tutorial has downloaded, move into the folder and run the `download_files.sh` script to download the remaining files: 

	cd tutorial-blast-split
	./download_files.sh

This command will have downloaded and unzipped the BLAST program (`ncbi-blast-2.9.0+`), the file we want to query 
(`mouse_rna.fa`) and a set of tools that will split the file into smaller pieces
(`gt-1.5.10-Linux_x86_64-64bit-complete`).

Next, we will use the command `gt` from the `genome tools` package to split our input query file into 2 MB chunks as indicated by the -targetsize flag. To split the file, run this command: 

	./gt-1.5.10-Linux_x86_64-64bit-complete/bin/gt splitfasta -targetsize 2 mouse_rna.fa

Later, we'll need a list of the split files, so run this command to generate that list: 

	ls mouse_rna.fa.* > list.txt

## Examine the submit file

The submit file, `blast.submit` looks like this: 

	executable = run_blast.sh
	arguments = $(inputfile)
	transfer_input_files = ncbi-blast-2.9.0+/bin/blastx, $(inputfile), stash:///osgconnect/public/osg/BlastTutorial/pdbaa.tar.gz

	output = logs/job_$(process).out
	error = logs/job_$(process).err
	log = logs/job_$(process).log

	requirements = OSGVO_OS_STRING == "RHEL 7" && Arch == "X86_64"

	request_memory = 2GB
	request_disk = 1GB
	request_cpus = 1

	queue inputfile from list.txt

The executable `run_blast.sh` is a script that runs blast and takes in a file to 
query as its argument. We'll look at this script in more detail in a minute. 

Our job will need to transfer the `blastx` executable and the input file being used for 
queries, shown in the `transfer_input_files` line. Because of the size of our database, 
we'll be using `stash:///` to transfer the database to our job.

> Note on `stash:///`: In this job, we're copying the file from a particular 
> `/public` folder (`osg/BlastTutorialV1`), but you have your own `/public` folder that you 
> could use for the database. If you wanted to try this, you would want to navigate to your `/public` folder, download the 
> `pdbaa.tar.gz` file, return to your `/home` folder, and change the path in the `stash:///`
> command above. This might look like: 
> 
>    cd /public/username
>    wget http://stash.osgconnect.net/public/osg/BlastTutorialV1/pdbaa.tar.gz
>    cd /home/username

Finally, you may have already noticed that instead of listing the individual input file 
by name, we've used the following syntax: `$(inputfile)`. This is a variable that represents 
the name of an individual input file. We've done this so that we can set the variable as 
a different file name for each job. 

We can set the variable by using the `queue` syntax shown at the bottom of the file: 

	queue inputfile from list.txt

This command will pull file names from the `list.txt` file that we created earlier, and 
submit one job per file and set the "inputfile" variable to that file name. 

## Examine the wrapper script

The submit file had a script called `run_blast.sh`: 

	#!/bin/bash

	# get input file from arguments
	inputfile=$1
	
	# Prepare our database and unzip into new dir
	tar -xzvf pdbaa.tar.gz
	rm pdbaa.tar.gz

	# run blast query on input file
	./blastx -db pdbaa/pdbaa -query $inputfile -out $inputfile.result

It saves the name of the input file, unpacks our database, and then 
runs the BLAST query from the input file we transferred and used as the argument. 

## Submit the jobs

Our jobs should be set and ready to go. To submit them, run this command:

	condor_submit blast.submit

And you should see that 51 jobs have been submitted: 

	Submitting job(s)................................................
	51 job(s) submitted to cluster 90363.

You can check on your jobs' progress using `condor_q`

## Bonus: a BLAST workflow

We had to go through multiple steps to run the jobs above. There was an initial 
step to split the files and generate a list of them; then we submitted the jobs. These 
two steps can be tied together in a workflow using the HTCondor DAGMan workflow tool. 

First, we would create a script (`split_files.sh`) that does the file splitting steps: 

	#!/bin/bash
	
	filesize=$1
	./gt-1.5.10-Linux_x86_64-64bit-complete/bin/gt splitfasta -targetsize $filesize mouse_rna.fa
	ls mouse_rna.fa.* > list.txt

This script will need executable permissions:

	chmod +x split_files.sh

Then, we create a DAG workflow file that ties the two steps together: 

	## DAG: blastrun.dag
	JOB blast blast.submit
	SCRIPT PRE blast split_files.sh 2

To submit this DAG, we use this command: 

	condor_submit_dag blastrun.dag


[stashcache]: https://support.opensciencegrid.org/support/solutions/articles/12000002775-transferring-data-with-stashcache
