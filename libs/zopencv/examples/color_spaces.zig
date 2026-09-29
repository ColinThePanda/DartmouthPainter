const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Color Spaces Example ===\n", .{});
    std.debug.print("Demonstrates BGR → HSV, Gray conversions\n\n", .{});

    const image_path = "testdata/images/fruits.jpg";
    var img = cv.imgcodecs.imread(image_path, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{image_path});
        return;
    };
    defer img.deinit();
    std.debug.print("✅ Loaded: {s} ({d}x{d}, channels={d})\n", .{
        image_path, img.cols(), img.rows(), img.channels(),
    });

    // BGR → Grayscale
    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);
    try cv.imgcodecs.imwrite("examples/tmp/color_gray.jpg", gray);
    std.debug.print("💾 Grayscale → examples/tmp/color_gray.jpg\n", .{});

    // BGR → HSV
    var hsv = try cv.Mat.init();
    defer hsv.deinit();
    cv.imgproc.cvtColor(img, &hsv, .bgr2hsv);
    try cv.imgcodecs.imwrite("examples/tmp/color_hsv.jpg", hsv);
    std.debug.print("💾 HSV → examples/tmp/color_hsv.jpg\n", .{});

    // BGR → RGB
    var rgb = try cv.Mat.init();
    defer rgb.deinit();
    cv.imgproc.cvtColor(img, &rgb, .bgr2rgb);
    try cv.imgcodecs.imwrite("examples/tmp/color_rgb.jpg", rgb);
    std.debug.print("💾 RGB → examples/tmp/color_rgb.jpg\n", .{});

    // Gray → BGR (3 channels from grayscale)
    var gray_bgr = try cv.Mat.init();
    defer gray_bgr.deinit();
    cv.imgproc.cvtColor(gray, &gray_bgr, .gray2bgr);
    try cv.imgcodecs.imwrite("examples/tmp/color_gray_bgr.jpg", gray_bgr);
    std.debug.print("💾 Gray→BGR → examples/tmp/color_gray_bgr.jpg\n", .{});

    std.debug.print("\n🎉 Color space conversions complete!\n", .{});
}
