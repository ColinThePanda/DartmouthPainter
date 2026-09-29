# zOpenCV Examples

This directory contains 22 complete, working examples demonstrating various OpenCV capabilities through the zOpenCV bindings.

## Building Examples

```bash
# Build all examples
zig build examples -Dcontrib=true

# Build a specific example
zig build example-hello_opencv
zig build example-face_detection

# Run a specific example
./zig-out/bin/hello_opencv
```

## Example Index

### Getting Started

| Example                              | Description                                     |
| ------------------------------------ | ----------------------------------------------- |
| [hello_opencv.zig](hello_opencv.zig) | Minimal example: create a Mat, check properties |
| [image_io.zig](image_io.zig)         | Read, manipulate, and write images              |

### Image Processing

| Example                                                        | Description                                         |
| -------------------------------------------------------------- | --------------------------------------------------- |
| [color_spaces.zig](color_spaces.zig)                           | Convert between color spaces (BGR, HSV, Gray)       |
| [edge_detection.zig](edge_detection.zig)                       | Canny, Sobel, and Laplacian edge detection          |
| [threshold.zig](threshold.zig)                                 | Binary, adaptive, and Otsu thresholding             |
| [morphology.zig](morphology.zig)                               | Erosion, dilation, opening, closing operations      |
| [histogram.zig](histogram.zig)                                 | Histogram calculation and equalization              |
| [contours.zig](contours.zig)                                   | Contour detection and drawing                       |
| [template_matching.zig](template_matching.zig)                 | Find patterns in images using template matching     |
| [drawing.zig](drawing.zig)                                     | Draw lines, rectangles, circles, ellipses, and text |
| [image_processing_pipeline.zig](image_processing_pipeline.zig) | Chain multiple processing steps together            |

### Feature Detection & Matching

| Example                                        | Description                                     |
| ---------------------------------------------- | ----------------------------------------------- |
| [feature_matching.zig](feature_matching.zig)   | Detect and match features using ORB descriptors |
| [realtime_features.zig](realtime_features.zig) | Real-time feature detection pipeline            |

### Object Detection

| Example                                  | Description                                  |
| ---------------------------------------- | -------------------------------------------- |
| [face_detection.zig](face_detection.zig) | Face detection using Haar cascade classifier |

### Video I/O

| Example                                  | Description                            |
| ---------------------------------------- | -------------------------------------- |
| [camera_capture.zig](camera_capture.zig) | Capture frames from a webcam           |
| [video_capture.zig](video_capture.zig)   | Read and process video files           |
| [video_writer.zig](video_writer.zig)     | Write processed frames to a video file |

### Video Analysis

| Example                                                  | Description                                 |
| -------------------------------------------------------- | ------------------------------------------- |
| [optical_flow.zig](optical_flow.zig)                     | Dense optical flow visualization            |
| [background_subtraction.zig](background_subtraction.zig) | Motion detection via background subtraction |

### Contrib Modules

| Example                                | Description                                        |
| -------------------------------------- | -------------------------------------------------- |
| [aruco_demo.zig](aruco_demo.zig)       | ArUco marker detection and generation              |
| [img_hash_demo.zig](img_hash_demo.zig) | Image perceptual hashing for similarity comparison |
| [photo_demo.zig](photo_demo.zig)       | Photo enhancement: denoising, HDR, inpainting      |

## Notes

- Most examples create synthetic test images, so no external files are needed.
- Examples requiring a webcam or specific files print usage instructions when run without arguments.
- All examples follow the RAII pattern with `defer .deinit()` for automatic resource cleanup.
- Build with `-Dcontrib=true` to include contrib module examples (aruco, img_hash, background_subtraction).
