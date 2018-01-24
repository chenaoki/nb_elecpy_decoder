FROM nvidia/cuda:latest

MAINTAINER chenaoki <chenaoki@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "now building"

RUN apt update && apt install -y \
  git curl make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev libpng-dev ffmpeg zsh

WORKDIR /root
USER root

RUN git clone git://github.com/yyuu/pyenv.git .pyenv

ENV HOME  /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN pyenv install anaconda2-4.3.1
RUN pyenv global anaconda2-4.3.1
RUN pyenv rehash

RUN conda install -c anaconda chainer 
RUN conda install -y accelerate 

RUN pip install cupy

RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8888" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.notebook_dir = '/notebooks'" >> /root/.jupyter/jupyter_notebook_config.py

WORKDIR /
RUN mkdir /notebooks
WORKDIR /notebooks
RUN rm -rf ./* 
RUN git clone https://github.com/chenaoki/nb_elecpy.git 
WORKDIR /notebooks/nb_elecpy
RUN git submodule init 
RUN git submodule update

WORKDIR /notebooks

CMD ["sh", "-c", "jupyter notebook"]


