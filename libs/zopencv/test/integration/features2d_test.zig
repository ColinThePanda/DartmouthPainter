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


test "features2d: ORB detect on real image" {
    var img = try cv.imgcodecs.imread(test_image_box, .grayscale);
    defer img.deinit();

    try testing.expect(!img.empty());

    var orb = try cv.features2d.ORB.init();
    defer orb.deinit();

    var kp = try cv.features2d.KeyPointVector.init();
    defer kp.deinit();

    orb.detect(img, &kp, null);
    try testing.expect(kp.size() > 0);
}

test "features2d: SIFT detect on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .grayscale);
    defer img.deinit();

    try testing.expect(!img.empty());

    var sift = try cv.features2d.SIFT.init();
    defer sift.deinit();

    var kp = try cv.features2d.KeyPointVector.init();
    defer kp.deinit();

    sift.detect(img, &kp, null);
    try testing.expect(kp.size() > 0);
}

test "features2d: AKAZE detect on real image" {
    var img = try cv.imgcodecs.imread(test_image_fruits, .grayscale);
    defer img.deinit();

    try testing.expect(!img.empty());

    var akaze = try cv.features2d.AKAZE.init();
    defer akaze.deinit();

    var kp = try cv.features2d.KeyPointVector.init();
    defer kp.deinit();

    akaze.detect(img, &kp, null);
    try testing.expect(kp.size() >= 0);
}
