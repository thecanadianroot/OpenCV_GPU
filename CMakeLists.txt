cmake_minimum_required(VERSION 3.10)
project(OpenCV_GPU)

set(CMAKE_CXX_STANDARD 14)

SET("OpenCV_DIR" "/usr/share/OpenCV")
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})
add_executable(OpenCV_GPU main.cpp)
target_link_libraries(OpenCV_GPU ${OpenCV_LIBS})
