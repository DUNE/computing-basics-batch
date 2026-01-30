---
title: Short Submission
---

## this collects the sequence of steps for a batch submission with local code

### in your top level mrb directory

For example `/exp/dune/app/users/$USER/myworkarea`

need to have a name for it as you will be making a tarball

~~~
export DIRECTORY=myworkarea
~~~

copy these scripts into that top level directory

- setup-grid

~~~
{% include setup-grid %}
~~~

- setup-local

~~~
{% include setup-local %}
~~~

- makercds

~~~
{% include makercds.sh %}
~~~

- submit_workflow.sh

~~~
{% include submit_workflow.sh %}
~~~


- submit_local_code.jobscript.sh

~~~
{% include submit_local_code.jobscript.sh %}
~~~

### modify this script (should not need to change the others)


- choose your code version and fcl file 
- make certain the fcl file is either in the fcl path or in `$DIRECTORY`
- add a string `PROCESS_TYPE` that will go in your filename


#### setup_before_submit.sh

~~~
{% include setup_before_submit.sh %}
~~~

Then run it to set things up

~~~
source setup_before_submit.sh
~~~

### from DIRECTORY make a tarball and put in rcds

If you have changed any scripts or code, you must redo this. 

~~~
./makercds.sh $DIRECTORY
~~~

will take a while, produce a tarball on /exp/dune/data and put the cvmfs location in cvmfs.location

### Submit the job

~~~
./submit_workflow.sh
~~~

should get a workflow number back

go to [justin](https://dunejustin.fnal.gov/dashboard/?method=list-workflows)

to track your job.






