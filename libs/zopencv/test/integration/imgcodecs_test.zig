const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// ============================================================================
// ImreadMode Enum Tests (2 tests)
// ============================================================================


test "imgcodecs: imwrite and imread grayscale" {
    const filename = "/tmp/test_gray.png";

    // Create a test image
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();

    // Fill with test pattern
    var i: i32 = 0;
    while (i < 100) : (i += 1) {
        img.setUChar(i, i, @intCast(i * 2));
    }

    // Write image
    try cv.imgcodecs.imwrite(filename, img);

    // Read back
    var loaded = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());
    try testing.expectEqual(@as(i32, 100), loaded.rows());
    try testing.expectEqual(@as(i32, 100), loaded.cols());
    try testing.expectEqual(@as(i32, 1), loaded.channels());

    // Cleanup
    // File cleanup skipped - using /tmp
}

test "imgcodecs: imwrite and imread color" {
    const filename = "/tmp/test_color.png";

    var img = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .color);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());
    try testing.expectEqual(@as(i32, 50), loaded.rows());
    try testing.expectEqual(@as(i32, 3), loaded.channels());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: imread unchanged mode" {
    const filename = "/tmp/test_unchanged.png";

    var img = try cv.Mat.initWithSize(64, 64, 16);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .unchanged);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());
    try testing.expectEqual(@as(i32, 64), loaded.rows());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: imread anycolor mode" {
    const filename = "/tmp/test_anycolor.png";

    var img = try cv.Mat.initWithSize(32, 32, 0);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .anycolor);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: imwrite different sizes" {
    const sizes = [_]i32{ 10, 50, 100, 200 };

    for (sizes, 0..) |size, idx| {
        var filename_buf: [64]u8 = undefined;
        const filename = try std.fmt.bufPrint(&filename_buf, "/tmp/test_size_{d}.png", .{idx});

        var img = try cv.Mat.initWithSize(size, size, 0);
        defer img.deinit();

        try cv.imgcodecs.imwrite(filename, img);

        var loaded = try cv.imgcodecs.imread(filename, .grayscale);
        defer loaded.deinit();

        try testing.expectEqual(size, loaded.rows());
        try testing.expectEqual(size, loaded.cols());

        // File cleanup skipped - using /tmp
    }
}

test "imgcodecs: imwrite rectangular image" {
    const filename = "/tmp/test_rect.png";

    var img = try cv.Mat.initWithSize(100, 200, 0);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded.deinit();

    try testing.expectEqual(@as(i32, 100), loaded.rows());
    try testing.expectEqual(@as(i32, 200), loaded.cols());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: imwrite preserves data" {
    const filename = "/tmp/test_data.png";

    var img = try cv.Mat.initWithSize(10, 10, 0);
    defer img.deinit();

    // Set specific values
    img.setUChar(5, 5, 128);
    img.setUChar(0, 0, 255);
    img.setUChar(9, 9, 64);

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded.deinit();

    // PNG is lossless, values should match
    try testing.expectEqual(@as(u8, 128), loaded.getUChar(5, 5));
    try testing.expectEqual(@as(u8, 255), loaded.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 64), loaded.getUChar(9, 9));

    // File cleanup skipped - using /tmp
}

test "imgcodecs: imread nonexistent file" {
    const result = cv.imgcodecs.imread("/tmp/nonexistent_file_12345.png", .color);
    try testing.expectError(cv.Error.MatCreationFailed, result);
}

