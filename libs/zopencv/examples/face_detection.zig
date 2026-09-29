const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Face Detection Example ===\n", .{});
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    // Load cascade classifier for face detection
    var cascade = try cv.objdetect.CascadeClassifier.init();
    defer cascade.deinit();

    const cascade_path = "testdata/models/haarcascades/haarcascade_frontalface_default.xml";
    const loaded = try cascade.load(cascade_path);
    if (!loaded) {
        std.debug.print("❌ Failed to load cascade file: {s}\n", .{cascade_path});
        std.debug.print("   Download from: https://github.com/opencv/opencv/tree/master/data/haarcascades\n", .{});
        return;
    }
    std.debug.print("✅ Loaded cascade: {s}\n", .{cascade_path});

    // Load test image
    const image_path = "testdata/images/lena.jpg";
    var img = cv.imgcodecs.imread(image_path, .color) catch {
        std.debug.print("❌ Failed to load image: {s}\n", .{image_path});
        return;
    };
    defer img.deinit();

    if (img.empty()) {
        std.debug.print("❌ Image is empty: {s}\n", .{image_path});
        return;
    }
    std.debug.print("✅ Loaded image: {s} ({d}x{d})\n", .{
        image_path, img.cols(), img.rows(),
    });

    // Convert to grayscale for detection
    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    // Detect faces
    var faces = try cv.objdetect.RectVector.init();
    defer faces.deinit();
    cascade.detectMultiScale(gray, &faces, 1.1, 3, 0, cv.Size{ .width = 30, .height = 30 }, cv.Size{ .width = 0, .height = 0 });

    std.debug.print("\n🔍 Detected {d} face(s)\n", .{faces.size()});

    // Draw rectangles around detected faces
    var i: usize = 0;
    while (i < faces.size()) : (i += 1) {
        const face = faces.at(i);
        std.debug.print("   Face {d}: x={d}, y={d}, w={d}, h={d}\n", .{
            i + 1, face.x, face.y, face.width, face.height,
        });

        // Draw green rectangle around face
        cv.imgproc.rectangle(
            &img,
            face,
            cv.Scalar.init(0, 255, 0, 0), // green
            2,
            8,
            0,
        );
    }

    // Save result
    const output_path = "examples/tmp/face_detection_result.jpg";
    try cv.imgcodecs.imwrite(output_path, img);
    std.debug.print("\n💾 Result saved to: {s}\n", .{output_path});
    std.debug.print("🎉 Face detection complete!\n", .{});
}
