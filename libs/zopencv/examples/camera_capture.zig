const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Live Camera Capture ===\n", .{});
    std.debug.print("Captures from camera and applies real-time edge detection\n", .{});
    std.debug.print("Press ESC to quit\n\n", .{});

    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    const opened = cap.openDevice(0);
    if (!opened or !cap.isOpened()) {
        std.debug.print("⚠️ No camera found. This example requires a connected camera.\n", .{});
        std.debug.print("   Tip: Try the video_capture example for file-based processing.\n", .{});
        return;
    }

    const width = cap.get(.frame_width);
    const height = cap.get(.frame_height);
    std.debug.print("✅ Camera opened: {d:.0}x{d:.0}\n\n", .{ width, height });

    var frame = try cv.Mat.init();
    defer frame.deinit();
    var gray = try cv.Mat.init();
    defer gray.deinit();
    var edges = try cv.Mat.init();
    defer edges.deinit();

    // Create windows
    try cv.highgui.namedWindow("Camera", .autosize);
    defer cv.highgui.destroyWindow("Camera") catch {};
    try cv.highgui.namedWindow("Edges", .autosize);
    defer cv.highgui.destroyWindow("Edges") catch {};

    var frame_count: u32 = 0;
    while (cap.read(&frame)) {
        if (frame.empty()) break;
        frame_count += 1;

        cv.imgproc.cvtColor(frame, &gray, .bgr2gray);
        cv.imgproc.gaussianBlur(gray, &gray, cv.Size{ .width = 5, .height = 5 }, 1.4, 0, 0);
        cv.imgproc.canny(gray, &edges, 50, 150, 3, false);

        try cv.highgui.imshow("Camera", frame);
        try cv.highgui.imshow("Edges", edges);

        if (frame_count == 1) {
            try cv.imgcodecs.imwrite("examples/tmp/camera_frame.jpg", frame);
            try cv.imgcodecs.imwrite("examples/tmp/camera_edges.jpg", edges);
            std.debug.print("💾 Saved first frame\n", .{});
        }

        const key = cv.highgui.waitKey(1);
        if (key == 27) break;
    }

    std.debug.print("\n📊 Captured {d} frames\n", .{frame_count});
    std.debug.print("🎉 Camera capture complete!\n", .{});
}
