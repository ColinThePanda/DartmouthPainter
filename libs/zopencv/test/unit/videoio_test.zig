const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "videoio: VideoWriter creation" {
    var writer = try cv.videoio.VideoWriter.init();
    defer writer.deinit();

    // Empty writer should not be opened
    try testing.expect(!writer.isOpened());
}

test "videoio: FourCC codes" {
    const mjpeg = cv.videoio.fourcc('M', 'J', 'P', 'G');
    const h264 = cv.videoio.fourcc('H', '2', '6', '4');

    try testing.expect(mjpeg != 0);
    try testing.expect(h264 != 0);
    try testing.expect(mjpeg != h264);
}

test "videoio: FourCC value check" {
    // MJPG = 0x47504A4D
    const mjpg = cv.videoio.fourcc('M', 'J', 'P', 'G');
    const xvid = cv.videoio.fourcc('X', 'V', 'I', 'D');
    const mp4v = cv.videoio.fourcc('M', 'P', '4', 'V');

    try testing.expect(mjpg != 0);
    try testing.expect(xvid != 0);
    try testing.expect(mp4v != 0);
    try testing.expect(mjpg != xvid);
    try testing.expect(mjpg != mp4v);
}

test "videoio: VideoCapture creation" {
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    // Empty capture should not be opened
    try testing.expect(!cap.isOpened());
}

test "videoio: VideoCapture from nonexistent file" {
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    // Opening nonexistent file should fail gracefully
    const opened = try cap.open("nonexistent_video.avi");
    try testing.expect(!opened);
    try testing.expect(!cap.isOpened());
}

test "videoio: VideoCapture grab on closed capture returns false" {
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    // grab should return false if not opened
    try testing.expect(!cap.grab());
}

test "videoio: VideoCapture retrieve on closed capture" {
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    var frame = try cv.Mat.init();
    defer frame.deinit();

    // retrieve should return false if not opened
    try testing.expect(!cap.retrieve(&frame));
}

test "videoio: VideoWriter write synthetic frame" {
    var writer = try cv.videoio.VideoWriter.init();
    defer writer.deinit();

    // Create a synthetic frame
    var frame = try cv.Mat.initWithSize(480, 640, cv.core.CV_8UC3);
    defer frame.deinit();
    frame.setTo(cv.Scalar.init(128, 64, 32, 0));

    const fourcc_code = cv.videoio.fourcc('M', 'J', 'P', 'G');
    const opened = try writer.open(
        "/tmp/test_videoio_output.avi",
        fourcc_code,
        25.0,
        cv.Size{ .width = 640, .height = 480 },
        true,
    );

    if (opened) {
        writer.write(frame);
        writer.release();
        try testing.expect(!writer.isOpened());
    }
}

test "videoio: VideoCaptureProperties enum values" {
    try testing.expectEqual(@as(i32, 0), @intFromEnum(cv.videoio.VideoCaptureProperty.pos_msec));
    try testing.expectEqual(@as(i32, 3), @intFromEnum(cv.videoio.VideoCaptureProperty.frame_width));
    try testing.expectEqual(@as(i32, 4), @intFromEnum(cv.videoio.VideoCaptureProperty.frame_height));
    try testing.expectEqual(@as(i32, 5), @intFromEnum(cv.videoio.VideoCaptureProperty.fps));
}
