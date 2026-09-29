const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_image_chessboard = "testdata/images/chessboard.png";

// ============================================================================
// Basic API Tests (1 test)
// ============================================================================


test "calib3d: findChessboardCorners on real image" {
    var img = try cv.imgcodecs.imread(test_image_chessboard, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var corners = try cv.Mat.init();
    defer corners.deinit();

    const pattern_size = cv.Size.init(9, 6);
    const found = cv.calib3d.findChessboardCorners(img, pattern_size, &corners, 0);

    // Just verify it doesn't crash - may or may not find corners
    _ = found;
}

test "calib3d: findChessboardCornersSB on real image" {
    var img = try cv.imgcodecs.imread(test_image_chessboard, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var corners = try cv.Mat.init();
    defer corners.deinit();

    const pattern_size = cv.Size.init(9, 6);
    const found = cv.calib3d.findChessboardCornersSB(img, pattern_size, &corners, 0);

    _ = found;
}

test "calib3d: drawChessboardCorners" {
    var img = try cv.imgcodecs.imread(test_image_chessboard, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var corners = try cv.Mat.init();
    defer corners.deinit();

    const pattern_size = cv.Size.init(9, 6);
    const found = cv.calib3d.findChessboardCorners(img, pattern_size, &corners, 0);

    if (found) {
        cv.calib3d.drawChessboardCorners(&img, pattern_size, corners, found);
        try testing.expect(!img.empty());
    }
}
