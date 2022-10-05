#!/bin/bash
mkdir ~/code
git clone https://github.com/NVIDIA/cuda-samples.git ~/code/
sudo pacman -S freeimage openmpi directx-headers openmp libopenmpt
GLPATH=/usr/lib make -C ~/code/cuda-samples/
# https://stackoverflow.com/questions/66371130/cuda-initialization-unexpected-error-from-cudagetdevicecount
