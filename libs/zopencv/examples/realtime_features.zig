const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Real-time Feature Detection Demo ===\n", .{});
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    // Open camera
    std.debug.print("Opening camera...\n", .{});
    var cap = try cv.videoio.VideoCapture.initFromIndex(0);
    defer cap.deinit();

    if (!cap.isOpened()) {
        std.debug.print("❌ Could not open camera\n", .{});
        std.debug.print("This demo requires a webcam.\n", .{});
        return;
    }

    const width = cap.get(.frame_width);
    const height = cap.get(.frame_height);
    const fps = cap.get(.fps);

    std.debug.print("✅ Camera opened: {}x{} @ {d:.1} FPS\n\n", .{
        @as(i32, @intFromFloat(width)),
        @as(i32, @intFromFloat(height)),
        fps,
    });

    // Create feature detector
    std.debug.print("Creating ORB detector...\n", .{});
    var orb = try cv.features2d.ORB.initWithParams(
        1000, // nfeatures
        1.2, // scaleFactor
        8, // nlevels
        31, // edgeThreshold
        0, // firstLevel
        2, // WTA_K
        0, // scoreType
        31, // patchSize
        20, // fastThreshold
    );
    defer orb.deinit();

    // Process frames
    std.debug.print("Processing frames (will process 10 frames)...\n\n", .{});

    var frame = try cv.Mat.init();
    defer frame.deinit();

    var gray = try cv.Mat.init();
    defer gray.deinit();

    var keypoints = try cv.features2d.KeyPointVector.init();
    defer keypoints.deinit();

    var descriptors = try cv.Mat.init();
    defer descriptors.deinit();

    var frame_count: usize = 0;
    while (frame_count < 10) : (frame_count += 1) {
        if (!cap.read(&frame)) {
            std.debug.print("Failed to read frame {}\n", .{frame_count + 1});
            break;
        }

        // Convert to grayscale
        cv.imgproc.cvtColor(frame, &gray, .bgr2gray);

        // Detect features
        orb.detectAndCompute(gray, null, &keypoints, &descriptors);

        std.debug.print("Frame {}: {}x{}, {} keypoints detected\n", .{
            frame_count + 1,
            frame.cols(),
            frame.rows(),
            keypoints.size(),
        });

        // Show first few keypoints
        if (keypoints.size() > 0) {
            const max_show = @min(keypoints.size(), 3);
            var i: usize = 0;
            while (i < max_show) : (i += 1) {
                const kp = keypoints.at(i);
                std.debug.print("  KP{}: ({d:.1}, {d:.1}) size={d:.1} angle={d:.1}\n", .{
                    i + 1,
                    kp.pt.x,
                    kp.pt.y,
                    kp.size,
                    kp.angle,
                });
            }
        }
    }

    std.debug.print("\n✅ Demo complete!\n", .{});
    std.debug.print("\nThis demo showed:\n", .{});
    std.debug.print("  - Real-time camera capture\n", .{});
    std.debug.print("  - Frame-by-frame processing\n", .{});
    std.debug.print("  - ORB feature detection\n", .{});
    std.debug.print("  - Keypoint analysis\n", .{});
}
