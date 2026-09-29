const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Contour Detection Example ===\n", .{});
    std.debug.print("Demonstrates findContours, drawContours, and contour properties\n\n", .{});

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

    var blurred = try cv.Mat.init();
    defer blurred.deinit();
    cv.imgproc.gaussianBlur(gray, &blurred, cv.Size{ .width = 5, .height = 5 }, 1.0, 0, 0);

    var edges = try cv.Mat.init();
    defer edges.deinit();
    cv.imgproc.canny(blurred, &edges, 50, 150, 3, false);

    // Find contours (mode=0 RETR_EXTERNAL, method=1 CHAIN_APPROX_SIMPLE)
    var contours = try cv.imgproc.findContours(edges, 0, 1);
    defer contours.deinit();

    std.debug.print("🔍 Found {d} contours\n\n", .{contours.size()});

    // Draw all contours
    var result = try img.clone();
    defer result.deinit();
    cv.imgproc.drawContours(&result, contours, -1, cv.Scalar.init(0, 255, 0, 0), 2);

    // Print properties of top contours
    var i: usize = 0;
    while (i < contours.size() and i < 10) : (i += 1) {
        const contour = contours.at(i) catch continue;
        const area = cv.imgproc.contourArea(contour, false);
        const perimeter = cv.imgproc.arcLength(contour, true);
        std.debug.print("  Contour {d}: area={d:.1}, perimeter={d:.1}\n", .{
            i, area, perimeter,
        });
    }

    const output_path = "examples/tmp/contours_result.jpg";
    try cv.imgcodecs.imwrite(output_path, result);
    std.debug.print("\n💾 Contours drawn → {s}\n", .{output_path});

    try cv.imgcodecs.imwrite("examples/tmp/contours_edges.jpg", edges);
    std.debug.print("💾 Edge map → examples/tmp/contours_edges.jpg\n", .{});
    std.debug.print("\n🎉 Contour detection complete!\n", .{});
}
