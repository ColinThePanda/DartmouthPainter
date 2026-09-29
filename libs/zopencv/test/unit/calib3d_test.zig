const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_image_chessboard = "testdata/images/chessboard.png";

// ============================================================================
// Basic API Tests (1 test)
// ============================================================================

test "calib3d: API types" {
    // Test that calib3d types compile correctly
    const size = cv.Size.init(640, 480);
    try testing.expect(size.width == 640);
    try testing.expect(size.height == 480);
}

test "calib3d: composeRT" {
    // Create identity rotation (Rodrigues form: zero vector) and translations
    var rvec1 = try cv.Mat.initWithSize(3, 1, 6); // CV_64FC1
    defer rvec1.deinit();
    rvec1.setTo(cv.Scalar.init(0, 0, 0, 0));

    var tvec1 = try cv.Mat.initWithSize(3, 1, 6);
    defer tvec1.deinit();
    tvec1.setTo(cv.Scalar.init(1, 0, 0, 0));

    var rvec2 = try cv.Mat.initWithSize(3, 1, 6);
    defer rvec2.deinit();
    rvec2.setTo(cv.Scalar.init(0, 0, 0, 0));

    var tvec2 = try cv.Mat.initWithSize(3, 1, 6);
    defer tvec2.deinit();
    tvec2.setTo(cv.Scalar.init(2, 0, 0, 0));

    var rvec3 = try cv.Mat.init();
    defer rvec3.deinit();
    var tvec3 = try cv.Mat.init();
    defer tvec3.deinit();

    cv.composeRT(rvec1, tvec1, rvec2, tvec2, &rvec3, &tvec3);
    try testing.expect(!rvec3.empty());
    try testing.expect(!tvec3.empty());
}

test "calib3d: decomposeEssentialMat" {
    // Create a simple essential matrix (identity-like)
    var E = try cv.Mat.eye(3, 3, 6); // CV_64FC1
    defer E.deinit();

    var R1 = try cv.Mat.init();
    defer R1.deinit();
    var R2 = try cv.Mat.init();
    defer R2.deinit();
    var t = try cv.Mat.init();
    defer t.deinit();

    cv.decomposeEssentialMat(E, &R1, &R2, &t);
    try testing.expect(!R1.empty());
    try testing.expect(!R2.empty());
    try testing.expect(!t.empty());
}

test "calib3d: convertPointsToHomogeneous and back" {
    // Create 2D points: N x 1 x 2 or N x 2
    var pts2d = try cv.Mat.initWithSize(4, 1, 13); // CV_32FC2
    defer pts2d.deinit();

    var pts3d = try cv.Mat.init();
    defer pts3d.deinit();

    cv.convertPointsToHomogeneous(pts2d, &pts3d);
    try testing.expect(!pts3d.empty());

    var pts2d_back = try cv.Mat.init();
    defer pts2d_back.deinit();

    cv.convertPointsFromHomogeneous(pts3d, &pts2d_back);
    try testing.expect(!pts2d_back.empty());
}

test "calib3d: rodrigues roundtrip" {
    // Create a rotation vector
    var rvec = try cv.Mat.initWithSize(3, 1, 6); // CV_64FC1
    defer rvec.deinit();
    rvec.setTo(cv.Scalar.init(0.1, 0.2, 0.3, 0));

    var rmat = try cv.Mat.init();
    defer rmat.deinit();

    cv.calib3d.rodrigues(rvec, &rmat, null);
    try testing.expect(!rmat.empty());
    try testing.expectEqual(@as(i32, 3), rmat.rows());
    try testing.expectEqual(@as(i32, 3), rmat.cols());
}

test "calib3d: undistortPoints" {
    // Create 2D points (Nx1 2-channel or 1xN 2-channel)
    var pts = try cv.Mat.initWithSize(4, 1, 13); // CV_32FC2
    defer pts.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Create identity camera matrix
    var cam_mat = try cv.Mat.eye(3, 3, 6); // CV_64FC1
    defer cam_mat.deinit();

    // Zero distortion
    var dist_coeffs = try cv.Mat.zeros(4, 1, 6); // CV_64FC1
    defer dist_coeffs.deinit();

    cv.calib3d.undistortPoints(pts, &dst, cam_mat, dist_coeffs, null, null);
    // With identity cam and zero dist, output should equal input
    try testing.expect(!dst.empty());
}

