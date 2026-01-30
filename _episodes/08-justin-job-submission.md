---
title: Jobsub Grid Job Submission and Common Errors - justIn Version
teaching: 65
exercises: 0
questions:
- How to submit grid jobs?
objectives:
- Submit a basic batchjob and understand what's happening behind the scenes
- Monitor the job and look at its outputs
- Review best practices for submitting jobs (including what NOT to do)
keypoints:
- When in doubt, ask! Understand that policies and procedures that seem annoying, overly complicated, or unnecessary (especially when compared to running an interactive test) are there to ensure efficient operation and scalability. They are also often the result of someone breaking something in the past, or of simpler approaches not scaling well.
- Send test jobs after creating new workflows or making changes to existing ones. If things don't work, don't blindly resubmit and expect things to magically work the next time.
- Only copy what you need in input tar files. In particular, avoid copying log files, .git directories, temporary files, etc. from interactive areas.
- Take care to follow best practices when setting up input and output file locations.
- Always, always, always prestage input datasets. No exceptions.
---

<!-- > ## Note: 
> This section describes basic job submission. Large scale submission of jobs to read DUNE data files are described in the [next section]({{ site.baseurl }}/08-submit-jobs-w-justin/index.html). -->

#### Session Video

This session will be captured on video a placed here after the workshop for asynchronous study.
<!-- The session was video captured for your asynchronous review. -->
The video from the two day version of this training in May 2022 is provided [here](https://www.youtube.com/embed/QuDxkhq64Og) as a reference.

<!--
<center>
<iframe width="560" height="315" src="https://www.youtube.com/embed/QuDxkhq64Og" title="DUNE Computing Tutorial May 2022 Grid Job Submission and Common Errors" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</center>
-->

#### Live Notes

<!-- Participants are encouraged to monitor and utilize the [livedoc](https://docs.google.com/document/d/1QNK-hKPqLIVaecRyg9q4QZOHNwAZgq32oHVuboG_AvQ/edit?usp=sharing) to ask questions and learn.  For reference, the [Livedoc from Jan. 2023](https://docs.google.com/document/d/1sgRQPQn1OCMEUHAk28bTPhZoySdT5NUSDnW07aL-iQU/edit?usp=sharing) is provided. -->

<!-- #### Temporary Instructor Note: 

The May 2023 training event was cloned from the [May 2022](https://github.com/DUNE/computing-training-basics/blob/gh-pages/_episodes/), both two day events.

This lesson (07-grid-job-submission.md) was imported from the [Jan. 2023 lesson](https://github.com/DUNE/computing-training-basics-short/blob/gh-pages/_episodes/07-grid-job-submission.md) which was a one half day version of the training.

Quiz blocks are added at the bottom of this page, and invite your review, modify, review, and additional comments. -->

<!-- 
The official timetable for this training event is on the [Indico site](https://indico.fnal.gov/event/59762/timetable/#20230524). 
-->

<!-- ## Notes on changes in the 2023/2024 versions

The past few months have seen significant changes in how DUNE (as well as other FNAL experiments) submits jobs and interacts with storage elements. While every effort was made to preserve backward compatibility a few things will be slightly different (and some are easier!) than what's been shown at previous versions. Therefore even if you've attended this tutorial multiple times in past and know the difference between copying and streaming, tokens vs. proxies, and know your schedds from your shadows, you are encouraged to attend this session. Here is a partial list of significant changes:

* The jobsub_client product generally used for job submission has been replaced by the [jobsub_lite](https://fifewiki.fnal.gov/wiki/Jobsub_Lite)
 product, which is very similar to jobsub_client except there is no server on the other side (i.e. there is more direct HTCondor interaction). You no longer need to set up the jobsub_client product as part of your software setup; it is installed via RPM now on all DUNE interactive machines. See [this Wiki page](https://fifewiki.fnal.gov/wiki/Differences_between_jobsub_lite_and_legacy_jobsub_client/server) for some differences between jobsub_lite and legacy jobsub.
* __As of May 2024 you cannot submit batch jobs from SL7 containers but many submission scripts only run on SL7. You need to record the submission command from SL7 and the open a separate window running Alma9 and execute that command.__
* Authentication via tokens instead of proxies is now rolling out and is now the primary authentication method. Please note that not only are tokens used for job submission now, they are also used for storage element access.
* It is no longer possible to write to certain directories from grid jobs as analysis users, namely the persistent area. Read access to the full /pnfs tree is still available. Bulk copies of job outputs from scratch to persistent have to be done outside of grid jobs.
* Multiple `--tar_file_name` options are now supported (and will be unpacked) if you need things in multiple tarballs.
* The `-f` behavior with and without dropbox:// in front is slightly different from legacy jobsub; see the [documentation](https://fifewiki.fnal.gov/wiki/Differences_between_jobsub_lite_and_legacy_jobsub_client/server#Bug_with_-f_dropbox:.2F.2F.2Fa.2Fb.2Fc.tar) for details.
* jobsub_lite will probably not work directly from lxplus at the moment, though work is underway to make it possible to submit batch jobs to non-FNAL schedulers. -->

## Submit a job

Go to [The Justin Tutorial](https://dunejustin.fnal.gov/docs/tutorials.dune.md)

and work up to ["run some hello world jobs"](https://dunejustin.fnal.gov/docs/tutorials.dune.md#run-some-hello-world-jobs)

> ## Quiz 
>
> 1. What is your workflow ID?
>
{: .solution}

Then work through 

- [View your workflow on the justIN web dashboard](https://dunejustin.fnal.gov/docs/tutorials.dune.md#view-your-workflow-on-the-justin-web-dashboard)
- [Jobs with inputs and outputs](https://dunejustin.fnal.gov/docs/tutorials.dune.md#jobs-with-inputs-and-outputs)
- [Fetching files from Rucio managed storage](https://dunejustin.fnal.gov/docs/tutorials.dune.md#fetching-files-from-rucio-managed-storage)
- (skip for now) Jobs using GPUs
- [Jobs writing to scratch](https://dunejustin.fnal.gov/docs/tutorials.dune.md#jobs-writing-to-scratch)





## Submit a job using the tarball containing custom code

First off, a very important point: for running analysis jobs, **you may not actually need to pass an input tarball**, especially if you are just using code from the base release and you don't actually modify any of it. In that case, it is much more efficient to use everything from the release and refrain from using a tarball.
All you need to do is set up any required software from CVMFS (e.g. dunetpc and/or protoduneana), and you are ready to go.
If you're just modifying a fcl file, for example, but no code, it's actually more efficient to copy just the fcl(s) you're changing to the scratch directory within the job, and edit them as part of your job script (copies of a fcl file in the current working directory have priority over others by default).

Sometimes, though, we need to run some custom code that isn't in a release. 
We need a way to efficiently get code into jobs without overwhelming our data transfer systems.
We have to make a few minor changes to the scripts you made in the previous tutorial section, generate a tarball, and invoke the proper jobsub options to get that into your job.
There are many ways of doing this but by far the best is to use the Rapid Code Distribution Service (RCDS), as shown in our example.  

If you have finished up the LArSoft follow-up and want to use your own code for this next attempt, feel free to tar it up (you won't need anything besides the localProducts* and work directories) and use your own tar ball in lieu of the one in this example.
You will have to change the last line with your own submit file instead of the pre-made one.

First, we should make a tarball. Here is what we can do 

~~~
cd mybuild
tar --exclude '.git' -czf mybuild.tar.gz *
~~~

Follow the instructions at:

[rapid code distribution to jobs via cvmfs](https://dunejustin.fnal.gov/docs/tutorials.dune.md#rapid-code-distribution-to-jobs-via-cvmfs)

    




Before we continue, let's examine these files a bit. We will source the first one in our job script, and it will set up the environment for us.

~~~
#!/bin/bash                                                                                                                                                                                                      

DIRECTORY=mybuild
# we cannot rely on "whoami" in a grid job. We have no idea what the local username will be.
# Use the GRID_USER environment variable instead (set automatically by jobsub). 
USERNAME=${GRID_USER}

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh
export WORKDIR=${_CONDOR_JOB_SCRATCH} # if we use the RCDS the our tarball will be placed in $INPUT_TAR_DIR_LOCAL.
if [ ! -d "$WORKDIR" ]; then
  export WORKDIR=`echo .`
fi

source ${INPUT_TAR_DIR_LOCAL}/${DIRECTORY}/localProducts*/setup-grid 
mrbslp
~~~
{: .source}



As you can see, we have switched from the hard-coded directories to directories defined by environment variables; the `INPUT_TAR_DIR_LOCAL` variable will be set for us (see below).
Now, let's actually create our tar file. 

Note how we have excluded the contents of ".git" directories in the various packages, since we don't need any of that in our jobs. It turns out that the .git directory can sometimes account for a substantial fraction of a package's size on disk! 

Then submit another job (in the following we keep the same submit file as above):

```bash
jobsub_submit -G dune --mail_always -N 1 --memory=2500MB --disk=2GB --expected-lifetime=3h --cpu=1 --tar_file_name=dropbox:///exp/dune/app/users/<username>/sep2025tutorial.tar.gz --singularity-image /cvmfs/singularity.opensciencegrid.org/fermilab/fnal-wn-sl7:latest --append_condor_requirements='(TARGET.HAS_Singularity==true&&TARGET.HAS_CVMFS_dune_opensciencegrid_org==true&&TARGET.HAS_CVMFS_larsoft_opensciencegrid_org==true&&TARGET.CVMFS_dune_opensciencegrid_org_REVISION>=1105&&TARGET.HAS_CVMFS_fifeuser1_opensciencegrid_org==true&&TARGET.HAS_CVMFS_fifeuser2_opensciencegrid_org==true&&TARGET.HAS_CVMFS_fifeuser3_opensciencegrid_org==true&&TARGET.HAS_CVMFS_fifeuser4_opensciencegrid_org==true)' -e GFAL_PLUGIN_DIR=/usr/lib64/gfal2-plugins -e GFAL_CONFIG_DIR=/etc/gfal2.d file:///exp/dune/app/users/kherner/run_sep2025tutorial.sh
```

You'll see this is very similar to the previous case, but there are some new options: 

* `--tar_file_name=dropbox://` automatically **copies and untars** the given tarball into a directory on the worker node, accessed via the INPUT_TAR_DIR_LOCAL environment variable in the job.  The value of INPUT_TAR_DIR_LOCAL is by default $CONDOR_DIR_INPUT/name_of_tar_file_without_extension, so if you have a tar file named e.g. sep2025tutorial.tar.gz, it would be $CONDOR_DIR_INPUT/sep2025tutorial.
* Notice that the `--append_condor_requirements` line is longer now, because we also check for the fifeuser[1-4]. opensciencegrid.org CVMFS repositories.  

The submission output will look something like this:

~~~
Attempting to get token from https://htvaultprod.fnal.gov:8200 ... succeeded
Storing bearer token in /tmp/bt_token_dune_Analysis_11469
Using bearer token located at /tmp/bt_token_dune_Analysis_11469 to authenticate to RCDS
Checking to see if uploaded file is published on RCDS
Could not locate uploaded file on RCDS.  Will retry in 30 seconds.
Could not locate uploaded file on RCDS.  Will retry in 30 seconds.
Could not locate uploaded file on RCDS.  Will retry in 30 seconds.
Found uploaded file on RCDS.
Transferring files to web sandbox...
Copying file:///nashome/k/kherner/.cache/jobsub_lite/js_2023_05_24_224713_9669e535-daf9-496f-8332-c6ec8a4238d9/run_sep2025tutorial.sh   [DONE]  after 0s                                                                                                                       
Copying file:///nashome/k/kherner/.cache/jobsub_lite/js_2023_05_24_224713_9669e535-daf9-496f-8332-c6ec8a4238d9/simple.cmd   [DONE]  after 0s                                                                                                                                   
Copying file:///nashome/k/kherner/.cache/jobsub_lite/js_2023_05_24_224713_9669e535-daf9-496f-8332-c6ec8a4238d9/simple.sh   [DONE]  after 0s                                                                                                                                    
Submitting job(s).
1 job(s) submitted to cluster 62007523.

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Use job id 62007523.0@jobsub01.fnal.gov to retrieve output
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
~~~

Note that the job submission will pause while it uploads the tarball to RCDS, and then it continues normally.

Now, there's a very small gotcha when using the RCDS, and that is when your job runs, the files in the unzipped tarball are actually placed in your work area as symlinks from the CVMFS version of the file (which is what you want since the whole point is not to have N different copies of everything).
The catch is that if your job script expected to be able to edit one or more of those files within the job, it won't work because the link is to a read-only area.
Fortunately there's a very simple trick you can do in your script before trying to edit any such files: 

~~~
cp ${INPUT_TAR_DIR_LOCAL}/file_I_want_to_edit mytmpfile  # do a cp, not mv
rm ${INPUT_TAR_DIR_LOCAL}file_I_want_to_edit # This really just removes the link
mv mytmpfile file_I_want_to_edit # now it's available as an editable regular file.
~~~

You certainly don't want to do this for every file, but for a handful of small text files this is perfectly acceptable and the overall benefits of copying in code via the RCDS far outweigh this small cost. 
This can get a little complicated when trying to do it for things several directories down, so it's easiest to have such files in the top level of your tar file. 

<!--
## Video Session Part 2 of 2

The session will be captured on video a placed here after the workshop for asynchronous study.
-->

<!--<center>
<iframe width="560" height="315" src="https://www.youtube.com/embed/L3dx-NQJvp8" title="DUNE Computing Tutorial May 2021 Day 2 Grid Job Submission and Common Errors Part 2" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</center>-->

## Monitor your jobs
For all links below, log in with your FNAL Services credentials (FNAL email, not Kerberos password).

* What DUNE is doing overall:  
[https://fifemon.fnal.gov/monitor/d/000000053/experiment-batch-details?orgId=1&var-experiment=dune](https://fifemon.fnal.gov/monitor/d/000000053/experiment-batch-details?orgId=1&var-experiment=dune)


* What's going on with only your jobs:   
Remember to change the url with your own username and adjust the time range to cover the region of interest.
[https://fifemon.fnal.gov/monitor/d/000000116/user-batch-details?orgId=1&var-cluster=fifebatch&var-user=kherner](https://fifemon.fnal.gov/monitor/d/000000116/user-batch-details?orgId=1&var-cluster=fifebatch&var-user=kherner)

* Why your jobs are held:  
Remember to choose your username in the upper left.  
[https://fifemon.fnal.gov/monitor/d/000000146/why-are-my-jobs-held?orgId=1](https://fifemon.fnal.gov/monitor/d/000000146/why-are-my-jobs-held?orgId=1)

## View the stdout/stderr of our jobs
Here's the link for the history page of the example job: [link](https://fifemon.fnal.gov/monitor/d/000000115/job-cluster-summary?orgId=1&var-cluster=40351757&var-schedd=jobsub01.fnal.gov&from=1611098894726&to=1611271694726). 

Feel free to sub in the link for your own jobs.

Once there, click "View Sandbox files (job logs)".
In general you want the .out and .err files for stdout and stderr.
The .cmd file can sometimes be useful to see exactly what got passed in to your job.

[Kibana][kibana] can also provide a lot of information.

You can also download the job logs from the command line with jobsub_fetchlog: 

```bash
jobsub_fetchlog --jobid=12345678.0@jobsub0N.fnal.gov --unzipdir=some_appropriately_named_directory
```

That will download them as a tarball and unzip it into the directory specified by the --unzipdir option.
Of course replace 12345678.0@jobsub0N.fnal.gov with your own job ID. 

> ## Quiz 
>
> Download the log of your last submission via jobsub_fetchlog or look it up on the monitoring pages. Then answer the following questions (all should be available in the .out or .err files):
> 1. On what site did your job run?
> 2. How much memory did it use?
> 3. Did it exit abnormally? If so, what was the exit code?
>
{: .solution}

## Review of best practices in grid jobs (and a bit on the interactive machines)

* When creating a new workflow or making changes to an existing one, <span style="color:red">**ALWAYS test with a single job first**</span>. Then go up to 10, etc. Don't submit thousands of jobs immediately and expect things to work.  
* **ALWAYS** be sure to prestage your input datasets before launching large sets of jobs. This may become less necesaary in the future as we move to distributed storage locations.
* **Use RCDS**; do not copy tarballs from places like scratch dCache. There's a finite amount of transfer bandwidth available from each dCache pool. If you absolutely cannot use RCDS for a given file, it's better to put it in resilient (but be sure to remove it when you're done!). The same goes for copying files from within your own job script: if you have a large number of jobs looking for a same file, get it from resilient. Remove the copy when no longer needed. Files in resilient dCache that go unaccessed for 45 days are automatically removed.  
* Be careful about placing your output files. **NEVER place more than a few thousand files into any one directory inside dCache. That goes for all type of dCache (scratch, persistent, resilient, etc). Subdirectories also count against the total for these purposes, so don't put too many subdirectories at any one level.
* **AVOID** commands like `ifdh ls /some/path` inside grid jobs unless it is absolutely necessary. That is an expensive operation and can cause a lot of pain for many users, especially when a directory has large number of files in it. Remote listings take much, much longer than the corresponding op on a machine where the directory is mounted via NFS. If you just need to verify a directory exists, there are much better ways than ifdh ls, for example the gfal-stat command. Note also that ifdh cp will now, by default, create an output directory if it does not exist (so be careful that you've specified your output string properly).
* Use xrootd when opening files interactively; this is much more stable than simply doing `root /pnfs/dune/... (and in general, do NOT do that...)`
* **NEVER** copy job outputs to a directory in resilient dCache. Remember that they are replicated by a factor of 20! **Any such files are subject to deletion without warning**.  
* **NEVER** do hadd on files in `/pnfs` areas unless you're using `xrootd`. I.e. do NOT do hadd out.root `/pnfs/dune/file1 /pnfs/dune/file2 ...` This can cause severe performance degradations.
* Generally aim for output file sizes of 1 GB or greater. dCache is really not a fan of small files. You may need to process multiple input files to get to that size (and we generally encourage that anyway!)
* Very short jobs (measured in minutes) are quite inefficient, especially if you have an input tarball. In general you want to run for at least a few hours, and 8-12 is probably ideal (and of course longer jobs are allowed). Again you may need to process multiple input files, depending on what you're doing, or run multiple workflow stages in the same job. See the POMS section of the tutorial for more details.

**Side note:** Some people will pass file lists to their jobs instead of using a SAM dataset. We do not recommend that for two reasons: 1) Lists do not protect you from cases where files fall out of cache at the location(s) in your list. When that happens your jobs sit idle waiting for the files to be fetched from tape, which kills your efficiency and blocks resources for others. 2) You miss out on cases where there might be a local copy of the file at the site you're running on, or at least at closer one to your list. So you may end up unecessarily streaming across oceans, whereas using SAM (or later Rucio) will find you closer, local copies when they exist.

**Another important side note:** If you are used to using other programs for your work such as project.py (which is **NOT** officially supported by DUNE or the Fermilab Scientific Computing Division), there is a helpful tool called [Project-py][project-py-guide] that you can use to convert existing xml into POMS configs, so you don't need to start from scratch! Then you can just switch to using POMS from that point forward. As a reminder, if you use unsupported tools, you are own your own and will receive NO SUPPORT WHATSOEVER. You are still responsible for making sure that your jobs satisfy Fermilab's policy for job efficiency: https://cd-docdb.fnal.gov/cgi-bin/sso/RetrieveFile?docid=7045&filename=FIFE_User_activity_mitigation_policy_20200625.pdf&version=1

## The cost of getting it wrong: a cautionary tale

Earlier in May 2023 there was a fairly significant disruption to FNAL dCache, which resulted in at least five different tickets across four different experiments complaining of poor performance (resulting in jobs going held of exceeding time), timeouts, or other storage-related failures. It's unclear exactly how many jobs were affcted but it was likely in the many thousands. The root cause was a DUNE user running `ifdh ls $OUTDIR 0` to check the existence of a given directory. That command, though it only spits out the directory name, was indeed doing a full internal listing of the contents of $OUTDIR. Normally that's not the end of the world (see the comment in the best practices section), but this directory had over 100,000 files in it! The user was writing all job outputs into the same directory from what we could tell. 

Since the workflow was causing a systemwide disruption we immediately held all of the user's jobs and blocked new submissions until the workflow was re-engineered. Fortunately dCache performance recovered very quickly after that. The user's jobs are running again and they are also much more CPU-efficient than they were before the changes.

*The bottom line: one single user not following best practices can disrupt the entire system if they get enough jobs running.* EVERYONE is responsible for following best practices. Getting it wrong affects not only you, but your collaborators!

## A word on the DUNE Global Pool

DUNE has also created a a global glideinWMS pool similar to the CMS Global Pool that is intended to serve as a single point through which multiple job submission systems (e.g. HTCondor schedulers at sites outside of Fermilab) can have access to the same resources. Jobs using the global pool still run in the exactly the same way as those that don't. We plan to move more and more work over to the global pool in 2023 and priority access to the FermiGrid quota will eventually be given to jobs submitted to the global pool. To switch to the global pool with jobsub, it's simply a matter of adding `--global-pool dune` as an option to your submission command. The only practical difference is that your jobs will come back with IDs of the form NNNNNNN.N@dunegpschedd0X.fnal.gov instead of NNNNNNN.N@jobsub0X.fnal.gov. Again, everything else is identical, so feel free to test it out.


## Making subsets of metacat datasets

Running across very large number of files puts you at risk of system issues.  It is often much nicer to run over several smaller subsets.
Many official metacat definitions are large data collections defined only by their properties and not really suitable for a single job.

You can do the following.  Submit your jobs using the skip and limit commands.  Here 'namespace:official_dataset' describes the official dataset. 

See [the basics tutorial](https://dune.github.io/computing-basics/03-data-management/index.html#official-datasets-) for information on official datasets. 

~~~
query="files from namespace:official_dataset skip 0 limit 1000"
query="files from namespace:official_dataset skip 1000 limit 1000"
query="files from namespace:official_dataset skip 2000 limit 1000"
....
~~~
{: ..language-bash}




<!-- 

## Making subsets of sam definitions

Running across very large number of files puts you at risk of system issues.  It is often much nicer to run over several smaller subsets.
Many official samweb definitions are large data collections defined only by their properties and not really suitable for a single job.

There are two ways of reducing their size.

You can create new dataset definitions; say `mydataset` has 10000 entries and you want to split it on to groups of 2000:

```bash
samweb create-definition $USER-mydataset-part0 “defname:mydataset limit 2000 offset 0”
samweb create-definition $USER-mydataset-part1 “defname:mydataset limit 2000 offset 2000"
samweb create-definition $USER-mydataset-part2 “defname:mydataset limit 2000 offset 4000”
samweb create-definition $USER-mydataset-part3 “defname:mydataset limit 2000 offset 6000"
samweb create-definition $USER-mydataset-part4 “defname:mydataset limit 2000 offset 8000”
```

Your name needs to be in there, unless it is already in the dataset name, but make certain you don’t miss a few at the end...

Alternatively you can use the syntax `with stride 5 offset 0` to take every 5th file:
```bash
samweb create-definition $USER-mydataset-part0 “defname:mydataset limit 2000 with stride 5 offset 0”
samweb create-definition $USER-mydataset-part1 “defname:mydataset limit 2000 with stride 5 offset 1"
samweb create-definition $USER-mydataset-part2 “defname:mydataset limit 2000 with stride 5 offset 2”
samweb create-definition $USER-mydataset-part3 “defname:mydataset limit 2000 with stride 5 offset 3"
samweb create-definition $USER-mydataset-part4 “defname:mydataset limit 2000 with stride 5 offset 4”
```




More on samweb can be found [here]({{ site.baseurl }}/sam-by-schellman). -->

## Verify Your Learning:

> ## Question 01
>
> What are the differences in environment between Fermilab worker nodes and those at other sites (assuming the site supports Singularity)?
> <ol type="A">
> <li>Fermilab workers have additional libraries available.</li>
> <li>Worker nodes at other sites have additional libraries installed.</li>
> <li>No difference.</li>
> </ol>
>
> > ## Answer
> > The correct answer is C - No difference.
> > {: .output}
> > Comment:
> {: .solution}
{: .challenge}

> ## Question 02
>
> After setting up a new workflow or preparing to run one that has not been exercised in a while, what is an that has not been exercised in a while, what is an appropriate number of test jobs to initially submit?
> <ol type="A">
> <li>1.</li>
> <li>10.</li>
> <li>100.</li>
> <li>As many as needed.</li>
> </ol>
>
> > ## Answer
> > The correct answer is A - 1.
> > {: .output}
> > Comment:
> {: .solution}
{: .challenge}


> ## Question 03
>
> project.py is supported by the Fermilab Scientific Computing Division
> <ol type="A">
> <li>True.</li>
> <li>False.</li>
> </ol>
>
> > ## Answer
> > The correct answer is B - False.
> > {: .output}
> > Comment:
> {: .solution}
{: .challenge}


> ## Question 04
>
> What is generally the best way to read in a .root file for analysis within a grid job?
> <ol type="A">
> <li>Open with an xrootd URI (root://).</li>
> <li>Copy the entire file at the beginning of the job.</li>
> <li>Both A and B.</li>
> </ol>
>
> > ## Answer
> > The correct answer is A - Open with an xrootd URI (root://).
> > {: .output}
> > Comment:
> {: .solution}
{: .challenge}


> ## Question 05
>
> What is the best way to specify your desired operating system and environment in a grid job?
> <ol type="A">
> <li>Use the --OS option in jobsub.</li>
> <li>Do not specify any OS, but control it with the SingularityImage classad.</li>
> <li>Don’t specify anything. The grid does it</li>
> <li>None of the Above</li>
> </ol>
>
> > ## Answer
> > The correct answer is B - Do not specify any OS, but control it with the SingularityImage classad.
> > {: .output}
> > Comment:
> {: .solution}
{: .challenge}


> ## Question 06
>
> What is the best way to copy custom code into a grid job?
> <ol type="A">
> <li>Use the RCDS (i.e. --tar_file_name=dropbox://foo/bar/) and stage the file in via CVMFS.</li>
> <li>Copy a tarball to /pnfs/dune/scratch/users/username.</li>
> <li>Copy a tarball to /pnfs/dune/persistent/users/username.</li>
> <li>Copy a tarball to /pnfs/dune/resilient/users/username.</li>
> <li>None of the Above</li>
> </ol>
>
> > ## Answer
> > The correct answer is A - Use the RCDS (i.e. --tar_file_name=dropbox://foo/bar/) and stage the file in via CVMFS.
> > {: .output}
> > Comment:
> {: .solution}
{: .challenge}

<!--
> ## Question 01
>
> Question here...
> <ol type="A">
> <li>.</li>
> <li>.</li>
> <li>.</li>
> <li>.</li>
> <li>None of the Above</li>
> </ol>
>
> > ## Answer
> > The correct answer is .
> > {: .output}
> > Comment here 
> {: .solution}
{: .challenge}
-->

## Further Reading
Some more background material on these topics (including some examples of why certain things are bad) is in these links:


[December 2022 jobsub_lite demo and information session](https://indico.fnal.gov/event/57514/)

[January 2023 additional experiment feedback session on jobsub_lite]( )

[Wiki page listing differences between jobsub_lite and legacy jobsub](https://fifewiki.fnal.gov/wiki/Differences_between_jobsub_lite_and_legacy_jobsub_client/server)

[2021 Intensity Frontier Summer School](https://indico.fnal.gov/event/49414)

[The Glidein-based Workflow Management System]( https://glideinwms.fnal.gov/doc.prd/index.html )

[Introduction to Docker](https://hsf-training.github.io/hsf-training-docker/index.html)

[job-autorelease]: https://cdcvs.fnal.gov/redmine/projects/fife/wiki/Job_autorelease

[redmine-wiki-jobsub]: https://cdcvs.fnal.gov/redmine/projects/jobsub/wiki

[redmine-wiki-using-the-client]: https://cdcvs.fnal.gov/redmine/projects/jobsub/wiki/Using_the_Client

[fifemon-dune]: https://fifemon.fnal.gov/monitor/d/000000053/experiment-batch-details?orgId=1&var-experiment=dune

[fifemon-userjobs]: https://fifemon.fnal.gov/monitor/d/000000116/user-batch-details?orgId=1&var-cluster=fifebatch&var-user=kherner

[fifemon-whyheld]: https://fifemon.fnal.gov/monitor/d/000000146/why-are-my-jobs-held?orgId=1

[kibana]: https://fifemon.fnal.gov/kibana/goto/8f432d2e4a40cbf81d3072d9c9d688a6

[poms-page-ana]: https://pomsgpvm01.fnal.gov/poms/index/dune/analysis/

[poms-user-doc]: https://cdcvs.fnal.gov/redmine/projects/prod_mgmt_db/wiki/POMS_User_Documentation

[fife-launch-ref]: https://cdcvs.fnal.gov/redmine/projects/fife_utils/wiki/Fife_launch_Reference 

[poms-campaign-stage-info]: https://pomsgpvm01.fnal.gov/poms/campaign_stage_info/dune/analysis?campaign_stage_id=9023

[project-py-guide]: https://cdcvs.fnal.gov/redmine/projects/project-py/wiki/Project-py_guide

[DUNE_computing_tutorial_advanced_topics_20200129]: https://indico.fnal.gov/event/20144/contributions/55932/attachments/34945/42690/DUNE_computing_tutorial_advanced_topics_and_best_practices_20200129.pdf  


{%include links.md%}
