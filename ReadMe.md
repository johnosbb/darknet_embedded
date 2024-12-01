# Darknet Embedded

Darknet is an open-source neural network framework Written in C and CUDA, optimized for computational efficiency. It is used for training and deploying deep learning models, particularly in computer vision tasks. The original Darknet framework was created by Joseph Redmon, a computer scientist and AI researcher. He initially developed Darknet while working on YOLO (You Only Look Once), a groundbreaking object detection system, as part of his research at the University of Washington.

Darknet Embedded is a slimmed down version of the darknet software (forked from https://github.com/AlexeyAB/darknet) geared towards resource constrained embedded devices. It can be used without dependency on GPU support, OpenCV and other frameworks which may not be available on constrained devices. It is also compatible with small foot-print C libraries like uclibc and musl which are specifically designed for embedded systems.

It is primarily intended for educational purposes and has been refactored to use CMake with additional scripts and configuration files that make integration into automated build environments like Buildroot easier. It can be integrated with Buildroot and a number of sample configurations are provided for both libc and uclibc based configurations. It is intended for those who want to experiment with the technology on low cost constrained embedded devices that run embedded Linux.

![image](https://github.com/user-attachments/assets/e40d842b-38df-492a-8290-d5111e2a1074)

## Buildroot

- `make darknet_embedded-dirclean`
- `make darknet_embedded`

## Git Management

- Tag a release on the command line: `git tag -a v1.0 -m "Release version 1.0 ` followed by `git push origin v1.1`
- Create a Hash for Buildroot: wget https://github.com/johnosbb/darknet_embedded/archive/refs/tags/v1.1.tar.gz -O v1.1.tar.gz; sha256sum v1.1.tar.gz

# Object Detection

Object detection is a computer vision task that involves identifying and localizing objects in an image or video. Unlike classification, which only labels the content of an image, object detection provides both the class of the object (e.g., "cat," "car") and its location within the frame, typically represented as bounding boxes. For example:

`Detected object: Class person, Probability 0.98, Box with normalised locations [Center: (0.36, 0.56) Width: 0.15 Height: 0.68]`

Object Detection is computationally intensive and poses some key challenges: The algorithm must detect objects in complex scenes with varying sizes, shapes, and appearances. For many applications like autonomous driving, surveillance, or robotics it must achieve real-time performance for applications like. It must also handle objects of different scales within a single image.

Over the years, various object detection approaches have emerged. One os the best known approach is Region-based Convolutional Neural Networks (R-CNN). This approach divides the object detection task into two stages: The first stage generates possible regions in the image where objects might exist. The second stage then uses a CNN to classify and refine these regions.

Single Shot MultiBox Detector (SSD) performs object detection in a single stage, without a separate region proposal step. It uses a grid of default bounding boxes and applies convolutional filters to predict object classes and refine bounding box coordinates directly.

YOLO (You Only Look Once) is another single-stage detection framework that frames object detection as a regression problem, emphasizing speed and simplicity. It is the initial focus of investigation into Object Detection and its integration into embedded systems.

YOLO is a deep learning-based object detection framework introduced by Joseph Redmon et al. in 2016. Its defining characteristic is its ability to perform object detection in a single pass through the neural network, making it extremely fast.

## How YOLO Works

The image is divided into an SxS grid of cells (e.g., 13x13 for YOLOv3 with a 416x416 input image). Each cell is responsible for predicting objects whose center falls within it.

Each cell predicts B bounding boxes. A bounding box includes x,y: Coordinates of the box center relative to the cell and Width and height relative to the image dimensions. Each cell also has a confidence score to indicate the likelihood of an object being in the box and the accuracy of the box. Each cell also predicts C class probabilities for the object.

YOLO combines these outputs (bounding boxes + class probabilities) in a single forward pass of the network. This enables end-to-end training, unlike region-based methods that split the task into separate stages.

## Applications

YOLO's speed and low complexity has made it a polular choice for **Autonomous Vehicles** where real-time detection of pedestrians, vehicles, and traffic signs is critical. It is also widely used in **Security and Surveillance** applications where it is often integrated into cameras. It has also become popular in **Retail Analytics** where smart cameras customer behavior analysis through object detection in stores.

## Darknet

The official implementations of YOLOv1, YOLOv2, and YOLOv3 are provided as part of the Darknet framework. Wile Darknet can work without a GPU much of its core implementation has been written in CUDA allowing providing seamless GPU acceleration for efficient training and inference. Compared to other frameworks Yolo has minimal dependencies and simple configuration files; these features will benefit us when we try to run Yola on Edge devices with constrained resources.
