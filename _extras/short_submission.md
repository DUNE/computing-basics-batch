---
title: Short submission with your own code
---

## this collects the sequence of steps for a batch submission with local code

### in your top level mrb directory

For example `/exp/dune/app/users/$USER/myworkarea`

need to have a name for it as you will be making a tarball

~~~
export DIRECTORY=myworkarea
~~~

### copy these scripts into that top level directory


[setup-grid](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/setup-grid) (should not need to modify)

[maketar.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/maketar.sh) 
(should not need to modify)

[makerdcs.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/makerdcs.sh) (should not need to modify)

[setup_before_submit.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/setup_before_submit.sh) (customize for your code)

[submit_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow.sh) (modify running time and memory)

[submit_local_code.jobscript.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_local_code.jobscript.sh) (may need to modify if expert)



### modify one script (should not need to change the others)

edit `setup_before_submit.sh` to reflect the parameters you need. 

- choose your code version and fcl file (code version has to match your build)
- *make certain the fcl file is either in the fcl path or in `$DIRECTORY`*
- add a string `PROCESS_TYPE` that will go in your filename
- add a description in `DESCRIPTION`




Then run it to set things up

~~~
source setup_before_submit.sh
~~~

### from DIRECTORY make a tarball and put in rcds

If you have changed any scripts or code, you must redo this. 

~~~
./maketar.sh $DIRECTORY
./makercds.sh $DIRECTORY
~~~

will take a while, produce a tarball on /exp/dune/data and put the cvmfs location in cvmfs.location in `$DIRECTORY`

### Submit the job

[submit_workflow.sh](https://github.com/hschellman/computing-basics-batch-devel/blob/gh-pages/_includes/submit_workflow.sh)

~~~
./submit_workflow.sh
~~~

should get a workflow number back

go to [justin](https://dunejustin.fnal.gov/dashboard/?method=list-workflows)

to track your job.

[internal link](/files/setup-grid)




