const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== ArUco Marker Demo ===\n", .{});
    std.debug.print("Demonstrates ArUco marker generation and detection\n\n", .{});

    // Get predefined ArUco dictionary
    var dict = try cv.contrib.aruco.ArucoDictionary.getPredefined(.dict_6x6_250);
    defer dict.deinit();
    std.debug.print("✅ Loaded ArUco dictionary: DICT_6x6_250\n", .{});

    // Generate marker images
    const marker_ids = [_]i32{ 0, 42, 100, 199 };
    for (marker_ids) |id| {
        var marker = try cv.Mat.init();
        defer marker.deinit();
        dict.generateImageMarker(id, 200, &marker, 1);

        // Add white border for better visibility
        var bordered = try cv.Mat.init();
        defer bordered.deinit();
        cv.imgproc.copyMakeBorder(marker, &bordered, 30, 30, 30, 30, 0, cv.Scalar.init(255, 255, 255, 0));

        var buf: [64]u8 = undefined;
        const path = std.fmt.bufPrint(&buf, "examples/tmp/aruco_marker_{d}.png", .{id}) catch "aruco.png";
        try cv.imgcodecs.imwrite(path, bordered);
        std.debug.print("💾 Marker ID {d} → {s}\n", .{ id, path });
    }

    // Now create a composite image with all markers and detect them
    std.debug.print("\n--- Detection Test ---\n", .{});

    // Generate and detect a single marker
    var test_marker = try cv.Mat.init();
    defer test_marker.deinit();
    dict.generateImageMarker(42, 200, &test_marker, 1);

    // Add border for reliable detection
    var detection_img = try cv.Mat.init();
    defer detection_img.deinit();
    cv.imgproc.copyMakeBorder(test_marker, &detection_img, 50, 50, 50, 50, 0, cv.Scalar.init(255, 255, 255, 0));

    var detector = try cv.contrib.aruco.ArucoDetector.create(dict);
    defer detector.deinit();

    var corners = try cv.Mat.init();
    defer corners.deinit();
    var ids = try cv.Mat.init();
    defer ids.deinit();
    var rejected = try cv.Mat.init();
    defer rejected.deinit();

    detector.detectMarkers(detection_img, &corners, &ids, &rejected);

    if (!ids.empty()) {
        std.debug.print("✅ Detected {d} marker(s)\n", .{ids.rows()});
        var i: i32 = 0;
        while (i < ids.rows()) : (i += 1) {
            const detected_id = ids.getInt(i, 0);
            std.debug.print("   Marker ID: {d}\n", .{detected_id});
        }
    } else {
        std.debug.print("⚠️ No markers detected\n", .{});
    }

    std.debug.print("\n🎉 ArUco demo complete!\n", .{});
}
