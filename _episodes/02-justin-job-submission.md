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





Once you have practiced basic justIn commands, please look at the instructions for running your own code below:



## First learn the basics of Justin Submit a job

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


### Temporary short version of an example for custom code.

We're working on a long version of this but please look at these [instructions for running a justIN workflow using your own code]({{ site.baseurl }}/short_submission) for now. 

### Cool justIN feature

justIN has a very useful interactive test command. 

Here is a test from the short submission example. 

~~~
{% include test_workflow.sh %}
~~~

it reads in a tarball from an area `$DUNEDATA` and writes output to a tmp area on your interactive machine.  It works very well at emulating a grid job. 

## Did your job work? 

If not please ask over at #computing-questions in Slack