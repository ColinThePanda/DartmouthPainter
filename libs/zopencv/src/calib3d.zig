const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Size = core.Size;
pub const Rect = core.Rect;
pub const Error = core.Error;

// ============================================================================
// Camera Calibration
// ============================================================================

/// Finds the camera intrinsic and extrinsic parameters from several views
pub fn calibrateCamera(
    objectPoints: Mat,
    imagePoints: Mat,
    imageSize: Size,
    cameraMatrix: *Mat,
    distCoeffs: *Mat,
    rvecs: *Mat,
    tvecs: *Mat,
    flags: i32,
    termcrit_type: i32,
    termcrit_maxCount: i32,
    termcrit_epsilon: f64,
) i32 {
    return c.CalibrateCamera(
        objectPoints.ptr,
        imagePoints.ptr,
        imageSize,
        cameraMatrix.ptr,
        distCoeffs.ptr,
        rvecs.ptr,
        tvecs.ptr,
        flags,
        termcrit_type,
        termcrit_maxCount,
        termcrit_epsilon,
    );
}

/// Initialize camera matrix from 2D points
pub fn initCameraMatrix2D(
    objectPoints: Mat,
    imagePoints: Mat,
    imageSize: Size,
    aspectRatio: f64,
) !Mat {
    const cameraMatrix = try Mat.init();
    const c_size = c.Size{ .width = imageSize.width, .height = imageSize.height };
    c.InitCameraMatrix2D(
        objectPoints.ptr,
        imagePoints.ptr,
        c_size,
        aspectRatio,
        cameraMatrix.ptr,
    );
    return cameraMatrix;
}

// ============================================================================
// Pose Estimation
// ============================================================================

/// Finds an object pose from 3D-2D point correspondences
pub fn solvePnP(
    objectPoints: Mat,
    imagePoints: Mat,
    cameraMatrix: Mat,
    distCoeffs: Mat,
    rvec: *Mat,
    tvec: *Mat,
    useExtrinsicGuess: bool,
    flags: i32,
) i32 {
    return c.SolvePnP(
        objectPoints.ptr,
        imagePoints.ptr,
        cameraMatrix.ptr,
        distCoeffs.ptr,
        rvec.ptr,
        tvec.ptr,
        if (useExtrinsicGuess) 1 else 0,
        flags,
    );
}

/// Finds an object pose from 3D-2D point correspondences using RANSAC
pub fn solvePnPRansac(
    objectPoints: Mat,
    imagePoints: Mat,
    cameraMatrix: Mat,
    distCoeffs: Mat,
    rvec: *Mat,
    tvec: *Mat,
    useExtrinsicGuess: bool,
    iterationsCount: i32,
    reprojectionError: f32,
    confidence: f64,
    inliers: *Mat,
    flags: i32,
) i32 {
    return c.SolvePnPRansac(
        objectPoints.ptr,
        imagePoints.ptr,
        cameraMatrix.ptr,
        distCoeffs.ptr,
        rvec.ptr,
        tvec.ptr,
        if (useExtrinsicGuess) 1 else 0,
        iterationsCount,
        reprojectionError,
        confidence,
        inliers.ptr,
        flags,
    );
}

// ============================================================================
// Stereo Vision
// ============================================================================

/// Computes rectification transforms for each head of a calibrated stereo camera
pub fn stereoRectify(
    cameraMatrix1: Mat,
    distCoeffs1: Mat,
    cameraMatrix2: Mat,
    distCoeffs2: Mat,
    imageSize: Size,
    R: Mat,
    T: Mat,
    R1: *Mat,
    R2: *Mat,
    P1: *Mat,
    P2: *Mat,
    Q: *Mat,
    flags: i32,
    alpha: f64,
    newImageSize: Size,
    validPixROI1: ?*Rect,
    validPixROI2: ?*Rect,
) void {
    c.StereoRectify(
        cameraMatrix1.ptr,
        distCoeffs1.ptr,
        cameraMatrix2.ptr,
        distCoeffs2.ptr,
        imageSize.toC(),
        R.ptr,
        T.ptr,
        R1.ptr,
        R2.ptr,
        P1.ptr,
        P2.ptr,
        Q.ptr,
        flags,
        alpha,
        newImageSize.toC(),
        if (validPixROI1) |ptr| ptr else null,
        if (validPixROI2) |ptr| ptr else null,
    );
}

