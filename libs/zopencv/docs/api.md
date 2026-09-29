# zOpenCV API Reference

Complete Zig bindings for OpenCV 4.13.0 with opencv_contrib modules.

**Version:** 0.1.0 | **Zig:** 0.16.0-dev.2510+bcb5218a2 | **OpenCV:** 4.13.0 | **Functions:** 651 | **Tests:** 560

---

## Module Summary

### Core Modules (15)

| Module     | Zig File         | Functions | OpenCV Module            | Status     |
| ---------- | ---------------- | --------- | ------------------------ | ---------- |
| core       | `core.zig`       | 171       | `opencv2/core.hpp`       | ✅ Complete |
| imgproc    | `imgproc.zig`    | 115       | `opencv2/imgproc.hpp`    | ✅ Complete |
| calib3d    | `calib3d.zig`    | 37        | `opencv2/calib3d.hpp`    | ✅ Complete |
| features2d | `features2d.zig` | 41        | `opencv2/features2d.hpp` | ✅ Complete |
| photo      | `photo.zig`      | 39        | `opencv2/photo.hpp`      | ✅ Complete |
| videoio    | `videoio.zig`    | 29        | `opencv2/videoio.hpp`    | ✅ Complete |
| video      | `video.zig`      | 27        | `opencv2/video.hpp`      | ✅ Complete |
| dnn        | `dnn.zig`        | 21        | `opencv2/dnn.hpp`        | ✅ Complete |
| highgui    | `highgui.zig`    | 19        | `opencv2/highgui.hpp`    | ✅ Complete |
| objdetect  | `objdetect.zig`  | 19        | `opencv2/objdetect.hpp`  | ✅ Complete |
| ml         | `ml.zig`         | 17        | `opencv2/ml.hpp`         | ✅ Complete |
| stitching  | `stitching.zig`  | 13        | `opencv2/stitching.hpp`  | ✅ Complete |
| imgcodecs  | `imgcodecs.zig`  | 9         | `opencv2/imgcodecs.hpp`  | ✅ Complete |
| flann      | `flann.zig`      | 5         | `opencv2/flann.hpp`      | ✅ Complete |

### Contrib Modules (13)

| Module       | Zig File                   | Functions | OpenCV Module              | Status     |
| ------------ | -------------------------- | --------- | -------------------------- | ---------- |
| xphoto       | `contrib/xphoto.zig`       | 10        | `opencv2/xphoto.hpp`       | ✅ Complete |
| ximgproc     | `contrib/ximgproc.zig`     | 9         | `opencv2/ximgproc.hpp`     | ✅ Complete |
| img_hash     | `contrib/img_hash.zig`     | 9         | `opencv2/img_hash.hpp`     | ✅ Complete |
| face         | `contrib/face.zig`         | 8         | `opencv2/face.hpp`         | ✅ Complete |
| bgsegm       | `contrib/bgsegm.zig`       | 8         | `opencv2/bgsegm.hpp`       | ✅ Complete |
| text         | `contrib/text.zig`         | 7         | `opencv2/text.hpp`         | ✅ Complete |
| dnn_superres | `contrib/dnn_superres.zig` | 7         | `opencv2/dnn_superres.hpp` | ✅ Complete |
| xfeatures2d  | `contrib/xfeatures2d.zig`  | 6         | `opencv2/xfeatures2d.hpp`  | ✅ Complete |
| tracking     | `contrib/tracking.zig`     | 6         | `opencv2/tracking.hpp`     | ✅ Complete |
| bioinspired  | `contrib/bioinspired.zig`  | 6         | `opencv2/bioinspired.hpp`  | ✅ Complete |
| aruco        | `contrib/aruco.zig`        | 6         | `opencv2/aruco.hpp`        | ✅ Complete |
| saliency     | `contrib/saliency.zig`     | 4         | `opencv2/saliency.hpp`     | ✅ Complete |
| optflow      | `contrib/optflow.zig`      | 3         | `opencv2/optflow.hpp`      | ✅ Complete |

---

## API Cross-Reference: Zig ↔ OpenCV C++

