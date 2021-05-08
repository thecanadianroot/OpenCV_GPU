#!/bin/bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo echo "Package: *" >> /etc/apt/preferences.d/pop-default-settings
sudo echo "Pin: origin nvidia.github.io" >> /etc/apt/preferences.d/pop-default-settings
sudo echo "Pin-Priority: 1002" >> /etc/apt/preferences.d/pop-default-settings
sudo apt update
sudo apt dist-upgrade -y
sudo apt install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi