const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Video Writer Example ===\n", .{});
    std.debug.print("Reads a video, applies blur, and writes to a new file\n\n", .{});

    const input_path = "testdata/videos/vtest.avi";
    var cap = try cv.videoio.VideoCapture.init();
    defer cap.deinit();

    const opened = try cap.open(input_path);
    if (!opened or !cap.isOpened()) {
        std.debug.print("❌ Failed to open: {s}\n", .{input_path});
        return;
    }

    const width = cap.get(.frame_width);
    const height = cap.get(.frame_height);
    const fps = cap.get(.fps);
    std.debug.print("✅ Input: {s} ({d:.0}x{d:.0} @ {d:.1} FPS)\n", .{ input_path, width, height, fps });

    var writer = try cv.videoio.VideoWriter.init();
    defer writer.deinit();

    const fourcc = cv.videoio.fourcc('M', 'J', 'P', 'G');
    const output_path = "examples/tmp/video_blurred.avi";
    const w_opened = try writer.open(
        output_path,
        fourcc,
        fps,
        cv.Size{ .width = @intFromFloat(width), .height = @intFromFloat(height) },
        true,
    );

    if (!w_opened) {
        std.debug.print("❌ Failed to create writer: {s}\n", .{output_path});
        return;
    }
    std.debug.print("✅ Output: {s}\n\n", .{output_path});

    var frame = try cv.Mat.init();
    defer frame.deinit();
    var blurred = try cv.Mat.init();
    defer blurred.deinit();

    var frame_count: u32 = 0;
    const max_frames: u32 = 100;

    while (cap.read(&frame)) {
        if (frame.empty()) break;
        if (frame_count >= max_frames) break;
        frame_count += 1;

        cv.imgproc.gaussianBlur(frame, &blurred, cv.Size{ .width = 15, .height = 15 }, 3.0, 0, 0);
        writer.write(blurred);

        if (frame_count % 25 == 0) {
            std.debug.print("  Processed {d} frames...\n", .{frame_count});
        }
    }

    writer.release();
    std.debug.print("\n📊 Wrote {d} blurred frames to: {s}\n", .{ frame_count, output_path });
    std.debug.print("🎉 Video writer complete!\n", .{});
}
