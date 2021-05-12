#include <opencv2/core.hpp>
#include <opencv2/cuda/>
#include <opencv2/imgcodecs.hpp>
#include <iostream>
#include <dirent.h>
#include <vector>
#include <thread>
#include <chrono>
#include <opencv2/imgproc.hpp>
#include <string>
#include <opencv2/core/cuda.hpp>

using namespace std;
using namespace cv;

vector<String> listFiles(const string &directory) {
    DIR *dir;
    vector<String> medias;
    struct dirent *file;
    if ((dir = opendir(directory.c_str())) != nullptr) {
        while ((file = readdir(dir)) != nullptr) {
            String path = directory + "/" + file->d_name;
            if (file->d_type != DT_DIR){
                medias.emplace_back(path);
            }
        }
        closedir(dir);
    }
    return medias;
}

vector<Mat> load(const vector<String> &images) {
    vector<Mat> loaded;
    for (const auto &image : images) {
        cout << image << endl;
        Mat src = imread(image, IMREAD_UNCHANGED);
        if (src.data != nullptr){
            loaded.emplace_back(src);
        }
    }
    return loaded;
}

void run(const vector<String> &images) {
    // Load all in memory to simulate receiving messages from the ROS provider
    vector<Mat> loadedImages = load(images);
    // Benchmark
    chrono::steady_clock::time_point now = chrono::steady_clock::now();
    for (const auto &loadedImage : loadedImages) {
        Mat dest;
        threshold(loadedImage, dest, 128.0, 255.0, CV_THRESH_BINARY);
        this_thread::sleep_for(chrono::milliseconds(33)); // Simulate 30 frames per second
    }
    chrono::steady_clock::time_point end = chrono::steady_clock::now();
    cout << "OpenCV runtime (CPU): " << chrono::duration_cast<chrono::milliseconds>(end - now).count()
         << " milliseconds" << endl;
    cout << "OpenCV runtime (CPU): " << chrono::duration_cast<chrono::milliseconds>(end - now).count() << " nanoseconds"
         << endl;
    loadedImages.clear();
}

void runCUDA(const vector<String> &images) {
    // Load all in memory to simulate receiving messages from the ROS provider
    vector<Mat> loadedImages = load(images);

    // Benchmark
    chrono::steady_clock::time_point now = chrono::steady_clock::now();
    for (const auto &loadedImage : loadedImages) {
        Mat dest;
        threshold(loadedImage, dest, 128.0, 255.0, CV_THRESH_BINARY);
        this_thread::sleep_for(chrono::milliseconds(33)); // Simulate 30 frames per second
    }
    chrono::steady_clock::time_point end = chrono::steady_clock::now();
    cout << "OpenCV runtime (GPU): " << chrono::duration_cast<chrono::milliseconds>(end - now).count()
         << " milliseconds" << endl;
    cout << "OpenCV runtime (GPU): " << chrono::duration_cast<chrono::milliseconds>(end - now).count() << " nanoseconds"
         << endl;
    loadedImages.clear();
}

int main(int argc, char *argv[]) {
    cuda::printCudaDeviceInfo(cuda::getDevice());
    const vector<String> &images = listFiles("media/imgs");
    run(images);
    runCUDA(images);
    return 0;
}

