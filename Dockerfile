ARG CUDA="11.2.2"
ARG UBUNTU="18.04"
FROM nvidia/cuda:${CUDA}-devel-ubuntu${UBUNTU}
ARG OPENCV="4.5.2"

# Update and install dependencies
RUN apt update
RUN apt dist-upgrade -y
RUN apt install -y build-essential \
    cmake \
    gcc \
    gdb \
    git \
    wget \
    unzip \
    yasm \
    pkg-config \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavformat-dev \
    libpq-dev \
    libxine2-dev \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    python-dev \
    python-numpy \
    python3-dev \
    python3-numpy

# Compile and install OpenCV
WORKDIR /opt
RUN wget https://github.com/opencv/opencv/archive/refs/tags/${OPENCV}.zip && unzip ${OPENCV}.zip && rm ${OPENCV}.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV}.zip && unzip ${OPENCV}.zip && rm ${OPENCV}.zip
RUN mkdir opencv-${OPENCV}/build && \
    cd opencv-${OPENCV}/build && \
    cmake -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV}/modules \
        -DWITH_CUDA=ON \
        -DENABLE_FAST_MATH=ON \
        -DCUDA_FAST_MATH=ON \
        -DWITH_CUBLAS=ON \
        -DWITH_GSTREAMER=OFF \
        -DWITH_V4L=OFF \
        -DWITH_GTK=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. && \
    make -j"$(nproc)" && \
    make install && \
    ldconfig
# Clean
RUN rm -rf opencv-${OPENCV}/build
#RUN export PATH=/usr/local/cuda/bin/lib64:$PATH
#RUN export CUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda

# Actually compile the application
RUN mkdir -p /app
WORKDIR /app
COPY main.cpp .
COPY CMakeLists.txt .
RUN cmake . && make -j "$(nproc)"
RUN chmod +x OpenCV_GPU

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
# ENTRYPOINT ["bash"]
CMD ["./OpenCV_GPU"]