test "calib3d: correctMatches" {
    // Create a fundamental matrix (3x3)
    var f_mat = try cv.Mat.eye(3, 3, 6); // CV_64FC1
    defer f_mat.deinit();

    // Create 2D point arrays (1xN 2-channel)
    var pts1 = try cv.Mat.initWithSize(1, 5, 14); // CV_64FC2
    defer pts1.deinit();
    var pts2 = try cv.Mat.initWithSize(1, 5, 14); // CV_64FC2
    defer pts2.deinit();

    var new_pts1 = try cv.Mat.init();
    defer new_pts1.deinit();
    var new_pts2 = try cv.Mat.init();
    defer new_pts2.deinit();

    cv.calib3d.correctMatches(f_mat, pts1, pts2, &new_pts1, &new_pts2);
    // Results should not be empty
    try testing.expect(!new_pts1.empty());
    try testing.expect(!new_pts2.empty());
}

// ============================================================================
// Additional Calib3d Function Tests
// ============================================================================

test "calib3d: findHomography" {
    // Source and destination points (4+ point correspondences, Nx1 2-channel)
    var src_pts = try cv.Mat.initWithSize(4, 1, 13); // CV_32FC2
    defer src_pts.deinit();

    var dst_pts = try cv.Mat.initWithSize(4, 1, 13); // CV_32FC2
    defer dst_pts.deinit();

    var mask = try cv.Mat.init();
    defer mask.deinit();

    var H = try cv.calib3d.findHomography(src_pts, dst_pts, 0, 3.0, &mask, 2000, 0.995);
    defer H.deinit();

    // findHomography returns 3x3 (or empty if degenerate)
    // With zero points it may succeed with identity-like result
    try testing.expect(H.rows() == 3 or H.empty());
}

test "calib3d: estimateAffine2D" {
    // Create point correspondences with a known affine transform
    var from_pts = try cv.Mat.initWithSize(3, 1, 13); // CV_32FC2
    defer from_pts.deinit();

    var to_pts = try cv.Mat.initWithSize(3, 1, 13); // CV_32FC2
    defer to_pts.deinit();

    var inliers = try cv.Mat.init();
    defer inliers.deinit();

    var result = try cv.calib3d.estimateAffine2D(from_pts, to_pts, &inliers, 8, 3.0, 2000, 0.99, 10);
    defer result.deinit();

    // estimateAffine2D returns 2x3 or empty
    try testing.expect(result.rows() == 2 or result.empty());
}

test "calib3d: undistort" {
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 128, 128, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Identity camera matrix
    var cam = try cv.Mat.eye(3, 3, 6); // CV_64FC1
    defer cam.deinit();

    // Zero distortion coefficients
    var dist = try cv.Mat.zeros(5, 1, 6);
    defer dist.deinit();

    cv.calib3d.undistort(src, &dst, cam, dist, cam);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 50), dst.rows());
    try testing.expectEqual(@as(i32, 50), dst.cols());
}

test "calib3d: projectPoints" {
    // Create 3D object points (Nx3 or Nx1x3)
    var obj_pts = try cv.Mat.initWithSize(4, 1, 21); // CV_64FC3
    defer obj_pts.deinit();

    // Rotation and translation vectors
    var rvec = try cv.Mat.zeros(3, 1, 6);
    defer rvec.deinit();
    var tvec = try cv.Mat.zeros(3, 1, 6);
    defer tvec.deinit();

    // Camera intrinsic matrix
    var cam = try cv.Mat.eye(3, 3, 6);
    defer cam.deinit();

    var dist = try cv.Mat.zeros(5, 1, 6);
    defer dist.deinit();

    var img_pts = try cv.Mat.init();
    defer img_pts.deinit();
    var jacobian = try cv.Mat.init();
    defer jacobian.deinit();

    cv.calib3d.projectPoints(obj_pts, rvec, tvec, cam, dist, &img_pts, &jacobian);
    try testing.expect(!img_pts.empty());
}

