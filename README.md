# Darknet Embedded

Darknet is an open-source neural network framework Written in C and CUDA, optimized for computational efficiency. It is used for training and deploying deep learning models, particularly in computer vision tasks. The original Darknet framework was created by Joseph Redmon, a computer scientist and AI researcher. He initially developed Darknet while working on YOLO (You Only Look Once), a groundbreaking object detection system, as part of his research at the University of Washington.

Darknet Embedded is a slimmed down version of the darknet software (forked from https://github.com/AlexeyAB/darknet) geared towards resource constrained embedded devices. It can be used without dependency on GPU support, OpenCV and other frameworks which may not be available on constrained devices. It is primarily intended for educational purposes and has been refactored to use CMake with additional scripts and configuration files that make integration into automated build environments like Buildroot easier. It is intended for those who want to experiment with the technology on low cost constrained embedded devices that run embedded Linux.

![image](https://github.com/user-attachments/assets/e40d842b-38df-492a-8290-d5111e2a1074)

## Buildroot

- ```make darknet_embedded-dirclean```
- ```make darknet_embedded``

## Git Management

- Tag a release on the command line: ```git tag -a v1.0 -m "Release version 1.0 ``` followed by ```git push origin v1.1```
- Create a Hash for Buildroot: wget https://github.com/johnosbb/darknet_embedded/archive/refs/tags/v1.1.tar.gz -O v1.1.tar.gz; sha256sum v1.1.tar.gz
- 

