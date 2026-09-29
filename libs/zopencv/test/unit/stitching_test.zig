const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "stitching: Stitcher creation" {
    var stitcher = try cv.stitching.Stitcher.create(cv.stitching.StitcherMode.panorama);
    defer stitcher.deinit();
    // Successfully created
}

test "stitching: Stitcher set parameters" {
    var stitcher = try cv.stitching.Stitcher.create(cv.stitching.StitcherMode.panorama);
    defer stitcher.deinit();

    stitcher.setRegistrationResol(0.6);
    try testing.expect(stitcher.getRegistrationResol() > 0.5);

    stitcher.setSeamEstimationResol(0.1);
    try testing.expect(stitcher.getSeamEstimationResol() > 0.0);

    stitcher.setCompositingResol(-1.0);
    try testing.expect(stitcher.getCompositingResol() < 0.0);

    stitcher.setPanoConfidenceThresh(1.0);
    try testing.expect(stitcher.getPanoConfidenceThresh() == 1.0);

    stitcher.setWaveCorrection(true);
    try testing.expect(stitcher.getWaveCorrection() == true);

    stitcher.setWaveCorrection(false);
    try testing.expect(stitcher.getWaveCorrection() == false);
}

test "stitching: StitcherMode enum" {
    const panorama = cv.stitching.StitcherMode.panorama;
    const scans = cv.stitching.StitcherMode.scans;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(panorama));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(scans));
}

test "stitching: StitcherStatus enum" {
    const ok = cv.stitching.StitcherStatus.ok;
    const need_more = cv.stitching.StitcherStatus.err_need_more_imgs;
    const homography_fail = cv.stitching.StitcherStatus.err_homography_est_fail;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(ok));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(need_more));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(homography_fail));
}

// ============================================================================
// Stitcher.stitch Tests
// ============================================================================

test "stitching: stitch with non-overlapping images returns error status" {
    var stitcher = try cv.stitching.Stitcher.create(cv.stitching.StitcherMode.panorama);
    defer stitcher.deinit();

    // Create two completely different images (no overlap = stitching will fail)
    var img1 = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img1.deinit();
    img1.setTo(cv.Scalar.init(255, 0, 0, 0)); // pure blue

    var img2 = try cv.Mat.initWithSize(100, 100, 16);
    defer img2.deinit();
    img2.setTo(cv.Scalar.init(0, 255, 0, 0)); // pure green

    var pano = try cv.Mat.init();
    defer pano.deinit();

    var images = [_]cv.Mat{ img1, img2 };
    const status = stitcher.stitch(&images, &pano);

    // With non-overlapping synthetic images, stitching should fail
    // (either need_more_imgs or homography_est_fail)
    try testing.expect(status != .ok);
}