test "calib3d: findChessboardCorners on blank image" {
    var img = try cv.Mat.initWithSize(200, 200, 0); // CV_8UC1 grayscale
    defer img.deinit();
    img.setTo(cv.Scalar.init(200, 0, 0, 0)); // blank white-ish

    var corners = try cv.Mat.init();
    defer corners.deinit();

    const found = cv.calib3d.findChessboardCorners(img, cv.Size.init(7, 7), &corners, 0);
    try testing.expect(!found);
}

test "calib3d: findChessboardCornersSB on blank image" {
    var img = try cv.Mat.initWithSize(200, 200, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(200, 0, 0, 0));

    var corners = try cv.Mat.init();
    defer corners.deinit();

    const found = cv.calib3d.findChessboardCornersSB(img, cv.Size.init(7, 7), &corners, 0);
    try testing.expect(!found);
}

test "calib3d: drawChessboardCorners" {
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(200, 200, 200, 0));

    // Empty corners Mat (no corners found)
    var corners = try cv.Mat.init();
    defer corners.deinit();

    // Should not crash even with empty corners
    cv.calib3d.drawChessboardCorners(&img, cv.Size.init(7, 7), corners, false);
    try testing.expect(!img.empty());
}

test "calib3d: computeCorrespondEpilines" {
    // 2D points (Nx1 2-channel or Nx2)
    var pts = try cv.Mat.initWithSize(5, 1, 13); // CV_32FC2
    defer pts.deinit();

    // Fundamental matrix
    var F = try cv.Mat.eye(3, 3, 6); // CV_64FC1
    defer F.deinit();

    var lines = try cv.Mat.init();
    defer lines.deinit();

    cv.calib3d.computeCorrespondEpilines(pts, 1, F, &lines);
    try testing.expect(!lines.empty());
}

test "calib3d: decomposeProjectionMatrix" {
    // 3x4 projection matrix
    var proj = try cv.Mat.initWithSize(3, 4, 6); // CV_64FC1
    defer proj.deinit();
    proj.setTo(cv.Scalar.init(0, 0, 0, 0));

    var cam = try cv.Mat.init();
    defer cam.deinit();
    var rot = try cv.Mat.init();
    defer rot.deinit();
    var trans = try cv.Mat.init();
    defer trans.deinit();

    cv.calib3d.decomposeProjectionMatrix(proj, &cam, &rot, &trans);
    try testing.expect(!cam.empty());
    try testing.expect(!rot.empty());
}

test "calib3d: filterSpeckles" {
    // filterSpeckles requires CV_8UC1 or CV_16SC1
    var disp = try cv.Mat.initWithSize(50, 50, 3); // CV_16SC1
    defer disp.deinit();
    disp.setTo(cv.Scalar.init(10, 0, 0, 0));

    var buf = try cv.Mat.init();
    defer buf.deinit();

    cv.calib3d.filterSpeckles(&disp, 0, 100, 2.0, &buf);
    try testing.expect(!disp.empty());
}

test "calib3d: reprojectImageTo3D" {
    // Disparity map (single channel float)
    var disp = try cv.Mat.initWithSize(50, 50, 5); // CV_32FC1
    defer disp.deinit();
    disp.setTo(cv.Scalar.init(5, 0, 0, 0));

    // 4x4 perspective transformation matrix Q
    var Q = try cv.Mat.eye(4, 4, 6); // CV_64FC1
    defer Q.deinit();

    var img3d = try cv.Mat.init();
    defer img3d.deinit();

    cv.calib3d.reprojectImageTo3D(disp, &img3d, Q, false, -1);
    try testing.expect(!img3d.empty());
    try testing.expectEqual(@as(i32, 50), img3d.rows());
}

test "calib3d: sampsonDistance" {
    // Two 2D points (1x2 or 2x1) as CV_64FC2
    var pt1 = try cv.Mat.initWithSize(1, 1, 14); // CV_64FC2
    defer pt1.deinit();
    var pt2 = try cv.Mat.initWithSize(1, 1, 14);
    defer pt2.deinit();

    var F = try cv.Mat.eye(3, 3, 6);
    defer F.deinit();

    const dist = cv.calib3d.sampsonDistance(pt1, pt2, F);
    // With zero points, result may be NaN — just verify API doesn't crash
    _ = dist;
}

