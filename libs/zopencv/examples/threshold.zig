const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Threshold Comparison Example ===\n", .{});
    std.debug.print("Demonstrates binary, Otsu, and adaptive thresholding\n\n", .{});

    const image_path = "testdata/images/lena.jpg";
    var img = cv.imgcodecs.imread(image_path, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{image_path});
        return;
    };
    defer img.deinit();
    std.debug.print("✅ Loaded: {s}\n", .{image_path});

    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_original_gray.jpg", gray);

    // Binary Threshold
    var binary = try cv.Mat.init();
    defer binary.deinit();
    _ = cv.imgproc.threshold(gray, &binary, 127, 255, .binary);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_binary.jpg", binary);
    std.debug.print("💾 Binary (127) → examples/tmp/thresh_binary.jpg\n", .{});

    // Binary Inverted
    var binary_inv = try cv.Mat.init();
    defer binary_inv.deinit();
    _ = cv.imgproc.threshold(gray, &binary_inv, 127, 255, .binary_inv);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_binary_inv.jpg", binary_inv);
    std.debug.print("💾 Binary Inv → examples/tmp/thresh_binary_inv.jpg\n", .{});

    // Truncate
    var trunc_out = try cv.Mat.init();
    defer trunc_out.deinit();
    _ = cv.imgproc.threshold(gray, &trunc_out, 127, 255, .trunc);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_trunc.jpg", trunc_out);
    std.debug.print("💾 Truncate → examples/tmp/thresh_trunc.jpg\n", .{});

    // Otsu's Threshold
    var otsu = try cv.Mat.init();
    defer otsu.deinit();
    const otsu_val = cv.imgproc.threshold(gray, &otsu, 0, 255, .otsu);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_otsu.jpg", otsu);
    std.debug.print("💾 Otsu (auto={d:.0}) → examples/tmp/thresh_otsu.jpg\n", .{otsu_val});

    // Adaptive Mean Threshold
    var adaptive_mean = try cv.Mat.init();
    defer adaptive_mean.deinit();
    cv.imgproc.adaptiveThreshold(gray, &adaptive_mean, 255, 0, .binary, 11, 2);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_adaptive_mean.jpg", adaptive_mean);
    std.debug.print("💾 Adaptive Mean → examples/tmp/thresh_adaptive_mean.jpg\n", .{});

    // Adaptive Gaussian Threshold
    var adaptive_gauss = try cv.Mat.init();
    defer adaptive_gauss.deinit();
    cv.imgproc.adaptiveThreshold(gray, &adaptive_gauss, 255, 1, .binary, 11, 2);
    try cv.imgcodecs.imwrite("examples/tmp/thresh_adaptive_gauss.jpg", adaptive_gauss);
    std.debug.print("💾 Adaptive Gaussian → examples/tmp/thresh_adaptive_gauss.jpg\n", .{});

    std.debug.print("\n🎉 Threshold comparison complete!\n", .{});
}
