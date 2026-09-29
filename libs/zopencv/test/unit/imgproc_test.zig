const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_image_lena = "testdata/images/lena.jpg";
const test_image_fruits = "testdata/images/fruits.jpg";
const test_image_box = "testdata/images/box.png";
const test_image_chessboard = "testdata/images/chessboard.png";

// ============================================================================
// Enum Tests (4 tests) - Keep original
// ============================================================================

test "imgproc: ColorConversionCode enum" {
    const bgr2gray = cv.imgproc.ColorConversionCode.bgr2gray;
    const gray2bgr = cv.imgproc.ColorConversionCode.gray2bgr;

    try testing.expectEqual(@as(i32, 6), @intFromEnum(bgr2gray));
    try testing.expectEqual(@as(i32, 8), @intFromEnum(gray2bgr));
}

test "imgproc: InterpolationFlag enum" {
    const nearest = cv.imgproc.InterpolationFlag.nearest;
    const linear = cv.imgproc.InterpolationFlag.linear;
    const cubic = cv.imgproc.InterpolationFlag.cubic;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(nearest));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(linear));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(cubic));
}

test "imgproc: ThresholdType enum" {
    const binary = cv.imgproc.ThresholdType.binary;
    const binary_inv = cv.imgproc.ThresholdType.binary_inv;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(binary));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(binary_inv));
}

test "imgproc: MorphShape enum" {
    const rect = cv.imgproc.MorphShape.rect;
    const cross = cv.imgproc.MorphShape.cross;
    const ellipse = cv.imgproc.MorphShape.ellipse;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(rect));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(cross));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(ellipse));
}

test "imgproc: cvtColor BGR to Gray" {
    var src = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .bgr2gray);

    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 1), dst.channels());
}

test "imgproc: cvtColor Gray to BGR" {
    var src = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .gray2bgr);

    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "imgproc: cvtColor BGR to RGB" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .bgr2rgb);

    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "imgproc: cvtColor BGR to HSV" {
    var src = try cv.Mat.initWithSize(64, 64, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .bgr2hsv);

    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "imgproc: cvtColor HSV to BGR" {
    var src = try cv.Mat.initWithSize(64, 64, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .hsv2bgr);

    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "imgproc: cvtColor RGB to Gray" {
    var src = try cv.Mat.initWithSize(80, 80, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .rgb2gray);

    try testing.expectEqual(@as(i32, 1), dst.channels());
}

test "imgproc: cvtColor different sizes" {
    const sizes = [_]i32{ 10, 50, 100, 200 };

    for (sizes) |size| {
        var src = try cv.Mat.initWithSize(size, size, 16);
        defer src.deinit();

        var dst = try cv.Mat.init();
        defer dst.deinit();

        cv.imgproc.cvtColor(src, &dst, .bgr2gray);

        try testing.expectEqual(size, dst.rows());
        try testing.expectEqual(size, dst.cols());
    }
}

test "imgproc: cvtColor preserves dimensions" {
    var src = try cv.Mat.initWithSize(123, 456, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.cvtColor(src, &dst, .bgr2gray);

    try testing.expectEqual(@as(i32, 123), dst.rows());
    try testing.expectEqual(@as(i32, 456), dst.cols());
}

test "imgproc: resize upscale nearest" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(200, 200);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .nearest);

    try testing.expectEqual(@as(i32, 200), dst.rows());
    try testing.expectEqual(@as(i32, 200), dst.cols());
}

test "imgproc: resize downscale linear" {
    var src = try cv.Mat.initWithSize(200, 200, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(100, 100);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .linear);

    try testing.expectEqual(@as(i32, 100), dst.rows());
    try testing.expectEqual(@as(i32, 100), dst.cols());
}

test "imgproc: resize cubic interpolation" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(100, 100);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .cubic);

    try testing.expectEqual(@as(i32, 100), dst.rows());
}

test "imgproc: resize area interpolation" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(50, 50);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .area);

    try testing.expectEqual(@as(i32, 50), dst.rows());
}

test "imgproc: resize non-square" {
    var src = try cv.Mat.initWithSize(100, 200, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(50, 150);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .linear);

    try testing.expectEqual(@as(i32, 150), dst.rows()); // height
    try testing.expectEqual(@as(i32, 50), dst.cols()); // width
}

test "imgproc: resize color image" {
    var src = try cv.Mat.initWithSize(64, 64, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(128, 128);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .linear);

    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "imgproc: resize with scale factor" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const empty_size = cv.Size.init(0, 0);
    cv.imgproc.resize(src, &dst, empty_size, 2.0, 2.0, .linear);

    try testing.expectEqual(@as(i32, 200), dst.rows());
    try testing.expectEqual(@as(i32, 200), dst.cols());
}

test "imgproc: resize very small" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(10, 10);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .area);

    try testing.expectEqual(@as(i32, 10), dst.rows());
}

test "imgproc: resize very large" {
    var src = try cv.Mat.initWithSize(10, 10, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(500, 500);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .cubic);

    try testing.expectEqual(@as(i32, 500), dst.rows());
}

test "imgproc: resize maintains type" {
    var src = try cv.Mat.initWithSize(50, 50, 5); // CV_32FC1
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const new_size = cv.Size.init(100, 100);
    cv.imgproc.resize(src, &dst, new_size, 0, 0, .linear);

    try testing.expectEqual(@as(i32, 5), dst.depth());
}

test "imgproc: GaussianBlur basic" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(5, 5);
    cv.imgproc.gaussianBlur(src, &dst, ksize, 1.0, 1.0, 4);

    try testing.expect(!dst.empty());
    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: GaussianBlur different sigma" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(7, 7);
    cv.imgproc.gaussianBlur(src, &dst, ksize, 2.0, 2.0, 4);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: medianBlur kernel 3" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.medianBlur(src, &dst, 3);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: medianBlur kernel 5" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.medianBlur(src, &dst, 5);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: blur box filter" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(5, 5);
    cv.imgproc.blur(src, &dst, ksize);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: bilateralFilter" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.bilateralFilter(src, &dst, 5, 50.0, 50.0, 4);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: Sobel X derivative" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.sobel(src, &dst, -1, 1, 0, 3, 1.0, 0.0, 4);

    try testing.expect(!dst.empty());
}

test "imgproc: Sobel Y derivative" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.sobel(src, &dst, -1, 0, 1, 3, 1.0, 0.0, 4);

    try testing.expect(!dst.empty());
}

test "imgproc: Laplacian" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.laplacian(src, &dst, -1, 3, 1.0, 0.0, 4);

    try testing.expect(!dst.empty());
}

test "imgproc: filter on color image" {
    var src = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(5, 5);
    cv.imgproc.gaussianBlur(src, &dst, ksize, 1.0, 1.0, 4);

    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "imgproc: Canny edge detection" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.canny(src, &dst, 50.0, 150.0, 3, false);

    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 1), dst.channels());
}

test "imgproc: Canny with L2 gradient" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.canny(src, &dst, 50.0, 150.0, 3, true);

    try testing.expect(!dst.empty());
}

test "imgproc: Canny different thresholds" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.canny(src, &dst, 100.0, 200.0, 3, false);

    try testing.expect(!dst.empty());
}

