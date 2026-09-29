const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    // Use debug print for simplicity
    const version = cv.getVersion();
    std.debug.print("OpenCV Version: {s}\n\n", .{version});

    // Create an empty Mat
    std.debug.print("Creating a Mat...\n", .{});
    var mat = try cv.Mat.init();
    defer mat.deinit();

    std.debug.print("Mat is empty: {}\n", .{mat.empty()});

    // Create a Mat with specific size
    std.debug.print("\nCreating a 3x3 Mat...\n", .{});
    var mat2 = try cv.Mat.initWithSize(3, 3, cv.core.CV_8UC1);
    defer mat2.deinit();

    std.debug.print("Mat size: {}x{}\n", .{ mat2.rows(), mat2.cols() });
    std.debug.print("Mat channels: {}\n", .{mat2.channels()});
    std.debug.print("Mat is empty: {}\n", .{mat2.empty()});

    std.debug.print("\nSuccess! zOpenCV is working correctly.\n", .{});
}
