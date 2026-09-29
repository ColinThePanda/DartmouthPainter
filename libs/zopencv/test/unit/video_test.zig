const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_video = "testdata/videos/vtest.avi";
const test_image_lena = "testdata/images/lena.jpg";

// ============================================================================
// BackgroundSubtractor Tests (8 tests)
// ============================================================================

test "video: BackgroundSubtractorMOG2 creation" {
    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();
}

test "video: BackgroundSubtractorMOG2 with params" {
    var mog2 = try cv.video.BackgroundSubtractorMOG2.initWithParams(300, 25.0, false);
    defer mog2.deinit();
}

test "video: BackgroundSubtractorKNN creation" {
    var knn = try cv.video.BackgroundSubtractorKNN.init();
    defer knn.deinit();
}

test "video: BackgroundSubtractorKNN with params" {
    var knn = try cv.video.BackgroundSubtractorKNN.initWithParams(300, 300.0, false);
    defer knn.deinit();
}

test "video: OptflowFlag enum" {
    const use_initial = cv.video.OptflowFlag.use_initial_flow;
    const get_min_eig = cv.video.OptflowFlag.lk_get_min_eigenvals;
    const gaussian = cv.video.OptflowFlag.farneback_gaussian;

    try testing.expectEqual(@as(i32, 4), @intFromEnum(use_initial));
    try testing.expectEqual(@as(i32, 8), @intFromEnum(get_min_eig));
    try testing.expectEqual(@as(i32, 256), @intFromEnum(gaussian));
}

test "video: TermCriteriaType enum" {
    const count = cv.video.TermCriteriaType.count;
    const eps = cv.video.TermCriteriaType.eps;
    const count_eps = cv.video.TermCriteriaType.count_eps;

    try testing.expectEqual(@as(i32, 1), @intFromEnum(count));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(eps));
    try testing.expectEqual(@as(i32, 3), @intFromEnum(count_eps));
}

test "video: KalmanFilter create and delete" {
    var kf = try cv.KalmanFilter.init(4, 2);
    defer kf.deinit();
}

test "video: KalmanFilter predict" {
    var kf = try cv.KalmanFilter.init(4, 2);
    defer kf.deinit();

    var prediction = try cv.Mat.init();
    defer prediction.deinit();

    kf.predict(&prediction);
    try testing.expect(!prediction.empty());
    try testing.expectEqual(@as(i32, 4), prediction.rows());
}

test "video: KalmanFilter correct" {
    var kf = try cv.KalmanFilter.init(4, 2);
    defer kf.deinit();

    // Create a measurement vector (2x1)
    var measurement = try cv.Mat.initWithSize(2, 1, 5); // CV_32F
    defer measurement.deinit();
    measurement.setFloat(0, 0, 100.0);
    measurement.setFloat(1, 0, 200.0);

    var corrected = try cv.Mat.init();
    defer corrected.deinit();

    kf.correct(measurement, &corrected);
    try testing.expect(!corrected.empty());
    try testing.expectEqual(@as(i32, 4), corrected.rows());
}

test "video: KalmanFilter get/set matrices" {
    var kf = try cv.KalmanFilter.init(4, 2);
    defer kf.deinit();

    // Get transition matrix (should be 4x4)
    var trans = try cv.Mat.init();
    defer trans.deinit();
    kf.getTransitionMatrix(&trans);
    try testing.expectEqual(@as(i32, 4), trans.rows());
    try testing.expectEqual(@as(i32, 4), trans.cols());

    // Get measurement matrix (should be 2x4)
    var meas = try cv.Mat.init();
    defer meas.deinit();
    kf.getMeasurementMatrix(&meas);
    try testing.expectEqual(@as(i32, 2), meas.rows());
    try testing.expectEqual(@as(i32, 4), meas.cols());
}

// ============================================================================
// BackgroundSubtractor Functional Tests
// ============================================================================

test "video: BackgroundSubtractorMOG2 apply" {
    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();

    var frame = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer frame.deinit();
    frame.setTo(cv.Scalar.init(128, 128, 128, 0));

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    mog2.apply(frame, &fgmask, -1.0);
    try testing.expect(!fgmask.empty());
    try testing.expectEqual(@as(i32, 100), fgmask.rows());
    try testing.expectEqual(@as(i32, 1), fgmask.channels());
}

test "video: BackgroundSubtractorKNN apply" {
    var knn = try cv.video.BackgroundSubtractorKNN.init();
    defer knn.deinit();

    var frame = try cv.Mat.initWithSize(80, 80, 16);
    defer frame.deinit();
    frame.setTo(cv.Scalar.init(64, 64, 64, 0));

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    knn.apply(frame, &fgmask, -1.0);
    try testing.expect(!fgmask.empty());
}

test "video: BackgroundSubtractorMOG2 getBackgroundImage" {
    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();

    // Feed several frames to build background model
    var frame = try cv.Mat.initWithSize(50, 50, 16);
    defer frame.deinit();
    frame.setTo(cv.Scalar.init(100, 100, 100, 0));

    var fgmask = try cv.Mat.init();
    defer fgmask.deinit();

    var i: i32 = 0;
    while (i < 5) : (i += 1) {
        mog2.apply(frame, &fgmask, -1.0);
    }

    var bg = try cv.Mat.init();
    defer bg.deinit();
    mog2.getBackgroundImage(&bg);
    try testing.expect(!bg.empty());
}

test "video: calcOpticalFlowFarneback" {
    // Create two grayscale frames with slight shift
    var prev = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer prev.deinit();
    prev.setTo(cv.Scalar.init(128, 0, 0, 0));

    var next_frame = try cv.Mat.initWithSize(50, 50, 0);
    defer next_frame.deinit();
    next_frame.setTo(cv.Scalar.init(128, 0, 0, 0));

    var flow = try cv.Mat.init();
    defer flow.deinit();

    cv.video.calcOpticalFlowFarneback(prev, next_frame, &flow, 0.5, 3, 15, 3, 5, 1.2, 0);
    try testing.expect(!flow.empty());
    try testing.expectEqual(@as(i32, 50), flow.rows());
    try testing.expectEqual(@as(i32, 50), flow.cols());
}
