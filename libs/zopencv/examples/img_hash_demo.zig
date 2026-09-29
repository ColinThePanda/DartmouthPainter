const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Image Hash Demo ===\n", .{});
    std.debug.print("Demonstrates perceptual hashing for image similarity comparison\n\n", .{});

    const path1 = "testdata/images/lena.jpg";
    const path2 = "testdata/images/fruits.jpg";

    var img1 = cv.imgcodecs.imread(path1, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{path1});
        return;
    };
    defer img1.deinit();

    var img2 = cv.imgcodecs.imread(path2, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{path2});
        return;
    };
    defer img2.deinit();

    std.debug.print("✅ Image 1: {s} ({d}x{d})\n", .{ path1, img1.cols(), img1.rows() });
    std.debug.print("✅ Image 2: {s} ({d}x{d})\n\n", .{ path2, img2.cols(), img2.rows() });

    // Compute PHash
    var hasher = try cv.contrib.img_hash.ImgHashBase.createPHash();
    defer hasher.deinit();

    var hash1 = try cv.Mat.init();
    defer hash1.deinit();
    var hash2 = try cv.Mat.init();
    defer hash2.deinit();

    hasher.compute(img1, &hash1);
    hasher.compute(img2, &hash2);

    std.debug.print("📊 Hash 1 size: {d}x{d}\n", .{ hash1.rows(), hash1.cols() });
    std.debug.print("📊 Hash 2 size: {d}x{d}\n", .{ hash2.rows(), hash2.cols() });

    const distance = hasher.compare(hash1, hash2);
    std.debug.print("\n🔍 PHash distance: {d:.2}\n", .{distance});

    if (distance < 10.0) {
        std.debug.print("   → Images are VERY SIMILAR\n", .{});
    } else if (distance < 20.0) {
        std.debug.print("   → Images are SOMEWHAT SIMILAR\n", .{});
    } else {
        std.debug.print("   → Images are DIFFERENT\n", .{});
    }

    // Self-comparison
    var hash1_copy = try cv.Mat.init();
    defer hash1_copy.deinit();
    hasher.compute(img1, &hash1_copy);
    const self_distance = hasher.compare(hash1, hash1_copy);
    std.debug.print("\n🔍 Self-comparison distance: {d:.2} (should be 0)\n", .{self_distance});

    std.debug.print("\n🎉 Image hash demo complete!\n", .{});
}
