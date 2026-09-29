const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "ximgproc: guidedFilter" {
    // Create a simple test image
    var src = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer src.deinit();

    var guide = try cv.Mat.initWithSize(100, 100, 0);
    defer guide.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply guided filter
    cv.contrib.ximgproc.guidedFilter(src, guide, &dst, 5, 0.01);

    // Verify output is not empty
    try testing.expect(!dst.empty());
}

test "ximgproc: bilateralTextureFilter" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply bilateral texture filter
    cv.contrib.ximgproc.bilateralTextureFilter(src, &dst, 5, 1, 0.5, 0.5);

    try testing.expect(!dst.empty());
}

test "ximgproc: adaptiveManifoldFilter" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply adaptive manifold filter
    cv.contrib.ximgproc.adaptiveManifoldFilter(src, &dst, 10.0, 0.5, false);

    try testing.expect(!dst.empty());
}

test "ximgproc: guidedFilter with color image" {
    // Test with color image
    var src = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer src.deinit();

    var guide = try cv.Mat.initWithSize(100, 100, 16);
    defer guide.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.ximgproc.guidedFilter(src, guide, &dst, 8, 100.0);

    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());
}

test "ximgproc: guidedFilter with different radii" {
    var src = try cv.Mat.initWithSize(64, 64, 0);
    defer src.deinit();

    // Test with small radius
    var dst_small = try cv.Mat.init();
    defer dst_small.deinit();
    cv.contrib.ximgproc.guidedFilter(src, src, &dst_small, 2, 10.0);
    try testing.expect(!dst_small.empty());

    // Test with large radius
    var dst_large = try cv.Mat.init();
    defer dst_large.deinit();
    cv.contrib.ximgproc.guidedFilter(src, src, &dst_large, 16, 10.0);
    try testing.expect(!dst_large.empty());
}

test "ximgproc: adaptiveManifoldFilter with outlier adjustment" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();

    // Test with outlier adjustment enabled
    var dst_adjusted = try cv.Mat.init();
    defer dst_adjusted.deinit();
    cv.contrib.ximgproc.adaptiveManifoldFilter(src, &dst_adjusted, 16.0, 0.2, true);
    try testing.expect(!dst_adjusted.empty());

    // Test with outlier adjustment disabled
    var dst_normal = try cv.Mat.init();
    defer dst_normal.deinit();
    cv.contrib.ximgproc.adaptiveManifoldFilter(src, &dst_normal, 16.0, 0.2, false);
    try testing.expect(!dst_normal.empty());
}

test "ximgproc: thinning binary image" {
    // Create a binary image with some features
    var src = try cv.Mat.initWithSize(64, 64, 0); // CV_8UC1
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply Zhang-Suen thinning
    cv.contrib.ximgproc.thinning(src, &dst, .ZHANGSUEN);
    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());

    // Apply Guo-Hall thinning
    var dst2 = try cv.Mat.init();
    defer dst2.deinit();
    cv.contrib.ximgproc.thinning(src, &dst2, .GUOHALL);
    try testing.expect(!dst2.empty());
}

test "ximgproc: niBlackThreshold" {
    // Create a grayscale image
    var src = try cv.Mat.initWithSize(64, 64, 0); // CV_8UC1
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // NIBLACK binarization with THRESH_BINARY (0)
    cv.contrib.ximgproc.niBlackThreshold(src, &dst, 255.0, 0, 15, -0.2, .NIBLACK);
    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());

    // SAUVOLA binarization
    var dst2 = try cv.Mat.init();
    defer dst2.deinit();
    cv.contrib.ximgproc.niBlackThreshold(src, &dst2, 255.0, 0, 15, 0.5, .SAUVOLA);
    try testing.expect(!dst2.empty());
}

test "ximgproc: anisotropicDiffusion" {
    // Create a 3-channel 8-bit image
    var src = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply anisotropic diffusion
    cv.contrib.ximgproc.anisotropicDiffusion(src, &dst, 0.1, 30.0, 10);
    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());
}