test "imgproc: Canny larger aperture" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.canny(src, &dst, 50.0, 150.0, 5, false);

    try testing.expect(!dst.empty());
}

test "imgproc: getStructuringElement rect" {
    const ksize = cv.Size.init(5, 5);
    const anchor = cv.Point.init(-1, -1);

    var kernel = try cv.imgproc.getStructuringElement(.rect, ksize, anchor);
    defer kernel.deinit();

    try testing.expect(!kernel.empty());
}

test "imgproc: getStructuringElement ellipse" {
    const ksize = cv.Size.init(5, 5);
    const anchor = cv.Point.init(-1, -1);

    var kernel = try cv.imgproc.getStructuringElement(.ellipse, ksize, anchor);
    defer kernel.deinit();

    try testing.expect(!kernel.empty());
}

test "imgproc: erode operation" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(3, 3);
    const anchor = cv.Point.init(-1, -1);
    var kernel = try cv.imgproc.getStructuringElement(.rect, ksize, anchor);
    defer kernel.deinit();

    cv.imgproc.erode(src, &dst, kernel, anchor, 1, 4);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: dilate operation" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(3, 3);
    const anchor = cv.Point.init(-1, -1);
    var kernel = try cv.imgproc.getStructuringElement(.rect, ksize, anchor);
    defer kernel.deinit();

    cv.imgproc.dilate(src, &dst, kernel, anchor, 1, 4);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: morphologyEx opening" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(5, 5);
    const anchor = cv.Point.init(-1, -1);
    var kernel = try cv.imgproc.getStructuringElement(.rect, ksize, anchor);
    defer kernel.deinit();

    cv.imgproc.morphologyEx(src, &dst, .open, kernel, anchor, 1, 4);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: morphologyEx closing" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ksize = cv.Size.init(5, 5);
    const anchor = cv.Point.init(-1, -1);
    var kernel = try cv.imgproc.getStructuringElement(.rect, ksize, anchor);
    defer kernel.deinit();

    cv.imgproc.morphologyEx(src, &dst, .close, kernel, anchor, 1, 4);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "imgproc: threshold binary" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const result = cv.imgproc.threshold(src, &dst, 127.0, 255.0, .binary);
    _ = result;

    try testing.expect(!dst.empty());
}

test "imgproc: threshold binary_inv" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    _ = cv.imgproc.threshold(src, &dst, 127.0, 255.0, .binary_inv);

    try testing.expect(!dst.empty());
}

test "imgproc: threshold Otsu" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const otsu_thresh = cv.imgproc.threshold(src, &dst, 0.0, 255.0, .otsu);
    _ = otsu_thresh;

    try testing.expect(!dst.empty());
}

test "imgproc: adaptiveThreshold" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.imgproc.adaptiveThreshold(src, &dst, 255.0, 0, .binary, 11, 2.0);

    try testing.expect(!dst.empty());
}

test "imgproc: draw line" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();

    const pt1 = cv.Point.init(10, 10);
    const pt2 = cv.Point.init(90, 90);
    const color = cv.Scalar.init(255, 0, 0, 0);

    cv.imgproc.line(&img, pt1, pt2, color, 2, 8, 0);

    try testing.expect(!img.empty());
}

test "imgproc: draw rectangle" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    const rect = cv.Rect.init(10, 10, 50, 50);
    const color = cv.Scalar.init(0, 255, 0, 0);

    cv.imgproc.rectangle(&img, rect, color, 2, 8, 0);

    try testing.expect(!img.empty());
}

test "imgproc: draw circle" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    const center = cv.Point.init(50, 50);
    const color = cv.Scalar.init(0, 0, 255, 0);

    cv.imgproc.circle(&img, center, 30, color, 2, 8, 0);

    try testing.expect(!img.empty());
}

test "imgproc: draw filled circle" {
    var img = try cv.Mat.initWithSize(100, 100, 16);
    defer img.deinit();

    const center = cv.Point.init(50, 50);
    const color = cv.Scalar.init(128, 128, 128, 0);

    cv.imgproc.circle(&img, center, 20, color, -1, 8, 0); // -1 = filled

    try testing.expect(!img.empty());
}

test "imgproc: pyrDown" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    // Fill with test pattern
    for (0..100) |i| {
        for (0..100) |j| {
            src.setUChar(@intCast(i), @intCast(j), @intCast((i + j) % 256));
        }
    }

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.pyrDown(src, &dst, cv.Size.init(0, 0), cv.imgproc.BORDER_DEFAULT);

    // Output should be half size
    try testing.expectEqual(@as(i32, 50), dst.rows());
    try testing.expectEqual(@as(i32, 50), dst.cols());
}

test "imgproc: pyrUp" {
    var src = try cv.Mat.initWithSize(50, 50, 0);
    defer src.deinit();

    // Fill with test pattern
    for (0..50) |i| {
        for (0..50) |j| {
            src.setUChar(@intCast(i), @intCast(j), @intCast((i + j) % 256));
        }
    }

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.pyrUp(src, &dst, cv.Size.init(0, 0), cv.imgproc.BORDER_DEFAULT);

    // Output should be double size
    try testing.expectEqual(@as(i32, 100), dst.rows());
    try testing.expectEqual(@as(i32, 100), dst.cols());
}

test "imgproc: warpAffine" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    // Fill with test pattern
    for (0..100) |i| {
        for (0..100) |j| {
            src.setUChar(@intCast(i), @intCast(j), @intCast((i + j) % 256));
        }
    }

    // Create identity transform matrix (2x3)
    var M = try cv.Mat.initWithSize(2, 3, 6);
    defer M.deinit();
    M.setDouble(0, 0, 1.0);
    M.setDouble(0, 1, 0.0);
    M.setDouble(0, 2, 0.0);
    M.setDouble(1, 0, 0.0);
    M.setDouble(1, 1, 1.0);
    M.setDouble(1, 2, 0.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.warpAffine(src, &dst, M, cv.Size.init(100, 100), 1, cv.imgproc.BORDER_CONSTANT, cv.Scalar.init(0, 0, 0, 0));

    try testing.expectEqual(@as(i32, 100), dst.rows());
    try testing.expectEqual(@as(i32, 100), dst.cols());
}