### Core Types

| Zig Type           | OpenCV C++ Type                       | Description                                 |
| ------------------ | ------------------------------------- | ------------------------------------------- |
| `cv.Mat`           | `cv::Mat`                             | N-dimensional dense array (image container) |
| `cv.Mats`          | `std::vector<cv::Mat>`                | Vector of Mat objects                       |
| `cv.Point`         | `cv::Point`                           | 2D integer point                            |
| `cv.Point2f`       | `cv::Point2f`                         | 2D float point                              |
| `cv.Point3f`       | `cv::Point3f`                         | 3D float point                              |
| `cv.Rect`          | `cv::Rect`                            | Rectangle (x, y, width, height)             |
| `cv.Size`          | `cv::Size`                            | 2D size (width, height)                     |
| `cv.Scalar`        | `cv::Scalar`                          | 4-element vector (for colors, etc.)         |
| `cv.PointVector`   | `std::vector<cv::Point>`              | Vector of points                            |
| `cv.Point2fVector` | `std::vector<cv::Point2f>`            | Vector of 2D float points                   |
| `cv.PointsVector`  | `std::vector<std::vector<cv::Point>>` | Vector of point vectors (contours)          |
| `cv.RectVector`    | `std::vector<cv::Rect>`               | Vector of rectangles                        |
| `cv.RotatedRect`   | `cv::RotatedRect`                     | Rotated rectangle                           |
| `cv.TermCriteria`  | `cv::TermCriteria`                    | Iteration termination criteria              |
| `cv.RNG`           | `cv::RNG`                             | Random number generator                     |

### Core Module — Mat Operations

| Zig Function                  | OpenCV C++                    | Description            |
| ----------------------------- | ----------------------------- | ---------------------- |
| `Mat.init()`                  | `cv::Mat()`                   | Create empty Mat       |
| `Mat.initWithSize(r, c, t)`   | `cv::Mat(r, c, t)`            | Create sized Mat       |
| `Mat.zeros(r, c, t)`          | `cv::Mat::zeros(r, c, t)`     | Create zero-filled Mat |
| `Mat.ones(r, c, t)`           | `cv::Mat::ones(r, c, t)`      | Create ones-filled Mat |
| `Mat.eye(r, c, t)`            | `cv::Mat::eye(r, c, t)`       | Create identity Mat    |
| `mat.clone()`                 | `mat.clone()`                 | Deep copy              |
| `mat.copyTo(dst)`             | `mat.copyTo(dst)`             | Copy to destination    |
| `mat.convertTo(dst, t, a, b)` | `mat.convertTo(dst, t, a, b)` | Convert type           |
| `mat.reshape(cn, rows)`       | `mat.reshape(cn, rows)`       | Reshape without copy   |
| `mat.t()`                     | `mat.t()`                     | Transpose              |
| `mat.inv(method)`             | `mat.inv(method)`             | Matrix inverse         |
| `mat.mul(other, scale)`       | `mat.mul(other, scale)`       | Element-wise multiply  |
| `mat.dot(other)`              | `mat.dot(other)`              | Dot product            |
| `mat.cross(other)`            | `mat.cross(other)`            | Cross product          |
| `mat.submat(roi)`             | `mat(roi)`                    | ROI submatrix          |
| `mat.rowAt(y)`                | `mat.row(y)`                  | Single row             |
| `mat.colAt(x)`                | `mat.col(x)`                  | Single column          |
| `mat.setTo(value)`            | `mat.setTo(value)`            | Set all elements       |
| `mat.getDouble(r, c)`         | `mat.at<double>(r, c)`        | Get element            |
| `mat.setDouble(r, c, v)`      | `mat.at<double>(r, c) = v`    | Set element            |

### Image Processing (imgproc)

