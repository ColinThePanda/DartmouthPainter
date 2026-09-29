const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Photo Module Demo ===\n", .{});
    std.debug.print("OpenCV Version: {s}\n\n", .{cv.getVersion()});

    // Create a test image with noise
    std.debug.print("1. Creating noisy test image...\n", .{});
    var img = try cv.Mat.initWithSize(200, 200, 16); // CV_8UC3
    defer img.deinit();

    // Fill with blue color
    const blue = cv.Scalar.init(200, 100, 50, 0);
    cv.imgproc.rectangle(&img, cv.Rect.init(0, 0, 200, 200), blue, -1, 8, 0);

    // Add some "damaged" regions (white rectangles)
    const white = cv.Scalar.init(255, 255, 255, 0);
    cv.imgproc.rectangle(&img, cv.Rect.init(50, 50, 20, 20), white, -1, 8, 0);
    cv.imgproc.rectangle(&img, cv.Rect.init(130, 120, 15, 15), white, -1, 8, 0);

    std.debug.print("   Image size: {}x{}\n", .{ img.cols(), img.rows() });

    // Test denoising
    std.debug.print("\n2. Testing denoising...\n", .{});
    var denoised = try cv.Mat.init();
    defer denoised.deinit();

    cv.photo.fastNlMeansDenoisingColored(img, &denoised, 10.0, 10.0, 7, 21);
    std.debug.print("   ✅ Denoised image: {}x{}\n", .{
        denoised.cols(),
        denoised.rows(),
    });

    // Test inpainting
    std.debug.print("\n3. Testing inpainting...\n", .{});

    // Create mask for damaged regions
    var mask = try cv.Mat.initWithSize(200, 200, 0); // CV_8UC1
    defer mask.deinit();

    const mask_white = cv.Scalar.init(255, 255, 255, 0);
    cv.imgproc.rectangle(&mask, cv.Rect.init(50, 50, 20, 20), mask_white, -1, 8, 0);
    cv.imgproc.rectangle(&mask, cv.Rect.init(130, 120, 15, 15), mask_white, -1, 8, 0);

    var inpainted = try cv.Mat.init();
    defer inpainted.deinit();

    cv.photo.inpaint(img, mask, &inpainted, 3.0, .ns);
    std.debug.print("   ✅ Inpainted image: {}x{}\n", .{
        inpainted.cols(),
        inpainted.rows(),
    });

    // Test detail enhancement
    std.debug.print("\n4. Testing detail enhancement...\n", .{});
    var enhanced = try cv.Mat.init();
    defer enhanced.deinit();

    cv.photo.detailEnhance(img, &enhanced, 10.0, 0.15);
    std.debug.print("   ✅ Enhanced image: {}x{}\n", .{
        enhanced.cols(),
        enhanced.rows(),
    });

    // Test stylization
    std.debug.print("\n5. Testing stylization filter...\n", .{});
    var stylized = try cv.Mat.init();
    defer stylized.deinit();

    cv.photo.stylization(img, &stylized, 60.0, 0.45);
    std.debug.print("   ✅ Stylized image: {}x{}\n", .{
        stylized.cols(),
        stylized.rows(),
    });

    // Test pencil sketch
    std.debug.print("\n6. Testing pencil sketch effect...\n", .{});
    var sketch_gray = try cv.Mat.init();
    defer sketch_gray.deinit();
    var sketch_color = try cv.Mat.init();
    defer sketch_color.deinit();

    cv.photo.pencilSketch(img, &sketch_gray, &sketch_color, 60.0, 0.07, 0.02);
    std.debug.print("   ✅ Sketch (gray): {}x{}\n", .{
        sketch_gray.cols(),
        sketch_gray.rows(),
    });
    std.debug.print("   ✅ Sketch (color): {}x{}\n", .{
        sketch_color.cols(),
        sketch_color.rows(),
    });

    std.debug.print("\n✅ Photo module demo complete!\n", .{});
    std.debug.print("\nDemonstrated features:\n", .{});
    std.debug.print("  - Non-local means denoising\n", .{});
    std.debug.print("  - Inpainting (damage repair)\n", .{});
    std.debug.print("  - Detail enhancement\n", .{});
    std.debug.print("  - Stylization filter\n", .{});
    std.debug.print("  - Pencil sketch effect\n", .{});
}
