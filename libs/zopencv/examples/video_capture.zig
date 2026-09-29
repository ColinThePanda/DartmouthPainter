const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Video Capture Example ===\n", .{});
    std.debug.print("Demonstrates reading video files and processing frames\n\n", .{});

    // Open video file
    const video_path = "testdata/videos/vtest.avi";
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    const opened = try cap.open(video_path);
    if (!opened or !cap.isOpened()) {
        std.debug.print("❌ Failed to open video: {s}\n", .{video_path});
        return;
    }
    std.debug.print("✅ Opened video: {s}\n", .{video_path});

    // Get video properties
    const width = cap.get(.frame_width);
    const height = cap.get(.frame_height);
    const fps = cap.get(.fps);
    const frame_count = cap.get(.frame_count);
    std.debug.print("   Resolution: {d:.0}x{d:.0}\n", .{ width, height });
    std.debug.print("   FPS: {d:.1}\n", .{fps});
    std.debug.print("   Total frames: {d:.0}\n\n", .{frame_count});

    // Read and process frames
    var frame = try cv.Mat.init();
    defer frame.deinit();
    var gray = try cv.Mat.init();
    defer gray.deinit();
    var edges = try cv.Mat.init();
    defer edges.deinit();

    var frame_num: u32 = 0;
    var saved_frame = false;

    while (cap.read(&frame)) {
        if (frame.empty()) break;
        frame_num += 1;

        // Process every 30th frame
        if (frame_num % 30 == 1) {
            // Convert to grayscale and detect edges
            cv.imgproc.cvtColor(frame, &gray, .bgr2gray);
            cv.imgproc.canny(gray, &edges, 50, 150, 3, false);

            std.debug.print("  Frame {d}: {d}x{d}\n", .{
                frame_num, frame.cols(), frame.rows(),
            });

            // Save first frame as sample
            if (!saved_frame) {
                try cv.imgcodecs.imwrite("examples/tmp/video_frame_original.jpg", frame);
                try cv.imgcodecs.imwrite("examples/tmp/video_frame_edges.jpg", edges);
                std.debug.print("  💾 Saved sample frame + edges\n", .{});
                saved_frame = true;
            }
        }
    }

    std.debug.print("\n📊 Processed {d} frames total\n", .{frame_num});
    std.debug.print("💾 Results in: examples/tmp/video_frame_*.jpg\n", .{});
    std.debug.print("🎉 Video capture complete!\n", .{});
}
