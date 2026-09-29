const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_image_box = "testdata/images/box.png";
const test_image_lena = "testdata/images/lena.jpg";
const test_image_fruits = "testdata/images/fruits.jpg";

// ============================================================================
// Detector Creation Tests (5 tests)
// ============================================================================

test "features2d: ORB creation" {
    var orb = try cv.features2d.ORB.init();
    defer orb.deinit();
}

test "features2d: ORB with custom parameters" {
    var orb = try cv.features2d.ORB.initWithParams(1000, 1.2, 8, 31, 0, 2, 0, 31, 20);
    defer orb.deinit();
}

test "features2d: SIFT creation" {
    var sift = try cv.features2d.SIFT.init();
    defer sift.deinit();
}

test "features2d: SIFT with custom parameters" {
    var sift = try cv.features2d.SIFT.initWithParams(0, 3, 0.04, 10.0, 1.6);
    defer sift.deinit();
}

test "features2d: AKAZE creation" {
    var akaze = try cv.features2d.AKAZE.init();
    defer akaze.deinit();
}

test "features2d: KeyPointVector creation" {
    var kpv = try cv.features2d.KeyPointVector.init();
    defer kpv.deinit();
    try testing.expectEqual(@as(usize, 0), kpv.size());
}

test "features2d: KeyPointVector size" {
    var kpv = try cv.features2d.KeyPointVector.init();
    defer kpv.deinit();
    try testing.expect(kpv.size() == 0);
}

test "features2d: DMatchVector create and delete" {
    var matches = try cv.DMatchVector.init();
    defer matches.deinit();

    try testing.expectEqual(@as(usize, 0), matches.size());
}

test "features2d: BFMatcher create and delete" {
    // NORM_L2 = 4
    var bf = try cv.BFMatcher.init(cv.NormTypes.norm_l2, false);
    defer bf.deinit();
}

test "features2d: BFMatcher match with ORB" {
    var img1 = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img1.deinit();
    img1.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Put some pattern in img1
    var i: usize = 20;
    while (i < 80) : (i += 1) {
        img1.setUChar(@intCast(i), @intCast(i), 255);
    }

    var img2 = try cv.Mat.initWithSize(100, 100, 0);
    defer img2.deinit();
    img2.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Similar pattern in img2
    i = 25;
    while (i < 85) : (i += 1) {
        img2.setUChar(@intCast(i), @intCast(i), 255);
    }

    // Detect features with ORB
    var orb = try cv.ORB.init();
    defer orb.deinit();

    var kp1 = try cv.KeyPointVector.init();
    defer kp1.deinit();
    var desc1 = try cv.Mat.init();
    defer desc1.deinit();
    orb.detectAndCompute(img1, null, &kp1, &desc1);

    var kp2 = try cv.KeyPointVector.init();
    defer kp2.deinit();
    var desc2 = try cv.Mat.init();
    defer desc2.deinit();
    orb.detectAndCompute(img2, null, &kp2, &desc2);

    // Match if we got descriptors
    if (!desc1.empty() and !desc2.empty()) {
        // ORB uses NORM_HAMMING
        var bf = try cv.BFMatcher.init(cv.NormTypes.norm_hamming, false);
        defer bf.deinit();

        var matches = try cv.DMatchVector.init();
        defer matches.deinit();

        bf.match(desc1, desc2, &matches);

        // Should have matches
        try testing.expect(matches.size() > 0);

        // Check first match structure
        const m = matches.at(0);
        try testing.expect(m.query_idx >= 0);
        try testing.expect(m.train_idx >= 0);
        try testing.expect(m.distance >= 0);
    }
}

test "features2d: drawMatches" {
    var img1 = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img1.deinit();
    img1.setTo(cv.Scalar.init(128, 128, 128, 0));

    var img2 = try cv.Mat.initWithSize(100, 100, 16);
    defer img2.deinit();
    img2.setTo(cv.Scalar.init(128, 128, 128, 0));

    var kp1 = try cv.KeyPointVector.init();
    defer kp1.deinit();
    var kp2 = try cv.KeyPointVector.init();
    defer kp2.deinit();

    var matches = try cv.DMatchVector.init();
    defer matches.deinit();

    var out = try cv.Mat.init();
    defer out.deinit();

    // Empty matches is fine - just produces combined image
    cv.drawMatches(img1, kp1, img2, kp2, matches, &out, cv.Scalar.init(-1, -1, -1, -1), cv.Scalar.init(-1, -1, -1, -1), 0);

    try testing.expect(!out.empty());
}

// ============================================================================
// KeyPoint Individual Tests - Verify complete Zig→C→OpenCV→C→Zig roundtrip
// ============================================================================