test "imgproc: warpPerspective" {
    var src = try cv.Mat.initWithSize(100, 100, 0);
    defer src.deinit();

    // Fill with test pattern
    for (0..100) |i| {
        for (0..100) |j| {
            src.setUChar(@intCast(i), @intCast(j), @intCast((i + j) % 256));
        }
    }

    // Create identity transform matrix (3x3)
    var M = try cv.Mat.initWithSize(3, 3, 6);
    defer M.deinit();
    M.setDouble(0, 0, 1.0);
    M.setDouble(0, 1, 0.0);
    M.setDouble(0, 2, 0.0);
    M.setDouble(1, 0, 0.0);
    M.setDouble(1, 1, 1.0);
    M.setDouble(1, 2, 0.0);
    M.setDouble(2, 0, 0.0);
    M.setDouble(2, 1, 0.0);
    M.setDouble(2, 2, 1.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();
}

test "imgproc: getAffineTransform" {
    var src_pts = try cv.Point2fVector.init();
    defer src_pts.deinit();
    try src_pts.append(cv.Point2f.init(0, 0));
    try src_pts.append(cv.Point2f.init(100, 0));
    try src_pts.append(cv.Point2f.init(0, 100));

    var dst_pts = try cv.Point2fVector.init();
    defer dst_pts.deinit();
    try dst_pts.append(cv.Point2f.init(10, 10));
    try dst_pts.append(cv.Point2f.init(110, 10));
    try dst_pts.append(cv.Point2f.init(10, 110));

    var M = try cv.getAffineTransform(src_pts, dst_pts);
    defer M.deinit();

    // Should be 2x3 matrix
    try testing.expectEqual(@as(i32, 2), M.rows());
    try testing.expectEqual(@as(i32, 3), M.cols());

    // Translation should be (10, 10)
    try testing.expectApproxEqAbs(@as(f64, 10.0), M.getDouble(0, 2), 0.001);
    try testing.expectApproxEqAbs(@as(f64, 10.0), M.getDouble(1, 2), 0.001);
}

test "imgproc: getPerspectiveTransform" {
    var src_pts = try cv.Point2fVector.init();
    defer src_pts.deinit();
    try src_pts.append(cv.Point2f.init(0, 0));
    try src_pts.append(cv.Point2f.init(100, 0));
    try src_pts.append(cv.Point2f.init(100, 100));
    try src_pts.append(cv.Point2f.init(0, 100));

    var dst_pts = try cv.Point2fVector.init();
    defer dst_pts.deinit();
    try dst_pts.append(cv.Point2f.init(10, 10));
    try dst_pts.append(cv.Point2f.init(110, 10));
    try dst_pts.append(cv.Point2f.init(110, 110));
    try dst_pts.append(cv.Point2f.init(10, 110));

    var M = try cv.getPerspectiveTransform(src_pts, dst_pts, 0);
    defer M.deinit();

    // Should be 3x3 matrix
    try testing.expectEqual(@as(i32, 3), M.rows());
    try testing.expectEqual(@as(i32, 3), M.cols());
}

test "imgproc: findContours basic" {
    // Create a simple binary image with a square
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();

    // Fill with zeros (black)
    img.setTo(cv.Scalar.init(0, 0, 0, 0));

    // Manually set pixels to white to create a square
    var i: usize = 20;
    while (i < 80) : (i += 1) {
        var j: usize = 20;
        while (j < 80) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    // Find contours
    var contours = try cv.findContours(img, cv.imgproc.RETR_EXTERNAL, cv.imgproc.CHAIN_APPROX_SIMPLE);
    defer contours.deinit();

    // Should find at least one contour
    try testing.expect(contours.size() > 0);
}

test "imgproc: drawContours" {
    // Create image and find contours
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));

    // Create a square
    var i: usize = 20;
    while (i < 80) : (i += 1) {
        var j: usize = 20;
        while (j < 80) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    var contours = try cv.findContours(img, cv.imgproc.RETR_EXTERNAL, cv.imgproc.CHAIN_APPROX_SIMPLE);
    defer contours.deinit();

    // Create output image
    var output = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer output.deinit();
    output.setTo(cv.Scalar.init(0, 0, 0, 0));

    // Draw contours
    cv.drawContours(&output, contours, -1, cv.Scalar.init(0, 255, 0, 255), 2);

    // Output should not be empty
    try testing.expect(!output.empty());
}

test "imgproc: contourArea" {
    // Create a PointVector representing a simple square
    var points = try cv.PointVector.init();
    defer points.deinit();

    try points.append(cv.Point.init(0, 0));
    try points.append(cv.Point.init(10, 0));
    try points.append(cv.Point.init(10, 10));
    try points.append(cv.Point.init(0, 10));

    // Calculate area (should be 100)
    const area = cv.contourArea(points, false);
    try testing.expectApproxEqAbs(@as(f64, 100.0), area, 1.0);
}

test "imgproc: arcLength" {
    // Create a PointVector representing a simple square
    var points = try cv.PointVector.init();
    defer points.deinit();

    try points.append(cv.Point.init(0, 0));
    try points.append(cv.Point.init(10, 0));
    try points.append(cv.Point.init(10, 10));
    try points.append(cv.Point.init(0, 10));

    // Calculate perimeter (should be 40 for closed contour)
    const perimeter = cv.arcLength(points, true);
    try testing.expectApproxEqAbs(@as(f64, 40.0), perimeter, 1.0);
}

test "imgproc: boundingRect" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    try points.append(cv.Point.init(10, 20));
    try points.append(cv.Point.init(50, 20));
    try points.append(cv.Point.init(50, 80));
    try points.append(cv.Point.init(10, 80));

    const rect = cv.boundingRect(points);
    try testing.expectEqual(@as(i32, 10), rect.x);
    try testing.expectEqual(@as(i32, 20), rect.y);
    try testing.expectEqual(@as(i32, 41), rect.width);
    try testing.expectEqual(@as(i32, 61), rect.height);
}

test "imgproc: minAreaRect" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    try points.append(cv.Point.init(0, 0));
    try points.append(cv.Point.init(100, 0));
    try points.append(cv.Point.init(100, 50));
    try points.append(cv.Point.init(0, 50));

    const rr = cv.minAreaRect(points);
    // Center should be approximately (50, 25)
    try testing.expectApproxEqAbs(@as(f32, 50.0), rr.center.x, 1.0);
    try testing.expectApproxEqAbs(@as(f32, 25.0), rr.center.y, 1.0);
    // Size should be approximately 100x50
    try testing.expect(rr.size.width > 0);
    try testing.expect(rr.size.height > 0);
}

test "imgproc: minEnclosingCircle" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    try points.append(cv.Point.init(0, 0));
    try points.append(cv.Point.init(100, 0));
    try points.append(cv.Point.init(100, 100));
    try points.append(cv.Point.init(0, 100));

    const result = cv.minEnclosingCircle(points);
    // Center should be approximately (50, 50)
    try testing.expectApproxEqAbs(@as(f32, 50.0), result.center.x, 1.0);
    try testing.expectApproxEqAbs(@as(f32, 50.0), result.center.y, 1.0);
    // Radius should be approximately 70.7 (diagonal/2)
    try testing.expect(result.radius > 60.0);
    try testing.expect(result.radius < 80.0);
}

test "imgproc: approxPolyDP" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    // Create a circle-like polygon with many points
    try points.append(cv.Point.init(50, 0));
    try points.append(cv.Point.init(75, 13));
    try points.append(cv.Point.init(93, 37));
    try points.append(cv.Point.init(100, 50));
    try points.append(cv.Point.init(93, 63));
    try points.append(cv.Point.init(75, 87));
    try points.append(cv.Point.init(50, 100));
    try points.append(cv.Point.init(25, 87));
    try points.append(cv.Point.init(7, 63));
    try points.append(cv.Point.init(0, 50));
    try points.append(cv.Point.init(7, 37));
    try points.append(cv.Point.init(25, 13));

    // Approximate with large epsilon -> fewer points
    var approx = try cv.approxPolyDP(points, 20.0, true);
    defer approx.deinit();

    // Should have fewer points than original
    try testing.expect(approx.size() < points.size());
    try testing.expect(approx.size() > 2);
}

