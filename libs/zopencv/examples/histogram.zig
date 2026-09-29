const std = @import("std");
const cv = @import("zopencv");

pub fn main() !void {
    std.debug.print("=== Histogram Example ===\n", .{});
    std.debug.print("Demonstrates histogram equalization and visualization\n\n", .{});

    const image_path = "testdata/images/lena.jpg";
    var img = cv.imgcodecs.imread(image_path, .color) catch {
        std.debug.print("❌ Failed to load: {s}\n", .{image_path});
        return;
    };
    defer img.deinit();
    std.debug.print("✅ Loaded: {s}\n", .{image_path});

    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    // Histogram Equalization
    var equalized = try cv.Mat.init();
    defer equalized.deinit();
    cv.imgproc.equalizeHist(gray, &equalized);

    try cv.imgcodecs.imwrite("examples/tmp/hist_original_gray.jpg", gray);
    try cv.imgcodecs.imwrite("examples/tmp/hist_equalized.jpg", equalized);
    std.debug.print("💾 Original gray → examples/tmp/hist_original_gray.jpg\n", .{});
    std.debug.print("💾 Equalized → examples/tmp/hist_equalized.jpg\n", .{});

    // Draw histogram visualizations
    const hist_orig = drawHistogram(gray);
    defer {
        var h = hist_orig;
        h.deinit();
    }
    try cv.imgcodecs.imwrite("examples/tmp/hist_plot_original.jpg", hist_orig);
    std.debug.print("💾 Histogram plot (original) → examples/tmp/hist_plot_original.jpg\n", .{});

    const hist_eq = drawHistogram(equalized);
    defer {
        var h = hist_eq;
        h.deinit();
    }
    try cv.imgcodecs.imwrite("examples/tmp/hist_plot_equalized.jpg", hist_eq);
    std.debug.print("💾 Histogram plot (equalized) → examples/tmp/hist_plot_equalized.jpg\n", .{});

    std.debug.print("\n🎉 Histogram operations complete!\n", .{});
}

fn drawHistogram(gray: cv.Mat) cv.Mat {
    const hist_w: i32 = 512;
    const hist_h: i32 = 400;
    var hist_img = cv.Mat.initWithSize(hist_h, hist_w, cv.core.CV_8UC3) catch unreachable;
    hist_img.setTo(cv.Scalar.init(255, 255, 255, 0));

    var bins: [256]u32 = [_]u32{0} ** 256;
    var max_val: u32 = 0;

    var r: i32 = 0;
    while (r < gray.rows()) : (r += 1) {
        var col: i32 = 0;
        while (col < gray.cols()) : (col += 1) {
            const val = gray.getUChar(r, col);
            bins[val] += 1;
            if (bins[val] > max_val) max_val = bins[val];
        }
    }

    if (max_val > 0) {
        const bin_w: f64 = @as(f64, @floatFromInt(hist_w)) / 256.0;
        for (0..256) |i| {
            const normalized_h: i32 = @intFromFloat(@as(f64, @floatFromInt(bins[i])) / @as(f64, @floatFromInt(max_val)) * @as(f64, @floatFromInt(hist_h - 20)));
            const x1: i32 = @intFromFloat(@as(f64, @floatFromInt(i)) * bin_w);
            const x2: i32 = @intFromFloat(@as(f64, @floatFromInt(i + 1)) * bin_w);
            cv.imgproc.rectangle(
                &hist_img,
                cv.Rect{ .x = x1, .y = hist_h - normalized_h, .width = x2 - x1, .height = normalized_h },
                cv.Scalar.init(200, 100, 50, 0),
                -1,
                8,
                0,
            );
        }
    }

    return hist_img;
}
