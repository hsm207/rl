FROM continuumio/anaconda3:latest

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


# need the gym atari environment
RUN pip install gym[atari]

# to run some jax demos
RUN pip install tensorflow tensorflow-datasets

RUN pip install --upgrade jupyterlab

