const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Drawing Primitives Example ===\n", .{});
    std.debug.print("Demonstrates lines, circles, rectangles, ellipses, and text\n\n", .{});

    // Create a black canvas
    var canvas = try cv.Mat.initWithSize(600, 800, cv.core.CV_8UC3);
    defer canvas.deinit();
    canvas.setTo(cv.Scalar.init(30, 30, 30, 0)); // dark gray background

    // --- Lines ---
    cv.imgproc.line(&canvas, cv.Point{ .x = 50, .y = 50 }, cv.Point{ .x = 200, .y = 100 }, cv.Scalar.init(0, 128, 255, 0), 2, 8, 0);
    cv.imgproc.line(&canvas, cv.Point{ .x = 50, .y = 100 }, cv.Point{ .x = 200, .y = 50 }, cv.Scalar.init(128, 255, 0, 0), 2, 8, 0);
    cv.imgproc.arrowedLine(&canvas, cv.Point{ .x = 50, .y = 130 }, cv.Point{ .x = 200, .y = 130 }, cv.Scalar.init(255, 128, 0, 0), 2, 8, 0, 0.1);
    std.debug.print("✅ Lines drawn\n", .{});

    // --- Rectangles ---
    cv.imgproc.rectangle(&canvas, cv.Rect{ .x = 250, .y = 30, .width = 150, .height = 110 }, cv.Scalar.init(0, 255, 0, 0), 2, 8, 0);
    cv.imgproc.rectangle(&canvas, cv.Rect{ .x = 270, .y = 50, .width = 110, .height = 70 }, cv.Scalar.init(0, 200, 100, 0), -1, 8, 0);
    std.debug.print("✅ Rectangles drawn\n", .{});

    // --- Circles ---
    cv.imgproc.circle(&canvas, cv.Point{ .x = 500, .y = 80 }, 50, cv.Scalar.init(255, 0, 0, 0), 2, 8, 0);
    cv.imgproc.circle(&canvas, cv.Point{ .x = 500, .y = 80 }, 30, cv.Scalar.init(255, 100, 100, 0), -1, 8, 0);
    cv.imgproc.circle(&canvas, cv.Point{ .x = 620, .y = 80 }, 40, cv.Scalar.init(0, 255, 255, 0), 3, 8, 0);
    std.debug.print("✅ Circles drawn\n", .{});

    // --- Ellipses ---
    cv.imgproc.ellipse(&canvas, cv.Point{ .x = 150, .y = 280 }, cv.Size{ .width = 100, .height = 50 }, 30, 0, 360, cv.Scalar.init(255, 0, 255, 0), 2, 8, 0);
    cv.imgproc.ellipse(&canvas, cv.Point{ .x = 150, .y = 280 }, cv.Size{ .width = 60, .height = 30 }, -30, 0, 180, cv.Scalar.init(0, 255, 128, 0), -1, 8, 0);
    std.debug.print("✅ Ellipses drawn\n", .{});

    // --- Text ---
    cv.imgproc.putText(&canvas, "zOpenCV Drawing Demo", cv.Point{ .x = 250, .y = 250 }, cv.imgproc.FONT_HERSHEY_COMPLEX, 0.8, cv.Scalar.init(255, 255, 255, 0), 2, 8, false);
    cv.imgproc.putText(&canvas, "Powered by OpenCV", cv.Point{ .x = 300, .y = 290 }, cv.imgproc.FONT_HERSHEY_SIMPLEX, 0.6, cv.Scalar.init(180, 180, 180, 0), 1, 8, false);
    std.debug.print("✅ Text drawn\n", .{});

    // --- Colorful shapes grid ---
    const colors = [_]cv.Scalar{
        cv.Scalar.init(255, 50, 50, 0),
        cv.Scalar.init(50, 255, 50, 0),
        cv.Scalar.init(50, 50, 255, 0),
        cv.Scalar.init(255, 255, 50, 0),
        cv.Scalar.init(255, 50, 255, 0),
        cv.Scalar.init(50, 255, 255, 0),
    };
    for (0..6) |ci| {
        const cx: i32 = @intCast(100 + ci * 110);
        cv.imgproc.circle(&canvas, cv.Point{ .x = cx, .y = 400 }, 35, colors[ci], -1, 8, 0);
        cv.imgproc.circle(&canvas, cv.Point{ .x = cx, .y = 400 }, 35, cv.Scalar.init(255, 255, 255, 0), 2, 8, 0);
    }
    std.debug.print("✅ Color palette drawn\n", .{});

    // --- Info text ---
    cv.imgproc.putText(&canvas, "Line | Rect | Circle | Ellipse | Arrow | Text", cv.Point{ .x = 100, .y = 500 }, cv.imgproc.FONT_HERSHEY_SIMPLEX, 0.5, cv.Scalar.init(200, 200, 200, 0), 1, 8, false);

    // Save result
    const output_path = "examples/tmp/drawing_demo.jpg";
    try cv.imgcodecs.imwrite(output_path, canvas);
    std.debug.print("\n💾 Saved to: {s}\n", .{output_path});
    std.debug.print("🎉 Drawing demo complete!\n", .{});
}
