# zOpenCV

zOpenCV: High-performance Zig bindings for [OpenCV](https://opencv.org/) 4.x — bridging the full power of OpenCV and opencv_contrib modules with Zig's zero-cost safety guarantees.

## Overview

| Metric              | Value                     |
| ------------------- | ------------------------- |
| **Version**         | 0.1.0                     |
| **Zig**             | 0.16.0-dev.2510+bcb5218a2 |
| **OpenCV**          | 4.13.0                    |
| **API Functions**   | 651                       |
| **Tests**           | 560 passing ✅             |
| **Examples**        | 22                        |
| **Core Modules**    | 15                        |
| **Contrib Modules** | 13                        |

## Features

- ✅ **Type-safe** — Idiomatic Zig API with compile-time type checking
- ✅ **Memory-safe** — RAII-style resource management with `defer`
- ✅ **Zero-cost** — Direct C API calls with minimal overhead
- ✅ **Comprehensive** — 651 functions across 28 modules
- ✅ **Well-tested** — 560 unit and integration tests
- ✅ **Exception-safe** — All C++ exceptions caught and mapped to Zig errors

## Quick Start

### Prerequisites

- **Zig** 0.16.0-dev.2510+bcb5218a2
- **OpenCV 4.13.0** with contrib modules

```bash
# macOS
brew install opencv

# Ubuntu/Debian
sudo apt-get install libopencv-dev

# Fedora
sudo dnf install opencv-devel
```

### Build & Test

```bash
git clone https://github.com/coderonion/zopencv
cd zopencv

zig build                           # Build library
zig build test                      # Run core tests
zig build test -Dcontrib=true       # Run all tests (including contrib)
zig build examples -Dcontrib=true   # Build all examples
zig build example-hello_opencv      # Build a specific example
```

### Basic Usage

```zig
const cv = @import("zopencv");

pub fn main() !void {
    // Read image
    var img = try cv.imgcodecs.imread("input.jpg", .color);
    defer img.deinit();

    // Convert to grayscale
    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    // Detect edges
    var edges = try cv.Mat.init();
    defer edges.deinit();
    cv.imgproc.canny(gray, &edges, 50, 150, 3, false);

    // Save result
    try cv.imgcodecs.imwrite("edges.jpg", edges);
}
```

## 📦 Use as Zig Package

Add zOpenCV as a dependency in your project — **C wrapper compilation and OpenCV linking are handled automatically**.

### Step 1: Add dependency to `build.zig.zon`

**Local path (for development):**

```zig
.dependencies = .{
    .zopencv = .{
        .path = "../zopencv",
    },
},
```

**Git URL (for release):**

```zig
.dependencies = .{
    .zopencv = .{
        .url = "https://github.com/coderonion/zopencv/archive/v0.1.0.tar.gz",
        .hash = "HASH_VALUE",
    },
},
```

> [!TIP]
> **How to get the hash:** First, add the `.url` field **without** `.hash`, then run `zig build`. Zig will download the package, compute the hash, and display the correct `.hash = "..."` value in the error output. Copy that value into your `build.zig.zon`.

### Step 2: Import in `build.zig`

**Option A — Simple (hardcoded flags):**

```zig
const zopencv = b.dependency("zopencv", .{
    .target   = target,
    .optimize = optimize,
    .contrib  = true,    // opencv_contrib modules (default: false)
});
exe.root_module.addImport("zopencv", zopencv.module("zopencv"));
```

**Option B — Dynamic (forward to CLI):**

Expose the contrib flag as your project's build option, so users can toggle it at build time:

```zig
const enable_contrib = b.option(bool, "contrib", "Enable opencv_contrib modules") orelse false;

const zopencv = b.dependency("zopencv", .{
    .target   = target,
    .optimize = optimize,
    .contrib  = enable_contrib,
});
exe.root_module.addImport("zopencv", zopencv.module("zopencv"));
```

```bash
zig build                        # core modules only
zig build -Dcontrib=true         # include opencv_contrib modules
```

### Step 3: Use in your code

```zig
const cv = @import("zopencv");

pub fn main() !void {
    var img = try cv.imgcodecs.imread("input.jpg", .color);
    defer img.deinit();
    // ...
}
```

## Modules

### Core Modules (15)

| Module         | Functions | Description                                                        |
| -------------- | --------- | ------------------------------------------------------------------ |
| **core**       | 171       | Mat, Point, Rect, Size, Scalar, matrix operations                  |
| **imgproc**    | 115       | Filters, edge detection, morphology, drawing, contours             |
| **features2d** | 41        | Feature detection (ORB, SIFT, AKAZE), matching (BFMatcher)         |
| **photo**      | 39        | Denoising, inpainting, HDR, tone mapping, artistic effects         |
| **calib3d**    | 37        | Camera calibration, stereo vision, pose estimation                 |
| **videoio**    | 29        | VideoCapture, VideoWriter, FourCC                                  |
| **video**      | 27        | Optical flow, background subtraction, tracking                     |
| **dnn**        | 21        | Neural network inference (ONNX, TF, Caffe, Darknet, Torch, TFLite) |
| **highgui**    | 19        | Windows, trackbars, mouse events, ROI selection                    |
| **objdetect**  | 19        | CascadeClassifier, HOGDescriptor, QRCodeDetector                   |
| **ml**         | 17        | SVM, KNearest classifiers                                          |
| **stitching**  | 13        | Image stitching / panorama                                         |
| **imgcodecs**  | 9         | imread, imwrite, imencode, imdecode, multi-page I/O                |
| **flann**      | 5         | Fast nearest neighbor search (KD-tree, K-means)                    |

### Contrib Modules (13)

| Module           | Functions | Description                                           |
| ---------------- | --------- | ----------------------------------------------------- |
| **xphoto**       | 10        | White balance, oil painting, inpainting               |
| **ximgproc**     | 9         | Thinning, Niblack threshold, extended morphology      |
| **img_hash**     | 9         | Perceptual hashing (PHash, AverageHash, MarrHildreth) |
| **face**         | 8         | LBPH face recognition                                 |
| **bgsegm**       | 8         | Background segmentation (CNT, GMG)                    |
| **text**         | 7         | OCR via Tesseract, text detection (SWT)               |
| **dnn_superres** | 7         | DNN-based super resolution                            |
| **xfeatures2d**  | 6         | SURF descriptors, BRIEF                               |
| **tracking**     | 6         | KCF object tracking                                   |
| **bioinspired**  | 6         | Bio-inspired retina model                             |
| **aruco**        | 6         | ArUco marker detection and generation                 |
| **saliency**     | 4         | Saliency detection (SpectralResidual, FineGrained)    |
| **optflow**      | 3         | Dense optical flow (DualTVL1)                         |

## Examples

22 working examples in the [`examples/`](examples/) directory. See [examples/README.md](examples/README.md) for the full categorized index.

```bash
# Build and run
zig build example-hello_opencv && ./zig-out/bin/hello_opencv
zig build example-edge_detection && ./zig-out/bin/edge_detection
zig build example-face_detection && ./zig-out/bin/face_detection
```

### Example Categories

| Category                | Examples                                                                                             |
| ----------------------- | ---------------------------------------------------------------------------------------------------- |
| **Getting Started**     | hello_opencv, image_io                                                                               |
| **Image Processing**    | edge_detection, threshold, morphology, histogram, contours, drawing, color_spaces, template_matching |
| **Features & Matching** | feature_matching, realtime_features                                                                  |
| **Object Detection**    | face_detection                                                                                       |
| **Video**               | camera_capture, video_capture, video_writer, optical_flow, background_subtraction                    |
| **Contrib**             | aruco_demo, img_hash_demo, photo_demo                                                                |

## Documentation

Comprehensive documentation is available in the [`docs/`](docs/) directory:

- **[Documentation Index](docs/README.md)** — Full navigation guide
- **[API Reference](docs/api.md)** — Complete Zig ↔ OpenCV cross-reference table (651 functions)
- **[Core Module Docs](docs/core/README.md)** — Mat, basic types, matrix operations
- **[Image Processing Docs](docs/imgproc/README.md)** — Filters, transforms, drawing, contours
- **[Contrib Module Docs](docs/contrib/README.md)** — All 13 contrib module references

Each module has its own detailed README in `docs/<module>/README.md`.

## Testing

```bash
zig build test                      # Core module tests
zig build test -Dcontrib=true       # All tests (560 tests, including contrib)
zig build test-unit                 # Unit tests only (fast, no I/O)
zig build test-integration          # Integration tests (uses real images/video)
zig build test-contrib              # Contrib module tests only
```

Test coverage includes:
- **Unit tests** — Each module's core functionality, error handling, edge cases
- **Integration tests** — Multi-module workflows with real images and video
- **Memory safety** — Create/deinit cycles, empty Mat handling, zero-size operations

## Architecture

```
zopencv/
├── src/                    # Zig API layer (651 public functions)
│   ├── main.zig           # Root module — re-exports all modules
│   ├── core.zig           # Mat, Point, Rect, Size, Scalar (171 fns)
│   ├── imgproc.zig        # Image processing (115 fns)
│   ├── contrib/           # 13 contrib module bindings
│   └── ...                # 12 more module files
├── c_api/                 # C++ wrapper layer (C ABI bridge)
│   ├── core.h / core.cpp
│   ├── contrib/           # Contrib C wrappers
│   └── ...
├── examples/              # 22 working examples
├── test/                  # 560 tests
│   ├── unit/              # Per-module unit tests
│   └── integration/       # Multi-module integration tests
├── docs/                  # Comprehensive API documentation
├── build.zig              # Build configuration
└── build.zig.zon          # Package manifest
```

**Data Flow:** Zig API → C API (extern "C") → OpenCV C++ → Back through same path

## Error Handling

All fallible functions return Zig error unions:

```zig
pub const Error = error{
    NullPointer,        // C API returned NULL (failed load, allocation, etc.)
    MatCreationFailed,  // Mat allocation failed
    MatIsEmpty,         // Operation on empty Mat
    InvalidMatType,     // Wrong Mat type for operation
    InvalidIndex,       // Index out of bounds
    ImWriteFailed,      // Image write failed
};
```

All C++ exceptions from OpenCV are caught in the C API layer and converted to NULL returns, which the Zig layer maps to `error.NullPointer`.

## Contributing

1. ⭐ Star and Fork this repository
2. Create a feature branch (`git checkout -b feature/new-module`)
3. Implement C++ wrapper in `c_api/`
4. Create Zig API bindings in `src/`
5. Add unit tests in `test/unit/` and integration tests in `test/integration/`
6. Create an example in `examples/`
7. Update documentation in `docs/`
8. Submit a Pull Request

## License

MIT License

## Acknowledgments

Built with gratitude on the shoulders of giants:

- **[OpenCV](https://opencv.org/)** — The industry-standard open-source computer vision library, maintained by the OpenCV team and a global community of contributors.
- **[Zig](https://ziglang.org/)** — A modern systems programming language focused on safety, performance, and simplicity, created by Andrew Kelley and the Zig Software Foundation.