| Zig Function                  | OpenCV C++                  | Description               |
| ----------------------------- | --------------------------- | ------------------------- |
| `cvtColor(src, dst, code)`    | `cv::cvtColor()`            | Color space conversion    |
| `resize(src, dst, ...)`       | `cv::resize()`              | Resize image              |
| `gaussianBlur(src, dst, ...)` | `cv::GaussianBlur()`        | Gaussian smoothing        |
| `medianBlur(src, dst, k)`     | `cv::medianBlur()`          | Median smoothing          |
| `blur(src, dst, ksize)`       | `cv::blur()`                | Box filter                |
| `bilateralFilter(...)`        | `cv::bilateralFilter()`     | Edge-preserving smoothing |
| `canny(src, dst, ...)`        | `cv::Canny()`               | Edge detection            |
| `sobel(src, dst, ...)`        | `cv::Sobel()`               | Gradient (Sobel)          |
| `laplacian(src, dst, ...)`    | `cv::Laplacian()`           | Gradient (Laplacian)      |
| `erode(src, dst, ...)`        | `cv::erode()`               | Morphological erosion     |
| `dilate(src, dst, ...)`       | `cv::dilate()`              | Morphological dilation    |
| `morphologyEx(src, dst, ...)` | `cv::morphologyEx()`        | Advanced morphology       |
| `threshold(src, dst, ...)`    | `cv::threshold()`           | Thresholding              |
| `adaptiveThreshold(...)`      | `cv::adaptiveThreshold()`   | Adaptive thresholding     |
| `findContours(img, m, mth)`   | `cv::findContours()`        | Contour detection         |
| `drawContours(img, ...)`      | `cv::drawContours()`        | Contour drawing           |
| `boundingRect(contour)`       | `cv::boundingRect()`        | Bounding rectangle        |
| `minAreaRect(pts)`            | `cv::minAreaRect()`         | Minimum area rectangle    |
| `contourArea(c, oriented)`    | `cv::contourArea()`         | Contour area              |
| `arcLength(c, closed)`        | `cv::arcLength()`           | Contour perimeter         |
| `approxPolyDP(c, eps, cl)`    | `cv::approxPolyDP()`        | Polygon approximation     |
| `convexHull(pts, cw)`         | `cv::convexHull()`          | Convex hull               |
| `equalizeHist(src, dst)`      | `cv::equalizeHist()`        | Histogram equalization    |
| `matchTemplate(i, t, r, m)`   | `cv::matchTemplate()`       | Template matching         |
| `line(img, pt1, pt2, ...)`    | `cv::line()`                | Draw line                 |
| `rectangle(img, rect, ...)`   | `cv::rectangle()`           | Draw rectangle            |
| `circle(img, c, r, ...)`      | `cv::circle()`              | Draw circle               |
| `ellipse(img, ...)`           | `cv::ellipse()`             | Draw ellipse              |
| `putText(img, text, ...)`     | `cv::putText()`             | Draw text                 |
| `warpAffine(...)`             | `cv::warpAffine()`          | Affine transform          |
| `warpPerspective(...)`        | `cv::warpPerspective()`     | Perspective transform     |
| `houghLines(...)`             | `cv::HoughLines()`          | Line detection            |
| `houghCircles(...)`           | `cv::HoughCirclesf()`       | Circle detection          |
| `moments(src, binary)`        | `cv::moments()`             | Image moments             |
| `filter2D(...)`               | `cv::filter2D()`            | Custom convolution        |
| `goodFeaturesToTrack(...)`    | `cv::goodFeaturesToTrack()` | Corner detection          |
| `pyrDown(src, dst, ...)`      | `cv::pyrDown()`             | Downsample                |
| `pyrUp(src, dst, ...)`        | `cv::pyrUp()`               | Upsample                  |

### Image Codecs (imgcodecs)

| Zig Function                 | OpenCV C++              | Description                   |
| ---------------------------- | ----------------------- | ----------------------------- |
| `imread(file, flags)`        | `cv::imread()`          | Read image from file          |
| `imwrite(file, img)`         | `cv::imwrite()`         | Write image to file           |
| `imwriteWithParams(...)`     | `cv::imwrite()`         | Write with compression params |
| `imencode(ext, img, params)` | `cv::imencode()`        | Encode to memory buffer       |
| `imdecode(buf, flags)`       | `cv::imdecode()`        | Decode from memory buffer     |
| `imreadMulti(file, flags)`   | `cv::imreadmulti()`     | Read multi-page image         |
| `haveImageReader(file)`      | `cv::haveImageReader()` | Check reader support          |
| `haveImageWriter(file)`      | `cv::haveImageWriter()` | Check writer support          |
| `imcount(file, flags)`       | `cv::imcount()`         | Count pages in file           |

