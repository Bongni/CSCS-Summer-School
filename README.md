
# CSCS-USI HPC/Data Analytics Summer School 2026

This repository contains my solutions for the exercises of the Summer School.

This is a fork from the official repository which contains the materials used in the Summer School, including source code, lecture notes and slides.

## Schedule

<img width="847" height="367" alt="image" src="https://github.com/user-attachments/assets/632b73bd-8430-4c99-b520-92ddb232bc82" />

## Link to materials

- [CUDA](./cuda) 
- [Python HPC](./python-hpc) 

## Setting up the course accounts
- https://docs.cscs.ch/guides/course-account/
  
## Obtaining a copy of this repository

### On your own computer

You will want to download the repository to your laptop to get all of the slides.
The best method is to use git, so that you can update the repository as more slides and material are added over the course of the event.
So, if you have git installed, use the same method as for Piz Daint below (in a directory of your choosing).

You can also download the code as a zip file by clicking on the "<> Code" (  <img width="121" height="39" alt="image" src="https://github.com/user-attachments/assets/0a55224e-5ac9-4027-80be-22066a86073f" /> ) button on the top right hand side of the github page, then clicking on __Download zip__.

### On Daint@Alps via JupyterLab

- Go to https://jupyter-daint.cscs.ch/ and sign in using your CSCS course credentials 
- Launch JupyterLab (might take a couple of minutes)
  - Advanced reservation 'ss2026' 
  - Default values for the other fields (unless told otherwise by the instructor)
- Launch a new terminal : File -> New -> Terminal
- Issue the following commands on the terminal:
```bash
ln -s $SCRATCH scratch
cd $SCRATCH
git clone https://github.com/eth-cscs/SummerSchool.git
```

### On Daint@Alps via ssh

This is an alternative method to the JupyterLab method above

```bash
# log onto Piz Daint ...
ssh classNNN@ela.cscs.ch
ssh daint

# go to scratch
cd $SCRATCH
git clone https://github.com/eth-cscs/SummerSchool.git
```

### Updating the repository

Lecture slides and source code will be regurlarly updated on the remote git repository throughout the course.
To update your local repository you can simply go inside the path and type

```
git pull origin main
```

There is a posibility that you might have a conflict between your working version of the repository and the origin.
In this case you can ask one of the assistants for help.

## Setup on Daint@Alps

```
uenv image pull prgenv-gnu/26.3:v1
uenv start --view=default prgenv-gnu/26.3:v1
```

## Running on Daint@Alps

```
srun -N 1 -A summerschool-course2026-cscs --reservation=ss2026 -t60 ./exec args
```

## My contribution

My own code is highlighted with the following opening and closing comments

```
...

// ======================================================
//              Start own code
// ======================================================

...

// ======================================================
//              End own code
// ======================================================

...
```

## How to access Daint@Alps

This will be covered in the lectures and you can find more details in the [CSCS User Documentation](https://docs.cscs.ch/clusters/daint/#daint).
