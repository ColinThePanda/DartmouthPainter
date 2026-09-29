const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// Test data paths
const test_image_lena = "testdata/images/lena.jpg";
const test_image_fruits = "testdata/images/fruits.jpg";
const test_image_box = "testdata/images/box.png";
const test_image_chessboard = "testdata/images/chessboard.png";

// ============================================================================
// Enum Tests (4 tests) - Keep original
// ============================================================================


test "imgproc: Gaussian blur on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var blurred = try cv.Mat.init();
    defer blurred.deinit();

    cv.imgproc.gaussianBlur(img, &blurred, cv.Size.init(5, 5), 1.5, 1.5, 0);

    try testing.expect(!blurred.empty());
    try testing.expectEqual(img.rows(), blurred.rows());
    try testing.expectEqual(img.cols(), blurred.cols());
    try testing.expectEqual(img.channels(), blurred.channels());
}

test "imgproc: Median blur on real image" {
    var img = try cv.imgcodecs.imread(test_image_fruits, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var blurred = try cv.Mat.init();
    defer blurred.deinit();

    cv.imgproc.medianBlur(img, &blurred, 5);

    try testing.expect(!blurred.empty());
    try testing.expectEqual(img.rows(), blurred.rows());
    try testing.expectEqual(img.cols(), blurred.cols());
}

test "imgproc: Bilateral filter on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var filtered = try cv.Mat.init();
    defer filtered.deinit();

    cv.imgproc.bilateralFilter(img, &filtered, 9, 75.0, 75.0, 0);

    try testing.expect(!filtered.empty());
    try testing.expectEqual(img.rows(), filtered.rows());
    try testing.expectEqual(img.cols(), filtered.cols());
}

test "imgproc: Canny edge detection on real image" {
    var img = try cv.imgcodecs.imread(test_image_box, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var edges = try cv.Mat.init();
    defer edges.deinit();

    cv.imgproc.canny(img, &edges, 50.0, 150.0, 3, false);

    try testing.expect(!edges.empty());
    try testing.expectEqual(img.rows(), edges.rows());
    try testing.expectEqual(img.cols(), edges.cols());
    try testing.expectEqual(@as(i32, 1), edges.channels());
}

test "imgproc: Sobel edge detection on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    var sobel_x = try cv.Mat.init();
    defer sobel_x.deinit();

    cv.imgproc.sobel(gray, &sobel_x, -1, 1, 0, 3, 1.0, 0.0, 0);

    try testing.expect(!sobel_x.empty());
    try testing.expectEqual(gray.rows(), sobel_x.rows());
    try testing.expectEqual(gray.cols(), sobel_x.cols());
}

test "imgproc: BGR to HSV on real image" {
    var img = try cv.imgcodecs.imread(test_image_fruits, .color);
    defer img.deinit();
    try testing.expect(!img.empty());
    try testing.expectEqual(@as(i32, 3), img.channels());

    var hsv = try cv.Mat.init();
    defer hsv.deinit();

    cv.imgproc.cvtColor(img, &hsv, .bgr2hsv);

    try testing.expect(!hsv.empty());
    try testing.expectEqual(img.rows(), hsv.rows());
    try testing.expectEqual(img.cols(), hsv.cols());
    try testing.expectEqual(@as(i32, 3), hsv.channels());
}

test "imgproc: BGR to Gray on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());
    try testing.expectEqual(@as(i32, 3), img.channels());

    var gray = try cv.Mat.init();
    defer gray.deinit();

    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    try testing.expect(!gray.empty());
    try testing.expectEqual(img.rows(), gray.rows());
    try testing.expectEqual(img.cols(), gray.cols());
    try testing.expectEqual(@as(i32, 1), gray.channels());
}

test "imgproc: Erosion and dilation on real image" {
    var img = try cv.imgcodecs.imread(test_image_box, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var kernel = try cv.imgproc.getStructuringElement(.rect, cv.Size.init(5, 5), cv.Point.init(-1, -1));
    defer kernel.deinit();

    var eroded = try cv.Mat.init();
    defer eroded.deinit();
    cv.imgproc.erode(img, &eroded, kernel, cv.Point.init(-1, -1), 1, 0);

    var dilated = try cv.Mat.init();
    defer dilated.deinit();
    cv.imgproc.dilate(eroded, &dilated, kernel, cv.Point.init(-1, -1), 1, 0);

    try testing.expect(!eroded.empty());
    try testing.expect(!dilated.empty());
}

test "imgproc: Morphological opening on real image" {
    var img = try cv.imgcodecs.imread(test_image_chessboard, .grayscale);
    defer img.deinit();
    try testing.expect(!img.empty());

    var kernel = try cv.imgproc.getStructuringElement(.rect, cv.Size.init(5, 5), cv.Point.init(-1, -1));
    defer kernel.deinit();

    var opened = try cv.Mat.init();
    defer opened.deinit();

    cv.imgproc.morphologyEx(img, &opened, .open, kernel, cv.Point.init(-1, -1), 1, 0);

    try testing.expect(!opened.empty());
    try testing.expectEqual(img.rows(), opened.rows());
    try testing.expectEqual(img.cols(), opened.cols());
}

test "imgproc: Adaptive threshold on real image" {
    var img = try cv.imgcodecs.imread(test_image_lena, .color);
    defer img.deinit();
    try testing.expect(!img.empty());

    var gray = try cv.Mat.init();
    defer gray.deinit();
    cv.imgproc.cvtColor(img, &gray, .bgr2gray);

    var thresh = try cv.Mat.init();
    defer thresh.deinit();

    cv.imgproc.adaptiveThreshold(gray, &thresh, 255.0, 0, .binary, 11, 2.0);

    try testing.expect(!thresh.empty());
    try testing.expectEqual(gray.rows(), thresh.rows());
    try testing.expectEqual(gray.cols(), thresh.cols());
    try testing.expectEqual(@as(i32, 1), thresh.channels());
}