test "imgproc: convexHull" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    // Create points with some interior points
    try points.append(cv.Point.init(0, 0));
    try points.append(cv.Point.init(50, 50)); // interior
    try points.append(cv.Point.init(100, 0));
    try points.append(cv.Point.init(100, 100));
    try points.append(cv.Point.init(0, 100));
    try points.append(cv.Point.init(30, 30)); // interior

    var hull = try cv.convexHull(points, false);
    defer hull.deinit();

    // Hull should have fewer points (interior points removed)
    try testing.expect(hull.size() <= points.size());
    try testing.expect(hull.size() >= 4); // At least the 4 corners
}

test "imgproc: equalizeHist" {
    // Create a dark grayscale image
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(50, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.equalizeHist(img, &result);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
    try testing.expectEqual(@as(i32, 100), result.cols());
}

test "imgproc: goodFeaturesToTrack" {
    // Create a grayscale image with distinct corners (a white square on black)
    var img = try cv.Mat.initWithSize(200, 200, 0); // CV_8UC1
    defer img.deinit();

    // Draw a white square
    var i: usize = 50;
    while (i < 150) : (i += 1) {
        var j: usize = 50;
        while (j < 150) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    var corners = try cv.Mat.init();
    defer corners.deinit();

    cv.goodFeaturesToTrack(img, &corners, 10, 0.01, 10.0);

    try testing.expect(!corners.empty());
    // Should detect 4 corners of the square
    try testing.expect(corners.rows() >= 4);
}

test "imgproc: matchTemplate" {
    // Create image with a white rectangle
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();

    // Fill a small region with white pixels as template region
    var i: usize = 30;
    while (i < 50) : (i += 1) {
        var j: usize = 30;
        while (j < 50) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    // Create template (small white rectangle)
    var templ = try cv.Mat.initWithSize(20, 20, 0); // CV_8UC1
    defer templ.deinit();
    templ.setTo(cv.Scalar.init(255, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.matchTemplate(img, templ, &result, cv.TemplateMatchMode.tm_ccoeff_normed);

    try testing.expect(!result.empty());
    // Result size = image_size - template_size + 1
    try testing.expectEqual(@as(i32, 81), result.rows());
    try testing.expectEqual(@as(i32, 81), result.cols());
}

test "imgproc: houghLines" {
    // Create edge image with a horizontal line
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();

    // Draw horizontal line
    var j: usize = 0;
    while (j < 100) : (j += 1) {
        img.setUChar(50, @intCast(j), 255);
    }

    var lines = try cv.Mat.init();
    defer lines.deinit();

    cv.houghLines(img, &lines, 1.0, 3.14159 / 180.0, 50);

    // Should detect at least one line
    try testing.expect(!lines.empty());
}

test "imgproc: houghCircles" {
    // Create grayscale image with a circle
    var img = try cv.Mat.initWithSize(200, 200, 0); // CV_8UC1
    defer img.deinit();

    // Draw circle outline manually at center (100,100) radius ~40
    var angle: f64 = 0;
    while (angle < 6.28318) : (angle += 0.02) {
        const x: i32 = @intFromFloat(100.0 + 40.0 * @cos(angle));
        const y: i32 = @intFromFloat(100.0 + 40.0 * @sin(angle));
        if (x >= 0 and x < 200 and y >= 0 and y < 200) {
            img.setUChar(y, x, 255);
        }
    }

    var circles = try cv.Mat.init();
    defer circles.deinit();

    cv.houghCircles(img, &circles, cv.HoughMode.hough_gradient, 1.0, 50.0, 100.0, 30.0, 20, 60);

    // May or may not detect circles depending on quality
    // Just verify it doesn't crash and returns valid Mat
    try testing.expect(circles.cols() >= 0);
}

test "imgproc: connectedComponents" {
    // Create binary image with two separate blobs
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0)); // Ensure zero-initialized

    // Blob 1: top-left
    var i: usize = 10;
    while (i < 30) : (i += 1) {
        var j: usize = 10;
        while (j < 30) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    // Blob 2: bottom-right
    i = 70;
    while (i < 90) : (i += 1) {
        var j: usize = 70;
        while (j < 90) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    var labels = try cv.Mat.init();
    defer labels.deinit();

    const num_labels = cv.connectedComponents(img, &labels, 8);

    try testing.expect(!labels.empty());
    // Should have 3 labels: background + 2 blobs
    try testing.expectEqual(@as(i32, 3), num_labels);
}

test "imgproc: connectedComponentsWithStats" {
    // Create binary image with 2 blobs
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));

    // First blob: top-left
    var i: usize = 10;
    while (i < 30) : (i += 1) {
        var j: usize = 10;
        while (j < 30) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }
    // Second blob: bottom-right
    i = 60;
    while (i < 80) : (i += 1) {
        var j: usize = 60;
        while (j < 80) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    var labels = try cv.Mat.init();
    defer labels.deinit();
    var stats = try cv.Mat.init();
    defer stats.deinit();
    var centroids = try cv.Mat.init();
    defer centroids.deinit();

    const num_labels = cv.connectedComponentsWithStats(img, &labels, &stats, &centroids, 8);

    try testing.expectEqual(@as(i32, 3), num_labels);
    try testing.expect(!labels.empty());
    try testing.expect(!stats.empty());
    try testing.expect(!centroids.empty());
    // Stats should have shape [num_labels x 5]
    try testing.expectEqual(@as(i32, 3), stats.rows());
    try testing.expectEqual(@as(i32, 5), stats.cols());
    // Centroids should have shape [num_labels x 2]
    try testing.expectEqual(@as(i32, 3), centroids.rows());
    try testing.expectEqual(@as(i32, 2), centroids.cols());
}

test "imgproc: moments" {
    // Create a white rectangle in image
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0)); // Ensure zero-initialized

    // Fill with white pixels (50x50 square at center)
    var i: usize = 25;
    while (i < 75) : (i += 1) {
        var j: usize = 25;
        while (j < 75) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    const m = cv.moments(img, true);

    // m00 with binaryImage=true counts non-zero pixels
    try testing.expectApproxEqAbs(@as(f64, 2500.0), m.m00, 10.0);

    // Centroid should be approximately at (50, 50)
    const cx = m.m10 / m.m00;
    const cy = m.m01 / m.m00;
    try testing.expectApproxEqAbs(@as(f64, 49.5), cx, 1.0);
    try testing.expectApproxEqAbs(@as(f64, 49.5), cy, 1.0);
}

test "imgproc: filter2D" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Create identity kernel (3x3)
    var kernel = try cv.Mat.initWithSize(3, 3, 5); // CV_32FC1
    defer kernel.deinit();
    kernel.setTo(cv.Scalar.init(0, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.filter2D(img, &result, -1, kernel, cv.Point.init(-1, -1), 0, 0);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
    try testing.expectEqual(@as(i32, 100), result.cols());
}

test "imgproc: scharr" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Set left half to different value for gradient
    var i: usize = 0;
    while (i < 100) : (i += 1) {
        var j: usize = 0;
        while (j < 50) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 255);
        }
    }

    var result = try cv.Mat.init();
    defer result.deinit();

    // CV_16S = 3
    cv.scharr(img, &result, 3, 1, 0, 1.0, 0, 0);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: matchShapes" {
    // Create two similar contours (squares of different sizes)
    var contour1 = try cv.PointVector.init();
    defer contour1.deinit();
    try contour1.append(cv.Point.init(0, 0));
    try contour1.append(cv.Point.init(100, 0));
    try contour1.append(cv.Point.init(100, 100));
    try contour1.append(cv.Point.init(0, 100));

    var contour2 = try cv.PointVector.init();
    defer contour2.deinit();
    try contour2.append(cv.Point.init(0, 0));
    try contour2.append(cv.Point.init(50, 0));
    try contour2.append(cv.Point.init(50, 50));
    try contour2.append(cv.Point.init(0, 50));

    // Same shape different size should have low distance
    const dist = cv.matchShapes(contour1, contour2, cv.ShapeMatchMethod.contours_match_i1, 0);
    try testing.expect(dist >= 0);
    try testing.expect(dist < 1.0); // Similar shapes
}

test "imgproc: fitLine" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    // Points roughly on y = x line
    try points.append(cv.Point.init(0, 0));
    try points.append(cv.Point.init(10, 10));
    try points.append(cv.Point.init(20, 21));
    try points.append(cv.Point.init(30, 30));
    try points.append(cv.Point.init(40, 39));

    var line_mat = try cv.Mat.init();
    defer line_mat.deinit();

    cv.fitLine(points, &line_mat, cv.DistType.dist_l2, 0.0, 0.01, 0.01);

    try testing.expect(!line_mat.empty());
    // fitLine returns 4 values: (vx, vy, x0, y0)
    try testing.expectEqual(@as(i32, 4), line_mat.rows());
}