/// Calibrates the stereo camera
pub fn stereoCalibrate(
    objectPoints: Mat,
    imagePoints1: Mat,
    imagePoints2: Mat,
    cameraMatrix1: *Mat,
    distCoeffs1: *Mat,
    cameraMatrix2: *Mat,
    distCoeffs2: *Mat,
    imageSize: Size,
    R: *Mat,
    T: *Mat,
    E: *Mat,
    F: *Mat,
    flags: i32,
    termcrit_type: i32,
    termcrit_maxCount: i32,
    termcrit_epsilon: f64,
) f64 {
    return c.StereoCalibrate(
        objectPoints.ptr,
        imagePoints1.ptr,
        imagePoints2.ptr,
        cameraMatrix1.ptr,
        distCoeffs1.ptr,
        cameraMatrix2.ptr,
        distCoeffs2.ptr,
        imageSize.toC(),
        R.ptr,
        T.ptr,
        E.ptr,
        F.ptr,
        flags,
        termcrit_type,
        termcrit_maxCount,
        termcrit_epsilon,
    );
}

// ============================================================================
// Geometric Transformations
// ============================================================================

/// Converts a rotation matrix to a rotation vector or vice versa
pub fn rodrigues(src: Mat, dst: *Mat, jacobian: ?*Mat) void {
    c.Rodrigues(
        src.ptr,
        dst.ptr,
        if (jacobian) |j| j.ptr else null,
    );
}

/// Computes an optimal affine transformation between two 2D point sets
pub fn estimateAffine2D(
    from: Mat,
    to: Mat,
    inliers: *Mat,
    method: i32,
    ransacReprojThreshold: f64,
    maxIters: i32,
    confidence: f64,
    refineIters: i32,
) !Mat {
    const ptr = c.EstimateAffine2D(
        from.ptr,
        to.ptr,
        inliers.ptr,
        method,
        ransacReprojThreshold,
        maxIters,
        confidence,
        refineIters,
    );
    if (ptr == null) return Error.NullPointer;
    return Mat{ .ptr = ptr.? };
}

/// Calculates a fundamental matrix from the corresponding points in two images
pub fn findFundamentalMat(
    points1: Mat,
    points2: Mat,
    method: i32,
    ransacReprojThreshold: f64,
    confidence: f64,
    mask: *Mat,
) !Mat {
    const ptr = c.FindFundamentalMat(
        points1.ptr,
        points2.ptr,
        method,
        ransacReprojThreshold,
        confidence,
        mask.ptr,
    );
    if (ptr == null) return Error.NullPointer;
    return Mat{ .ptr = ptr.? };
}

/// Calculates an essential matrix from the corresponding points in two images
pub fn findEssentialMat(
    points1: Mat,
    points2: Mat,
    cameraMatrix: Mat,
    method: i32,
    prob: f64,
    threshold: f64,
    mask: *Mat,
) !Mat {
    const ptr = c.FindEssentialMat(
        points1.ptr,
        points2.ptr,
        cameraMatrix.ptr,
        method,
        prob,
        threshold,
        mask.ptr,
    );
    if (ptr == null) return Error.NullPointer;
    return Mat{ .ptr = ptr.? };
}

// ============================================================================
// Triangulation
// ============================================================================

/// Reconstructs points by triangulation
pub fn triangulatePoints(
    projMatr1: Mat,
    projMatr2: Mat,
    projPoints1: Mat,
    projPoints2: Mat,
    points4D: *Mat,
) void {
    c.TriangulatePoints(
        projMatr1.ptr,
        projMatr2.ptr,
        projPoints1.ptr,
        projPoints2.ptr,
        points4D.ptr,
    );
}

// ============================================================================
// Undistortion
// ============================================================================

/// Computes the undistortion and rectification transformation map
pub fn initUndistortRectifyMap(
    cameraMatrix: Mat,
    distCoeffs: Mat,
    R: Mat,
    newCameraMatrix: Mat,
    size: Size,
    m1type: i32,
    map1: *Mat,
    map2: *Mat,
) void {
    c.InitUndistortRectifyMap(
        cameraMatrix.ptr,
        distCoeffs.ptr,
        R.ptr,
        newCameraMatrix.ptr,
        size.toC(),
        m1type,
        map1.ptr,
        map2.ptr,
    );
}

/// Transforms an image to compensate for lens distortion
pub fn undistort(
    src: Mat,
    dst: *Mat,
    cameraMatrix: Mat,
    distCoeffs: Mat,
    newCameraMatrix: ?Mat,
) void {
    c.Undistort(
        src.ptr,
        dst.ptr,
        cameraMatrix.ptr,
        distCoeffs.ptr,
        if (newCameraMatrix) |m| m.ptr else null,
    );
}