### DNN

| Zig Function                     | OpenCV C++                         | Description               |
| -------------------------------- | ---------------------------------- | ------------------------- |
| `Net.readNetFromDarknet(...)`    | `cv::dnn::readNetFromDarknet()`    | Load Darknet model        |
| `Net.readNetFromCaffe(...)`      | `cv::dnn::readNetFromCaffe()`      | Load Caffe model          |
| `Net.readNetFromTensorflow(...)` | `cv::dnn::readNetFromTensorflow()` | Load TF model             |
| `Net.readNetFromONNX(...)`       | `cv::dnn::readNetFromONNX()`       | Load ONNX model           |
| `Net.readNetFromTorch(...)`      | `cv::dnn::readNetFromTorch()`      | Load Torch model          |
| `Net.readNetFromTFLite(...)`     | `cv::dnn::readNetFromTFLite()`     | Load TFLite model         |
| `net.forward(name)`              | `net.forward()`                    | Run forward pass          |
| `net.setInput(blob, name)`       | `net.setInput()`                   | Set network input         |
| `net.setPreferableBackend(b)`    | `net.setPreferableBackend()`       | Set compute backend       |
| `net.setPreferableTarget(t)`     | `net.setPreferableTarget()`        | Set compute target        |
| `net.dump()`                     | `net.dump()`                       | Dump network structure    |
| `blobFromImage(...)`             | `cv::dnn::blobFromImage()`         | Create 4D blob from image |
| `nmsBoxes(...)`                  | `cv::dnn::NMSBoxes()`              | Non-maximum suppression   |

### Video Analysis (video)

| Zig Function                      | OpenCV C++                             | Description                |
| --------------------------------- | -------------------------------------- | -------------------------- |
| `BackgroundSubtractorMOG2.init()` | `cv::createBackgroundSubtractorMOG2()` | MOG2 background subtractor |
| `BackgroundSubtractorKNN.init()`  | `cv::createBackgroundSubtractorKNN()`  | KNN background subtractor  |
| `calcOpticalFlowPyrLK(...)`       | `cv::calcOpticalFlowPyrLK()`           | Sparse optical flow        |
| `calcOpticalFlowFarneback(...)`   | `cv::calcOpticalFlowFarneback()`       | Dense optical flow         |
| `Tracker.initMIL()`               | `cv::TrackerMIL::create()`             | MIL tracker                |

### Video I/O (videoio)

| Zig Function                      | OpenCV C++                  | Description        |
| --------------------------------- | --------------------------- | ------------------ |
| `VideoCapture.init()`             | `cv::VideoCapture()`        | Create capture     |
| `VideoCapture.initFromFile(f)`    | `cv::VideoCapture(f)`       | Open file          |
| `VideoCapture.initFromIndex(i)`   | `cv::VideoCapture(i)`       | Open camera        |
| `vc.read(frame)`                  | `vc.read(frame)`            | Read next frame    |
| `vc.get(prop)`                    | `vc.get(prop)`              | Get property       |
| `vc.set(prop, val)`               | `vc.set(prop, val)`         | Set property       |
| `VideoWriter.initWithParams(...)` | `cv::VideoWriter(...)`      | Create writer      |
| `vw.write(img)`                   | `vw.write(img)`             | Write frame        |
| `fourcc(c1,c2,c3,c4)`             | `cv::VideoWriter::fourcc()` | Create FourCC code |

### Features2D