test "features2d: KeyPoint creation with getData verification" {
    var kp = try cv.KeyPoint.init(100.0, 200.0, 10.0, 45.0, 0.5, 1, -1);
    defer kp.deinit();

    // Verify all fields via getData roundtrip
    const data = kp.getData();
    try testing.expectApproxEqAbs(@as(f32, 100.0), data.pt.x, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 200.0), data.pt.y, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 10.0), data.size, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 45.0), data.angle, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 0.5), data.response, 0.001);
    try testing.expectEqual(@as(i32, 1), data.octave);
    try testing.expectEqual(@as(i32, -1), data.class_id);
}

test "features2d: KeyPoint zero values" {
    var kp = try cv.KeyPoint.init(0.0, 0.0, 1.0, 0.0, 0.0, 0, 0);
    defer kp.deinit();

    const data = kp.getData();
    try testing.expectApproxEqAbs(@as(f32, 0.0), data.pt.x, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 0.0), data.pt.y, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 1.0), data.size, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 0.0), data.angle, 0.001);
    try testing.expectEqual(@as(i32, 0), data.octave);
    try testing.expectEqual(@as(i32, 0), data.class_id);
}

test "features2d: KeyPoint negative coords and large values" {
    var kp = try cv.KeyPoint.init(-50.5, -30.2, 25.0, 270.0, 0.95, 3, 42);
    defer kp.deinit();

    const data = kp.getData();
    try testing.expectApproxEqAbs(@as(f32, -50.5), data.pt.x, 0.01);
    try testing.expectApproxEqAbs(@as(f32, -30.2), data.pt.y, 0.01);
    try testing.expectApproxEqAbs(@as(f32, 25.0), data.size, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 270.0), data.angle, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 0.95), data.response, 0.001);
    try testing.expectEqual(@as(i32, 3), data.octave);
    try testing.expectEqual(@as(i32, 42), data.class_id);
}

test "features2d: KeyPoint multiple independent instances" {
    var kp1 = try cv.KeyPoint.init(10.0, 20.0, 5.0, 0.0, 1.0, 0, 0);
    defer kp1.deinit();

    var kp2 = try cv.KeyPoint.init(50.0, 60.0, 15.0, 90.0, 0.5, 2, 1);
    defer kp2.deinit();

    // Verify they are independent: kp2 does not affect kp1
    const d1 = kp1.getData();
    const d2 = kp2.getData();
    try testing.expectApproxEqAbs(@as(f32, 10.0), d1.pt.x, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 50.0), d2.pt.x, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 5.0), d1.size, 0.001);
    try testing.expectApproxEqAbs(@as(f32, 15.0), d2.size, 0.001);
}

// ============================================================================
// BFMatcher knnMatch Tests — verify match properties
// ============================================================================

test "features2d: BFMatcher knnMatch produces valid matches" {
    // Create two synthetic images with similar patterns
    var img1 = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img1.deinit();
    img1.setTo(cv.Scalar.init(128, 0, 0, 0));
    var img2 = try cv.Mat.initWithSize(100, 100, 0);
    defer img2.deinit();
    img2.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Draw diagonal + cross patterns for feature detection
    var i: i32 = 10;
    while (i < 90) : (i += 1) {
        img1.setUChar(i, i, 255);
        img1.setUChar(i, 99 - i, 255);
        img1.setUChar(50, i, 255);
        img1.setUChar(i, 50, 255);
        img2.setUChar(i, i, 255);
        img2.setUChar(i, 99 - i, 255);
        img2.setUChar(50, i, 255);
        img2.setUChar(i, 50, 255);
    }

    var orb = try cv.ORB.init();
    defer orb.deinit();

    var kp1 = try cv.KeyPointVector.init();
    defer kp1.deinit();
    var desc1 = try cv.Mat.init();
    defer desc1.deinit();
    orb.detectAndCompute(img1, null, &kp1, &desc1);

    var kp2 = try cv.KeyPointVector.init();
    defer kp2.deinit();
    var desc2 = try cv.Mat.init();
    defer desc2.deinit();
    orb.detectAndCompute(img2, null, &kp2, &desc2);

    if (!desc1.empty() and !desc2.empty()) {
        var bf = try cv.BFMatcher.init(cv.NormTypes.norm_hamming, false);
        defer bf.deinit();

        var matches = try cv.DMatchVector.init();
        defer matches.deinit();

        bf.knnMatch(desc1, desc2, &matches, 2);

        // knnMatch with k=2 flattens best match per query to DMatchVector
        try testing.expect(matches.size() > 0);

        // Verify each match has valid properties
        const n = matches.size();
        var j: usize = 0;
        while (j < n) : (j += 1) {
            const m = matches.at(j);
            try testing.expect(m.query_idx >= 0);
            try testing.expect(m.train_idx >= 0);
            try testing.expect(m.distance >= 0);
        }

        // Since images are identical, best matches should have distance 0
        const first = matches.at(0);
        try testing.expectEqual(@as(f32, 0.0), first.distance);
    }
}
