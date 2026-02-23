---
title: Short submission with your own code
---

## this collects the sequence of steps for a batch submission with local code which produces both an artroot and root file.

It splits out different functions so you need to examine/adapt all of the support scripts which can be found [here](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/files/usefulcode.tar). 

This sequence assumes you are in your top level mrb directory.

### in your top level mrb directory


For example `/exp/dune/app/users/$USER/myworkarea`

need to have a name for it as you will be making a tarball

~~~
export DIRECTORY=myworkarea
~~~
{: ..language-bash}

### copy these scripts into that top level directory

You can access a tarball with them all [here](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/files/usefulcode.tar). 

Download that tarball into the top level directory for your build and

~~~
tar xBf usefulcode.tar
~~~
{: ..language-bash}

 to get the code.

### here are the scripts.. 

#### utilities you need

- [setup-grid](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/setup-grid) (should not need to modify)
This replaces `setup` in your local_build directory.

- [maketar.sh $DIRECTORY](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/maketar.sh) 
(should not need to modify)
This takes the contents of `$DIRECTORY` and makes a tarball in `/exp/data/users/$USER/`

- [makerdcs.sh $DIRECTORY](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/makerdcs.sh) (should not need to modify)
This takes the tarball and copies it to /cvmfs/ where grid jobs can find it.  It places the location in the file `$DIRECTORY/cvmfs.location` so you can find it. 

#### setup scripts

- [setup_before_submit.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/setup_before_submit.sh) (customize versions for your code)
You need to modify this to reflect the code version you are setting up. Normally only need to run/modify this once/session.


- [job_config.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/job_config.sh)  (you modify this to reflect your workflow.  Sets things like $FCL_FILE). This sets up essential job parameters.  You need to understand and modify these appropriately for your purpose. 

#### Script to test and submit jobs

- [test_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/test_workflow.sh) (script to do interactive tests of your jobscript)

- [submit_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow.sh) (writes output to scratch. Modify running time and memory)

- [submit_workflow_rucio.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow_rucio.sh) (writes output to rucio. Modify running time and memory)


#### scripts that run on the remote machine

[extractor_new.py](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/extractor_new.py) (this makes metadata for your files)

[submit_local_code.jobscript.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_local_code.jobscript.sh) (may need to modify if expert)



## How to run these scripts

### modify two-three scripts (should not need to change the others)

edit 

- `setup_before_submit.sh` if you change code versions and 
- `job_config.sh` if you change more temporary things like fcl files. 

- choose your code version (code version has to match your build)
- *make certain the fcl file is either in the fcl path or in `$DIRECTORY`*
- add a string `APP_TAG` that will go in your filename
- add a description in `DESCRIPTION`

Then run those scripts to set things up

~~~
source setup_before_submit.sh # sets up larsoft
~~~

### from $DIRECTORY make a tarball and put in rcds

If you have changed any scripts or code, you must redo this. 

~~~
./maketar.sh $DIRECTORY
./makercds.sh $DIRECTORY
~~~
{: ..language-bash}

will take a while, produce a tarball on `/exp/dune/data/users/$USER/` and put the cvmfs location in cvmfs.location in `$DIRECTORY`

### Configure your job with job_config.sh

Then edit `job_config.sh` to reflect the # of events you want and other run-time parameters.

#### Details of job_config.sh

Here is what is in job_config.sh
~~~
{% include job_config.sh %}
~~~

- `FCL_FILE`= the top level fcl file - assumes it is in DIRECTORY or in the `PHICL_FILE_PATH`
- `OUTPUT_DATA_TIER1` data_tier for artroot output (full-reconstructed, ...)
- `OUTPUT_DATA_TIER2` data_tier for root output - normally plain root-tuple
- `MQL` Metacat query that you wish to run over
- `APP_TAG` this is a tag that goes into the output filename, like reco2, ana ...
- `DESCRIPTION` the jobname that shows up in justIN
- `USERF`  make certain the grid knows who your are without overwriting whatever internal `USER` it has
- `NUM_EVENTS`  the `-n` argument of larsoft
- `FNALURL` sends output to subdirectories of your area on scratch
- `NAMESPACE`  rucio/metacat namespace for your output, normally `usertests` or possibly your username or physics group unless you are doing production. 


### Test your jobscript interactively

[test_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/test_workflow.sh)

results will show up in the 'tmp' area on your local machine. 


### Submit the job

[submit_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow.sh)

This one writes to `/pnfs/dune/scratch`

~~~
./submit_workflow.sh
~~~
{: ..language-bash}

[submit_workflow_rucio.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow_rucio.sh)

This one writes to a rucio location specified by `$NAMESPACE`

~~~
./submit_workflow_rucio.sh
~~~
{: ..language-bash}

### after submission

You should get a workflow number back

go to [justin](https://dunejustin.fnal.gov/dashboard/?method=list-workflows)

to track your job.
