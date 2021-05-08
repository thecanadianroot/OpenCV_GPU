#include <iostream>

#include <opencv2/opencv.hpp>
#include <opencv2/core.hpp>
#include "opencv2/core/cuda.hpp"

using namespace std;
using namespace cv;

int main(int argc, char *argv[]) {
    cout << "Garbage";
    cuda::printCudaDeviceInfo(cuda::getDevice());
    return 0;
}