test "imgcodecs: PNG format" {
    const filename = "/tmp/test.png";

    var img = try cv.Mat.initWithSize(50, 50, 0);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: JPEG format" {
    const filename = "/tmp/test.jpg";

    var img = try cv.Mat.initWithSize(50, 50, 16);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .color);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());
    try testing.expectEqual(@as(i32, 50), loaded.rows());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: BMP format" {
    const filename = "/tmp/test.bmp";

    var img = try cv.Mat.initWithSize(32, 32, 16);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .color);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: TIFF format" {
    const filename = "/tmp/test.tiff";

    var img = try cv.Mat.initWithSize(64, 64, 0);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded.deinit();

    try testing.expect(!loaded.empty());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: WebP format" {
    const filename = "/tmp/test.webp";

    var img = try cv.Mat.initWithSize(48, 48, 16);
    defer img.deinit();

    // WebP might not be supported on all systems
    cv.imgcodecs.imwrite(filename, img) catch |err| {
        if (err == error.ImWriteFailed) {
            // WebP not supported, skip test
            return;
        }
        return err;
    };

    var loaded = cv.imgcodecs.imread(filename, .color) catch |err| {
        // File cleanup skipped - using /tmp
        if (err == cv.Error.MatCreationFailed) {
            // WebP not supported, skip test
            return;
        }
        return err;
    };
    defer loaded.deinit();

    try testing.expect(!loaded.empty());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: write and read multiple times" {
    const filename = "/tmp/test_multi.png";

    // First write/read cycle
    var img1 = try cv.Mat.initWithSize(30, 30, 0);
    defer img1.deinit();
    img1.setUChar(15, 15, 200);

    try cv.imgcodecs.imwrite(filename, img1);

    var loaded1 = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded1.deinit();

    try testing.expectEqual(@as(u8, 200), loaded1.getUChar(15, 15));

    // Second write/read cycle (overwrite)
    var img2 = try cv.Mat.initWithSize(40, 40, 0);
    defer img2.deinit();
    img2.setUChar(20, 20, 100);

    try cv.imgcodecs.imwrite(filename, img2);

    var loaded2 = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded2.deinit();

    try testing.expectEqual(@as(i32, 40), loaded2.rows());
    try testing.expectEqual(@as(u8, 100), loaded2.getUChar(20, 20));

    // File cleanup skipped - using /tmp
}

test "imgcodecs: large image" {
    const filename = "/tmp/test_large.png";

    var img = try cv.Mat.initWithSize(1000, 1000, 0);
    defer img.deinit();

    try cv.imgcodecs.imwrite(filename, img);

    var loaded = try cv.imgcodecs.imread(filename, .grayscale);
    defer loaded.deinit();

    try testing.expectEqual(@as(i32, 1000), loaded.rows());
    try testing.expectEqual(@as(i32, 1000), loaded.cols());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: color to grayscale conversion" {
    const filename = "/tmp/test_convert.png";

    // Write color image
    var img_color = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer img_color.deinit();

    try cv.imgcodecs.imwrite(filename, img_color);

    // Read as grayscale
    var img_gray = try cv.imgcodecs.imread(filename, .grayscale);
    defer img_gray.deinit();

    try testing.expectEqual(@as(i32, 1), img_gray.channels());
    try testing.expectEqual(@as(i32, 50), img_gray.rows());

    // File cleanup skipped - using /tmp
}

test "imgcodecs: imwriteWithParams JPEG quality" {
    var img = try cv.Mat.initWithSize(30, 30, 16);
    defer img.deinit();
    img.setTo(cv.Scalar.init(100, 200, 50, 0));

    // Write with JPEG quality 95
    const params = [_]i32{ cv.ImwriteFlags.jpeg_quality, 95 };
    try cv.imwriteWithParams("/tmp/test_quality.jpg", img, &params);

    var loaded = try cv.imgcodecs.imread("/tmp/test_quality.jpg", .color);
    defer loaded.deinit();
    try testing.expect(!loaded.empty());
}

test "imgcodecs: haveImageReader" {
    // PNG should always be supported
    const has_png = try cv.haveImageReader("/tmp/test.png");
    try testing.expect(has_png);
}

test "imgcodecs: haveImageWriter" {
    // PNG should always be supported
    const can_write_png = try cv.haveImageWriter("/tmp/test.png");
    try testing.expect(can_write_png);
}
