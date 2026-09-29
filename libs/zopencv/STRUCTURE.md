# zOpenCV Project Structure

## Directory Layout

```
zopencv/
├── build.zig              # Build configuration (library, tests, examples)
├── build.zig.zon          # Package manifest
├── src/                   # Zig API layer (651 public functions)
│   ├── main.zig           # Root module — re-exports all modules
│   ├── c.zig              # C type imports
│   ├── core.zig           # Mat, Point, Rect, Size, Scalar (171 fns)
│   ├── imgproc.zig        # Image processing (115 fns)
│   ├── calib3d.zig        # Camera calibration, 3D vision (37 fns)
│   ├── features2d.zig     # Feature detection, matching (41 fns)
│   ├── photo.zig          # Computational photography (39 fns)
│   ├── videoio.zig        # VideoCapture, VideoWriter (29 fns)
│   ├── video.zig          # Optical flow, bg subtraction (27 fns)
│   ├── dnn.zig            # Neural network inference (21 fns)
│   ├── highgui.zig        # GUI windows, trackbars (19 fns)
│   ├── objdetect.zig      # Cascade, HOG, QR (19 fns)
│   ├── ml.zig             # SVM, KNearest (17 fns)
│   ├── stitching.zig      # Image stitching (13 fns)
│   ├── imgcodecs.zig      # Image read/write (9 fns)
│   ├── flann.zig          # Nearest neighbors (5 fns)
│   └── contrib/           # 13 contrib modules
│       ├── contrib.zig    # Contrib entry point
│       ├── aruco.zig      # ArUco markers (6 fns)
│       ├── bgsegm.zig     # Background segmentation (8 fns)
│       ├── bioinspired.zig # Bio-inspired retina (6 fns)
│       ├── dnn_superres.zig # DNN super resolution (7 fns)
│       ├── face.zig       # Face recognition (8 fns)
│       ├── img_hash.zig   # Perceptual hashing (9 fns)
│       ├── optflow.zig    # Dense optical flow (3 fns)
│       ├── saliency.zig   # Saliency detection (4 fns)
│       ├── text.zig       # OCR / text detection (7 fns)
│       ├── tracking.zig   # Object tracking (6 fns)
│       ├── xfeatures2d.zig # SURF, BRIEF (6 fns)
│       ├── ximgproc.zig   # Extended imgproc (9 fns)
│       └── xphoto.zig     # Extended photo (10 fns)
├── c_api/                 # C++ wrapper layer (extern "C" bridge)
│   ├── core.h / core.cpp
│   ├── imgproc.h / imgproc.cpp
│   ├── ...                # One .h/.cpp pair per core module
│   └── contrib/           # Contrib C wrappers
│       ├── aruco.h / aruco.cpp
│       └── ...
├── test/                  # 560 tests
│   ├── test_runner.zig    # Main test runner
│   ├── unit_runner.zig    # Unit test runner
│   ├── contrib_runner.zig # Contrib test runner
│   ├── unit/              # Per-module unit tests
│   │   ├── core_test.zig
│   │   ├── imgproc_test.zig
│   │   ├── ...
│   │   └── contrib/       # Contrib module tests
│   │       ├── aruco_test.zig
│   │       └── ...
│   └── integration/       # Multi-module integration tests
│       ├── pipeline_test.zig
│       └── contrib/
├── examples/              # 22 working examples
│   ├── README.md          # Categorized example index
│   ├── hello_opencv.zig
│   ├── face_detection.zig
│   └── ...
├── docs/                  # API documentation
│   ├── README.md          # Documentation index
│   ├── api.md             # Complete API cross-reference
│   ├── core/README.md
│   ├── imgproc/README.md
│   ├── ...                # Per-module docs
│   └── contrib/           # Contrib module docs
├── testdata/              # Test data files
└── CHANGELOG.md
```

## Module Categories

### Core Modules (15)

Located directly in `src/` and `c_api/`:

core, imgproc, imgcodecs, videoio, highgui, features2d, objdetect,
photo, calib3d, video, dnn, ml, stitching, flann

### Contrib Modules (13)

Located in `src/contrib/` and `c_api/contrib/`:

aruco, bgsegm, bioinspired, dnn_superres, face, img_hash, optflow,
saliency, text, tracking, xfeatures2d, ximgproc, xphoto

Build with `-Dcontrib=true` to include contrib modules.

## Data Flow

```
Zig API (src/*.zig) → C API (c_api/*.cpp, extern "C") → OpenCV C++ → return path
```