test "calib3d: triangulatePoints" {
    // 3x4 projection matrices
    var proj1 = try cv.Mat.eye(3, 4, 6); // CV_64FC1
    defer proj1.deinit();
    var proj2 = try cv.Mat.eye(3, 4, 6);
    defer proj2.deinit();

    // 2xN point correspondences
    var pts1 = try cv.Mat.initWithSize(2, 5, 6); // CV_64FC1
    defer pts1.deinit();
    pts1.setTo(cv.Scalar.init(1, 0, 0, 0));
    var pts2 = try cv.Mat.initWithSize(2, 5, 6);
    defer pts2.deinit();
    pts2.setTo(cv.Scalar.init(1, 0, 0, 0));

    var points4d = try cv.Mat.init();
    defer points4d.deinit();

    cv.calib3d.triangulatePoints(proj1, proj2, pts1, pts2, &points4d);
    try testing.expect(!points4d.empty());
}

test "calib3d: findFundamentalMat" {
    // Point correspondences (Nx2 or Nx1x2)
    var pts1 = try cv.Mat.initWithSize(8, 1, 14); // CV_64FC2
    defer pts1.deinit();
    var pts2 = try cv.Mat.initWithSize(8, 1, 14);
    defer pts2.deinit();

    var mask = try cv.Mat.init();
    defer mask.deinit();

    var F = try cv.calib3d.findFundamentalMat(pts1, pts2, 8, 3.0, 0.99, &mask);
    defer F.deinit();

    // May return empty if points are degenerate (all zeros)
    try testing.expect(F.empty() or F.rows() == 3);
}

test "calib3d: findEssentialMat" {
    var pts1 = try cv.Mat.initWithSize(8, 1, 14); // CV_64FC2
    defer pts1.deinit();
    var pts2 = try cv.Mat.initWithSize(8, 1, 14);
    defer pts2.deinit();

    var cam = try cv.Mat.eye(3, 3, 6);
    defer cam.deinit();

    var mask = try cv.Mat.init();
    defer mask.deinit();

    var E = try cv.calib3d.findEssentialMat(pts1, pts2, cam, 8, 0.999, 1.0, &mask);
    defer E.deinit();

    try testing.expect(E.empty() or E.rows() == 3);
}

test "calib3d: estimateAffinePartial2D" {
    var from_pts = try cv.Mat.initWithSize(4, 1, 13); // CV_32FC2
    defer from_pts.deinit();
    var to_pts = try cv.Mat.initWithSize(4, 1, 13);
    defer to_pts.deinit();

    var inliers = try cv.Mat.init();
    defer inliers.deinit();

    var result = try cv.calib3d.estimateAffinePartial2D(from_pts, to_pts, &inliers, 8, 3.0, 2000, 0.99, 10);
    defer result.deinit();

    try testing.expect(result.rows() == 2 or result.empty());
}

test "calib3d: estimateAffine3D" {
    var src = try cv.Mat.initWithSize(4, 1, 21); // CV_64FC3
    defer src.deinit();
    var dst = try cv.Mat.initWithSize(4, 1, 21);
    defer dst.deinit();

    var out = try cv.Mat.init();
    defer out.deinit();
    var inliers = try cv.Mat.init();
    defer inliers.deinit();

    const ret = cv.calib3d.estimateAffine3D(src, dst, &out, &inliers, 3.0, 0.99);
    // Return value is the number of RANSAC iterations or error code
    _ = ret;
    // out should be 3x4 affine transform or empty
    try testing.expect(out.empty() or out.rows() == 3);
}

test "calib3d: initUndistortRectifyMap" {
    var cam = try cv.Mat.eye(3, 3, 6);
    defer cam.deinit();
    var dist = try cv.Mat.zeros(5, 1, 6);
    defer dist.deinit();
    var R = try cv.Mat.eye(3, 3, 6);
    defer R.deinit();
    var new_cam = try cv.Mat.eye(3, 3, 6);
    defer new_cam.deinit();

    var map1 = try cv.Mat.init();
    defer map1.deinit();
    var map2 = try cv.Mat.init();
    defer map2.deinit();

    cv.calib3d.initUndistortRectifyMap(cam, dist, R, new_cam, cv.Size.init(100, 100), 5, &map1, &map2);
    try testing.expect(!map1.empty());
    try testing.expect(!map2.empty());
}

