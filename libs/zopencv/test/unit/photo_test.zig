const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

test "photo: InpaintFlag enum" {
    const ns = cv.photo.InpaintFlag.ns;
    const telea = cv.photo.InpaintFlag.telea;

    try testing.expectEqual(@as(i32, 0), @intFromEnum(ns));
    try testing.expectEqual(@as(i32, 1), @intFromEnum(telea));
}

test "photo: EdgePreservingFilterFlag enum" {
    const recurs = cv.photo.EdgePreservingFilterFlag.recurs_filter;
    const normconv = cv.photo.EdgePreservingFilterFlag.normconv_filter;

    try testing.expectEqual(@as(i32, 1), @intFromEnum(recurs));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(normconv));
}

test "photo: SeamlessCloningFlag enum" {
    const normal = cv.photo.SeamlessCloningFlag.normal_clone;
    const mixed = cv.photo.SeamlessCloningFlag.mixed_clone;
    const mono = cv.photo.SeamlessCloningFlag.monochrome_transfer;

    try testing.expectEqual(@as(i32, 1), @intFromEnum(normal));
    try testing.expectEqual(@as(i32, 2), @intFromEnum(mixed));
    try testing.expectEqual(@as(i32, 3), @intFromEnum(mono));
}

// ============================================================================
// HDR / Tonemap Pipeline Tests
// ============================================================================

test "photo: MergeMertens create and destroy" {
    const mm = cv.MergeMertens.init();
    defer mm.deinit();
    try testing.expect(mm.ptr != null);
}

test "photo: MergeMertens process" {
    const mm = cv.MergeMertens.initWithParams(1.0, 1.0, 1.0);
    defer mm.deinit();

    // Create test images (simulate exposure brackets)
    var img1 = try cv.Mat.initWithSize(10, 10, 16); // CV_8UC3
    defer img1.deinit();
    img1.setTo(cv.Scalar.init(50, 50, 50, 0));

    var img2 = try cv.Mat.initWithSize(10, 10, 16);
    defer img2.deinit();
    img2.setTo(cv.Scalar.init(128, 128, 128, 0));

    var img3 = try cv.Mat.initWithSize(10, 10, 16);
    defer img3.deinit();
    img3.setTo(cv.Scalar.init(200, 200, 200, 0));

    const imgs = [_]cv.Mat{ img1, img2, img3 };
    var dst = try cv.Mat.init();
    defer dst.deinit();

    mm.process(&imgs, &dst);
    try testing.expect(!dst.empty());
}

test "photo: Tonemap create and destroy" {
    const tm = cv.Tonemap.init(2.2);
    defer tm.deinit();
    try testing.expect(tm.ptr != null);
}

test "photo: AlignMTB, CalibrateDebevec, MergeDebevec create/destroy" {
    const align_mtb = cv.AlignMTB.init(6, 4, false);
    defer align_mtb.deinit();
    try testing.expect(align_mtb.ptr != null);

    const cal = cv.CalibrateDebevec.init(70, 10.0, false);
    defer cal.deinit();
    try testing.expect(cal.ptr != null);

    const md = cv.MergeDebevec.init();
    defer md.deinit();
    try testing.expect(md.ptr != null);
}

test "photo: TonemapDrago create and destroy" {
    const td = cv.TonemapDrago.init(1.0, 1.0, 0.85);
    defer td.deinit();
    try testing.expect(td.ptr != null);
}

test "photo: TonemapReinhard create and destroy" {
    const tr = cv.TonemapReinhard.init(1.0, 0.0, 0.0, 0.0);
    defer tr.deinit();
    try testing.expect(tr.ptr != null);
}

test "photo: TonemapMantiuk create and destroy" {
    const tm = cv.TonemapMantiuk.init(1.0, 0.7, 1.0);
    defer tm.deinit();
    try testing.expect(tm.ptr != null);
}

// ============================================================================
// Image Processing Function Tests
// ============================================================================

test "photo: fastNlMeansDenoising" {
    var src = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.fastNlMeansDenoising(src, &dst, 3.0, 7, 21);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 50), dst.rows());
    try testing.expectEqual(@as(i32, 50), dst.cols());
}

