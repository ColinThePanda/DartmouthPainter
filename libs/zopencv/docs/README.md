# zOpenCV Documentation

## Overview

zOpenCV provides complete Zig bindings for OpenCV 4.13.0 with opencv_contrib modules.

| Stat                     | Value |
| ------------------------ | ----- |
| Zig API Functions        | 651   |
| Unit + Integration Tests | 560   |
| Working Examples         | 22    |
| Core Modules             | 15    |
| Contrib Modules          | 13    |

## Documentation Index

### API Reference

- [**API Overview & Cross-Reference**](api.md) — Complete module listing with function counts and OpenCV mapping table

### Core Modules

| Module     | Doc                            | Description                                            |
| ---------- | ------------------------------ | ------------------------------------------------------ |
| core       | [README](core/README.md)       | Mat, Point, Rect, Size, Scalar, and matrix operations  |
| imgproc    | [README](imgproc/README.md)    | Filters, edge detection, morphology, drawing, contours |
| imgcodecs  | [README](imgcodecs/README.md)  | Image read/write (imread, imwrite, imencode, imdecode) |
| videoio    | [README](videoio/README.md)    | VideoCapture and VideoWriter                           |
| highgui    | [README](highgui/README.md)    | GUI windows, trackbars, mouse events                   |
| dnn        | [README](dnn/README.md)        | Deep neural network inference                          |
| features2d | [README](features2d/README.md) | ORB, SIFT, AKAZE, BFMatcher                            |
| objdetect  | [README](objdetect/README.md)  | CascadeClassifier, HOGDescriptor, QRCodeDetector       |
| video      | [README](video/README.md)      | Optical flow, background subtraction, tracking         |
| photo      | [README](photo/README.md)      | Denoising, inpainting, HDR, tone mapping               |
| calib3d    | [README](calib3d/README.md)    | Camera calibration, stereo vision, pose estimation     |
| ml         | [README](ml/README.md)         | SVM, KNearest classifiers                              |
| stitching  | [README](stitching/README.md)  | Image stitching / panorama                             |
| flann      | [README](flann/README.md)      | Fast nearest neighbor search                           |

### Contrib Modules

| Module       | Doc                               | Description                                                 |
| ------------ | --------------------------------- | ----------------------------------------------------------- |
| aruco        | [README](contrib/aruco.md)        | ArUco marker detection and generation                       |
| tracking     | [README](contrib/tracking.md)     | Object tracking (KCF)                                       |
| face         | [README](contrib/face.md)         | Face recognition (LBPHFaceRecognizer)                       |
| text         | [README](contrib/text.md)         | Text detection and recognition (OCR)                        |
| xfeatures2d  | [README](contrib/xfeatures2d.md)  | Extended feature detectors (SURF, BriefDescriptorExtractor) |
| ximgproc     | [README](contrib/ximgproc.md)     | Extended image processing (thin, Niblack threshold)         |
| xphoto       | [README](contrib/xphoto.md)       | Extended photo (white balance, oil painting)                |
| img_hash     | [README](contrib/img_hash.md)     | Perceptual image hashing                                    |
| bgsegm       | [README](contrib/bgsegm.md)       | Background segmentation (CNT, GMG)                          |
| dnn_superres | [README](contrib/dnn_superres.md) | DNN-based super resolution                                  |
| bioinspired  | [README](contrib/bioinspired.md)  | Bio-inspired retina model                                   |
| optflow      | [README](contrib/optflow.md)      | Dense optical flow (DualTVL1)                               |
| saliency     | [README](contrib/saliency.md)     | Saliency detection (SpectralResidual, FineGrained)          |

### Guides

- [Examples Guide](../examples/README.md) — 22 working examples with descriptions
- [Project Structure](../STRUCTURE.md) — Source code organization
