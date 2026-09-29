const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");


test "videoio: VideoCapture creation" {
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    // Empty capture should not be opened
    try testing.expect(!cap.isOpened());
}

test "videoio: VideoCaptureProperty enum" {
    const width_prop = cv.videoio.VideoCaptureProperty.frame_width;
    const height_prop = cv.videoio.VideoCaptureProperty.frame_height;
    const fps_prop = cv.videoio.VideoCaptureProperty.fps;

    try testing.expectEqual(@as(i32, 3), @intFromEnum(width_prop));
    try testing.expectEqual(@as(i32, 4), @intFromEnum(height_prop));
    try testing.expectEqual(@as(i32, 5), @intFromEnum(fps_prop));

    // Test extended properties
    const buffersize = cv.videoio.VideoCaptureProperty.buffersize;
    try testing.expectEqual(@as(i32, 38), @intFromEnum(buffersize));
    const bitrate = cv.videoio.VideoCaptureProperty.bitrate;
    try testing.expectEqual(@as(i32, 47), @intFromEnum(bitrate));
}

test "videoio: VideoCaptureAPI enum" {
    const any = cv.videoio.VideoCaptureAPI.any;
    const ffmpeg = cv.videoio.VideoCaptureAPI.ffmpeg;
    const avfoundation = cv.videoio.VideoCaptureAPI.avfoundation;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(any));
    try testing.expectEqual(@as(i32, 1900), @intFromEnum(ffmpeg));
    try testing.expectEqual(@as(i32, 1200), @intFromEnum(avfoundation));
}