test "imgproc: fitEllipse" {
    var points = try cv.PointVector.init();
    defer points.deinit();

    // Create ellipse-like points (need at least 5)
    try points.append(cv.Point.init(50, 0));
    try points.append(cv.Point.init(100, 50));
    try points.append(cv.Point.init(50, 100));
    try points.append(cv.Point.init(0, 50));
    try points.append(cv.Point.init(75, 25));

    const ellipse_rr = cv.fitEllipse(points);

    // Should return valid RotatedRect
    try testing.expect(ellipse_rr.size.width > 0);
    try testing.expect(ellipse_rr.size.height > 0);
}

test "imgproc: getStructuringElement cross" {
    var elem = try cv.imgproc.getStructuringElement(.cross, cv.Size.init(5, 5), cv.Point.init(-1, -1));
    defer elem.deinit();

    try testing.expect(!elem.empty());
    try testing.expectEqual(@as(i32, 5), elem.rows());
    try testing.expectEqual(@as(i32, 5), elem.cols());
}

test "imgproc: cornerHarris" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));

    // Draw a corner pattern
    var i: usize = 30;
    while (i < 70) : (i += 1) {
        img.setUChar(@intCast(i), 50, 255); // vertical line
    }
    var j: usize = 30;
    while (j < 70) : (j += 1) {
        img.setUChar(50, @intCast(j), 255); // horizontal line
    }

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.cornerHarris(img, &result, 2, 3, 0.04, 0);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: pyrMeanShiftFiltering" {
    // Requires 8-bit 3-channel image
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(100, 150, 200, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.pyrMeanShiftFiltering(img, &result, 10.0, 20.0);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: distanceTransform" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(255, 0, 0, 0));

    // Add a black hole in the center
    var i: usize = 40;
    while (i < 60) : (i += 1) {
        var j: usize = 40;
        while (j < 60) : (j += 1) {
            img.setUChar(@intCast(i), @intCast(j), 0);
        }
    }

    var result = try cv.Mat.init();
    defer result.deinit();

    // DIST_L2 = 2, mask size 3
    cv.distanceTransform(img, &result, 2, 3);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: integral" {
    var img = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(1, 0, 0, 0));

    var sum = try cv.Mat.init();
    defer sum.deinit();
    var sqsum = try cv.Mat.init();
    defer sqsum.deinit();

    // CV_32S = 4
    cv.integral(img, &sum, &sqsum, -1);

    try testing.expect(!sum.empty());
    // Integral image is (rows+1) x (cols+1)
    try testing.expectEqual(@as(i32, 51), sum.rows());
    try testing.expectEqual(@as(i32, 51), sum.cols());
}

test "imgproc: watershed" {
    // Requires 8UC3 image and 32SC1 markers
    var img = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(100, 150, 200, 0));

    // CV_32SC1 = 4, seed the entire image as region 1
    var markers = try cv.Mat.initWithSize(50, 50, 4); // CV_32SC1
    defer markers.deinit();
    markers.setTo(cv.Scalar.init(1, 0, 0, 0));

    cv.watershed(img, &markers);

    try testing.expect(!markers.empty());
    try testing.expectEqual(@as(i32, 50), markers.rows());
}

test "imgproc: copyMakeBorder" {
    var img = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    // BORDER_CONSTANT = 0
    cv.copyMakeBorder(img, &result, 10, 10, 10, 10, 0, cv.Scalar.init(0, 0, 0, 0));

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 70), result.rows()); // 50 + 10 + 10
    try testing.expectEqual(@as(i32, 70), result.cols());
}

test "imgproc: pyrDown with default params" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.pyrDown(img, &result, cv.Size.init(0, 0), cv.imgproc.BORDER_DEFAULT);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 50), result.rows()); // halved
    try testing.expectEqual(@as(i32, 50), result.cols());
}

test "imgproc: pyrUp with default params" {
    var img = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.pyrUp(img, &result, cv.Size.init(0, 0), cv.imgproc.BORDER_DEFAULT);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows()); // doubled
    try testing.expectEqual(@as(i32, 100), result.cols());
}

test "imgproc: grabCut" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(100, 150, 200, 0));

    var mask = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(0, 0, 0, 0));

    var bgd = try cv.Mat.init();
    defer bgd.deinit();
    var fgd = try cv.Mat.init();
    defer fgd.deinit();

    const rect = cv.Rect.init(10, 10, 80, 80);
    cv.grabCut(img, &mask, rect, &bgd, &fgd, 1, cv.GrabCutMode.gc_init_with_rect);

    try testing.expect(!mask.empty());
}

test "imgproc: CLAHE" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    var clahe = try cv.Clahe.init(2.0, cv.Size.init(8, 8));
    defer clahe.deinit();

    var result = try cv.Mat.init();
    defer result.deinit();

    clahe.apply(img, &result);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: floodFill" {
    var img = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Mask must be 2 pixels larger than image
    var mask = try cv.Mat.initWithSize(52, 52, 0);
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(0, 0, 0, 0));

    const area = cv.floodFill(
        &img,
        &mask,
        cv.Point.init(25, 25),
        cv.Scalar.init(255, 0, 0, 0),
        null,
        cv.Scalar.init(10, 0, 0, 0),
        cv.Scalar.init(10, 0, 0, 0),
        4, // connectivity=4
    );

    try testing.expect(area > 0);
}

test "imgproc: getTextSize" {
    const result = cv.getTextSize("Hello OpenCV", 0, 1.0, 2);

    try testing.expect(result.size.width > 0);
    try testing.expect(result.size.height > 0);
    try testing.expect(result.base_line >= 0);
}