// ============================================================================
// Chessboard Detection
// ============================================================================

/// Finds the positions of internal corners of the chessboard
pub fn findChessboardCorners(image: Mat, patternSize: Size, corners: *Mat, flags: i32) bool {
    return c.FindChessboardCorners(image.ptr, patternSize.toC(), corners.ptr, flags) != 0;
}

/// Finds the positions of internal corners of the chessboard using a sector based approach
pub fn findChessboardCornersSB(image: Mat, patternSize: Size, corners: *Mat, flags: i32) bool {
    return c.FindChessboardCornersSB(image.ptr, patternSize.toC(), corners.ptr, flags) != 0;
}

/// Renders the detected chessboard corners
pub fn drawChessboardCorners(image: *Mat, patternSize: Size, corners: Mat, patternWasFound: bool) void {
    c.DrawChessboardCorners(image.ptr, patternSize.toC(), corners.ptr, if (patternWasFound) 1 else 0);
}

/// Returns the new camera intrinsic matrix based on the free scaling parameter
pub fn getOptimalNewCameraMatrix(cameraMatrix: Mat, distCoeffs: Mat, imageSize: Size, alpha: f64, newImgSize: Size, validPixROI: Rect, centerPrincipalPoint: bool) !Mat {
    const ptr = c.GetOptimalNewCameraMatrix(cameraMatrix.ptr, distCoeffs.ptr, imageSize.toC(), alpha, newImgSize.toC(), validPixROI.toC(), if (centerPrincipalPoint) 1 else 0) orelse return Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

// ============================================================================
// Homography and Affine Estimation
// ============================================================================

/// Finds a perspective transformation between two planes
pub fn findHomography(srcPoints: Mat, dstPoints: Mat, method: i32, ransacReprojThreshold: f64, mask: *Mat, maxIters: i32, confidence: f64) !Mat {
    const ptr = c.FindHomography(srcPoints.ptr, dstPoints.ptr, method, ransacReprojThreshold, mask.ptr, maxIters, confidence) orelse return Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

/// Computes an optimal limited affine transformation with 4 degrees of freedom
pub fn estimateAffinePartial2D(from: Mat, to: Mat, inliers: *Mat, method: i32, ransacReprojThreshold: f64, maxIters: i32, confidence: f64, refineIters: i32) !Mat {
    const ptr = c.EstimateAffinePartial2D(from.ptr, to.ptr, inliers.ptr, method, ransacReprojThreshold, maxIters, confidence, refineIters) orelse return Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

/// Computes an optimal affine transformation between two 3D point sets
pub fn estimateAffine3D(src: Mat, dst: Mat, out: *Mat, inliers: *Mat, ransacThreshold: f64, confidence: f64) i32 {
    return c.EstimateAffine3D(src.ptr, dst.ptr, out.ptr, inliers.ptr, ransacThreshold, confidence);
}

// ============================================================================
// Projection and Pose
// ============================================================================

/// Projects 3D points to an image plane
pub fn projectPoints(objectPoints: Mat, rvec: Mat, tvec: Mat, cameraMatrix: Mat, distCoeffs: Mat, imagePoints: *Mat, jacobian: *Mat) void {
    c.ProjectPoints(objectPoints.ptr, rvec.ptr, tvec.ptr, cameraMatrix.ptr, distCoeffs.ptr, imagePoints.ptr, jacobian.ptr);
}

/// Reprojects a disparity image to 3D space
pub fn reprojectImageTo3D(disparity: Mat, _3dImage: *Mat, Q: Mat, handleMissingValues: bool, ddepth: i32) void {
    c.ReprojectImageTo3D(disparity.ptr, _3dImage.ptr, Q.ptr, if (handleMissingValues) 1 else 0, ddepth);
}

/// Recovers the relative camera rotation and translation from an essential matrix
pub fn recoverPose(E: Mat, points1: Mat, points2: Mat, cameraMatrix: Mat, R: *Mat, t: *Mat, mask: *Mat) i32 {
    return c.RecoverPose(E.ptr, points1.ptr, points2.ptr, cameraMatrix.ptr, R.ptr, t.ptr, mask.ptr);
}

// ============================================================================
// Matrix Decomposition
// ============================================================================

/// Combines two rotation-and-shift transformations
pub fn composeRT(rvec1: Mat, tvec1: Mat, rvec2: Mat, tvec2: Mat, rvec3: *Mat, tvec3: *Mat) void {
    c.ComposeRT(rvec1.ptr, tvec1.ptr, rvec2.ptr, tvec2.ptr, rvec3.ptr, tvec3.ptr);
}

/// Decomposes a projection matrix into a rotation matrix and a camera intrinsic matrix
pub fn decomposeProjectionMatrix(projMatrix: Mat, cameraMatrix: *Mat, rotMatrix: *Mat, transVect: *Mat) void {
    c.DecomposeProjectionMatrix(projMatrix.ptr, cameraMatrix.ptr, rotMatrix.ptr, transVect.ptr);
}

/// Decomposes an essential matrix into two rotation matrices and translation vector
pub fn decomposeEssentialMat(E: Mat, R1: *Mat, R2: *Mat, t: *Mat) void {
    c.DecomposeEssentialMat(E.ptr, R1.ptr, R2.ptr, t.ptr);
}

// ============================================================================
// Epipolar Geometry
// ============================================================================

/// For points in an image of a stereo pair, computes the corresponding epilines
pub fn computeCorrespondEpilines(points: Mat, whichImage: i32, F: Mat, lines: *Mat) void {
    c.ComputeCorrespondEpilines(points.ptr, whichImage, F.ptr, lines.ptr);
}

/// Computes the Sampson Distance between two points and a fundamental matrix
pub fn sampsonDistance(pt1: Mat, pt2: Mat, F: Mat) f64 {
    return c.SampsonDistance(pt1.ptr, pt2.ptr, F.ptr);
}

// ============================================================================
// Point Conversion
// ============================================================================

/// Converts points from homogeneous to Euclidean space
pub fn convertPointsFromHomogeneous(src: Mat, dst: *Mat) void {
    c.ConvertPointsFromHomogeneous(src.ptr, dst.ptr);
}

/// Converts points from Euclidean to homogeneous space
pub fn convertPointsToHomogeneous(src: Mat, dst: *Mat) void {
    c.ConvertPointsToHomogeneous(src.ptr, dst.ptr);
}

// ============================================================================
// Stereo
// ============================================================================

/// Filters off small noise blobs in the disparity map
pub fn filterSpeckles(img: *Mat, newVal: f64, maxSpeckleSize: i32, maxDiff: f64, buf: *Mat) void {
    c.FilterSpeckles(img.ptr, newVal, maxSpeckleSize, maxDiff, buf.ptr);
}

/// Validates disparity using left-right cross-check
pub fn validateDisparity(disparity: *Mat, cost: Mat, minDisparity: i32, numberOfDisparities: i32, disp12MaxDiff: i32) void {
    c.ValidateDisparity(disparity.ptr, cost.ptr, minDisparity, numberOfDisparities, disp12MaxDiff);
}

// ============================================================================
// Drawing
// ============================================================================

/// Draw frame axes on an image
pub fn drawFrameAxes(image: *Mat, cameraMatrix: Mat, distCoeffs: Mat, rvec: Mat, tvec: Mat, length: f32, thickness: i32) void {
    c.DrawFrameAxes(image.ptr, cameraMatrix.ptr, distCoeffs.ptr, rvec.ptr, tvec.ptr, length, thickness);
}

// ============================================================================
// Additional Calibration Functions
// ============================================================================

/// Find circles grid pattern in an image
pub fn findCirclesGrid(image: Mat, pattern_size: Size, centers: *Mat, flags: i32) bool {
    return c.FindCirclesGrid(image.ptr, pattern_size.toC(), centers.ptr, flags) != 0;
}

/// Compute rectification transformations for uncalibrated stereo pair
pub fn stereoRectifyUncalibrated(points1: Mat, points2: Mat, F: Mat, img_size: Size, H1: *Mat, H2: *Mat, threshold: f64) bool {
    return c.StereoRectifyUncalibrated(points1.ptr, points2.ptr, F.ptr, img_size.toC(), H1.ptr, H2.ptr, threshold) != 0;
}

/// Refine two matching point sets to satisfy the epipolar constraint
pub fn correctMatches(F: Mat, points1: Mat, points2: Mat, new_points1: *Mat, new_points2: *Mat) void {
    c.CorrectMatches(F.ptr, points1.ptr, points2.ptr, new_points1.ptr, new_points2.ptr);
}

/// Undistort 2D points using camera intrinsics and distortion coefficients
pub fn undistortPoints(src: Mat, dst: *Mat, camera_matrix: Mat, dist_coeffs: Mat, R: ?Mat, P: ?Mat) void {
    c.UndistortPoints(src.ptr, dst.ptr, camera_matrix.ptr, dist_coeffs.ptr, if (R) |r| r.ptr else null, if (P) |p| p.ptr else null);
}
