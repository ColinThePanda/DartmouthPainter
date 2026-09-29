# Image Processing Module

Filters, edge detection, morphology, drawing, contours, and geometric transforms.

## Color Conversion

```zig
fn cvtColor(src: Mat, dst: *Mat, code: ColorConversionCode) void;

const ColorConversionCode = enum(i32) {
    bgr2gray = 6, gray2bgr = 8, bgr2rgb = 4, bgr2hsv = 40, hsv2bgr = 54, // ...
};
```

## Filtering

```zig
fn gaussianBlur(src: Mat, dst: *Mat, ksize: Size, sigmaX: f64, sigmaY: f64, borderType: i32) void;
fn medianBlur(src: Mat, dst: *Mat, ksize: i32) void;
fn blur(src: Mat, dst: *Mat, ksize: Size) void;
fn bilateralFilter(src: Mat, dst: *Mat, d: i32, sigmaColor: f64, sigmaSpace: f64, borderType: i32) void;
fn filter2D(src: Mat, dst: *Mat, ddepth: i32, kernel: Mat, anchor: Point, delta: f64, borderType: i32) void;
fn scharr(src: Mat, dst: *Mat, ddepth: i32, dx: i32, dy: i32, scale: f64, delta: f64, borderType: i32) void;
```

## Edge Detection

```zig
fn canny(src: Mat, dst: *Mat, threshold1: f64, threshold2: f64, apertureSize: i32, L2gradient: bool) void;
fn sobel(src: Mat, dst: *Mat, ddepth: i32, dx: i32, dy: i32, ksize: i32, scale: f64, delta: f64, borderType: i32) void;
fn laplacian(src: Mat, dst: *Mat, ddepth: i32, ksize: i32, scale: f64, delta: f64, borderType: i32) void;
```

## Thresholding

```zig
fn threshold(src: Mat, dst: *Mat, thresh: f64, maxval: f64, threshType: ThresholdType) f64;
fn adaptiveThreshold(src: Mat, dst: *Mat, maxValue: f64, adaptiveMethod: i32, thresholdType: ThresholdType, blockSize: i32, C: f64) void;
```

## Morphology

```zig
fn erode(src: Mat, dst: *Mat, kernel: Mat, anchor: Point, iterations: i32, borderType: i32) void;
fn dilate(src: Mat, dst: *Mat, kernel: Mat, anchor: Point, iterations: i32, borderType: i32) void;
fn morphologyEx(src: Mat, dst: *Mat, op: MorphType, kernel: Mat, anchor: Point, iterations: i32, borderType: i32) void;
fn getStructuringElement(shape: MorphShape, ksize: Size, anchor: Point) !Mat;
```

## Contours

```zig
fn findContours(image: Mat, mode: i32, method: i32) !PointsVector;
fn drawContours(image: *Mat, contours: PointsVector, contourIdx: i32, color: Scalar, thickness: i32) void;
fn contourArea(contour: PointVector, oriented: bool) f64;
fn arcLength(curve: PointVector, closed: bool) f64;
fn boundingRect(contour: PointVector) Rect;
fn minAreaRect(points: PointVector) RotatedRect;
fn minEnclosingCircle(points: PointVector) struct { center: Point2f, radius: f32 };
fn approxPolyDP(curve: PointVector, epsilon: f64, closed: bool) !PointVector;
fn convexHull(points: PointVector, clockwise: bool) !PointVector;
fn matchShapes(contour1: PointVector, contour2: PointVector, method: i32, parameter: f64) f64;
fn fitLine(points: PointVector, line_mat: *Mat, dist_type: i32, param: f64, reps: f64, aeps: f64) void;
fn fitEllipse(points: PointVector) RotatedRect;
```

## Drawing

```zig
fn line(img: *Mat, pt1: Point, pt2: Point, color: Scalar, thickness: i32, lineType: i32, shift: i32) void;
fn rectangle(img: *Mat, rect: Rect, color: Scalar, thickness: i32, lineType: i32, shift: i32) void;
fn circle(img: *Mat, center: Point, radius: i32, color: Scalar, thickness: i32, lineType: i32, shift: i32) void;
fn ellipse(img: *Mat, center: Point, axes: Size, angle: f64, startAngle: f64, endAngle: f64, color: Scalar, thickness: i32, lineType: i32, shift: i32) void;
fn putText(img: *Mat, text: []const u8, org: Point, fontFace: i32, fontScale: f64, color: Scalar, thickness: i32, lineType: i32, bottomLeftOrigin: bool) void;
```

## Geometric Transforms

```zig
fn resize(src: Mat, dst: *Mat, dsize: Size, fx: f64, fy: f64, interpolation: InterpolationFlag) void;
fn warpAffine(src: Mat, dst: *Mat, M: Mat, dsize: Size, flags: i32, borderMode: i32, borderValue: Scalar) void;
fn warpPerspective(src: Mat, dst: *Mat, M: Mat, dsize: Size, flags: i32, borderMode: i32, borderValue: Scalar) void;
fn getAffineTransform(src: Point2fVector, dst: Point2fVector) !Mat;
fn getPerspectiveTransform(src: Point2fVector, dst: Point2fVector, solveMethod: i32) !Mat;
fn pyrDown(src: Mat, dst: *Mat, dstsize: Size, borderType: i32) void;
fn pyrUp(src: Mat, dst: *Mat, dstsize: Size, borderType: i32) void;
```

## Feature Detection & Histograms

```zig
fn goodFeaturesToTrack(image: Mat, corners: *Mat, maxCorners: i32, qualityLevel: f64, minDistance: f64) void;
fn matchTemplate(image: Mat, templ: Mat, result: *Mat, method: i32) void;
fn equalizeHist(src: Mat, dst: *Mat) void;
fn moments(src: Mat, binaryImage: bool) Moments;
fn houghLines(src: Mat, lines: *Mat, rho: f64, theta: f64, thresh: i32) void;
fn houghCircles(src: Mat, circles: *Mat, method: i32, dp: f64, minDist: f64, param1: f64, param2: f64, minRadius: i32, maxRadius: i32) void;
fn connectedComponents(image: Mat, labels: *Mat, connectivity: i32) i32;
fn connectedComponentsWithStats(image: Mat, labels: *Mat, stats: *Mat, centroids: *Mat, connectivity: i32) i32;
```
