FROM nvidia/cuda:11.3.0-devel-ubuntu18.04
ARG VERSION=4.5.2

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
    libgtk2.0-dev \
    python-dev \
    python-numpy \
    python3-dev \
    python3-numpy

# Compile and install OpenCV
WORKDIR /opt
RUN wget https://github.com/opencv/opencv/archive/refs/tags/$VERSION.zip && unzip $VERSION.zip && rm $VERSION.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/$VERSION.zip && unzip $VERSION.zip && rm $VERSION.zip
RUN mkdir opencv-$VERSION/build && \
    cd opencv-$VERSION/build && \
    cmake -DOPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-$VERSION/modules \
        -DWITH_CUDA=ON \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUBLAS=1 \
        -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        .. && \
    make -j"$(nproc)" && \
    make install && \
    ldconfig
# Clean
RUN rm -rf /opt/*

# Actually compile the application
RUN mkdir -p /app
WORKDIR /app
COPY main.cpp .
COPY CMakeLists.txt .
RUN cmake . && make -j "$(nproc)"
RUN mv OpenCV_GPU bin/

CMD ["./bin/OpenCV_GPU"]