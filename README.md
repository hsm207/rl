# Introduction

This repository contains my notes on reinforcement learning

# Usage

## CPU

1. Open project inside the container
2. Run:
    ```bash
    xvfb-run -s "-screen 0 1400x900x24" bash
    jupyter lab --ip 0.0.0.0 --no-browser
    ```


## GPU

Execute the following in the project's root directory:

```bash
docker build -t rl:gpu -f gpu.Dockerfile . && \
docker run -it \
    --gpus all \
    -u vscode \
    -p 8888:8888 \
    -v $(pwd):/workspaces/rl \
    -w /workspaces/rl \
    rl:gpu jupyter lab --ip 0.0.0.0 --no-browser
```
