const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_video = "testdata/videos/vtest.avi";
const test_image_lena = "testdata/images/lena.jpg";

// ============================================================================
// BackgroundSubtractor Tests (8 tests)
// ============================================================================


test "video: BackgroundSubtractorMOG2 on real video" {
    var cap = try cv.videoio.VideoCapture.initFromFile(test_video);
    defer cap.deinit();

    if (!cap.isOpened()) {
        // Skip if video file not available
        return;
    }

    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();

    var frame = try cv.Mat.init();
    defer frame.deinit();

    var fg_mask = try cv.Mat.init();
    defer fg_mask.deinit();

    var frame_count: usize = 0;
    while (cap.read(&frame) and frame_count < 10) : (frame_count += 1) {
        try testing.expect(!frame.empty());
        mog2.apply(frame, &fg_mask, -1.0);
        try testing.expect(!fg_mask.empty());
    }

    try testing.expect(frame_count > 0);
}

test "video: BackgroundSubtractorKNN on real video" {
    var cap = try cv.videoio.VideoCapture.initFromFile(test_video);
    defer cap.deinit();

    if (!cap.isOpened()) {
        return;
    }

    var knn = try cv.video.BackgroundSubtractorKNN.init();
    defer knn.deinit();

    var frame = try cv.Mat.init();
    defer frame.deinit();

    var fg_mask = try cv.Mat.init();
    defer fg_mask.deinit();

    var frame_count: usize = 0;
    while (cap.read(&frame) and frame_count < 10) : (frame_count += 1) {
        try testing.expect(!frame.empty());
        knn.apply(frame, &fg_mask, -1.0);
        try testing.expect(!fg_mask.empty());
    }

    try testing.expect(frame_count > 0);
}

test "video: BackgroundSubtractor learning rate" {
    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();

    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();

    var fg_mask = try cv.Mat.init();
    defer fg_mask.deinit();

    // Test with different learning rates
    mog2.apply(img, &fg_mask, 0.01);
    try testing.expect(!fg_mask.empty());

    mog2.apply(img, &fg_mask, 0.5);
    try testing.expect(!fg_mask.empty());
}

test "video: BackgroundSubtractor multiple frames" {
    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();

    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();

    var fg_mask = try cv.Mat.init();
    defer fg_mask.deinit();

    // Apply same frame multiple times to build background model
    var i: usize = 0;
    while (i < 5) : (i += 1) {
        mog2.apply(img, &fg_mask, -1.0);
        try testing.expect(!fg_mask.empty());
    }
}

test "video: Optical flow Farneback on real video" {
    var cap = try cv.videoio.VideoCapture.initFromFile(test_video);
    defer cap.deinit();

    if (!cap.isOpened()) {
        return;
    }

    var prev_frame = try cv.Mat.init();
    defer prev_frame.deinit();

    var next_frame = try cv.Mat.init();
    defer next_frame.deinit();

    var prev_gray = try cv.Mat.init();
    defer prev_gray.deinit();

    var next_gray = try cv.Mat.init();
    defer next_gray.deinit();

    var flow = try cv.Mat.init();
    defer flow.deinit();

    // Read first frame
    if (!cap.read(&prev_frame) or prev_frame.empty()) {
        return;
    }
    cv.imgproc.cvtColor(prev_frame, &prev_gray, .bgr2gray);

    // Read second frame
    if (!cap.read(&next_frame) or next_frame.empty()) {
        return;
    }
    cv.imgproc.cvtColor(next_frame, &next_gray, .bgr2gray);

    // Calculate optical flow
    cv.video.calcOpticalFlowFarneback(prev_gray, next_gray, &flow, 0.5, // pyr_scale
        3, // levels
        15, // winsize
        3, // iterations
        5, // poly_n
        1.2, // poly_sigma
        0 // flags
    );

    try testing.expect(!flow.empty());
    try testing.expect(flow.channels() == 2); // Flow has 2 channels (x, y)
}
