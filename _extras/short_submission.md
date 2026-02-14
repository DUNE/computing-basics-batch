---
title: Short submission with your own code
---

## this collects the sequence of steps for a batch submission with local code which produces both an artroot and root file

### in your top level mrb directory

For example `/exp/dune/app/users/$USER/myworkarea`

need to have a name for it as you will be making a tarball

~~~
export DIRECTORY=myworkarea
~~~

### copy these scripts into that top level directory

You can access a tarball with them all [here](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/files/usefulcode.tar). 

Download that tarball into the top level directory for your build and `tar xBf usefulcode.tar` to get the code.

Here are links to each of the scripts. 

[setup-grid](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/setup-grid) (should not need to modify)

[maketar.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/maketar.sh) 
(should not need to modify)

[makerdcs.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/makerdcs.sh) (should not need to modify)

[job_config.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/job_config.sh)  (you modify this to choose things like MQL query, number of events..)

[setup_before_submit.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/setup_before_submit.sh) (customize versions for your code)

[submit_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow.sh) (modify running time and memory)

[test_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/test_workflow.sh) (script to do interactive tests of your jobscript)


[extractor_new.py](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/extractor_new.py) (this makes metadata for your files)

[submit_local_code.jobscript.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_local_code.jobscript.sh) (may need to modify if expert)



### modify two script (should not need to change the others)

edit `setup_before_submit.sh` if you change code versions and `job_config.sh` if you change more temporary things like fcl files . 

- choose your code version (code version has to match your build)
- *make certain the fcl file is either in the fcl path or in `$DIRECTORY`*
- add a string `APP_NAME` that will go in your filename
- add a description in `DESCRIPTION`

Then run it to set things up

~~~
source setup_before_submit.sh # sets up larsoft
~~~

### from $DIRECTORY make a tarball and put in rcds

If you have changed any scripts or code, you must redo this. 

~~~
./maketar.sh $DIRECTORY
./makercds.sh $DIRECTORY
~~~

will take a while, produce a tarball on `/exp/dune/data/users` and put the cvmfs location in cvmfs.location in `$DIRECTORY`

Then edit `job_config.sh` to reflect the # of events you want and other run-time parameters.

### Submit the job

[submit_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow.sh)

~~~
./submit_workflow.sh
~~~

should get a workflow number back

go to [justin](https://dunejustin.fnal.gov/dashboard/?method=list-workflows)

to track your job.

[internal link](/files/setup-grid)




