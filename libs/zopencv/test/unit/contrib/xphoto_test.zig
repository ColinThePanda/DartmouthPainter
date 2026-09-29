const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "xphoto: WhiteBalancer simple" {
    var src = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Create simple white balancer
    var wb = try cv.contrib.xphoto.WhiteBalancer.createSimple();
    defer wb.deinit();

    // Balance white
    wb.balanceWhite(src, &dst);

    try testing.expect(!dst.empty());
}

test "xphoto: WhiteBalancer gray world" {
    var src = try cv.Mat.initWithSize(100, 100, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    var wb = try cv.contrib.xphoto.WhiteBalancer.createGrayWorld();
    defer wb.deinit();

    wb.balanceWhite(src, &dst);

    try testing.expect(!dst.empty());
}

test "xphoto: BM3D denoising" {
    var src = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply BM3D denoising
    cv.contrib.xphoto.bm3dDenoising(src, &dst, 10.0);

    try testing.expect(!dst.empty());
}

test "xphoto: inpainting" {
    var src = try cv.Mat.initWithSize(100, 100, 16);
    defer src.deinit();

    var mask = try cv.Mat.initWithSize(100, 100, 0);
    defer mask.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply inpainting with FMM
    cv.contrib.xphoto.inpaintFMM(src, mask, &dst, 3);

    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());
}

test "xphoto: BM3D with different noise levels" {
    var src = try cv.Mat.initWithSize(64, 64, 0);
    defer src.deinit();

    // Light denoising
    var dst_light = try cv.Mat.init();
    defer dst_light.deinit();
    cv.contrib.xphoto.bm3dDenoising(src, &dst_light, 3.0);
    try testing.expect(!dst_light.empty());

    // Heavy denoising
    var dst_heavy = try cv.Mat.init();
    defer dst_heavy.deinit();
    cv.contrib.xphoto.bm3dDenoising(src, &dst_heavy, 20.0);
    try testing.expect(!dst_heavy.empty());
}

test "xphoto: white balance on different image sizes" {
    var wb = try cv.contrib.xphoto.WhiteBalancer.createSimple();
    defer wb.deinit();

    // Small image
    var small = try cv.Mat.initWithSize(32, 32, 16);
    defer small.deinit();
    var dst_small = try cv.Mat.init();
    defer dst_small.deinit();
    wb.balanceWhite(small, &dst_small);
    try testing.expect(!dst_small.empty());

    // Large image
    var large = try cv.Mat.initWithSize(256, 256, 16);
    defer large.deinit();
    var dst_large = try cv.Mat.init();
    defer dst_large.deinit();
    wb.balanceWhite(large, &dst_large);
    try testing.expect(!dst_large.empty());
}

test "xphoto: oilPainting effect" {
    var src = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.xphoto.oilPainting(src, &dst, 5, 1);
    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());
}

test "xphoto: applyChannelGains" {
    var src = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // Apply different gains per channel
    cv.contrib.xphoto.applyChannelGains(src, &dst, 1.2, 0.8, 1.0);
    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());
}

test "xphoto: dctDenoising" {
    // DCT denoising expects CV_32FC3
    var src_u8 = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer src_u8.deinit();

    // Convert to float (CV_32FC3 = 21)
    var src = try cv.Mat.init();
    defer src.deinit();
    src_u8.convertTo(&src, 21, 1.0 / 255.0, 0); // 21 = CV_32FC3

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.contrib.xphoto.dctDenoising(src, &dst, 10.0, 16);
    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
}