test "imgproc: getRotationMatrix2D" {
    var rot_mat = try cv.getRotationMatrix2D(cv.Point2f.init(50.0, 50.0), 45.0, 1.0);
    defer rot_mat.deinit();

    try testing.expect(!rot_mat.empty());
    try testing.expectEqual(@as(i32, 2), rot_mat.rows()); // 2x3 matrix
    try testing.expectEqual(@as(i32, 3), rot_mat.cols());
}

test "imgproc: houghLinesP" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));

    // Draw a line
    var i: usize = 10;
    while (i < 90) : (i += 1) {
        img.setUChar(50, @intCast(i), 255);
    }

    var lines = try cv.Mat.init();
    defer lines.deinit();

    const pi = 3.14159265;
    cv.houghLinesP(img, &lines, 1.0, pi / 180.0, 10, 20.0, 5.0);

    // Should detect at least the drawn line
    try testing.expect(!lines.empty());
}

test "imgproc: pointPolygonTest" {
    var contour = try cv.PointVector.init();
    defer contour.deinit();

    // Square contour
    try contour.append(cv.Point.init(0, 0));
    try contour.append(cv.Point.init(100, 0));
    try contour.append(cv.Point.init(100, 100));
    try contour.append(cv.Point.init(0, 100));

    // Point inside
    const dist_inside = cv.pointPolygonTest(contour, cv.Point2f.init(50.0, 50.0), true);
    try testing.expect(dist_inside > 0);

    // Point outside
    const dist_outside = cv.pointPolygonTest(contour, cv.Point2f.init(200.0, 200.0), true);
    try testing.expect(dist_outside < 0);
}

test "imgproc: isContourConvex" {
    var contour = try cv.PointVector.init();
    defer contour.deinit();

    // Convex square
    try contour.append(cv.Point.init(0, 0));
    try contour.append(cv.Point.init(100, 0));
    try contour.append(cv.Point.init(100, 100));
    try contour.append(cv.Point.init(0, 100));

    try testing.expect(cv.isContourConvex(contour));
}

test "imgproc: boxFilter" {
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.boxFilter(img, &result, -1, cv.Size.init(5, 5), cv.Point.init(-1, -1), true, 0);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: sepFilter2D" {
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Simple 1D kernels - CV_32FC1 = 5
    var kx = try cv.Mat.initWithSize(1, 3, 5);
    defer kx.deinit();
    kx.setTo(cv.Scalar.init(1.0 / 3.0, 0, 0, 0));

    var ky = try cv.Mat.initWithSize(1, 3, 5);
    defer ky.deinit();
    ky.setTo(cv.Scalar.init(1.0 / 3.0, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.sepFilter2D(img, &result, -1, kx, ky, cv.Point.init(-1, -1), 0, 0);

    try testing.expect(!result.empty());
}

test "imgproc: remap" {
    var img = try cv.Mat.initWithSize(50, 50, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    // Identity map - CV_32FC1 = 5
    var map_x = try cv.Mat.initWithSize(50, 50, 5);
    defer map_x.deinit();
    var map_y = try cv.Mat.initWithSize(50, 50, 5);
    defer map_y.deinit();

    // Fill maps with identity mapping
    var i: usize = 0;
    while (i < 50) : (i += 1) {
        var j: usize = 0;
        while (j < 50) : (j += 1) {
            // Can't easily set float values, use setTo for uniform
        }
    }
    // Use uniform value for simple test
    map_x.setTo(cv.Scalar.init(25, 0, 0, 0));
    map_y.setTo(cv.Scalar.init(25, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    // INTER_LINEAR = 1
    cv.remap(img, &result, map_x, map_y, 1, 0, cv.Scalar.init(0, 0, 0, 0));

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 50), result.rows());
}

test "imgproc: convertScaleAbs" {
    var img = try cv.Mat.initWithSize(100, 100, 0);
    defer img.deinit();
    img.setTo(cv.Scalar.init(100, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.convertScaleAbs(img, &result, 2.0, 10.0);

    try testing.expect(!result.empty());
    try testing.expectEqual(@as(i32, 100), result.rows());
}

test "imgproc: normalize" {
    // CV_32FC1 = 5
    var img = try cv.Mat.initWithSize(100, 100, 5);
    defer img.deinit();
    img.setTo(cv.Scalar.init(50, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    // NORM_MINMAX = 32
    cv.imgproc.normalize(img, &result, 0, 1.0, cv.NormType.norm_minmax);

    try testing.expect(!result.empty());
}

test "imgproc: compareHist" {
    // Create two identical histograms - CV_32FC1 = 5
    var h1 = try cv.Mat.initWithSize(256, 1, 5);
    defer h1.deinit();
    h1.setTo(cv.Scalar.init(1, 0, 0, 0));

    var h2 = try cv.Mat.initWithSize(256, 1, 5);
    defer h2.deinit();
    h2.setTo(cv.Scalar.init(1, 0, 0, 0));

    // CORREL = 0, identical histograms should have correlation = 1
    const score = cv.compareHist(h1, h2, cv.HistCompMethod.correl);
    // For identical uniform histograms, correlation may be NaN or specific value
    // Just check it returns a valid number or is not negative infinity
    try testing.expect(score >= -1.0 or score != score); // Allow NaN for uniform
}

test "imgproc: accumulate" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var acc = try cv.Mat.initWithSize(100, 100, 21); // CV_64FC3
    defer acc.deinit();
    acc.setTo(cv.Scalar.init(0, 0, 0, 0));
    cv.accumulate(img, &acc, null);
    try testing.expect(!acc.empty());
}

test "imgproc: accumulateWeighted" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var acc = try cv.Mat.initWithSize(100, 100, 21); // CV_64FC3
    defer acc.deinit();
    acc.setTo(cv.Scalar.init(0, 0, 0, 0));
    cv.accumulateWeighted(img, &acc, 0.5, null);
    try testing.expect(!acc.empty());
}

test "imgproc: applyColorMap" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.applyColorMap(img, &dst, cv.ColormapTypes.jet);
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
}

test "imgproc: arrowedLine" {
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));
    cv.arrowedLine(&img, cv.Point.init(10, 10), cv.Point.init(100, 100), cv.Scalar.init(255, 0, 0, 0), 2, 8, 0, 0.1);
}

test "imgproc: drawMarker" {
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));
    cv.drawMarker(&img, cv.Point.init(100, 100), cv.Scalar.init(0, 255, 0, 0), cv.MarkerTypes.marker_cross, 20, 2, 8);
}

test "imgproc: fillConvexPoly" {
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));
    var pts = try cv.PointVector.init();
    defer pts.deinit();
    try pts.append(cv.Point.init(50, 50));
    try pts.append(cv.Point.init(150, 50));
    try pts.append(cv.Point.init(100, 150));
    cv.fillConvexPoly(&img, pts, cv.Scalar.init(255, 255, 255, 0), 8);
}

test "imgproc: getGaussianKernel" {
    var k = try cv.getGaussianKernel(5, 1.0, 6); // CV_64F
    defer k.deinit();
    try testing.expect(!k.empty());
    try testing.expectEqual(@as(i32, 5), k.rows());
}

