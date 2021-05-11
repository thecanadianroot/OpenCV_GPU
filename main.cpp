#include <iostream>
#include <opencv2/core/cuda.hpp>

using namespace std;
using namespace cv;

int main(int argc, char *argv[]) {
    cuda::printCudaDeviceInfo(cuda::getDevice());
    return 0;
}