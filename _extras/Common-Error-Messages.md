---
title: Common Error Messages
permalink: ErrorMessages
keypoints:
- Errors that people report in doing the tutorial
--- 

- ####  `/usr/bin/xauth: unable to write authority file`
  #### `disk quota exceeded error with metacat auth login`

    These likely means your kerberos ticket was not forwarded and you can't access your home are without it.  do a kinit in your terminal session.  Or possibly you really have filled your home area. 

- #### `bash: setup: command not found`

  setup is a UPS command.  You need to be running in the Apptainer and setup the DUNE ups system - check out the instructions in [SL7 setup]
  (https://dune.github.io/computing-basics/sl7_setup)


- #### `SyntaxError: future feature annotations is not defined` 

    This looks like a bad python version, try doing `which python` if it isn't > 3.9 you don't have a modern python version.

    - On SL7 we suggest setting up the dunesw as shown in the example setup. alternatively you can 

        ~~~
        setup root -v v6_28_12 -q e26:p3915:prof
        ~~~
        {: .language-bash} 

    - On AL9 we suggest loading ROOT which brings in a modern version of python and allows xrootd access to data. 

        ~~~
        spack load root@6.28.12
        ~~~
        {: .language-bash} 


- #### Spack ==> `Error: somecode matches multiple packages
  ~~~
  Matching packages:
    jhpj2js somecode@6.28.06%gcc@12.2.0 arch=linux-almalinux9-x86_64_v2
    sfwfmqo somecode@6.28.12%gcc@12.2.0 arch=linux-almalinux9-x86_64_v2
  Use a more specific spec (e.g., prepend '/' to the hash).
  ~~~
  {: .language-bash} 

  Choose a version and then
  ~~~
  spack load somecode@6.28.12
  ~~~
  {: .language-bash} 
  We do not suggest using the hash as then how do you know what you did? 