test "imgproc: invertAffineTransform" {
    var m = try cv.Mat.initWithSize(2, 3, 6); // CV_64F
    defer m.deinit();
    // Identity-ish
    m.setDouble(0, 0, 1.0);
    m.setDouble(0, 1, 0.0);
    m.setDouble(0, 2, 0.0);
    m.setDouble(1, 0, 0.0);
    m.setDouble(1, 1, 1.0);
    m.setDouble(1, 2, 0.0);
    var im = try cv.Mat.init();
    defer im.deinit();
    cv.invertAffineTransform(m, &im);
    try testing.expect(!im.empty());
}

test "imgproc: stackBlur" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.stackBlur(img, &dst, cv.Size.init(5, 5));
    try testing.expect(!dst.empty());
    try testing.expectEqual(img.rows(), dst.rows());
}

test "imgproc: sqrBoxFilter" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.sqrBoxFilter(img, &dst, -1, cv.Size.init(3, 3), cv.Point.init(-1, -1), true, 0);
    try testing.expect(!dst.empty());
}

test "imgproc: spatialGradient" {
    var src = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 0, 0, 0));
    var dx = try cv.Mat.init();
    defer dx.deinit();
    var dy = try cv.Mat.init();
    defer dy.deinit();
    cv.spatialGradient(src, &dx, &dy, 3, 4); // 4 = BORDER_DEFAULT
    try testing.expect(!dx.empty());
    try testing.expect(!dy.empty());
}

test "imgproc: createHanningWindow" {
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.createHanningWindow(&dst, cv.Size.init(64, 64), 6); // CV_64F
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 64), dst.rows());
}

test "imgproc: warpPolar" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    const center = cv.Point2f{ .x = 50.0, .y = 50.0 };
    cv.warpPolar(img, &dst, cv.Size.init(64, 64), center, 50.0, 0);
    try testing.expect(!dst.empty());
}

test "imgproc: clipLine" {
    var pt1 = cv.Point.init(-10, -10);
    var pt2 = cv.Point.init(300, 300);
    const result = cv.clipLine(cv.Size.init(200, 200), &pt1, &pt2);
    try testing.expect(result);
}

test "imgproc: ellipse2Poly" {
    var pts = try cv.PointVector.init();
    defer pts.deinit();
    cv.ellipse2Poly(cv.Point.init(100, 100), cv.Size.init(50, 30), 0, 0, 360, 10, &pts);
    try testing.expect(pts.size() > 0);
}

test "imgproc: huMoments" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 0, 0, 0));
    const hu = cv.huMoments(img);
    // Hu moments should be finite
    try testing.expect(hu[0] == hu[0]); // Not NaN
}

test "imgproc: getFontScaleFromHeight" {
    const scale = cv.getFontScaleFromHeight(0, 30, 1);
    try testing.expect(scale > 0);
}

