# Contrib Modules Overview

zOpenCV includes bindings for 13 OpenCV Contrib modules.

## Module List

| Module                          | Description                           | Functions |
| ------------------------------- | ------------------------------------- | --------- |
| [aruco](aruco.md)               | ArUco marker detection and generation | 6         |
| [bgsegm](bgsegm.md)             | Background segmentation (CNT, GMG)    | 8         |
| [bioinspired](bioinspired.md)   | Bio-inspired retina model             | 6         |
| [dnn_superres](dnn_superres.md) | DNN-based super resolution            | 7         |
| [face](face.md)                 | Face recognition (LBPH)               | 8         |
| [img_hash](img_hash.md)         | Perceptual image hashing              | 9         |
| [optflow](optflow.md)           | Dense optical flow (DualTVL1)         | 3         |
| [saliency](saliency.md)         | Saliency detection                    | 4         |
| [text](text.md)                 | Text detection and OCR                | 7         |
| [tracking](tracking.md)         | Object tracking (KCF)                 | 6         |
| [xfeatures2d](xfeatures2d.md)   | Extended features (SURF, BRIEF)       | 6         |
| [ximgproc](ximgproc.md)         | Extended image processing             | 9         |
| [xphoto](xphoto.md)             | Extended photography                  | 10        |

## Building with Contrib

```bash
zig build test -Dcontrib=true       # Run tests including contrib
zig build examples -Dcontrib=true   # Build examples including contrib
```

## Usage

```zig
const cv = @import("zopencv");

// Access contrib modules via cv.contrib namespace
var tracker = try cv.contrib.tracking.TrackerKCF.init();
defer tracker.deinit();
```
