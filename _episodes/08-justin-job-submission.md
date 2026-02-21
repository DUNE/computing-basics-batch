---
title: justIN Grid Job Submission (UNDER CONSTRUCTION)
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
<!-- 
#### Session Video

This session will be captured on video a placed here after the workshop for asynchronous study.
<!-- The session was video captured for your asynchronous review. -->
The video from the two day version of this training in May 2022 is provided [here](https://www.youtube.com/embed/QuDxkhq64Og) as a reference. -->

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

For now, please look at the short version of this sequence at
[Short Submission Runthrough]({{ site.baseurl }}/short_submission)

## Submit a job

Go to [The justIN Tutorial](https://dunejustin.fnal.gov/docs/tutorials.dune.md)

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

### Temporary short version of an example for custom code.

We're working on a long version of this but please look at these [instructions for running a justIN workflow using your own code]({{ site.baseurl }}/short_submission) for now. 

### Cool justIN feature

justIN has a very useful interactive test command. 

Here is a test from the short submission example. 

~~~
{% include test_workflow.sh %}
~~~

it reads in a tarball from an area `$DUNEDATA` and writes output to a tmp area on your interactive machine.  It works very well at emulating a grid job. 