const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Edge Detection Example ===\n", .{});
    std.debug.print("Demonstrates Canny, Sobel, and Laplacian edge detection\n\n", .{});

    // Load image
    const image_path = "testdata/images/fruits.jpg";
    var img = cv.imgcodecs.imread(image_path, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{image_path});
        return;
    };
    defer img.deinit();
    std.debug.print("✅ Loaded: {s} ({d}x{d})\n", .{ image_path, img.cols(), img.rows() });

    // Convert to grayscale
    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    // Apply Gaussian blur to reduce noise
    var blurred = try cv.Mat.init();
    defer blurred.deinit();
    cv.imgproc.gaussianBlur(gray, &blurred, cv.Size{ .width = 5, .height = 5 }, 1.4, 0, 0);

    // --- Canny Edge Detection ---
    var canny = try cv.Mat.init();
    defer canny.deinit();
    cv.imgproc.canny(blurred, &canny, 50, 150, 3, false);
    try cv.imgcodecs.imwrite("examples/tmp/edges_canny.jpg", canny);
    std.debug.print("💾 Canny edges saved to: examples/tmp/edges_canny.jpg\n", .{});

    // --- Sobel Edge Detection ---
    var sobel_x = try cv.Mat.init();
    defer sobel_x.deinit();
    var sobel_y = try cv.Mat.init();
    defer sobel_y.deinit();

    // Sobel X (vertical edges)
    cv.imgproc.sobel(blurred, &sobel_x, cv.core.CV_16S, 1, 0, 3, 1.0, 0.0, 0);
    // Sobel Y (horizontal edges)
    cv.imgproc.sobel(blurred, &sobel_y, cv.core.CV_16S, 0, 1, 3, 1.0, 0.0, 0);

    // Convert to absolute and merge
    var abs_x = try cv.Mat.init();
    defer abs_x.deinit();
    var abs_y = try cv.Mat.init();
    defer abs_y.deinit();
    cv.core.convertScaleAbs(sobel_x, &abs_x, 1.0, 0.0);
    cv.core.convertScaleAbs(sobel_y, &abs_y, 1.0, 0.0);

    var sobel_combined = try cv.Mat.init();
    defer sobel_combined.deinit();
    cv.core.addWeighted(abs_x, 0.5, abs_y, 0.5, 0, &sobel_combined);
    try cv.imgcodecs.imwrite("examples/tmp/edges_sobel.jpg", sobel_combined);
    std.debug.print("💾 Sobel edges saved to: examples/tmp/edges_sobel.jpg\n", .{});

    // --- Laplacian Edge Detection ---
    var laplacian_raw = try cv.Mat.init();
    defer laplacian_raw.deinit();
    cv.imgproc.laplacian(blurred, &laplacian_raw, cv.core.CV_16S, 3, 1.0, 0.0, 0);
    var laplacian_abs = try cv.Mat.init();
    defer laplacian_abs.deinit();
    cv.core.convertScaleAbs(laplacian_raw, &laplacian_abs, 1.0, 0.0);
    try cv.imgcodecs.imwrite("examples/tmp/edges_laplacian.jpg", laplacian_abs);
    std.debug.print("💾 Laplacian edges saved to: examples/tmp/edges_laplacian.jpg\n", .{});

    std.debug.print("\n🎉 Edge detection complete! Check examples/tmp/ for results.\n", .{});
}
