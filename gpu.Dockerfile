FROM nvidia/cuda:10.1-devel-ubuntu18.04

# install python
# from: https://github.com/ContinuumIO/docker-images/blob/master/anaconda3/debian/Dockerfile

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    DEBIAN_FRONTEND="noninteractive" TZ="Asia/Kuala_Lumpur"  apt-get install -y wget \
        bzip2 \
        ca-certificates \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1 \
        git \
        mercurial \
        subversion && \
    apt-get clean

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# create a non-root user
# from https://code.visualstudio.com/docs/remote/containers-advanced#_adding-a-nonroot-user-to-your-dev-container
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# gym system packages
# from https://github.com/openai/gym#installing-everything
RUN apt-get install -y build-essential \
    cmake \
    curl \
    ffmpeg \
    libgl1-mesa-dev \
    libglfw3 \
    libglfw3-dev \
    libglu1-mesa-dev \
    libosmesa6-dev \
    patchelf \
    swig \
    xvfb \
    zlib1g \
    zlib1g-dev

# from https://coax.readthedocs.io/en/latest/
RUN pip install --upgrade coax \
    jax \
    jaxlib

RUN pip install --upgrade coax \
    jax \
    jaxlib==0.1.60+cuda101 -f https://storage.googleapis.com/jax-releases/jax_releases.html


# need the gym atari environment
RUN pip install gym[atari]

# to run some jax demos
RUN pip install tensorflow tensorflow-datasets

RUN pip install --upgrade jupyterlab