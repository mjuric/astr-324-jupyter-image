FROM jupyter/scipy-notebook

#######################################################
# Packages installed as root
#######################################################
USER root

# General (editors, etc)
RUN sudo apt-get update && sudo apt-get install --yes telnet inetutils-ping
RUN sudo apt-get update && sudo apt-get install --yes openssh-client
RUN sudo apt-get update && sudo apt-get install --yes vim joe emacs-nox

#######################################################
# Packages installed as joyvan (who owns conda)
#######################################################
USER $NB_UID

# notebook environment and utilities
RUN conda install nb_conda_kernels
RUN conda install -c conda-forge nbgitpuller

# install additional general data science and astronomy conda packages
RUN conda install -c conda-forge munch tqdm pv
RUN conda install -c conda-forge astropy aplpy astroml

# Solar system
RUN conda install -c conda-forge openorb

# Lecture 6 (MCMC)
RUN conda install -c conda-forge pymc3 emcee

# Lecture 10 (ML)
RUN conda install mamba -c conda-forge
# RUN mamba install pytorch -y # <-- broken as of 2022-05-27

# Hide system kernels from nb_conda_kernels
# Place user-defined conda environments into the user's directory
RUN printf '\
\n\
c.CondaKernelSpecManager.env_filter = r"^/opt/.*$" \n\
c.CondaKernelSpecManager.name_format = "Conda env '"{1}"' ({0})" \n'\
>> /etc/jupyter/jupyter_notebook_config.py

RUN printf '\
envs_dirs:\n\
  - $HOME/.conda-envs\n\
' >> /opt/conda/.condarc

