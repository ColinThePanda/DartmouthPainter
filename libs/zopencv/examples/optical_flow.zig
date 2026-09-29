const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Optical Flow Example ===\n", .{});
    std.debug.print("Demonstrates dense optical flow (Farneback) on video\n\n", .{});

    const video_path = "testdata/videos/vtest.avi";
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    const opened = try cap.open(video_path);
    if (!opened or !cap.isOpened()) {
        std.debug.print("❌ Failed to open: {s}\n", .{video_path});
        return;
    }
    std.debug.print("✅ Opened: {s}\n", .{video_path});

    var frame = try cv.Mat.init();
    defer frame.deinit();
    var gray = try cv.Mat.init();
    defer gray.deinit();
    var prev_gray = try cv.Mat.init();
    defer prev_gray.deinit();
    var flow = try cv.Mat.init();
    defer flow.deinit();

    // Read first frame
    if (!cap.read(&frame) or frame.empty()) {
        std.debug.print("❌ Cannot read first frame\n", .{});
        return;
    }
    cv.imgproc.cvtColor(frame, &prev_gray, .bgr2gray);

    var frame_count: u32 = 0;
    const max_frames: u32 = 50;

    while (cap.read(&frame)) {
        if (frame.empty()) break;
        if (frame_count >= max_frames) break;
        frame_count += 1;

        cv.imgproc.cvtColor(frame, &gray, .bgr2gray);

        // Dense optical flow (Farneback)
        cv.video.calcOpticalFlowFarneback(
            prev_gray,
            gray,
            &flow,
            0.5, // pyr_scale
            3, // levels
            15, // winsize
            3, // iterations
            5, // poly_n
            1.2, // poly_sigma
            0, // flags
        );

        if (frame_count % 10 == 0) {
            std.debug.print("  Frame {d}: flow size = {d}x{d}\n", .{
                frame_count, flow.cols(), flow.rows(),
            });
        }

        // Save a sample flow visualization at frame 20
        if (frame_count == 20) {
            try cv.imgcodecs.imwrite("examples/tmp/optical_flow_frame.jpg", frame);
            std.debug.print("  💾 Saved flow frame at frame 20\n", .{});
        }

        // Copy current to previous
        gray.copyTo(&prev_gray);
    }

    std.debug.print("\n📊 Computed optical flow for {d} frames\n", .{frame_count});
    std.debug.print("🎉 Optical flow complete!\n", .{});
}