test "calib3d: drawFrameAxes" {
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));

    var cam = try cv.Mat.eye(3, 3, 6);
    defer cam.deinit();
    var dist = try cv.Mat.zeros(5, 1, 6);
    defer dist.deinit();
    var rvec = try cv.Mat.zeros(3, 1, 6);
    defer rvec.deinit();
    var tvec = try cv.Mat.zeros(3, 1, 6);
    defer tvec.deinit();

    cv.calib3d.drawFrameAxes(&img, cam, dist, rvec, tvec, 0.1, 1);
    try testing.expect(!img.empty());
}

test "calib3d: validateDisparity" {
    // validateDisparity requires CV_16S disp and CV_16S or CV_32S cost
    var disp = try cv.Mat.initWithSize(50, 50, 3); // CV_16SC1
    defer disp.deinit();
    disp.setTo(cv.Scalar.init(5, 0, 0, 0));

    var cost = try cv.Mat.initWithSize(50, 50, 3); // CV_16SC1
    defer cost.deinit();
    cost.setTo(cv.Scalar.init(0, 0, 0, 0));

    cv.calib3d.validateDisparity(&disp, cost, 0, 16, 1);
    try testing.expect(!disp.empty());
}

test "calib3d: stereoRectifyUncalibrated" {
    var pts1 = try cv.Mat.initWithSize(8, 1, 14); // CV_64FC2
    defer pts1.deinit();
    var pts2 = try cv.Mat.initWithSize(8, 1, 14);
    defer pts2.deinit();

    var F = try cv.Mat.eye(3, 3, 6);
    defer F.deinit();

    var H1 = try cv.Mat.init();
    defer H1.deinit();
    var H2 = try cv.Mat.init();
    defer H2.deinit();

    const success = cv.calib3d.stereoRectifyUncalibrated(pts1, pts2, F, cv.Size.init(640, 480), &H1, &H2, 5.0);
    _ = success; // May false with zero points
    // H1 and H2 should be populated or empty
    try testing.expect(H1.empty() or H1.rows() == 3);
}

test "calib3d: findCirclesGrid on blank image" {
    var img = try cv.Mat.initWithSize(200, 200, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(200, 0, 0, 0));

    var centers = try cv.Mat.init();
    defer centers.deinit();

    // Flag 1 = CALIB_CB_SYMMETRIC_GRID (flags must specify grid type)
    const found = cv.calib3d.findCirclesGrid(img, cv.Size.init(4, 4), &centers, 1);
    try testing.expect(!found);
}

test "calib3d: recoverPose" {
    var E = try cv.Mat.eye(3, 3, 6);
    defer E.deinit();

    var pts1 = try cv.Mat.initWithSize(8, 1, 14); // CV_64FC2
    defer pts1.deinit();
    var pts2 = try cv.Mat.initWithSize(8, 1, 14);
    defer pts2.deinit();

    var cam = try cv.Mat.eye(3, 3, 6);
    defer cam.deinit();

    var R = try cv.Mat.init();
    defer R.deinit();
    var t = try cv.Mat.init();
    defer t.deinit();
    var mask = try cv.Mat.init();
    defer mask.deinit();

    const inlier_count = cv.calib3d.recoverPose(E, pts1, pts2, cam, &R, &t, &mask);
    _ = inlier_count;
    // R should be 3x3 rotation, t should be 3x1 translation
    try testing.expect(R.empty() or R.rows() == 3);
}

test "calib3d: getOptimalNewCameraMatrix" {
    var cam = try cv.Mat.eye(3, 3, 6);
    defer cam.deinit();
    var dist = try cv.Mat.zeros(5, 1, 6);
    defer dist.deinit();

    var new_cam = try cv.calib3d.getOptimalNewCameraMatrix(cam, dist, cv.Size.init(640, 480), 1.0, cv.Size.init(640, 480), cv.Rect.init(0, 0, 640, 480), false);
    defer new_cam.deinit();

    try testing.expect(!new_cam.empty());
    try testing.expectEqual(@as(i32, 3), new_cam.rows());
    try testing.expectEqual(@as(i32, 3), new_cam.cols());
}
