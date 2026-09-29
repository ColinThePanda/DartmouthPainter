const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== OpenCV Image Processing Pipeline Demo ===\n", .{});
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    // Create a test image (100x100, 3 channels, blue background)
    std.debug.print("1. Creating test image...\n", .{});
    var img = try cv.Mat.initWithSize(100, 100, 16); // CV_8UC3
    defer img.deinit();

    // Fill with blue color
    const blue = cv.Scalar.init(255, 0, 0, 0); // BGR format
    cv.imgproc.rectangle(&img, cv.Rect.init(0, 0, 100, 100), blue, -1, // filled
        8, 0);

    // Draw some shapes
    std.debug.print("2. Drawing shapes...\n", .{});
    const red = cv.Scalar.init(0, 0, 255, 0);
    const green = cv.Scalar.init(0, 255, 0, 0);
    const white = cv.Scalar.init(255, 255, 255, 0);

    // Draw rectangle
    cv.imgproc.rectangle(&img, cv.Rect.init(10, 10, 30, 30), red, 2, 8, 0);

    // Draw circle
    cv.imgproc.circle(&img, cv.Point.init(70, 30), 15, green, 2, 8, 0);

    // Draw line
    cv.imgproc.line(&img, cv.Point.init(10, 70), cv.Point.init(90, 90), white, 2, 8, 0);

    // Add text
    cv.imgproc.putText(&img, "OpenCV", cv.Point.init(5, 95), 0, // FONT_HERSHEY_SIMPLEX
        0.3, white, 1, 8, false);

    std.debug.print("3. Applying image processing...\n", .{});

    // Convert to grayscale
    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    // Apply Gaussian blur
    var blurred = try cv.Mat.init();
    defer blurred.deinit();
    cv.imgproc.gaussianBlur(gray, &blurred, cv.Size.init(5, 5), 1.5, 1.5, 0);

    // Detect edges with Canny
    var edges = try cv.Mat.init();
    defer edges.deinit();
    cv.imgproc.canny(blurred, &edges, 50, 150, 3, false);

    std.debug.print("4. Image statistics:\n", .{});
    std.debug.print("   Original: {}x{}, {} channels\n", .{
        img.rows(),
        img.cols(),
        img.channels(),
    });
    std.debug.print("   Grayscale: {}x{}, {} channels\n", .{
        gray.rows(),
        gray.cols(),
        gray.channels(),
    });
    std.debug.print("   Edges: {}x{}, {} channels\n", .{
        edges.rows(),
        edges.cols(),
        edges.channels(),
    });

    std.debug.print("\n5. Feature detection...\n", .{});

    // Detect features with ORB
    var orb = try cv.features2d.ORB.init();
    defer orb.deinit();

    var keypoints = try cv.features2d.KeyPointVector.init();
    defer keypoints.deinit();

    var descriptors = try cv.Mat.init();
    defer descriptors.deinit();

    orb.detectAndCompute(gray, null, &keypoints, &descriptors);

    std.debug.print("   Found {} keypoints with ORB\n", .{keypoints.size()});

    if (keypoints.size() > 0) {
        const kp = keypoints.at(0);
        std.debug.print("   First keypoint: ({d:.1}, {d:.1}), size={d:.1}\n", .{
            kp.pt.x,
            kp.pt.y,
            kp.size,
        });
    }

    std.debug.print("\n✅ Pipeline complete!\n", .{});
    std.debug.print("\nThis demo showed:\n", .{});
    std.debug.print("  - Mat creation and manipulation\n", .{});
    std.debug.print("  - Drawing shapes (rectangle, circle, line, text)\n", .{});
    std.debug.print("  - Color conversion (BGR → Gray)\n", .{});
    std.debug.print("  - Image filtering (Gaussian blur)\n", .{});
    std.debug.print("  - Edge detection (Canny)\n", .{});
    std.debug.print("  - Feature detection (ORB)\n", .{});
}