| Zig Function                       | OpenCV C++                     | Description         |
| ---------------------------------- | ------------------------------ | ------------------- |
| `ORB.init()`                       | `cv::ORB::create()`            | ORB detector        |
| `SIFT.init()`                      | `cv::SIFT::create()`           | SIFT detector       |
| `AKAZE.init()`                     | `cv::AKAZE::create()`          | AKAZE detector      |
| `detector.detect(img, kps)`        | `detector->detect()`           | Detect keypoints    |
| `detector.compute(img, kps, desc)` | `detector->compute()`          | Compute descriptors |
| `detector.detectAndCompute(...)`   | `detector->detectAndCompute()` | Detect + compute    |
| `BFMatcher.init()`                 | `cv::BFMatcher()`              | Brute-force matcher |
| `matcher.knnMatch(q, t, k)`        | `matcher.knnMatch()`           | KNN matching        |

### Object Detection (objdetect)

| Zig Function                | OpenCV C++                | Description           |
| --------------------------- | ------------------------- | --------------------- |
| `CascadeClassifier.init()`  | `cv::CascadeClassifier()` | Create classifier     |
| `cc.load(file)`             | `cc.load(file)`           | Load cascade file     |
| `cc.detectMultiScale(...)`  | `cc.detectMultiScale()`   | Multi-scale detection |
| `HOGDescriptor.init()`      | `cv::HOGDescriptor()`     | HOG detector          |
| `hog.setSVMDetector(type)`  | `hog.setSVMDetector()`    | Set people detector   |
| `hog.detectMultiScale(...)` | `hog.detectMultiScale()`  | Detect objects        |
| `QRCodeDetector.init()`     | `cv::QRCodeDetector()`    | QR code detector      |
| `qr.detectAndDecode(...)`   | `qr.detectAndDecode()`    | Detect and decode QR  |

### Photo

| Zig Function                       | OpenCV C++                          | Description          |
| ---------------------------------- | ----------------------------------- | -------------------- |
| `fastNlMeansDenoising(...)`        | `cv::fastNlMeansDenoising()`        | Grayscale denoising  |
| `fastNlMeansDenoisingColored(...)` | `cv::fastNlMeansDenoisingColored()` | Color denoising      |
| `inpaint(src, mask, dst, ...)`     | `cv::inpaint()`                     | Image inpainting     |
| `detailEnhance(src, dst, ...)`     | `cv::detailEnhance()`               | Detail enhancement   |
| `pencilSketch(src, ...)`           | `cv::pencilSketch()`                | Pencil sketch effect |
| `stylization(src, dst, ...)`       | `cv::stylization()`                 | Stylization          |
| `seamlessClone(src, dst, ...)`     | `cv::seamlessClone()`               | Seamless cloning     |
| `decolorization(src, ...)`         | `cv::decolor()`                     | Decolorization       |
| `MergeMertens.init()`              | `cv::createMergeMertens()`          | HDR merge (Mertens)  |
| `Tonemap.init(gamma)`              | `cv::createTonemap()`               | Tone mapping         |
| `AlignMTB.init(...)`               | `cv::createAlignMTB()`              | Exposure alignment   |

### Calibration & 3D (calib3d)

| Zig Function                 | OpenCV C++                    | Description             |
| ---------------------------- | ----------------------------- | ----------------------- |
| `calibrateCamera(...)`       | `cv::calibrateCamera()`       | Camera calibration      |
| `undistort(src, dst, ...)`   | `cv::undistort()`             | Lens undistortion       |
| `findChessboardCorners(...)` | `cv::findChessboardCorners()` | Chessboard detection    |
| `solvePnP(...)`              | `cv::solvePnP()`              | PnP pose estimation     |
| `findHomography(...)`        | `cv::findHomography()`        | Homography estimation   |
| `findFundamentalMat(...)`    | `cv::findFundamentalMat()`    | Fundamental matrix      |
| `findEssentialMat(...)`      | `cv::findEssentialMat()`      | Essential matrix        |
| `stereoCalibrate(...)`       | `cv::stereoCalibrate()`       | Stereo calibration      |
| `drawFrameAxes(...)`         | `cv::drawFrameAxes()`         | Draw 3D coordinate axes |

### Machine Learning (ml)

