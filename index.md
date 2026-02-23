---
layout: lesson
root: .  # Is the only page that doesn't follow the pattern /:path/index.html
permalink: index.html  # Is the only page that doesn't follow the pattern /:path/index.html
venue: "DUNE Collaboration"
address: "online"
country: "us"
language: "en"
latitude: "45"
longitude: "-1"
humandate: "2024"
humantime: "asynchronous"
startdate: "2025-09-08"
enddate: "2025-09-11"
instructor: ["Heidi Schellman","Dave Demuth","Michael Kirby","Steve Timm","Tom Junk","Ken Herner","Aaron Higuera"]
helper: ["mentor1", "mentor2"]
email: ["schellmh@oregonstate.edu","dmdemuth@gmail.com","mkirby@bnl.gov","timm@fnal.gov","junk@fnal.gov","herner@fnal.gov"]
collaborative_notes: "2025-09-11-dune"
eventbrite:
---

This tutorial will teach you the basics of DUNE batch computing. 

Instructors will engage students with hands-on lessons focused in three areas:

1. The [justIN](https://dunejustin.fnal.gov) batch system
2. The jobsub batch system


Mentors will answer your questions and provide technical support.

<!-- this is an html comment -->

{% comment %} This is a comment in Liquid {% endcomment %}

> ## Prerequisites
> 1. Unix command line experience is necessary for this training. 
>   We recommend that participants to go through [The Unix Shell](https://swcarpentry.github.io/shell-novice/), if new to the unix command line (also known as terminal or shell).
> 2. A computer set up so that you can log into a remote unix system at FNAL or CERN.  
>   This will include getting DUNE computing accounts at FNAL or CERN.      
>   See [Setup](http://dune.github.io/computing-basics/setup.html) to do this pre-class setup.  
{: .prereq}

By the end of this workshop, participants will know how to:

* submit simple jobs using the [justIn](https://dunejustin.fnal.gov) batch system
* know some simple methods for debugging batch jobs

There are additional materials provided that explain how to:

* Use the [justIn](https://dunejustin.fnal.gov) system to process data
* [Develop configuration files to control jobsub batch jobs]({{ site.baseurl }}/07-grid-job-submission)



You will need to be a DUNE Collaborator (listed member), and have a valid FNAL or CERN computing account to join the tutorial. Contact your  DUNE group leader for assistance.

> ## Getting Started
>
> First step: follow the directions in the "[Setup](https://dune.github.io/computing-basics/setup.html)". Once you follow the instructions; we give you an easy exercise 
> to make sure you are good to go.
{: .callout}

Ask questions on [Slack](https://dunescience.slack.com/archives/C02TJDHUQPR) anytime or - during the live lessons - on the [livedoc](https://docs.google.com/document/d/1QNK-hKPqLIVaecRyg9q4QZOHNwAZgq32oHVuboG_AvQ/edit?usp=sharing).

<!-- If there is a live session the schedule will appear here -->

<!--<h2 id="schedule">Schedule by Day</h2>

The official schedule for this event is listed on the [Indico site (59762)](https://indico.fnal.gov/event/59762/timetable/#20230524).

{% include sc/schedule.html %}
--->


<!--<center><img  alt="" src="fig/Schedule_computing_training_202105.png"/></center>-->

<!-- An [asynchronous session]({{site.baseurl}}/asynchronous/) is designed as later day acivities for the first two days of the workshop.-->

{% include links.md %}
