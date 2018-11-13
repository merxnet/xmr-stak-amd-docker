ARG UBUNTU_VERSION=18.04


FROM ubuntu:${UBUNTU_VERSION} AS build

ENV XMR_STAK_VERSION '2.5.2'
ENV CMAKE_OPTS '-DMICROHTTPD_ENABLE=OFF -DXMR-STAK_COMPILE=generic -DHWLOC_ENABLE=OFF -DCPU_ENABLE=OFF -DCUDA_ENABLE=OFF'

RUN apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates cmake g++ gcc git libc++-dev libssl-dev make ocl-icd-opencl-dev \
    && git clone https://github.com/fireice-uk/xmr-stak.git \
    && cd xmr-stak \
    && git checkout ${XMR_STAK_VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. ${CMAKE_OPTS} \
    && make install


FROM ubuntu:${UBUNTU_VERSION}

LABEL maintainer='docker@merxnet.io'

ENV UBUNTU=${UBUNTU_VERSION}
ENV AMDGPU_VERSION=18.20-606296
ENV AMDGPU_URL=https://www2.ati.com/drivers/linux/ubuntu/${UBUNTU}/amdgpu-pro-${AMDGPU_VERSION}.tar.xz

RUN apt-get update \
    && apt-get -y install --no-install-recommends ca-certificates curl xz-utils \
    && curl -L -O --referer https://support.amd.com ${AMDGPU_URL} \
    && tar -xvJf amdgpu-pro-${AMDGPU_VERSION}.tar.xz \
    && rm amdgpu-pro-${AMDGPU_VERSION}.tar.xz \
    && SUDO_FORCE_REMOVE=yes apt-get -y remove --purge ca-certificates curl xz-utils $(apt-mark showauto) \
    && apt-get -y install --no-install-recommends gcc libc++-dev libssl-dev ocl-icd-opencl-dev \
    && ./amdgpu-pro-${AMDGPU_VERSION}/amdgpu-install -y --no-install-recommends --headless --opencl=legacy,rocm \
    && rm -r amdgpu-pro-${AMDGPU_VERSION} \
    && rm -rf /var/lib/apt/lists/* /usr/src/amdgpu-18.20-606296/ /var/opt/amdgpu-pro-local/

COPY --from=build /xmr-stak/build/bin/* /usr/local/bin/

WORKDIR /usr/local/bin

ENTRYPOINT ["xmr-stak"]