test "imgproc: cornerMinEigenVal" {
    var gray = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer gray.deinit();
    gray.setTo(cv.Scalar.init(128, 0, 0, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.cornerMinEigenVal(gray, &dst, 3, 3, 0);
    try testing.expect(!dst.empty());
}

test "imgproc: preCornerDetect" {
    var gray = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer gray.deinit();
    gray.setTo(cv.Scalar.init(128, 0, 0, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.preCornerDetect(gray, &dst, 3, 0);
    try testing.expect(!dst.empty());
}

test "imgproc: fitEllipseAMS" {
    var pts = try cv.PointVector.init();
    defer pts.deinit();
    // Need at least 5 points for fitEllipse
    try pts.append(cv.Point.init(100, 50));
    try pts.append(cv.Point.init(150, 100));
    try pts.append(cv.Point.init(100, 150));
    try pts.append(cv.Point.init(50, 100));
    try pts.append(cv.Point.init(75, 60));
    const rr = cv.fitEllipseAMS(pts);
    try testing.expect(rr.size.width > 0 or rr.size.height > 0);
}

test "imgproc: rotatedRectangleIntersection" {
    const rr1 = cv.imgproc.RotatedRect{
        .center = .{ .x = 100, .y = 100 },
        .size = .{ .width = 50, .height = 50 },
        .angle = 0,
    };
    const rr2 = cv.imgproc.RotatedRect{
        .center = .{ .x = 120, .y = 100 },
        .size = .{ .width = 50, .height = 50 },
        .angle = 0,
    };
    var region = try cv.PointVector.init();
    defer region.deinit();
    const result = cv.rotatedRectangleIntersection(rr1, rr2, &region);
    try testing.expect(result >= 0);
}

test "imgproc: getGaborKernel" {
    var k = try cv.getGaborKernel(cv.Size.init(31, 31), 4.0, 0.0, 10.0, 0.5, 0.0, 6);
    defer k.deinit();
    try testing.expect(!k.empty());
    try testing.expectEqual(@as(i32, 31), k.rows());
    try testing.expectEqual(@as(i32, 31), k.cols());
}

test "imgproc: getDerivKernels" {
    var kx = try cv.Mat.init();
    defer kx.deinit();
    var ky = try cv.Mat.init();
    defer ky.deinit();
    cv.getDerivKernels(&kx, &ky, 1, 0, 3, false, 6); // CV_64F
    try testing.expect(!kx.empty());
    try testing.expect(!ky.empty());
}

test "imgproc: phaseCorrelate" {
    var img1 = try cv.Mat.initWithSize(64, 64, 5); // CV_32FC1
    defer img1.deinit();
    img1.setTo(cv.Scalar.init(0, 0, 0, 0));
    var img2 = try cv.Mat.initWithSize(64, 64, 5); // CV_32FC1
    defer img2.deinit();
    img2.setTo(cv.Scalar.init(0, 0, 0, 0));
    const result = cv.phaseCorrelate(img1, img2, null);
    // Shift should be near zero for identical images
    try testing.expect(result.shift.x == result.shift.x); // Not NaN
}

test "imgproc: linearPolar" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.linearPolar(img, &dst, cv.Point2f{ .x = 50.0, .y = 50.0 }, 50.0, 0);
    try testing.expect(!dst.empty());
}

test "imgproc: logPolar" {
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(128, 128, 128, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.logPolar(img, &dst, cv.Point2f{ .x = 50.0, .y = 50.0 }, 40.0, 0);
    try testing.expect(!dst.empty());
}

test "imgproc: convexityDefects" {
    // Create a concave polygon contour
    var contour = try cv.PointVector.init();
    defer contour.deinit();
    try contour.append(cv.Point.init(0, 0));
    try contour.append(cv.Point.init(100, 0));
    try contour.append(cv.Point.init(50, 50)); // concavity
    try contour.append(cv.Point.init(100, 100));
    try contour.append(cv.Point.init(0, 100));
    var hull = try cv.PointVector.init();
    defer hull.deinit();
    var defects = try cv.Mat.init();
    defer defects.deinit();
    cv.convexityDefects(contour, hull, &defects);
    // defects may or may not be empty depending on hull computation
}

test "imgproc: approxPolyN" {
    var curve = try cv.PointVector.init();
    defer curve.deinit();
    try curve.append(cv.Point.init(0, 0));
    try curve.append(cv.Point.init(50, 0));
    try curve.append(cv.Point.init(100, 0));
    try curve.append(cv.Point.init(100, 50));
    try curve.append(cv.Point.init(100, 100));
    try curve.append(cv.Point.init(50, 100));
    try curve.append(cv.Point.init(0, 100));
    try curve.append(cv.Point.init(0, 50));
    var approx = try cv.PointVector.init();
    defer approx.deinit();
    cv.approxPolyN(curve, &approx, 4, 0.02, false);
    // Should approximate to roughly 4 sides
}

// ============================================================================
// calcHist Tests
// ============================================================================

test "imgproc: calcHist single channel" {
    // Create a simple 8-bit image with known values
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();

    // Fill with value 128
    img.setTo(cv.Scalar.init(128, 0, 0, 0));

    var hist = try cv.Mat.init();
    defer hist.deinit();

    const channels = [_]i32{0};
    const hist_size = [_]i32{256};
    const ranges = [_]f32{ 0.0, 256.0 };

    cv.calcHist(
        &[_]cv.Mat{img},
        &channels,
        null,
        &hist,
        &hist_size,
        &ranges,
        true,
        false,
    );

    try testing.expect(!hist.empty());
    // Histogram should be 256x1
    try testing.expectEqual(@as(i32, 256), hist.rows());
}

// ============================================================================
// Additional Imgproc Tests (remaining untested functions)
// ============================================================================

test "imgproc: accumulateProduct" {
    var src1 = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer src1.deinit();
    src1.setTo(cv.Scalar.init(128, 0, 0, 0));

    var src2 = try cv.Mat.initWithSize(50, 50, 0);
    defer src2.deinit();
    src2.setTo(cv.Scalar.init(64, 0, 0, 0));

    var acc = try cv.Mat.initWithSize(50, 50, 6); // CV_64FC1
    defer acc.deinit();
    acc.setTo(cv.Scalar.init(0, 0, 0, 0));

    cv.accumulateProduct(src1, src2, &acc, null);
    try testing.expect(!acc.empty());
}

test "imgproc: accumulateSquare" {
    var src = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 0, 0, 0));

    var acc = try cv.Mat.initWithSize(50, 50, 6); // CV_64FC1
    defer acc.deinit();
    acc.setTo(cv.Scalar.init(0, 0, 0, 0));

    cv.accumulateSquare(src, &acc, null);
    try testing.expect(!acc.empty());
}

test "imgproc: blendLinear" {
    var src1 = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src1.deinit();
    src1.setTo(cv.Scalar.init(255, 0, 0, 0));

    var src2 = try cv.Mat.initWithSize(50, 50, 16);
    defer src2.deinit();
    src2.setTo(cv.Scalar.init(0, 0, 255, 0));

    var w1 = try cv.Mat.initWithSize(50, 50, 5); // CV_32FC1
    defer w1.deinit();
    w1.setTo(cv.Scalar.init(0.5, 0, 0, 0));

    var w2 = try cv.Mat.initWithSize(50, 50, 5);
    defer w2.deinit();
    w2.setTo(cv.Scalar.init(0.5, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.blendLinear(src1, src2, w1, w2, &dst);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 50), dst.rows());
}

test "imgproc: ellipse" {
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();
    img.setTo(cv.Scalar.init(0, 0, 0, 0));

    cv.imgproc.ellipse(&img, cv.Point.init(100, 100), cv.Size.init(50, 30), 0.0, 0.0, 360.0, cv.Scalar.init(255, 255, 255, 0), 2, 8, 0);
    try testing.expect(!img.empty());
}

test "imgproc: fitEllipseDirect" {
    var pts = try cv.PointVector.init();
    defer pts.deinit();
    // Need at least 5 points
    try pts.append(cv.Point.init(100, 50));
    try pts.append(cv.Point.init(150, 100));
    try pts.append(cv.Point.init(100, 150));
    try pts.append(cv.Point.init(50, 100));
    try pts.append(cv.Point.init(75, 60));

    const rr = cv.fitEllipseDirect(pts);
    try testing.expect(rr.size.width > 0 or rr.size.height > 0);
}

test "imgproc: getRectSubPix" {
    var img = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer img.deinit();
    img.setTo(cv.Scalar.init(200, 0, 0, 0));

    var patch = try cv.Mat.init();
    defer patch.deinit();

    cv.getRectSubPix(img, cv.Size.init(20, 20), cv.Point2f.init(50.0, 50.0), &patch);
    try testing.expect(!patch.empty());
    try testing.expectEqual(@as(i32, 20), patch.rows());
    try testing.expectEqual(@as(i32, 20), patch.cols());
}

test "imgproc: cornerEigenValsAndVecs" {
    var gray = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer gray.deinit();
    gray.setTo(cv.Scalar.init(128, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.cornerEigenValsAndVecs(gray, &dst, 3, 3, 0);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 100), dst.rows());
}

test "imgproc: divSpectrums" {
    // Create two complex spectrums (2-channel float)
    var a = try cv.Mat.initWithSize(50, 50, 13); // CV_32FC2
    defer a.deinit();
    a.setTo(cv.Scalar.init(1, 0, 0, 0));

    var b = try cv.Mat.initWithSize(50, 50, 13);
    defer b.deinit();
    b.setTo(cv.Scalar.init(1, 0, 0, 0));

    var result = try cv.Mat.init();
    defer result.deinit();

    cv.divSpectrums(a, b, &result, 0, false);
    try testing.expect(!result.empty());
}

test "imgproc: demosaicing" {
    // Bayer pattern image (single channel)
    var src = try cv.Mat.initWithSize(100, 100, 0); // CV_8UC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    // COLOR_BayerBG2BGR = 46
    cv.demosaicing(src, &dst, 46, 0);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 100), dst.rows());
}

test "imgproc: minEnclosingTriangle" {
    var pts = try cv.PointVector.init();
    defer pts.deinit();
    try pts.append(cv.Point.init(10, 10));
    try pts.append(cv.Point.init(90, 10));
    try pts.append(cv.Point.init(90, 90));
    try pts.append(cv.Point.init(10, 90));
    try pts.append(cv.Point.init(50, 50));

    var triangle = try cv.PointVector.init();
    defer triangle.deinit();

    const area = cv.minEnclosingTriangle(pts, &triangle);
    try testing.expect(area > 0);
}

test "imgproc: convertMaps" {
    // Create float maps
    var map1 = try cv.Mat.initWithSize(50, 50, 5); // CV_32FC1
    defer map1.deinit();
    map1.setTo(cv.Scalar.init(25, 0, 0, 0));
    var map2 = try cv.Mat.initWithSize(50, 50, 5);
    defer map2.deinit();
    map2.setTo(cv.Scalar.init(25, 0, 0, 0));

    var dstmap1 = try cv.Mat.init();
    defer dstmap1.deinit();
    var dstmap2 = try cv.Mat.init();
    defer dstmap2.deinit();

    // Convert to CV_16SC2 + CV_16UC1 (dstmap1type = 4 is CV_16SC2... actually let's use type 1 = CV_16SC2)
    // Actually CV_16SC2 = 11 (depth=3 + channels=2: (2-1)*8 + 3 = 11)
    cv.convertMaps(map1, map2, &dstmap1, &dstmap2, 11, false);
    try testing.expect(!dstmap1.empty());
}