test "photo: fastNlMeansDenoisingColored" {
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.fastNlMeansDenoisingColored(src, &dst, 3.0, 10.0, 7, 21);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 3), dst.channels());
}

test "photo: detailEnhance" {
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.detailEnhance(src, &dst, 10.0, 0.15);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 50), dst.rows());
}

test "photo: edgePreservingFilter" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.edgePreservingFilter(src, &dst, .recurs_filter, 60.0, 0.4);
    try testing.expect(!dst.empty());
}

test "photo: stylization" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.stylization(src, &dst, 60.0, 0.45);
    try testing.expect(!dst.empty());
}

test "photo: inpaint" {
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 128, 128, 0));

    // Create a small mask marking damaged region
    var mask = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(0, 0, 0, 0));
    // Mark center as damaged
    var r: i32 = 20;
    while (r < 30) : (r += 1) {
        var col: i32 = 20;
        while (col < 30) : (col += 1) {
            mask.setUChar(r, col, 255);
        }
    }

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.inpaint(src, mask, &dst, 3.0, .telea);
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 50), dst.rows());
}

test "photo: decolorization" {
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 150, 200, 0));

    var grayscale = try cv.Mat.init();
    defer grayscale.deinit();
    var color_boost = try cv.Mat.init();
    defer color_boost.deinit();

    cv.photo.decolorization(src, &grayscale, &color_boost);
    try testing.expect(!grayscale.empty());
    try testing.expect(!color_boost.empty());
    try testing.expectEqual(@as(i32, 1), grayscale.channels());
}

test "photo: pencilSketch" {
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var dst1 = try cv.Mat.init(); // grayscale pencil sketch
    defer dst1.deinit();
    var dst2 = try cv.Mat.init(); // color pencil sketch
    defer dst2.deinit();

    cv.photo.pencilSketch(src, &dst1, &dst2, 60.0, 0.07, 0.02);
    try testing.expect(!dst1.empty());
    try testing.expect(!dst2.empty());
    try testing.expectEqual(@as(i32, 1), dst1.channels()); // grayscale
    try testing.expectEqual(@as(i32, 3), dst2.channels()); // color
}

test "photo: seamlessClone" {
    // Create source image (object to clone)
    var src = try cv.Mat.initWithSize(50, 50, 16); // CV_8UC3
    defer src.deinit();
    src.setTo(cv.Scalar.init(200, 100, 50, 0));

    // Create destination image (background)
    var dst = try cv.Mat.initWithSize(100, 100, 16);
    defer dst.deinit();
    dst.setTo(cv.Scalar.init(50, 100, 200, 0));

    // Create mask (all white = use entire source)
    var mask = try cv.Mat.initWithSize(50, 50, 0); // CV_8UC1
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(255, 0, 0, 0));

    var blend = try cv.Mat.init();
    defer blend.deinit();

    const center = cv.Point.init(50, 50);
    cv.photo.seamlessClone(src, dst, mask, center, &blend, .normal_clone);
    try testing.expect(!blend.empty());
    try testing.expectEqual(@as(i32, 100), blend.rows());
    try testing.expectEqual(@as(i32, 100), blend.cols());
}

test "photo: colorChange" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var mask = try cv.Mat.initWithSize(50, 50, 0);
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(255, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.colorChange(src, mask, &dst, 1.5, 0.5, 0.5);
    try testing.expect(!dst.empty());
}

test "photo: illuminationChange" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var mask = try cv.Mat.initWithSize(50, 50, 0);
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(255, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.illuminationChange(src, mask, &dst, 0.2, 0.4);
    try testing.expect(!dst.empty());
}

test "photo: textureFlattening" {
    var src = try cv.Mat.initWithSize(50, 50, 16);
    defer src.deinit();
    src.setTo(cv.Scalar.init(100, 128, 150, 0));

    var mask = try cv.Mat.initWithSize(50, 50, 0);
    defer mask.deinit();
    mask.setTo(cv.Scalar.init(255, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.photo.textureFlattening(src, mask, &dst, 30.0, 45.0, 3);
    try testing.expect(!dst.empty());
}
