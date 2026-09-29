const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Morphology Operations Example ===\n", .{});
    std.debug.print("Demonstrates erosion, dilation, opening, closing, gradient, tophat, blackhat\n\n", .{});

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

    // Create structuring element
    const anchor = cv.Point{ .x = -1, .y = -1 };
    var kernel = try cv.imgproc.getStructuringElement(.rect, cv.Size{ .width = 5, .height = 5 }, anchor);
    defer kernel.deinit();

    // Erosion
    var eroded = try cv.Mat.init();
    defer eroded.deinit();
    cv.imgproc.erode(gray, &eroded, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_erode.jpg", eroded);
    std.debug.print("💾 Erosion → examples/tmp/morph_erode.jpg\n", .{});

    // Dilation
    var dilated = try cv.Mat.init();
    defer dilated.deinit();
    cv.imgproc.dilate(gray, &dilated, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_dilate.jpg", dilated);
    std.debug.print("💾 Dilation → examples/tmp/morph_dilate.jpg\n", .{});

    // Opening
    var opened = try cv.Mat.init();
    defer opened.deinit();
    cv.imgproc.morphologyEx(gray, &opened, .open, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_open.jpg", opened);
    std.debug.print("💾 Opening → examples/tmp/morph_open.jpg\n", .{});

    // Closing
    var closed = try cv.Mat.init();
    defer closed.deinit();
    cv.imgproc.morphologyEx(gray, &closed, .close, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_close.jpg", closed);
    std.debug.print("💾 Closing → examples/tmp/morph_close.jpg\n", .{});

    // Gradient
    var gradient_out = try cv.Mat.init();
    defer gradient_out.deinit();
    cv.imgproc.morphologyEx(gray, &gradient_out, .gradient, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_gradient.jpg", gradient_out);
    std.debug.print("💾 Gradient → examples/tmp/morph_gradient.jpg\n", .{});

    // Top Hat
    var tophat = try cv.Mat.init();
    defer tophat.deinit();
    cv.imgproc.morphologyEx(gray, &tophat, .tophat, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_tophat.jpg", tophat);
    std.debug.print("💾 Top Hat → examples/tmp/morph_tophat.jpg\n", .{});

    // Black Hat
    var blackhat = try cv.Mat.init();
    defer blackhat.deinit();
    cv.imgproc.morphologyEx(gray, &blackhat, .blackhat, kernel, anchor, 1, 0);
    try cv.imgcodecs.imwrite("examples/tmp/morph_blackhat.jpg", blackhat);
    std.debug.print("💾 Black Hat → examples/tmp/morph_blackhat.jpg\n", .{});

    std.debug.print("\n🎉 Morphology operations complete!\n", .{});
}
