const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Background Subtraction Demo ===\n", .{});
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    // Create background subtractors
    std.debug.print("1. Creating background subtractors...\n", .{});

    var mog2 = try cv.video.BackgroundSubtractorMOG2.init();
    defer mog2.deinit();
    std.debug.print("   ✅ MOG2 created (Gaussian Mixture Model)\n", .{});

    var knn = try cv.video.BackgroundSubtractorKNN.init();
    defer knn.deinit();
    std.debug.print("   ✅ KNN created (K-Nearest Neighbors)\n", .{});

    // Create test frames
    std.debug.print("\n2. Processing test frames...\n", .{});

    // Frame 1: Background (blue)
    var frame1 = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer frame1.deinit();
    const blue = cv.Scalar.init(255, 0, 0, 0);
    cv.imgproc.rectangle(&frame1, cv.Rect.init(0, 0, 100, 100), blue, -1, 8, 0);

    // Frame 2: Background + foreground object (red rectangle)
    var frame2 = try cv.Mat.initWithSize(100, 100, 16);
    defer frame2.deinit();
    cv.imgproc.rectangle(&frame2, cv.Rect.init(0, 0, 100, 100), blue, -1, 8, 0);
    const red = cv.Scalar.init(0, 0, 255, 0);
    cv.imgproc.rectangle(&frame2, cv.Rect.init(30, 30, 40, 40), red, -1, 8, 0);

    // Apply background subtraction with MOG2
    var fgmask_mog2 = try cv.Mat.init();
    defer fgmask_mog2.deinit();

    std.debug.print("   Processing with MOG2...\n", .{});
    mog2.apply(frame1, &fgmask_mog2, -1); // Learn background
    mog2.apply(frame2, &fgmask_mog2, -1); // Detect foreground

    std.debug.print("   Foreground mask: {}x{}\n", .{
        fgmask_mog2.cols(),
        fgmask_mog2.rows(),
    });

    // Apply background subtraction with KNN
    var fgmask_knn = try cv.Mat.init();
    defer fgmask_knn.deinit();

    std.debug.print("   Processing with KNN...\n", .{});
    knn.apply(frame1, &fgmask_knn, -1); // Learn background
    knn.apply(frame2, &fgmask_knn, -1); // Detect foreground

    std.debug.print("   Foreground mask: {}x{}\n", .{
        fgmask_knn.cols(),
        fgmask_knn.rows(),
    });

    // Get background images
    var bg_mog2 = try cv.Mat.init();
    defer bg_mog2.deinit();
    mog2.getBackgroundImage(&bg_mog2);

    var bg_knn = try cv.Mat.init();
    defer bg_knn.deinit();
    knn.getBackgroundImage(&bg_knn);

    std.debug.print("\n3. Background models:\n", .{});
    std.debug.print("   MOG2 background: {}x{}\n", .{
        bg_mog2.cols(),
        bg_mog2.rows(),
    });
    std.debug.print("   KNN background: {}x{}\n", .{
        bg_knn.cols(),
        bg_knn.rows(),
    });

    std.debug.print("\n✅ Demo complete!\n", .{});
    std.debug.print("\nThis demo showed:\n", .{});
    std.debug.print("  - MOG2 background subtraction\n", .{});
    std.debug.print("  - KNN background subtraction\n", .{});
    std.debug.print("  - Foreground mask generation\n", .{});
    std.debug.print("  - Background model extraction\n", .{});
    std.debug.print("\nFor real-world usage:\n", .{});
    std.debug.print("  - Use with VideoCapture for live video\n", .{});
    std.debug.print("  - Adjust learning rate for different scenarios\n", .{});
    std.debug.print("  - Apply morphological operations to clean masks\n", .{});
}
