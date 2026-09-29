# Calibration & 3D Vision Module

Camera calibration, stereo vision, and pose estimation.

## Camera Calibration

```zig
fn calibrateCamera(objectPoints: PointsVector, imagePoints: PointsVector, imageSize: Size,
    cameraMatrix: *Mat, distCoeffs: *Mat, rvecs: *Mat, tvecs: *Mat, flags: i32) f64;

fn undistort(src: Mat, dst: *Mat, cameraMatrix: Mat, distCoeffs: Mat, newCameraMatrix: ?Mat) void;
fn undistortPoints(src: Mat, dst: *Mat, cameraMatrix: Mat, distCoeffs: Mat, R: ?Mat, P: ?Mat) void;
fn initUndistortRectifyMap(cameraMatrix: Mat, distCoeffs: Mat, R: Mat, newCameraMatrix: Mat,
    size: Size, m1type: i32, map1: *Mat, map2: *Mat) void;
```

## Chessboard & Pattern Detection

```zig
fn findChessboardCorners(image: Mat, patternSize: Size, corners: *Mat, flags: i32) bool;
fn drawChessboardCorners(image: *Mat, patternSize: Size, corners: Mat, patternWasFound: bool) void;
fn findCirclesGrid(image: Mat, patternSize: Size, centers: *Mat, flags: i32) bool;
```

## Pose Estimation

```zig
fn solvePnP(objectPoints: Mat, imagePoints: Mat, cameraMatrix: Mat, distCoeffs: Mat,
    rvec: *Mat, tvec: *Mat, useExtrinsicGuess: bool, flags: i32) bool;
fn solvePnPRansac(objectPoints: Mat, imagePoints: Mat, cameraMatrix: Mat, distCoeffs: Mat,
    rvec: *Mat, tvec: *Mat, useExtrinsicGuess: bool, iterationsCount: i32,
    reprojectionError: f32, confidence: f64, inliers: *Mat, flags: i32) bool;
fn drawFrameAxes(image: *Mat, cameraMatrix: Mat, distCoeffs: Mat, rvec: Mat, tvec: Mat,
    length: f32, thickness: i32) void;
```

## Stereo Vision

```zig
fn findHomography(srcPoints: Mat, dstPoints: Mat, method: i32, ransacReprojThreshold: f64,
    mask: *Mat, maxIters: i32, confidence: f64) !Mat;
fn findFundamentalMat(points1: Mat, points2: Mat, method: i32, ransacReprojThreshold: f64,
    confidence: f64, mask: *Mat) !Mat;
fn findEssentialMat(points1: Mat, points2: Mat, cameraMatrix: Mat, method: i32,
    prob: f64, threshold: f64, mask: *Mat) !Mat;
fn stereoCalibrate(objectPoints: Mats, imagePoints1: Mats, imagePoints2: Mats,
    cameraMatrix1: *Mat, distCoeffs1: *Mat, cameraMatrix2: *Mat, distCoeffs2: *Mat,
    imageSize: Size, R: *Mat, T: *Mat, E: *Mat, F: *Mat, flags: i32) f64;
fn stereoRectify(cameraMatrix1: Mat, distCoeffs1: Mat, cameraMatrix2: Mat, distCoeffs2: Mat,
    imageSize: Size, R: Mat, T: Mat, R1: *Mat, R2: *Mat, P1: *Mat, P2: *Mat, Q: *Mat,
    flags: i32, alpha: f64, newImageSize: Size) void;
```

## Coordinate Transforms

```zig
fn rodrigues(src: Mat, dst: *Mat, jacobian: ?*Mat) void;
fn convertPointsFromHomogeneous(src: Mat, dst: *Mat) void;
fn convertPointsToHomogeneous(src: Mat, dst: *Mat) void;
fn projectPoints(objectPoints: Mat, rvec: Mat, tvec: Mat, cameraMatrix: Mat,
    distCoeffs: Mat, imagePoints: *Mat, jacobian: ?*Mat, aspectRatio: f64) void;
```
