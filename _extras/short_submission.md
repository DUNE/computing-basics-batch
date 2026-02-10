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

copy these scripts into that top level directory

> ## setup-grid
{: .callout}

~~~
{% include setup-grid %}
~~~

<!-- - setup-local

~~~
{% include setup-local %}
~~~ -->

> ## setup_before_submit.sh
{: .callout}
~~~
{% include setup_before_submit.sh %}
~~~

> ## maketar
{: .callout}

~~~
{% include maketar.sh %}
~~~

> ## makercds
{: .callout}

~~~
{% include makercds.sh %}
~~~

> ## submit_workflow.sh
{: .callout}

~~~
{% include submit_workflow.sh %}
~~~


> ## submit_local_code.jobscript.sh
{: .callout}
~~~
{% include submit_local_code.jobscript.sh %}
~~~


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

~~~
./submit_workflow.sh
~~~

should get a workflow number back

go to [justin](https://dunejustin.fnal.gov/dashboard/?method=list-workflows)

to track your job.

[internal link](/files/setup-grid)




