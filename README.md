# Dockerized XMR-Stak (AMD GPU) Monero miner

[![GitHub Release](https://img.shields.io/github/release/merxnet/xmr-stak-amd-docker/all.svg)](https://github.com/merxnet/xmr-stak-amd-docker/releases)
[![GitHub Release Date](https://img.shields.io/github/release-date-pre/merxnet/xmr-stak-amd-docker.svg)](https://github.com/merxnet/xmr-stak-amd-docker/releases)
[![Docker Pulls](https://img.shields.io/docker/pulls/merxnet/xmr-stak-amd.svg)](https://hub.docker.com/r/merxnet/xmr-stak-amd/)

The goal for this code is to create a modular and easy-to-use Docker image of the popular XMR-Stak (AMD GPU) Monero miner. Discover and support the source code [here](https://github.com/fireice-uk/xmr-stak). There are also code repositories for "Dockerized" versions of the [CPU](https://github.com/merxnet/xmr-stak-cpu-docker) and [NVIDIA GPU](https://github.com/merxnet/xmr-stak-nvidia-docker) miners as well. Note that XMR-Stak offers a unified miner which supports CPUs and AMD/NVIDIA GPUs; however, for simplicity each image contains source code compiled for a single purpose.

## Quickstart
The Docker image created by this code is conveniently available on [Docker Hub](https://hub.docker.com/r/merxnet/xmr-stak-amd/).
```
docker pull merxnet/xmr-stak-amd
```
To get started, install the AMD drivers (see the [Host Configuration](#host-configuration) section below). Once complete, all you need is a [wallet](https://getmonero.org/resources/user-guides/create_wallet.html) and a [mining pool](https://monero.org/services/mining-pools/) of your choice, such as [MoriaXMR](https://moriaxmr.com/). You may also be prompted for a password, which in this case is simply an identifer for the host. This information can be provided on the command line at run time:
```
docker run --device /dev/dri merxnet/xmr-stak-amd -o ${POOL} -u ${WALLET} -p ${PASSWD} --currency monero
```
To get the most out of mining, be sure to check out the sections below as well as the documentation at the [source code's GitHub page](https://github.com/fireice-uk/xmr-stak/blob/master/doc/usage.md).

## Usage
This Docker image can be treated just like the binary -- that is, you can provide any and all command line options directly. For example:
```
docker run -d --name xmr-stak-amd merxnet/xmr-stak-amd \
  -O us.moriaxmr.com:9000 \
  -u ${WALLET} \
  -p ${PASSWD} \
  --currency monero
```
Most often it is easiest to provide configuration files. To do this, it is recommended that all configuration files be stored in the same directory on the host and then passed to the container at runtime:
```
docker run -d -v /etc/xmr-stak:/etc/xmr-stak:ro merxnet/xmr-stak-amd \
  -c /etc/xmr-stak/config.txt \
  -C /etc/xmr-stak/pools.txt \
  --amd /etc/xmr-stak/amd.txt
```
To see examples and benchmarks, visit the [XMR-Stak website](https://www.xmrstak.com/).

## Host Configuration
For AMD GPU mining, the host machine (i.e., the machine running `dockerd`) **MUST** have the AMD drivers installed. This most often means AMDGPU or AMDGPU-PRO, but supposedly both the open source ATI drivers and the proprietary Catalyst drivers work as well. Check out [this Arch Linux Wiki page](https://wiki.archlinux.org/index.php/Xorg#AMD) for information on which driver to use. Most Linux distributions will have AMD drivers available in their corresponding package repositories; otherwise, refer to the [AMD Download Drivers](https://support.amd.com/en-us/download) site.


If not using the AMDGPU-PRO drivers, ensure that you have the proper [OpenCL runtime](https://wiki.archlinux.org/index.php/GPGPU#OpenCL_Runtime) installed as well. This is pre-packaged with the AMDGPU-PRO drivers only.

Note that you must pass the proper device to the Docker container at runtime -- in this case, that means using the `--device` flag to pass through the AMD card. Usually passing `/dev/dri` is all that is required, but passing `/dev/kfd` may also be required (or increase hashrate).

If you encounter an error such as `CL_OUT_OF_HOST_MEMORY`, some environment variables may be required to run properly. Trying using some or all of the variables below:
```
GPU_FORCE_64BIT_PTR=1
GPU_USE_SYNC_OBJECTS=1
GPU_MAX_ALLOC_PERCENT=100
GPU_SINGLE_ALLOC_PERCENT=100
GPU_MAX_HEAP_SIZE=100
```

## Support
Feel free to fork and create pull requests or create issues. Feedback is always welcomed. One can also send donatations to the Monero wallet below.
```
43txUsLN5h3LUKpQFGsFsnRLCpCW7BvT2ZKacsfuqYpUAvt6Po8HseJPwY9ubwXVjySe5SmxVstLfcV8hM8tHg8UTVB14Tk
```
Thank you.