| Zig Function                            | OpenCV C++                   | Description   |
| --------------------------------------- | ---------------------------- | ------------- |
| `SVM.init()`                            | `cv::ml::SVM::create()`      | Create SVM    |
| `svm.train(samples, layout, responses)` | `svm->train()`               | Train model   |
| `svm.predict(samples, results, flags)`  | `svm->predict()`             | Predict       |
| `svm.setType(type)` / `setKernel(k)`    | `svm->setType()`             | Configure SVM |
| `KNearest.init()`                       | `cv::ml::KNearest::create()` | Create KNN    |
| `knn.train(samples, layout, responses)` | `knn->train()`               | Train model   |
| `knn.predict(samples, ...)`             | `knn->predict()`             | Predict       |
| `knn.setDefaultK(k)`                    | `knn->setDefaultK()`         | Set K value   |

### Contrib Modules Cross-Reference

| Zig API                                  | OpenCV C++                             | Description            |
| ---------------------------------------- | -------------------------------------- | ---------------------- |
| `contrib.aruco.ArucoDetector`            | `cv::aruco::ArucoDetector`             | ArUco marker detection |
| `contrib.tracking.TrackerKCF`            | `cv::TrackerKCF`                       | KCF object tracking    |
| `contrib.face.LBPHFaceRecognizer`        | `cv::face::LBPHFaceRecognizer`         | Face recognition       |
| `contrib.text.OCRTesseract`              | `cv::text::OCRTesseract`               | OCR via Tesseract      |
| `contrib.xfeatures2d.SURF`               | `cv::xfeatures2d::SURF`                | SURF features          |
| `contrib.ximgproc.thinning(...)`         | `cv::ximgproc::thinning()`             | Skeletonization        |
| `contrib.ximgproc.niBlackThreshold(...)` | `cv::ximgproc::niBlackThreshold()`     | Niblack threshold      |
| `contrib.xphoto.WhiteBalancer`           | `cv::xphoto::WhiteBalancer`            | White balance          |
| `contrib.xphoto.oilPainting(...)`        | `cv::xphoto::oilPainting()`            | Oil painting effect    |
| `contrib.img_hash.PHash`                 | `cv::img_hash::PHash`                  | Perceptual hash        |
| `contrib.img_hash.AverageHash`           | `cv::img_hash::AverageHash`            | Average hash           |
| `contrib.bgsegm.BackgroundSubtractorCNT` | `cv::bgsegm::*BackgroundSubtractorCNT` | CNT bg subtraction     |
| `contrib.bgsegm.BackgroundSubtractorGMG` | `cv::bgsegm::*BackgroundSubtractorGMG` | GMG bg subtraction     |
| `contrib.dnn_superres.DnnSuperResImpl`   | `cv::dnn_superres::DnnSuperResImpl`    | DNN super resolution   |
| `contrib.bioinspired.Retina`             | `cv::bioinspired::Retina`              | Bio-inspired retina    |
| `contrib.optflow.DualTVL1OpticalFlow`    | `cv::optflow::DualTVL1OpticalFlow`     | TV-L1 optical flow     |
| `contrib.saliency.StaticSaliency`        | `cv::saliency::StaticSaliency*`        | Saliency detection     |

---

## Error Handling

All fallible functions return Zig error unions:

```zig
pub const Error = error{
    NullPointer,        // C API returned NULL (e.g., failed file load)
    MatCreationFailed,  // Mat allocation failed
    MatIsEmpty,         // Operation on empty Mat
    InvalidMatType,     // Wrong Mat type for operation
    InvalidIndex,       // Index out of bounds
    ImWriteFailed,      // Image write failed
};
```

## Memory Management

zOpenCV uses RAII-style resource management with `defer`:

```zig
var mat = try cv.Mat.init();
defer mat.deinit();  // Freed at scope exit

var detector = try cv.features2d.ORB.init();
defer detector.deinit();
```

## Building

```bash
zig build                           # Build library
zig build test                      # Run core tests
zig build test -Dcontrib=true       # Run all tests (including contrib)
zig build examples                  # Build core examples
zig build examples -Dcontrib=true   # Build all examples
zig build example-<name>            # Build specific example
```
