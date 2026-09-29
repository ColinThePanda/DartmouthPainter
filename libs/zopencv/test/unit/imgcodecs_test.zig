const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// ============================================================================
// ImreadMode Enum Tests (2 tests)
// ============================================================================


test "imgcodecs: ImreadMode enum values" {
    const unchanged = cv.imgcodecs.ImreadMode.unchanged;
    const grayscale = cv.imgcodecs.ImreadMode.grayscale;
    const color = cv.imgcodecs.ImreadMode.color;

    try testing.expectEqual(@as(i32, -1), @intFromEnum(unchanged));
    try testing.expectEqual(@as(i32, 0), @intFromEnum(grayscale));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(color));
}

test "imgcodecs: ImreadMode reduced modes" {
    const reduced_gray_2 = cv.imgcodecs.ImreadMode.reduced_grayscale_2;
    const reduced_color_4 = cv.imgcodecs.ImreadMode.reduced_color_4;

    try testing.expectEqual(@as(i32, 16), @intFromEnum(reduced_gray_2));
    try testing.expectEqual(@as(i32, 33), @intFromEnum(reduced_color_4));
}

test "imgcodecs: imencode and imdecode roundtrip" {
    // Create a test image
    var img = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 64, 32, 0));

    // Encode to PNG
    const encoded = try cv.imencode(".png", img, null);
    defer std.heap.c_allocator.free(encoded);

    try testing.expect(encoded.len > 0);

    // Decode back
    var decoded = try cv.imdecode(encoded, cv.imgcodecs.ImreadMode.color);
    defer decoded.deinit();

    try testing.expect(!decoded.empty());
    try testing.expectEqual(@as(i32, 50), decoded.rows());
    try testing.expectEqual(@as(i32, 50), decoded.cols());
}

test "imgcodecs: ImwriteFlags constants" {
    try testing.expectEqual(@as(i32, 1), cv.ImwriteFlags.jpeg_quality);
    try testing.expectEqual(@as(i32, 16), cv.ImwriteFlags.png_compression);
    try testing.expectEqual(@as(i32, 64), cv.ImwriteFlags.webp_quality);
}
