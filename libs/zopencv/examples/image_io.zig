const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    std.debug.print("Reading image...\n", .{});
    var img = try cv.imgcodecs.imread("test.jpg", .color);
    defer img.deinit();

    if (img.empty()) {
        std.debug.print("Error: Could not read image\n", .{});
        return;
    }

    std.debug.print("Image size: {}x{}\n", .{ img.cols(), img.rows() });
    std.debug.print("Image type: {}\n\n", .{img.matType()});

    // Convert to grayscale
    std.debug.print("Converting to grayscale...\n", .{});
    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    // Apply Gaussian blur
    std.debug.print("Applying Gaussian blur...\n", .{});
    var blurred = try cv.Mat.init();
    defer blurred.deinit();
    cv.imgproc.gaussianBlur(gray, &blurred, cv.Size.init(5, 5), 1.5, 1.5, 0);

    // Detect edges using Canny
    std.debug.print("Detecting edges with Canny...\n", .{});
    var edges = try cv.Mat.init();
    defer edges.deinit();
    cv.imgproc.canny(blurred, &edges, 50, 150, 3, false);

    // Save results
    std.debug.print("Saving results...\n", .{});
    try cv.imgcodecs.imwrite("output_gray.jpg", gray);
    try cv.imgcodecs.imwrite("output_edges.jpg", edges);

    std.debug.print("\nSuccess! Processed images saved.\n", .{});
}
