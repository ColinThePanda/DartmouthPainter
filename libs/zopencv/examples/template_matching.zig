const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Template Matching Example ===\n", .{});
    std.debug.print("Demonstrates template matching to find a sub-image within a larger image\n\n", .{});

    const image_path = "testdata/images/lena.jpg";
    var img = cv.imgcodecs.imread(image_path, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{image_path});
        return;
    };
    defer img.deinit();
    std.debug.print("✅ Loaded source: {s} ({d}x{d})\n", .{ image_path, img.cols(), img.rows() });

    // Create a template by cropping a region from the image (face area)
    var tmpl = try img.submat(cv.Rect{ .x = 200, .y = 200, .width = 100, .height = 100 });
    defer tmpl.deinit();
    try cv.imgcodecs.imwrite("examples/tmp/template_crop.jpg", tmpl);
    std.debug.print("✅ Template: {d}x{d} (cropped from source)\n", .{ tmpl.cols(), tmpl.rows() });

    // Perform template matching (TM_CCOEFF_NORMED = 5)
    var result = try cv.Mat.init();
    defer result.deinit();
    cv.imgproc.matchTemplate(img, tmpl, &result, 5);

    // Find the best match location
    var min_val: f64 = 0;
    var max_val: f64 = 0;
    var min_loc = cv.Point{ .x = 0, .y = 0 };
    var max_loc = cv.Point{ .x = 0, .y = 0 };
    cv.core.minMaxLoc(result, &min_val, &max_val, &min_loc, &max_loc);

    std.debug.print("\n🔍 Best match at: ({d}, {d}) with score {d:.4}\n", .{
        max_loc.x, max_loc.y, max_val,
    });

    // Draw rectangle at match location
    var output = try img.clone();
    defer output.deinit();
    cv.imgproc.rectangle(
        &output,
        cv.Rect{ .x = max_loc.x, .y = max_loc.y, .width = tmpl.cols(), .height = tmpl.rows() },
        cv.Scalar.init(0, 0, 255, 0),
        3,
        8,
        0,
    );

    // Add text label
    cv.imgproc.putText(
        &output,
        "Match!",
        cv.Point{ .x = max_loc.x, .y = max_loc.y - 10 },
        cv.imgproc.FONT_HERSHEY_SIMPLEX,
        0.7,
        cv.Scalar.init(0, 0, 255, 0),
        2,
        8,
        false,
    );

    const output_path = "examples/tmp/template_match_result.jpg";
    try cv.imgcodecs.imwrite(output_path, output);
    std.debug.print("💾 Result → {s}\n", .{output_path});
    std.debug.print("🎉 Template matching complete!\n", .{});
}
