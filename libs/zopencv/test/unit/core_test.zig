const std = @import("std");
const testing = std.testing;
const cv = @import("zopencv");

// ============================================================================
// Version and Basic Tests
// ============================================================================

test "core: OpenCV version" {
    const version = cv.getVersion();
    try testing.expect(version.len > 0);
    try testing.expect(std.mem.startsWith(u8, version, "4."));
}

// ============================================================================
// Mat Creation Tests (10 tests)
// ============================================================================

test "core: Mat empty creation" {
    var mat = try cv.Mat.init();
    defer mat.deinit();
    try testing.expect(mat.empty());
}

test "core: Mat with size CV_8UC1" {
    var mat = try cv.Mat.initWithSize(3, 3, 0); // CV_8UC1
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 3), mat.rows());
    try testing.expectEqual(@as(i32, 3), mat.cols());
    try testing.expectEqual(@as(i32, 1), mat.channels());
}

test "core: Mat with size CV_8UC3" {
    var mat = try cv.Mat.initWithSize(100, 200, 16); // CV_8UC3
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 100), mat.rows());
    try testing.expectEqual(@as(i32, 200), mat.cols());
    try testing.expectEqual(@as(i32, 3), mat.channels());
}

test "core: Mat with size CV_32FC1" {
    var mat = try cv.Mat.initWithSize(50, 50, 5); // CV_32FC1
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 1), mat.channels());
}

// ============================================================================
// Mat Static Construction Tests (6 tests) - NEW
// ============================================================================

test "core: Mat.zeros CV_8UC1" {
    var mat = try cv.Mat.zeros(3, 3, 0); // CV_8UC1
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 3), mat.rows());
    try testing.expectEqual(@as(i32, 3), mat.cols());
    try testing.expectEqual(@as(i32, 1), mat.channels());

    // Verify all elements are zero
    try testing.expectEqual(@as(u8, 0), mat.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 0), mat.getUChar(1, 1));
    try testing.expectEqual(@as(u8, 0), mat.getUChar(2, 2));
}

test "core: Mat.zeros CV_64F" {
    var mat = try cv.Mat.zeros(4, 4, 6); // CV_64F
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 4), mat.rows());
    try testing.expectEqual(@as(i32, 4), mat.cols());

    // Verify all elements are zero
    try testing.expectEqual(@as(f64, 0.0), mat.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 0.0), mat.getDouble(2, 2));
}

test "core: Mat.ones CV_8UC1" {
    var mat = try cv.Mat.ones(3, 3, 0); // CV_8UC1
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 3), mat.rows());
    try testing.expectEqual(@as(i32, 3), mat.cols());

    // Verify all elements are one
    try testing.expectEqual(@as(u8, 1), mat.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 1), mat.getUChar(1, 1));
    try testing.expectEqual(@as(u8, 1), mat.getUChar(2, 2));
}

test "core: Mat.ones CV_64F" {
    var mat = try cv.Mat.ones(4, 4, 6); // CV_64F
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 4), mat.rows());
    try testing.expectEqual(@as(i32, 4), mat.cols());

    // Verify all elements are one
    try testing.expectEqual(@as(f64, 1.0), mat.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 1.0), mat.getDouble(2, 2));
}

test "core: Mat.eye CV_8UC1" {
    var mat = try cv.Mat.eye(3, 3, 0); // CV_8UC1
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 3), mat.rows());
    try testing.expectEqual(@as(i32, 3), mat.cols());

    // Verify diagonal elements are 1, others are 0
    try testing.expectEqual(@as(u8, 1), mat.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 0), mat.getUChar(0, 1));
    try testing.expectEqual(@as(u8, 1), mat.getUChar(1, 1));
    try testing.expectEqual(@as(u8, 0), mat.getUChar(1, 2));
    try testing.expectEqual(@as(u8, 1), mat.getUChar(2, 2));
}

test "core: Mat.eye CV_64F" {
    var mat = try cv.Mat.eye(4, 4, 6); // CV_64F
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(i32, 4), mat.rows());
    try testing.expectEqual(@as(i32, 4), mat.cols());

    // Verify diagonal elements are 1.0, others are 0.0
    try testing.expectEqual(@as(f64, 1.0), mat.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 0.0), mat.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 1.0), mat.getDouble(1, 1));
    try testing.expectEqual(@as(f64, 0.0), mat.getDouble(1, 2));
    try testing.expectEqual(@as(f64, 1.0), mat.getDouble(3, 3));
}

// ============================================================================
// Mat Element Operations Tests (8 tests) - Phase 2
// ============================================================================

test "core: Mat.setTo" {
    var mat = try cv.Mat.initWithSize(3, 3, 6); // CV_64F
    defer mat.deinit();

    const scalar = cv.Scalar.init(5.0, 0.0, 0.0, 0.0);
    mat.setTo(scalar);

    // Verify all elements are set to 5.0
    try testing.expectEqual(@as(f64, 5.0), mat.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 5.0), mat.getDouble(1, 1));
    try testing.expectEqual(@as(f64, 5.0), mat.getDouble(2, 2));
}

test "core: Mat.reshape" {
    var mat = try cv.Mat.initWithSize(2, 6, 0); // 2x6 CV_8UC1
    defer mat.deinit();

    var reshaped = try mat.reshape(1, 3); // Reshape to 3x4
    defer reshaped.deinit();

    try testing.expectEqual(@as(i32, 3), reshaped.rows());
    try testing.expectEqual(@as(i32, 4), reshaped.cols());
}

test "core: Mat.t transpose" {
    var mat = try cv.Mat.initWithSize(2, 3, 6); // 2x3 CV_64F
    defer mat.deinit();

    // Set some values
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(0, 1, 2.0);
    mat.setDouble(1, 0, 3.0);

    var transposed = try mat.t();
    defer transposed.deinit();

    // Verify dimensions are swapped
    try testing.expectEqual(@as(i32, 3), transposed.rows());
    try testing.expectEqual(@as(i32, 2), transposed.cols());

    // Verify values are transposed
    try testing.expectEqual(@as(f64, 1.0), transposed.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 3.0), transposed.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 2.0), transposed.getDouble(1, 0));
}

test "core: Mat.inv inverse" {
    var mat = try cv.Mat.eye(3, 3, 6); // 3x3 identity CV_64F
    defer mat.deinit();

    var inverted = try mat.inv(0); // DECOMP_LU = 0
    defer inverted.deinit();

    // Inverse of identity is identity
    try testing.expectEqual(@as(f64, 1.0), inverted.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 0.0), inverted.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 1.0), inverted.getDouble(1, 1));
}

test "core: Mat.mul element-wise multiplication" {
    var mat1 = try cv.Mat.ones(2, 2, 6); // CV_64F
    defer mat1.deinit();
    mat1.setDouble(0, 0, 2.0);
    mat1.setDouble(1, 1, 3.0);

    var mat2 = try cv.Mat.ones(2, 2, 6);
    defer mat2.deinit();
    mat2.setDouble(0, 0, 4.0);
    mat2.setDouble(1, 1, 5.0);

    var result = try mat1.mul(mat2, 1.0);
    defer result.deinit();

    // Element-wise: 2*4=8, 3*5=15, others 1*1=1
    try testing.expectEqual(@as(f64, 8.0), result.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 15.0), result.getDouble(1, 1));
}

test "core: Mat.dot product" {
    var mat1 = try cv.Mat.initWithSize(3, 1, 6); // 3x1 CV_64F
    defer mat1.deinit();
    mat1.setDouble(0, 0, 1.0);
    mat1.setDouble(1, 0, 2.0);
    mat1.setDouble(2, 0, 3.0);

    var mat2 = try cv.Mat.initWithSize(3, 1, 6);
    defer mat2.deinit();
    mat2.setDouble(0, 0, 4.0);
    mat2.setDouble(1, 0, 5.0);
    mat2.setDouble(2, 0, 6.0);

    const dot_product = mat1.dot(mat2);

    // 1*4 + 2*5 + 3*6 = 4 + 10 + 18 = 32
    try testing.expectEqual(@as(f64, 32.0), dot_product);
}

test "core: Mat.cross product" {
    var mat1 = try cv.Mat.initWithSize(1, 3, 6); // 1x3 CV_64F (3D vector)
    defer mat1.deinit();
    mat1.setDouble(0, 0, 1.0);
    mat1.setDouble(0, 1, 0.0);
    mat1.setDouble(0, 2, 0.0);

    var mat2 = try cv.Mat.initWithSize(1, 3, 6);
    defer mat2.deinit();
    mat2.setDouble(0, 0, 0.0);
    mat2.setDouble(0, 1, 1.0);
    mat2.setDouble(0, 2, 0.0);

    var result = try mat1.cross(mat2);
    defer result.deinit();

    // Cross product of (1,0,0) x (0,1,0) = (0,0,1)
    try testing.expectEqual(@as(f64, 0.0), result.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 0.0), result.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 1.0), result.getDouble(0, 2));
}

test "core: Mat.setToMask with mask" {
    var mat = try cv.Mat.zeros(3, 3, 0); // CV_8UC1
    defer mat.deinit();

    var mask = try cv.Mat.zeros(3, 3, 0);
    defer mask.deinit();
    // Set mask center to 255 (only center element should be set)
    mask.setUChar(1, 1, 255);

    const scalar = cv.Scalar.init(100.0, 0.0, 0.0, 0.0);
    mat.setToMask(scalar, mask);

    // Only center should be 100, others should be 0
    try testing.expectEqual(@as(u8, 0), mat.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 100), mat.getUChar(1, 1));
    try testing.expectEqual(@as(u8, 0), mat.getUChar(2, 2));
}

// ============================================================================
// Mat ROI/Slicing Tests (6 tests) - Phase 3
// ============================================================================

test "core: Mat.rowAt" {
    var mat = try cv.Mat.initWithSize(3, 4, 6); // 3x4 CV_64F
    defer mat.deinit();

    // Set values in row 1
    mat.setDouble(1, 0, 10.0);
    mat.setDouble(1, 1, 20.0);
    mat.setDouble(1, 2, 30.0);
    mat.setDouble(1, 3, 40.0);

    var row1 = try mat.rowAt(1);
    defer row1.deinit();

    // Row should be 1x4
    try testing.expectEqual(@as(i32, 1), row1.rows());
    try testing.expectEqual(@as(i32, 4), row1.cols());

    // Verify values
    try testing.expectEqual(@as(f64, 10.0), row1.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 20.0), row1.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 30.0), row1.getDouble(0, 2));
    try testing.expectEqual(@as(f64, 40.0), row1.getDouble(0, 3));
}

test "core: Mat.colAt" {
    var mat = try cv.Mat.initWithSize(4, 3, 6); // 4x3 CV_64F
    defer mat.deinit();

    // Set values in column 1
    mat.setDouble(0, 1, 10.0);
    mat.setDouble(1, 1, 20.0);
    mat.setDouble(2, 1, 30.0);
    mat.setDouble(3, 1, 40.0);

    var col1 = try mat.colAt(1);
    defer col1.deinit();

    // Column should be 4x1
    try testing.expectEqual(@as(i32, 4), col1.rows());
    try testing.expectEqual(@as(i32, 1), col1.cols());

    // Verify values
    try testing.expectEqual(@as(f64, 10.0), col1.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 20.0), col1.getDouble(1, 0));
    try testing.expectEqual(@as(f64, 30.0), col1.getDouble(2, 0));
    try testing.expectEqual(@as(f64, 40.0), col1.getDouble(3, 0));
}

test "core: Mat.rowRange" {
    var mat = try cv.Mat.initWithSize(5, 3, 6); // 5x3 CV_64F
    defer mat.deinit();

    // Set values in rows 1-3
    mat.setDouble(1, 0, 11.0);
    mat.setDouble(2, 0, 22.0);
    mat.setDouble(3, 0, 33.0);

    var range = try mat.rowRange(1, 4); // Rows 1, 2, 3 (end is exclusive)
    defer range.deinit();

    // Should be 3x3
    try testing.expectEqual(@as(i32, 3), range.rows());
    try testing.expectEqual(@as(i32, 3), range.cols());

    // Verify values (indices relative to submatrix)
    try testing.expectEqual(@as(f64, 11.0), range.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 22.0), range.getDouble(1, 0));
    try testing.expectEqual(@as(f64, 33.0), range.getDouble(2, 0));
}

test "core: Mat.colRange" {
    var mat = try cv.Mat.initWithSize(3, 5, 6); // 3x5 CV_64F
    defer mat.deinit();

    // Set values in columns 1-3
    mat.setDouble(0, 1, 11.0);
    mat.setDouble(0, 2, 22.0);
    mat.setDouble(0, 3, 33.0);

    var range = try mat.colRange(1, 4); // Columns 1, 2, 3 (end is exclusive)
    defer range.deinit();

    // Should be 3x3
    try testing.expectEqual(@as(i32, 3), range.rows());
    try testing.expectEqual(@as(i32, 3), range.cols());

    // Verify values
    try testing.expectEqual(@as(f64, 11.0), range.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 22.0), range.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 33.0), range.getDouble(0, 2));
}

test "core: Mat.submat with Rect" {
    var mat = try cv.Mat.initWithSize(5, 5, 6); // 5x5 CV_64F
    defer mat.deinit();

    // Set a value in the ROI area
    mat.setDouble(2, 2, 99.0);

    // Extract 2x2 submatrix starting at (1, 1)
    const roi = cv.Rect.init(1, 1, 2, 2);
    var sub = try mat.submat(roi);
    defer sub.deinit();

    // Should be 2x2
    try testing.expectEqual(@as(i32, 2), sub.rows());
    try testing.expectEqual(@as(i32, 2), sub.cols());

    // Value at (2,2) in original is at (1,1) in submatrix
    try testing.expectEqual(@as(f64, 99.0), sub.getDouble(1, 1));
}

test "core: Mat.submatRanges" {
    var mat = try cv.Mat.initWithSize(5, 5, 6); // 5x5 CV_64F
    defer mat.deinit();

    // Set values in the range area
    mat.setDouble(1, 1, 11.0);
    mat.setDouble(2, 2, 22.0);

    // Extract submatrix: rows [1,3), cols [1,3) -> 2x2 matrix
    var sub = try mat.submatRanges(1, 3, 1, 3);
    defer sub.deinit();

    // Should be 2x2
    try testing.expectEqual(@as(i32, 2), sub.rows());
    try testing.expectEqual(@as(i32, 2), sub.cols());

    // Verify values (indices relative to submatrix)
    try testing.expectEqual(@as(f64, 11.0), sub.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 22.0), sub.getDouble(1, 1));
}

test "core: Mat with size CV_32FC3" {
    var mat = try cv.Mat.initWithSize(64, 64, 21); // CV_32FC3
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 3), mat.channels());
}

test "core: Mat large size" {
    var mat = try cv.Mat.initWithSize(1000, 1000, 0);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 1000), mat.rows());
    try testing.expectEqual(@as(i32, 1000), mat.cols());
}

test "core: Mat small size" {
    var mat = try cv.Mat.initWithSize(1, 1, 0);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 1), mat.rows());
    try testing.expectEqual(@as(i32, 1), mat.cols());
}

test "core: Mat rectangular" {
    var mat = try cv.Mat.initWithSize(100, 300, 16);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 100), mat.rows());
    try testing.expectEqual(@as(i32, 300), mat.cols());
}

test "core: Mat from bytes" {
    var data: [100]u8 = undefined;
    for (&data, 0..) |*byte, i| {
        byte.* = @intCast(i);
    }

    var mat = try cv.Mat.initFromBytes(10, 10, 0, &data, 10);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 10), mat.rows());
    try testing.expectEqual(@as(i32, 10), mat.cols());
}

test "core: Mat type CV_8UC4" {
    var mat = try cv.Mat.initWithSize(50, 50, 24); // CV_8UC4
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 4), mat.channels());
}

// ============================================================================
// Mat Properties Tests (8 tests)
// ============================================================================

test "core: Mat total elements" {
    var mat = try cv.Mat.initWithSize(10, 20, 0);
    defer mat.deinit();

    try testing.expectEqual(@as(usize, 200), mat.total());
}

test "core: Mat element size CV_8UC1" {
    var mat = try cv.Mat.initWithSize(10, 10, 0);
    defer mat.deinit();

    try testing.expectEqual(@as(usize, 1), mat.elemSize());
}

test "core: Mat element size CV_8UC3" {
    var mat = try cv.Mat.initWithSize(10, 10, 16);
    defer mat.deinit();

    try testing.expectEqual(@as(usize, 3), mat.elemSize());
}

test "core: Mat step size" {
    var mat = try cv.Mat.initWithSize(10, 10, 16); // CV_8UC3
    defer mat.deinit();

    const step_size = mat.step();
    try testing.expect(step_size >= 30); // At least 10 cols * 3 channels
}

test "core: Mat depth CV_8U" {
    var mat = try cv.Mat.initWithSize(10, 10, 0);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 0), mat.depth()); // CV_8U = 0
}

test "core: Mat depth CV_32F" {
    var mat = try cv.Mat.initWithSize(10, 10, 5);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 5), mat.depth()); // CV_32F = 5
}

test "core: Mat type value" {
    var mat = try cv.Mat.initWithSize(10, 10, 16);
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 16), mat.matType());
}

test "core: Mat data pointer" {
    var mat = try cv.Mat.initWithSize(10, 10, 0);
    defer mat.deinit();

    const data_ptr = mat.data();
    _ = data_ptr; // Verify pointer is accessible
}

// ============================================================================
// Mat Operations Tests (12 tests)
// ============================================================================

test "core: Mat clone creates independent copy" {
    var mat1 = try cv.Mat.initWithSize(5, 5, 0);
    defer mat1.deinit();

    var mat2 = try mat1.clone();
    defer mat2.deinit();

    try testing.expectEqual(mat1.rows(), mat2.rows());
    try testing.expectEqual(mat1.cols(), mat2.cols());
    try testing.expectEqual(mat1.channels(), mat2.channels());
}

test "core: Mat copyTo" {
    var src = try cv.Mat.initWithSize(10, 10, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    src.copyTo(&dst);

    try testing.expectEqual(src.rows(), dst.rows());
    try testing.expectEqual(src.cols(), dst.cols());
}

test "core: Mat convertTo same type" {
    var src = try cv.Mat.initWithSize(10, 10, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    src.convertTo(&dst, 0, 1.0, 0.0);

    try testing.expectEqual(src.rows(), dst.rows());
}

test "core: Mat convertTo with scaling" {
    var src = try cv.Mat.initWithSize(10, 10, 0);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    src.convertTo(&dst, 0, 2.0, 10.0); // dst = src * 2.0 + 10.0

    try testing.expect(!dst.empty());
}

test "core: Mat getUChar and setUChar" {
    var mat = try cv.Mat.initWithSize(5, 5, 0);
    defer mat.deinit();

    mat.setUChar(2, 3, 255);
    const val = mat.getUChar(2, 3);

    try testing.expectEqual(@as(u8, 255), val);
}

test "core: Mat getInt and setInt" {
    var mat = try cv.Mat.initWithSize(5, 5, 4); // CV_32SC1
    defer mat.deinit();

    mat.setInt(1, 2, 12345);
    const val = mat.getInt(1, 2);

    try testing.expectEqual(@as(i32, 12345), val);
}

test "core: Mat getFloat and setFloat" {
    var mat = try cv.Mat.initWithSize(5, 5, 5); // CV_32FC1
    defer mat.deinit();

    mat.setFloat(0, 0, 3.14159);
    const val = mat.getFloat(0, 0);

    try testing.expectApproxEqAbs(@as(f32, 3.14159), val, 0.0001);
}

test "core: Mat getDouble and setDouble" {
    var mat = try cv.Mat.initWithSize(5, 5, 6); // CV_64FC1
    defer mat.deinit();

    mat.setDouble(4, 4, 2.71828);
    const val = mat.getDouble(4, 4);

    try testing.expectApproxEqAbs(@as(f64, 2.71828), val, 0.00001);
}

test "core: Mat multiple element access" {
    var mat = try cv.Mat.initWithSize(10, 10, 0);
    defer mat.deinit();

    // Set diagonal
    var i: i32 = 0;
    while (i < 10) : (i += 1) {
        mat.setUChar(i, i, @intCast(i * 10));
    }

    // Verify diagonal
    i = 0;
    while (i < 10) : (i += 1) {
        const val = mat.getUChar(i, i);
        try testing.expectEqual(@as(u8, @intCast(i * 10)), val);
    }
}

test "core: Mat clone preserves data" {
    var mat1 = try cv.Mat.initWithSize(3, 3, 0);
    defer mat1.deinit();

    mat1.setUChar(1, 1, 100);

    var mat2 = try mat1.clone();
    defer mat2.deinit();

    const val = mat2.getUChar(1, 1);
    try testing.expectEqual(@as(u8, 100), val);
}

test "core: Mat copyTo preserves data" {
    var src = try cv.Mat.initWithSize(5, 5, 0);
    defer src.deinit();

    src.setUChar(2, 2, 200);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    src.copyTo(&dst);

    const val = dst.getUChar(2, 2);
    try testing.expectEqual(@as(u8, 200), val);
}

test "core: Mat different types" {
    const types = [_]i32{ 0, 5, 6, 16, 21 }; // CV_8UC1, CV_32FC1, CV_64FC1, CV_8UC3, CV_32FC3

    for (types) |mat_type| {
        var mat = try cv.Mat.initWithSize(10, 10, mat_type);
        defer mat.deinit();

        try testing.expect(!mat.empty());
    }
}

// ============================================================================
// Basic Data Types Tests (8 tests)
// ============================================================================

test "core: Point creation" {
    const p = cv.Point.init(10, 20);
    try testing.expectEqual(@as(i32, 10), p.x);
    try testing.expectEqual(@as(i32, 20), p.y);
}

test "core: Point negative coordinates" {
    const p = cv.Point.init(-5, -10);
    try testing.expectEqual(@as(i32, -5), p.x);
    try testing.expectEqual(@as(i32, -10), p.y);
}

test "core: Point2f creation" {
    const p = cv.Point2f.init(1.5, 2.5);
    try testing.expectEqual(@as(f32, 1.5), p.x);
    try testing.expectEqual(@as(f32, 2.5), p.y);
}

test "core: Point2f fractional coordinates" {
    const p = cv.Point2f.init(3.14159, 2.71828);
    try testing.expectApproxEqAbs(@as(f32, 3.14159), p.x, 0.0001);
    try testing.expectApproxEqAbs(@as(f32, 2.71828), p.y, 0.0001);
}

test "core: Rect creation" {
    const r = cv.Rect.init(10, 20, 30, 40);
    try testing.expectEqual(@as(i32, 10), r.x);
    try testing.expectEqual(@as(i32, 20), r.y);
    try testing.expectEqual(@as(i32, 30), r.width);
    try testing.expectEqual(@as(i32, 40), r.height);
}

test "core: Size creation" {
    const s = cv.Size.init(640, 480);
    try testing.expectEqual(@as(i32, 640), s.width);
    try testing.expectEqual(@as(i32, 480), s.height);
}

test "core: Scalar creation" {
    const s = cv.Scalar.init(255, 128, 64, 32);
    try testing.expectEqual(@as(f64, 255), s.val1);
    try testing.expectEqual(@as(f64, 128), s.val2);
    try testing.expectEqual(@as(f64, 64), s.val3);
    try testing.expectEqual(@as(f64, 32), s.val4);
}

test "core: Scalar all" {
    const s = cv.Scalar.all(100);
    try testing.expectEqual(@as(f64, 100), s.val1);
    try testing.expectEqual(@as(f64, 100), s.val2);
    try testing.expectEqual(@as(f64, 100), s.val3);
    try testing.expectEqual(@as(f64, 100), s.val4);
}

// ============================================================================
// Edge Cases and Error Handling (6 tests)
// ============================================================================

test "core: Mat empty check" {
    var mat = try cv.Mat.init();
    defer mat.deinit();

    try testing.expect(mat.empty());

    var mat2 = try cv.Mat.initWithSize(10, 10, 0);
    defer mat2.deinit();

    try testing.expect(!mat2.empty());
}

test "core: Mat zero size dimensions" {
    var mat = try cv.Mat.init();
    defer mat.deinit();

    try testing.expectEqual(@as(i32, 0), mat.rows());
    try testing.expectEqual(@as(i32, 0), mat.cols());
}

test "core: Mat single pixel" {
    var mat = try cv.Mat.initWithSize(1, 1, 0);
    defer mat.deinit();

    mat.setUChar(0, 0, 42);
    const val = mat.getUChar(0, 0);

    try testing.expectEqual(@as(u8, 42), val);
}

test "core: Mat boundary access" {
    var mat = try cv.Mat.initWithSize(10, 10, 0);
    defer mat.deinit();

    // Access corners
    mat.setUChar(0, 0, 1);
    mat.setUChar(0, 9, 2);
    mat.setUChar(9, 0, 3);
    mat.setUChar(9, 9, 4);

    try testing.expectEqual(@as(u8, 1), mat.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 2), mat.getUChar(0, 9));
    try testing.expectEqual(@as(u8, 3), mat.getUChar(9, 0));
    try testing.expectEqual(@as(u8, 4), mat.getUChar(9, 9));
}

test "core: Mat large allocation" {
    var mat = try cv.Mat.initWithSize(2000, 2000, 16); // 12MB
    defer mat.deinit();

    try testing.expect(!mat.empty());
    try testing.expectEqual(@as(usize, 4000000), mat.total());
}

test "core: Mat multiple sequential operations" {
    var mat1 = try cv.Mat.initWithSize(10, 10, 0);
    defer mat1.deinit();

    var mat2 = try mat1.clone();
    defer mat2.deinit();

    var mat3 = try cv.Mat.init();
    defer mat3.deinit();

    mat2.copyTo(&mat3);

    try testing.expectEqual(mat1.rows(), mat3.rows());
    try testing.expectEqual(mat1.cols(), mat3.cols());
}

// ============================================================================
// Matrix Arithmetic Operations Tests (12 tests) - Phase 4
// ============================================================================

test "core: add matrices" {
    var src1 = try cv.Mat.ones(2, 2, 6); // CV_64F
    defer src1.deinit();
    var src2 = try cv.Mat.ones(2, 2, 6);
    defer src2.deinit();
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.add(src1, src2, &dst);

    // 1 + 1 = 2
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(1, 1));
}

test "core: subtract matrices" {
    var src1 = try cv.Mat.ones(2, 2, 6);
    defer src1.deinit();
    var src2 = try cv.Mat.ones(2, 2, 6);
    defer src2.deinit();
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.subtract(src1, src2, &dst);

    // 1 - 1 = 0
    try testing.expectEqual(@as(f64, 0.0), dst.getDouble(0, 0));
}

test "core: multiply matrices element-wise" {
    var src1 = try cv.Mat.ones(2, 2, 6);
    defer src1.deinit();
    src1.setDouble(0, 0, 3.0);
    var src2 = try cv.Mat.ones(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 4.0);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.multiply(src1, src2, &dst);

    // 3 * 4 = 12
    try testing.expectEqual(@as(f64, 12.0), dst.getDouble(0, 0));
}

test "core: divide matrices element-wise" {
    var src1 = try cv.Mat.ones(2, 2, 6);
    defer src1.deinit();
    src1.setDouble(0, 0, 8.0);
    var src2 = try cv.Mat.ones(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 2.0);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.divide(src1, src2, &dst);

    // 8 / 2 = 4
    try testing.expectEqual(@as(f64, 4.0), dst.getDouble(0, 0));
}

test "core: bitwise AND" {
    var src1 = try cv.Mat.initWithSize(2, 2, 0); // CV_8UC1
    defer src1.deinit();
    src1.setUChar(0, 0, 0xFF);
    var src2 = try cv.Mat.initWithSize(2, 2, 0);
    defer src2.deinit();
    src2.setUChar(0, 0, 0x0F);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.bitwiseAnd(src1, src2, &dst);

    // 0xFF & 0x0F = 0x0F
    try testing.expectEqual(@as(u8, 0x0F), dst.getUChar(0, 0));
}

test "core: bitwise OR" {
    var src1 = try cv.Mat.initWithSize(2, 2, 0);
    defer src1.deinit();
    src1.setUChar(0, 0, 0xF0);
    var src2 = try cv.Mat.initWithSize(2, 2, 0);
    defer src2.deinit();
    src2.setUChar(0, 0, 0x0F);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.bitwiseOr(src1, src2, &dst);

    // 0xF0 | 0x0F = 0xFF
    try testing.expectEqual(@as(u8, 0xFF), dst.getUChar(0, 0));
}

test "core: bitwise XOR" {
    var src1 = try cv.Mat.initWithSize(2, 2, 0);
    defer src1.deinit();
    src1.setUChar(0, 0, 0xFF);
    var src2 = try cv.Mat.initWithSize(2, 2, 0);
    defer src2.deinit();
    src2.setUChar(0, 0, 0x0F);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.bitwiseXor(src1, src2, &dst);

    // 0xFF ^ 0x0F = 0xF0
    try testing.expectEqual(@as(u8, 0xF0), dst.getUChar(0, 0));
}

test "core: bitwise NOT" {
    var src = try cv.Mat.initWithSize(2, 2, 0);
    defer src.deinit();
    src.setUChar(0, 0, 0x0F);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.bitwiseNot(src, &dst);

    // ~0x0F = 0xF0
    try testing.expectEqual(@as(u8, 0xF0), dst.getUChar(0, 0));
}

test "core: compare matrices" {
    var src1 = try cv.Mat.initWithSize(2, 2, 6); // CV_64F
    defer src1.deinit();
    src1.setDouble(0, 0, 5.0);
    src1.setDouble(0, 1, 1.0);
    src1.setDouble(1, 0, 3.0);
    src1.setDouble(1, 1, 2.0);

    var src2 = try cv.Mat.initWithSize(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 3.0);
    src2.setDouble(0, 1, 2.0);
    src2.setDouble(1, 0, 3.0);
    src2.setDouble(1, 1, 4.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.compare(src1, src2, &dst, 2); // CMP_GT = 2

    // Verify basic functionality: 5 > 3 should be 255 (true)
    try testing.expectEqual(@as(u8, 255), dst.getUChar(0, 0));
}

test "core: inRange" {
    var src = try cv.Mat.initWithSize(3, 3, 0);
    defer src.deinit();
    src.setUChar(0, 0, 50);
    src.setUChar(1, 1, 150);
    src.setUChar(2, 2, 250);

    const lower = cv.Scalar.init(100.0, 0.0, 0.0, 0.0);
    const upper = cv.Scalar.init(200.0, 0.0, 0.0, 0.0);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.inRange(src, lower, upper, &dst);

    // 50 not in range = 0, 150 in range = 255, 250 not in range = 0
    try testing.expectEqual(@as(u8, 0), dst.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 255), dst.getUChar(1, 1));
    try testing.expectEqual(@as(u8, 0), dst.getUChar(2, 2));
}

test "core: addWeighted" {
    var src1 = try cv.Mat.ones(2, 2, 6);
    defer src1.deinit();
    src1.setDouble(0, 0, 10.0);
    var src2 = try cv.Mat.ones(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 20.0);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.addWeighted(src1, 0.5, src2, 0.5, 0.0, &dst);

    // 10*0.5 + 20*0.5 + 0 = 15
    try testing.expectEqual(@as(f64, 15.0), dst.getDouble(0, 0));
}

test "core: absdiff" {
    var src1 = try cv.Mat.ones(2, 2, 6);
    defer src1.deinit();
    src1.setDouble(0, 0, 10.0);
    var src2 = try cv.Mat.ones(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 7.0);
    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.absdiff(src1, src2, &dst);

    // |10 - 7| = 3
    try testing.expectEqual(@as(f64, 3.0), dst.getDouble(0, 0));
}

// ============================================================================
// Math and Reduction Operations Tests (13 tests) - Phase 5
// ============================================================================

test "core: norm" {
    var mat = try cv.Mat.initWithSize(3, 3, 6); // CV_64F
    defer mat.deinit();
    mat.setDouble(0, 0, 3.0);
    mat.setDouble(0, 1, 4.0);

    const n = cv.norm(mat, 2); // NORM_L2 = 2

    // Verify norm is positive (exact value depends on uninitialized elements)
    try testing.expect(n > 0.0);
}

test "core: normalize" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, 1.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(1, 0, 3.0);
    src.setDouble(1, 1, 4.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.normalize(src, &dst, 0.0, 1.0, 32); // NORM_MINMAX = 32

    // After normalization to [0,1], min should be 0, max should be 1
    var minVal: f64 = 0;
    var maxVal: f64 = 0;
    cv.minMaxLoc(dst, &minVal, &maxVal, null, null);
    try testing.expectEqual(@as(f64, 0.0), minVal);
    try testing.expectEqual(@as(f64, 1.0), maxVal);
}

test "core: sum" {
    var mat = try cv.Mat.initWithSize(2, 2, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(0, 1, 2.0);
    mat.setDouble(1, 0, 3.0);
    mat.setDouble(1, 1, 4.0);

    const s = cv.sum(mat);

    // Sum = 1 + 2 + 3 + 4 = 10
    try testing.expectEqual(@as(f64, 10.0), s.val1);
}

test "core: mean" {
    var mat = try cv.Mat.initWithSize(2, 2, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 2.0);
    mat.setDouble(0, 1, 4.0);
    mat.setDouble(1, 0, 6.0);
    mat.setDouble(1, 1, 8.0);

    const m = cv.mean(mat);

    // Mean = (2 + 4 + 6 + 8) / 4 = 5
    try testing.expectEqual(@as(f64, 5.0), m.val1);
}

test "core: meanStdDev" {
    var mat = try cv.Mat.initWithSize(2, 2, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 2.0);
    mat.setDouble(0, 1, 4.0);
    mat.setDouble(1, 0, 4.0);
    mat.setDouble(1, 1, 6.0);

    var mean_val: cv.Scalar = undefined;
    var stddev_val: cv.Scalar = undefined;
    cv.meanStdDev(mat, &mean_val, &stddev_val);

    // Mean = (2 + 4 + 4 + 6) / 4 = 4
    try testing.expectEqual(@as(f64, 4.0), mean_val.val1);
    // StdDev should be > 0
    try testing.expect(stddev_val.val1 > 0.0);
}

test "core: minMaxLoc" {
    var mat = try cv.Mat.initWithSize(3, 3, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 5.0);
    mat.setDouble(1, 1, 1.0);
    mat.setDouble(2, 2, 9.0);

    var minVal: f64 = 0;
    var maxVal: f64 = 0;
    var minLoc: cv.Point = undefined;
    var maxLoc: cv.Point = undefined;
    cv.minMaxLoc(mat, &minVal, &maxVal, &minLoc, &maxLoc);

    try testing.expectEqual(@as(f64, 0.0), minVal); // Uninitialized elements are 0
    try testing.expectEqual(@as(f64, 9.0), maxVal);
    try testing.expectEqual(@as(i32, 2), maxLoc.x);
    try testing.expectEqual(@as(i32, 2), maxLoc.y);
}

test "core: reduce" {
    var mat = try cv.Mat.initWithSize(3, 3, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(0, 1, 2.0);
    mat.setDouble(0, 2, 3.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.reduce(mat, &dst, 0, 0); // Reduce rows, CV_REDUCE_SUM = 0

    // Result should be 1x3 (sum of each column)
    try testing.expectEqual(@as(i32, 1), dst.rows());
    try testing.expectEqual(@as(i32, 3), dst.cols());
}

test "core: countNonZero" {
    var mat = try cv.Mat.initWithSize(3, 3, 0); // CV_8UC1
    defer mat.deinit();
    mat.setUChar(0, 0, 1);
    mat.setUChar(0, 1, 2);
    mat.setUChar(1, 1, 3);

    const count = cv.countNonZero(mat);

    // 3 non-zero elements
    try testing.expectEqual(@as(i32, 3), count);
}

test "core: sqrt" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, 4.0);
    src.setDouble(0, 1, 9.0);
    src.setDouble(1, 0, 16.0);
    src.setDouble(1, 1, 25.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.sqrt(src, &dst);

    // sqrt(4) = 2, sqrt(9) = 3, sqrt(16) = 4, sqrt(25) = 5
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 3.0), dst.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 4.0), dst.getDouble(1, 0));
    try testing.expectEqual(@as(f64, 5.0), dst.getDouble(1, 1));
}

test "core: pow" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, 2.0);
    src.setDouble(0, 1, 3.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.pow(src, 2.0, &dst);

    // 2^2 = 4, 3^2 = 9
    try testing.expectEqual(@as(f64, 4.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 9.0), dst.getDouble(0, 1));
}

test "core: exp" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, 0.0);
    src.setDouble(0, 1, 1.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.exp(src, &dst);

    // e^0 = 1, e^1 ≈ 2.718
    try testing.expectEqual(@as(f64, 1.0), dst.getDouble(0, 0));
    try testing.expect(dst.getDouble(0, 1) >= 2.7 and dst.getDouble(0, 1) <= 2.8);
}

test "core: log" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, 1.0);
    src.setDouble(0, 1, 2.718281828459045);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.log(src, &dst);

    // ln(1) = 0, ln(e) = 1
    try testing.expectEqual(@as(f64, 0.0), dst.getDouble(0, 0));
    try testing.expect(dst.getDouble(0, 1) >= 0.99 and dst.getDouble(0, 1) <= 1.01);
}

// ============================================================================
// Array Operations Tests (4 tests) - Phase 6
// ============================================================================

test "core: merge and split" {
    // Create 3 single-channel matrices
    var ch1 = try cv.Mat.initWithSize(2, 2, 0); // CV_8UC1
    defer ch1.deinit();
    ch1.setUChar(0, 0, 10);

    var ch2 = try cv.Mat.initWithSize(2, 2, 0);
    defer ch2.deinit();
    ch2.setUChar(0, 0, 20);

    var ch3 = try cv.Mat.initWithSize(2, 2, 0);
    defer ch3.deinit();
    ch3.setUChar(0, 0, 30);

    // Merge into 3-channel matrix
    var merged = try cv.Mat.init();
    defer merged.deinit();
    const channels = [_]cv.Mat{ ch1, ch2, ch3 };
    cv.merge(&channels, &merged);

    try testing.expectEqual(@as(i32, 3), merged.channels());

    // Split back
    var out1 = try cv.Mat.init();
    defer out1.deinit();
    var out2 = try cv.Mat.init();
    defer out2.deinit();
    var out3 = try cv.Mat.init();
    defer out3.deinit();
    var outputs = [_]cv.Mat{ out1, out2, out3 };
    cv.split(merged, &outputs);

    try testing.expectEqual(@as(u8, 10), outputs[0].getUChar(0, 0));
    try testing.expectEqual(@as(u8, 20), outputs[1].getUChar(0, 0));
    try testing.expectEqual(@as(u8, 30), outputs[2].getUChar(0, 0));
}

test "core: flip vertical" {
    var src = try cv.Mat.initWithSize(2, 2, 0);
    defer src.deinit();
    src.setUChar(0, 0, 1);
    src.setUChar(0, 1, 2);
    src.setUChar(1, 0, 3);
    src.setUChar(1, 1, 4);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.flip(src, &dst, 0); // Flip vertically (around x-axis)

    // After vertical flip: top row becomes bottom row
    try testing.expectEqual(@as(u8, 3), dst.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 4), dst.getUChar(0, 1));
    try testing.expectEqual(@as(u8, 1), dst.getUChar(1, 0));
    try testing.expectEqual(@as(u8, 2), dst.getUChar(1, 1));
}

test "core: flip horizontal" {
    var src = try cv.Mat.initWithSize(2, 2, 0);
    defer src.deinit();
    src.setUChar(0, 0, 1);
    src.setUChar(0, 1, 2);
    src.setUChar(1, 0, 3);
    src.setUChar(1, 1, 4);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.flip(src, &dst, 1); // Flip horizontally (around y-axis)

    // After horizontal flip: left column becomes right column
    try testing.expectEqual(@as(u8, 2), dst.getUChar(0, 0));
    try testing.expectEqual(@as(u8, 1), dst.getUChar(0, 1));
    try testing.expectEqual(@as(u8, 4), dst.getUChar(1, 0));
    try testing.expectEqual(@as(u8, 3), dst.getUChar(1, 1));
}

test "core: rotate 90 clockwise" {
    var src = try cv.Mat.initWithSize(2, 3, 0); // 2 rows, 3 cols
    defer src.deinit();
    src.setUChar(0, 0, 1);
    src.setUChar(0, 1, 2);
    src.setUChar(0, 2, 3);
    src.setUChar(1, 0, 4);
    src.setUChar(1, 1, 5);
    src.setUChar(1, 2, 6);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.rotate(src, &dst, 0); // ROTATE_90_CLOCKWISE = 0

    // After 90° CW rotation: 2x3 becomes 3x2
    try testing.expectEqual(@as(i32, 3), dst.rows());
    try testing.expectEqual(@as(i32, 2), dst.cols());
}

// ============================================================================
// Linear Algebra Operations Tests (6 tests) - Phase 7
// ============================================================================

test "core: transpose" {
    var src = try cv.Mat.initWithSize(2, 3, 6); // 2x3 matrix
    defer src.deinit();
    src.setDouble(0, 0, 1.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(0, 2, 3.0);
    src.setDouble(1, 0, 4.0);
    src.setDouble(1, 1, 5.0);
    src.setDouble(1, 2, 6.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.transpose(src, &dst);

    // After transpose: 2x3 becomes 3x2
    try testing.expectEqual(@as(i32, 3), dst.rows());
    try testing.expectEqual(@as(i32, 2), dst.cols());
    try testing.expectEqual(@as(f64, 1.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 4.0), dst.getDouble(0, 1));
}

test "core: determinant" {
    var mat = try cv.Mat.initWithSize(2, 2, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(0, 1, 2.0);
    mat.setDouble(1, 0, 3.0);
    mat.setDouble(1, 1, 4.0);

    const det = cv.determinant(mat);

    // det([[1,2],[3,4]]) = 1*4 - 2*3 = -2
    try testing.expectEqual(@as(f64, -2.0), det);
}

test "core: trace" {
    var mat = try cv.Mat.initWithSize(3, 3, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(1, 1, 2.0);
    mat.setDouble(2, 2, 3.0);

    const tr = cv.trace(mat);

    // trace = sum of diagonal = 1 + 2 + 3 = 6
    try testing.expectEqual(@as(f64, 6.0), tr.val1);
}

test "core: invert identity" {
    var src = try cv.Mat.eye(3, 3, 6);
    defer src.deinit();

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const ret = cv.invert(src, &dst, 0); // DECOMP_LU = 0

    // Inverse of identity is identity, return value should be non-zero
    try testing.expect(ret != 0.0);
    try testing.expectEqual(@as(f64, 1.0), dst.getDouble(0, 0));
}

test "core: solve linear system" {
    // Solve Ax = b where A = [[2,1],[1,2]], b = [[5],[4]]
    var a = try cv.Mat.initWithSize(2, 2, 6);
    defer a.deinit();
    a.setDouble(0, 0, 2.0);
    a.setDouble(0, 1, 1.0);
    a.setDouble(1, 0, 1.0);
    a.setDouble(1, 1, 2.0);

    var b = try cv.Mat.initWithSize(2, 1, 6);
    defer b.deinit();
    b.setDouble(0, 0, 5.0);
    b.setDouble(1, 0, 4.0);

    var x = try cv.Mat.init();
    defer x.deinit();

    const success = cv.solve(a, b, &x, 0); // DECOMP_LU = 0

    try testing.expect(success);
    // Solution should be x = [2, 1]
    try testing.expect(x.getDouble(0, 0) >= 1.9 and x.getDouble(0, 0) <= 2.1);
    try testing.expect(x.getDouble(1, 0) >= 0.9 and x.getDouble(1, 0) <= 1.1);
}

test "core: gemm" {
    // C = alpha * A * B + beta * D
    var a = try cv.Mat.initWithSize(2, 2, 6);
    defer a.deinit();
    a.setDouble(0, 0, 1.0);
    a.setDouble(0, 1, 2.0);
    a.setDouble(1, 0, 3.0);
    a.setDouble(1, 1, 4.0);

    var b = try cv.Mat.initWithSize(2, 2, 6);
    defer b.deinit();
    b.setDouble(0, 0, 1.0);
    b.setDouble(0, 1, 0.0);
    b.setDouble(1, 0, 0.0);
    b.setDouble(1, 1, 1.0);

    var d = try cv.Mat.zeros(2, 2, 6);
    defer d.deinit();

    var c = try cv.Mat.init();
    defer c.deinit();

    cv.gemm(a, b, 1.0, d, 0.0, &c, 0); // C = 1.0 * A * B + 0.0 * D

    // A * B = A (since B is identity)
    try testing.expectEqual(@as(f64, 1.0), c.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 2.0), c.getDouble(0, 1));
}

// ============================================================================
// Math Operations Tests (3 tests) - Phase 8
// ============================================================================

test "core: min" {
    var src1 = try cv.Mat.initWithSize(2, 2, 6);
    defer src1.deinit();
    src1.setDouble(0, 0, 5.0);
    src1.setDouble(0, 1, 2.0);
    src1.setDouble(1, 0, 8.0);
    src1.setDouble(1, 1, 1.0);

    var src2 = try cv.Mat.initWithSize(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 3.0);
    src2.setDouble(0, 1, 7.0);
    src2.setDouble(1, 0, 6.0);
    src2.setDouble(1, 1, 4.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.min(src1, src2, &dst);

    // Element-wise minimum
    try testing.expectEqual(@as(f64, 3.0), dst.getDouble(0, 0)); // min(5, 3)
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(0, 1)); // min(2, 7)
    try testing.expectEqual(@as(f64, 6.0), dst.getDouble(1, 0)); // min(8, 6)
    try testing.expectEqual(@as(f64, 1.0), dst.getDouble(1, 1)); // min(1, 4)
}

test "core: max" {
    var src1 = try cv.Mat.initWithSize(2, 2, 6);
    defer src1.deinit();
    src1.setDouble(0, 0, 5.0);
    src1.setDouble(0, 1, 2.0);
    src1.setDouble(1, 0, 8.0);
    src1.setDouble(1, 1, 1.0);

    var src2 = try cv.Mat.initWithSize(2, 2, 6);
    defer src2.deinit();
    src2.setDouble(0, 0, 3.0);
    src2.setDouble(0, 1, 7.0);
    src2.setDouble(1, 0, 6.0);
    src2.setDouble(1, 1, 4.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.max(src1, src2, &dst);

    // Element-wise maximum
    try testing.expectEqual(@as(f64, 5.0), dst.getDouble(0, 0)); // max(5, 3)
    try testing.expectEqual(@as(f64, 7.0), dst.getDouble(0, 1)); // max(2, 7)
    try testing.expectEqual(@as(f64, 8.0), dst.getDouble(1, 0)); // max(8, 6)
    try testing.expectEqual(@as(f64, 4.0), dst.getDouble(1, 1)); // max(1, 4)
}

test "core: abs" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, -5.0);
    src.setDouble(0, 1, 3.0);
    src.setDouble(1, 0, -2.0);
    src.setDouble(1, 1, 0.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.abs(src, &dst);

    // Absolute values
    try testing.expectEqual(@as(f64, 5.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 3.0), dst.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(1, 0));
    try testing.expectEqual(@as(f64, 0.0), dst.getDouble(1, 1));
}

// ============================================================================
// Channel Operations Tests (4 tests) - Phase 9
// ============================================================================

test "core: extractChannel" {
    // Create a 3-channel BGR image
    var bgr = try cv.Mat.initWithSize(2, 2, 16); // CV_8UC3
    defer bgr.deinit();

    // Set some values (B=10, G=20, R=30 for first pixel)
    bgr.setUChar(0, 0, 10); // B
    bgr.setUChar(0, 1, 20); // G

    var blue = try cv.Mat.init();
    defer blue.deinit();

    cv.extractChannel(bgr, &blue, 0); // Extract blue channel

    try testing.expectEqual(@as(i32, 1), blue.channels());
    try testing.expectEqual(@as(u8, 10), blue.getUChar(0, 0));
}

test "core: insertChannel" {
    // Create a single-channel matrix
    var gray = try cv.Mat.initWithSize(2, 2, 0); // CV_8UC1
    defer gray.deinit();
    gray.setUChar(0, 0, 100);

    // Create a 3-channel matrix
    var bgr = try cv.Mat.initWithSize(2, 2, 16); // CV_8UC3
    defer bgr.deinit();

    cv.insertChannel(gray, &bgr, 1); // Insert into green channel

    try testing.expectEqual(@as(i32, 3), bgr.channels());
    try testing.expectEqual(@as(u8, 100), bgr.getUChar(0, 1)); // Green channel
}

test "core: mixChannels BGR to RGB" {
    // Create BGR image
    var bgr = try cv.Mat.initWithSize(2, 2, 16); // CV_8UC3
    defer bgr.deinit();

    // Pre-allocate RGB matrix with same size and type
    var rgb = try cv.Mat.initWithSize(2, 2, 16); // CV_8UC3
    defer rgb.deinit();

    // Mix channels: BGR -> RGB (swap B and R)
    const src_mats = [_]cv.Mat{bgr};
    var dst_mats = [_]cv.Mat{rgb};
    const fromTo = [_]i32{ 0, 2, 1, 1, 2, 0 }; // B->R, G->G, R->B

    cv.mixChannels(&src_mats, &dst_mats, &fromTo);

    try testing.expectEqual(@as(i32, 3), dst_mats[0].channels());
}

test "core: findNonZero" {
    var src = try cv.Mat.initWithSize(3, 3, 0); // CV_8UC1
    defer src.deinit();

    // Set some non-zero values
    src.setUChar(0, 0, 1);
    src.setUChar(1, 1, 2);
    src.setUChar(2, 2, 3);

    var idx = try cv.Mat.init();
    defer idx.deinit();

    cv.findNonZero(src, &idx);

    // Should find 3 non-zero elements
    try testing.expect(idx.total() == 3);
}

// ============================================================================
// Array Concatenation Operations Tests (3 tests) - Phase 10
// ============================================================================

test "core: repeat" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, 1.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(1, 0, 3.0);
    src.setDouble(1, 1, 4.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.repeat(src, 2, 2, &dst); // Tile 2x2 matrix to 4x4

    // Result should be 4x4
    try testing.expectEqual(@as(i32, 4), dst.rows());
    try testing.expectEqual(@as(i32, 4), dst.cols());

    // Check tiling pattern - first tile
    try testing.expectEqual(@as(f64, 1.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 3.0), dst.getDouble(1, 0));
    try testing.expectEqual(@as(f64, 4.0), dst.getDouble(1, 1));
}

test "core: hconcat" {
    var mat1 = try cv.Mat.initWithSize(2, 2, 6);
    defer mat1.deinit();
    mat1.setDouble(0, 0, 1.0);

    var mat2 = try cv.Mat.initWithSize(2, 3, 6);
    defer mat2.deinit();
    mat2.setDouble(0, 0, 2.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const mats = [_]cv.Mat{ mat1, mat2 };
    cv.hconcat(&mats, &dst);

    // Result should be 2 rows, 5 cols (2+3)
    try testing.expectEqual(@as(i32, 2), dst.rows());
    try testing.expectEqual(@as(i32, 5), dst.cols());
}

test "core: vconcat" {
    var mat1 = try cv.Mat.initWithSize(2, 3, 6);
    defer mat1.deinit();
    mat1.setDouble(0, 0, 1.0);

    var mat2 = try cv.Mat.initWithSize(3, 3, 6);
    defer mat2.deinit();
    mat2.setDouble(0, 0, 2.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    const mats = [_]cv.Mat{ mat1, mat2 };
    cv.vconcat(&mats, &dst);

    // Result should be 5 rows (2+3), 3 cols
    try testing.expectEqual(@as(i32, 5), dst.rows());
    try testing.expectEqual(@as(i32, 3), dst.cols());
}

// ============================================================================
// Advanced Linear Algebra Operations Tests (3 tests) - Phase 11
// ============================================================================

test "core: mulTransposed" {
    var src = try cv.Mat.initWithSize(3, 2, 6); // 3x2 matrix
    defer src.deinit();
    src.setDouble(0, 0, 1.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(1, 0, 3.0);
    src.setDouble(1, 1, 4.0);
    src.setDouble(2, 0, 5.0);
    src.setDouble(2, 1, 6.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.mulTransposed(src, &dst, false); // A*A^T (3x3)

    // Result should be 3x3
    try testing.expectEqual(@as(i32, 3), dst.rows());
    try testing.expectEqual(@as(i32, 3), dst.cols());
}

test "core: eigen" {
    // Create a symmetric matrix
    var src = try cv.Mat.initWithSize(3, 3, 6);
    defer src.deinit();
    src.setDouble(0, 0, 4.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(0, 2, 0.0);
    src.setDouble(1, 0, 2.0);
    src.setDouble(1, 1, 5.0);
    src.setDouble(1, 2, 3.0);
    src.setDouble(2, 0, 0.0);
    src.setDouble(2, 1, 3.0);
    src.setDouble(2, 2, 6.0);

    var eigenvalues = try cv.Mat.init();
    defer eigenvalues.deinit();

    var eigenvectors = try cv.Mat.init();
    defer eigenvectors.deinit();

    const success = cv.eigen(src, &eigenvalues, &eigenvectors);

    try testing.expect(success);
    try testing.expectEqual(@as(i32, 3), eigenvalues.rows());
}

test "core: SVDecomp" {
    var src = try cv.Mat.initWithSize(3, 2, 6); // 3x2 matrix
    defer src.deinit();
    src.setDouble(0, 0, 1.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(1, 0, 3.0);
    src.setDouble(1, 1, 4.0);
    src.setDouble(2, 0, 5.0);
    src.setDouble(2, 1, 6.0);

    var w = try cv.Mat.init();
    defer w.deinit();

    var u = try cv.Mat.init();
    defer u.deinit();

    var vt = try cv.Mat.init();
    defer vt.deinit();

    cv.SVDecomp(src, &w, &u, &vt, 0);

    // w should contain singular values (2x1)
    try testing.expectEqual(@as(i32, 2), w.rows());
    try testing.expectEqual(@as(i32, 1), w.cols());
}

// ============================================================================
// Final P1 Utility Functions Tests (7 tests) - Phase 12
// ============================================================================

test "core: setIdentity" {
    var mat = try cv.Mat.initWithSize(3, 3, 6);
    defer mat.deinit();

    const s = cv.Scalar.init(2.0, 0, 0, 0).toC();
    cv.setIdentity(&mat, s);

    // Diagonal should be 2.0, others 0.0
    try testing.expectEqual(@as(f64, 2.0), mat.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 0.0), mat.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 2.0), mat.getDouble(1, 1));
    try testing.expectEqual(@as(f64, 0.0), mat.getDouble(1, 2));
    try testing.expectEqual(@as(f64, 2.0), mat.getDouble(2, 2));
}

test "core: sort" {
    var src = try cv.Mat.initWithSize(1, 5, 6);
    defer src.deinit();
    src.setDouble(0, 0, 5.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(0, 2, 8.0);
    src.setDouble(0, 3, 1.0);
    src.setDouble(0, 4, 3.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.sort(src, &dst, 0); // Sort ascending

    // Should be sorted: 1, 2, 3, 5, 8
    try testing.expectEqual(@as(f64, 1.0), dst.getDouble(0, 0));
    try testing.expectEqual(@as(f64, 2.0), dst.getDouble(0, 1));
    try testing.expectEqual(@as(f64, 3.0), dst.getDouble(0, 2));
}

test "core: sortIdx" {
    var src = try cv.Mat.initWithSize(1, 5, 6);
    defer src.deinit();
    src.setDouble(0, 0, 5.0);
    src.setDouble(0, 1, 2.0);
    src.setDouble(0, 2, 8.0);
    src.setDouble(0, 3, 1.0);
    src.setDouble(0, 4, 3.0);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.sortIdx(src, &dst, 0); // Sort ascending, return indices

    // Indices should be: 3, 1, 4, 0, 2 (for values 1, 2, 3, 5, 8)
    try testing.expectEqual(@as(i32, 3), dst.getInt(0, 0)); // Index of 1.0
    try testing.expectEqual(@as(i32, 1), dst.getInt(0, 1)); // Index of 2.0
}

test "core: completeSymm" {
    var mat = try cv.Mat.initWithSize(3, 3, 6);
    defer mat.deinit();

    // Fill upper triangle
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(0, 1, 2.0);
    mat.setDouble(0, 2, 3.0);
    mat.setDouble(1, 1, 4.0);
    mat.setDouble(1, 2, 5.0);
    mat.setDouble(2, 2, 6.0);

    cv.completeSymm(&mat, false); // Copy upper to lower

    // Check symmetry
    try testing.expectEqual(@as(f64, 2.0), mat.getDouble(1, 0)); // Should equal (0,1)
    try testing.expectEqual(@as(f64, 3.0), mat.getDouble(2, 0)); // Should equal (0,2)
    try testing.expectEqual(@as(f64, 5.0), mat.getDouble(2, 1)); // Should equal (1,2)
}

test "core: convertScaleAbs" {
    var src = try cv.Mat.initWithSize(2, 2, 6);
    defer src.deinit();
    src.setDouble(0, 0, -2.0);
    src.setDouble(0, 1, 3.0);
    src.setDouble(1, 0, -1.5);
    src.setDouble(1, 1, 0.5);

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.convertScaleAbs(src, &dst, 2.0, 0.0); // Scale by 2, then abs

    // Results: |2*(-2)|=4, |2*3|=6, |2*(-1.5)|=3, |2*0.5|=1
    try testing.expect(dst.getUChar(0, 0) == 4);
    try testing.expect(dst.getUChar(0, 1) == 6);
}

test "core: LUT" {
    var src = try cv.Mat.initWithSize(2, 2, 0); // CV_8UC1
    defer src.deinit();
    src.setUChar(0, 0, 0);
    src.setUChar(0, 1, 1);
    src.setUChar(1, 0, 2);
    src.setUChar(1, 1, 255);

    // Create lookup table (256 entries)
    var lut = try cv.Mat.initWithSize(256, 1, 0);
    defer lut.deinit();

    // Simple LUT: multiply by 2
    var i: usize = 0;
    while (i < 256) : (i += 1) {
        lut.setUChar(@intCast(i), 0, @intCast(@min(i * 2, 255)));
    }

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.LUT(src, lut, &dst);

    // Check results
    try testing.expectEqual(@as(u8, 0), dst.getUChar(0, 0)); // 0*2=0
    try testing.expectEqual(@as(u8, 2), dst.getUChar(0, 1)); // 1*2=2
    try testing.expectEqual(@as(u8, 4), dst.getUChar(1, 0)); // 2*2=4
}

test "core: hasNonZero" {
    var zeros = try cv.Mat.initWithSize(3, 3, 6);
    defer zeros.deinit();

    try testing.expect(!cv.hasNonZero(zeros)); // All zeros

    zeros.setDouble(1, 1, 1.0);
    try testing.expect(cv.hasNonZero(zeros)); // Has non-zero
}

// ============================================================================
// Final P2 Utility Functions Tests (3 tests) - Phase 13
// ============================================================================

test "core: checkRange" {
    var mat = try cv.Mat.initWithSize(2, 2, 6);
    defer mat.deinit();
    mat.setDouble(0, 0, 1.0);
    mat.setDouble(0, 1, 2.0);
    mat.setDouble(1, 0, 3.0);
    mat.setDouble(1, 1, 4.0);

    // All values in range [0, 5]
    try testing.expect(cv.checkRange(mat, true, 0.0, 5.0));

    // Not all values in range [0, 2]
    try testing.expect(!cv.checkRange(mat, true, 0.0, 2.0));
}

test "core: patchNaNs" {
    var mat = try cv.Mat.initWithSize(2, 2, 5); // CV_32FC1
    defer mat.deinit();
    mat.setFloat(0, 0, 1.0);
    mat.setFloat(0, 1, std.math.nan(f32));
    mat.setFloat(1, 0, 3.0);
    mat.setFloat(1, 1, std.math.nan(f32));

    cv.patchNaNs(&mat, 0.0);

    // NaNs should be replaced with 0.0
    try testing.expectEqual(@as(f32, 1.0), mat.getFloat(0, 0));
    try testing.expectEqual(@as(f32, 0.0), mat.getFloat(0, 1));
    try testing.expectEqual(@as(f32, 3.0), mat.getFloat(1, 0));
    try testing.expectEqual(@as(f32, 0.0), mat.getFloat(1, 1));
}

test "core: setRNGSeed" {
    // Set seed for reproducibility
    cv.setRNGSeed(42);

    // This test just verifies the function doesn't crash
    // Actual RNG testing would require generating random numbers
    try testing.expect(true);
}

// ============================================================================
// Point2fVector Tests
// ============================================================================

test "core: Point2fVector basic operations" {
    var vec = try cv.Point2fVector.init();
    defer vec.deinit();

    // Initially empty
    try testing.expectEqual(@as(usize, 0), vec.size());

    // Append points
    try vec.append(cv.Point2f.init(1.5, 2.5));
    try vec.append(cv.Point2f.init(3.5, 4.5));
    try vec.append(cv.Point2f.init(5.5, 6.5));

    // Check size
    try testing.expectEqual(@as(usize, 3), vec.size());

    // Check values
    const p0 = vec.at(0);
    try testing.expectEqual(@as(f32, 1.5), p0.x);
    try testing.expectEqual(@as(f32, 2.5), p0.y);

    const p2 = vec.at(2);
    try testing.expectEqual(@as(f32, 5.5), p2.x);
    try testing.expectEqual(@as(f32, 6.5), p2.y);
}

// ============================================================================
// Phase 2: DFT / Math / Random / Clustering tests
// ============================================================================

test "core: DFT and IDFT roundtrip" {
    var src = try cv.Mat.initWithSize(1, 8, 5); // CV_32FC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(1.0, 0, 0, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.dft(src, &dst, 0, 0);
    try testing.expect(!dst.empty());

    var back = try cv.Mat.init();
    defer back.deinit();
    cv.idft(dst, &back, cv.DftFlags.scale, 0);
    try testing.expect(!back.empty());
}

test "core: getOptimalDFTSize" {
    const optimal = cv.getOptimalDFTSize(100);
    try testing.expect(optimal >= 100);
    // Should be a power-friendly size
    try testing.expect(optimal <= 128);
}

test "core: DCT and IDCT roundtrip" {
    var src = try cv.Mat.initWithSize(1, 8, 5); // CV_32FC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(2.0, 0, 0, 0));
    var dst = try cv.Mat.init();
    defer dst.deinit();
    cv.dct(src, &dst, 0);
    try testing.expect(!dst.empty());

    var back = try cv.Mat.init();
    defer back.deinit();
    cv.idct(dst, &back, 0);
    try testing.expect(!back.empty());
}

test "core: phase" {
    var x = try cv.Mat.initWithSize(1, 4, 5); // CV_32FC1
    defer x.deinit();
    x.setTo(cv.Scalar.init(1.0, 0, 0, 0));
    var y = try cv.Mat.initWithSize(1, 4, 5); // CV_32FC1
    defer y.deinit();
    y.setTo(cv.Scalar.init(0.0, 0, 0, 0));
    var angle = try cv.Mat.init();
    defer angle.deinit();
    cv.phase(x, y, &angle, true);
    try testing.expect(!angle.empty());
}

test "core: computeMagnitude and cartToPolar" {
    var x = try cv.Mat.initWithSize(1, 4, 5); // CV_32FC1
    defer x.deinit();
    x.setTo(cv.Scalar.init(3.0, 0, 0, 0));
    var y = try cv.Mat.initWithSize(1, 4, 5); // CV_32FC1
    defer y.deinit();
    y.setTo(cv.Scalar.init(4.0, 0, 0, 0));
    var mag = try cv.Mat.init();
    defer mag.deinit();
    cv.computeMagnitude(x, y, &mag);
    try testing.expect(!mag.empty());

    // cartToPolar
    var angle = try cv.Mat.init();
    defer angle.deinit();
    var mag2 = try cv.Mat.init();
    defer mag2.deinit();
    cv.cartToPolar(x, y, &mag2, &angle, false);
    try testing.expect(!angle.empty());
    try testing.expect(!mag2.empty());
}

test "core: randu" {
    var mat = try cv.Mat.initWithSize(10, 10, 5); // CV_32FC1
    defer mat.deinit();
    cv.randu(&mat, cv.Scalar.init(0, 0, 0, 0), cv.Scalar.init(255, 0, 0, 0));
    try testing.expect(!mat.empty());
}

test "core: randShuffle" {
    var mat = try cv.Mat.initWithSize(1, 10, 0); // CV_8UC1
    defer mat.deinit();
    mat.setTo(cv.Scalar.init(42, 0, 0, 0));
    cv.randShuffle(&mat);
    try testing.expect(!mat.empty());
}

test "core: kmeans" {
    // Create 20 data points with 2 features
    var data = try cv.Mat.initWithSize(20, 2, 5); // CV_32FC1
    defer data.deinit();
    cv.randu(&data, cv.Scalar.init(0, 0, 0, 0), cv.Scalar.init(100, 0, 0, 0));

    var labels = try cv.Mat.init();
    defer labels.deinit();
    var centers = try cv.Mat.init();
    defer centers.deinit();

    const compactness = cv.kmeans(data, 2, &labels, 10, 1.0, 3, cv.KMeansFlags.pp_centers, &centers);
    try testing.expect(compactness >= 0);
    try testing.expect(!labels.empty());
    try testing.expect(!centers.empty());
}

// ============================================================================
// PCA Tests
// ============================================================================

test "core: PCA create and project" {
    // Create some sample data (5 samples x 3 features)
    var data = try cv.Mat.initWithSize(5, 3, 5); // CV_32FC1
    defer data.deinit();
    data.setTo(cv.Scalar.init(1.0, 0, 0, 0));

    var mean_val = try cv.Mat.init();
    defer mean_val.deinit();

    const pca = cv.PCA.init(data, mean_val, cv.PCA.Flags.data_as_row, 2);
    defer pca.deinit();

    var eigenvals = try pca.getEigenvalues();
    defer eigenvals.deinit();
    try testing.expect(!eigenvals.empty());

    var eigenvecs = try pca.getEigenvectors();
    defer eigenvecs.deinit();
    try testing.expect(!eigenvecs.empty());
}

// ============================================================================
// Utility Function Tests
// ============================================================================

test "core: copyMakeBorder" {
    var src = try cv.Mat.initWithSize(10, 10, 0); // CV_8UC1
    defer src.deinit();
    src.setTo(cv.Scalar.init(128, 0, 0, 0));

    var dst = try cv.Mat.init();
    defer dst.deinit();

    cv.copyMakeBorder(src, &dst, 5, 5, 5, 5, 0, cv.Scalar.init(0, 0, 0, 0));
    try testing.expect(!dst.empty());
    try testing.expectEqual(@as(i32, 20), dst.rows());
    try testing.expectEqual(@as(i32, 20), dst.cols());
}

test "core: borderInterpolate" {
    // BORDER_REFLECT = 2 (returns valid index for out-of-bounds)
    const result = cv.borderInterpolate(-1, 10, 2);
    try testing.expect(result >= 0);
    try testing.expect(result < 10);
}

test "core: calcCovarMatrix" {
    // Create a 3x3 float matrix (each row = a sample)
    var samples = try cv.Mat.initWithSize(3, 3, 5); // CV_32FC1
    defer samples.deinit();

    var covar = try cv.Mat.init();
    defer covar.deinit();

    var mean_val = try cv.Mat.init();
    defer mean_val.deinit();

    // flags: cv::COVAR_NORMAL=1 | cv::COVAR_ROWS=8 (=9)
    cv.calcCovarMatrix(samples, &covar, &mean_val, 9, 5); // CV_32FC1
    try testing.expect(!covar.empty());
    try testing.expect(!mean_val.empty());
}

test "core: mahalanobis" {
    // Create two 1D vectors and an identity inverse covariance
    var v1 = try cv.Mat.initWithSize(1, 3, 6); // CV_64FC1
    defer v1.deinit();
    var v2 = try cv.Mat.initWithSize(1, 3, 6); // CV_64FC1
    defer v2.deinit();

    var icovar = try cv.Mat.eye(3, 3, 6); // CV_64FC1
    defer icovar.deinit();

    // Mahalanobis distance with identity icovar and zero vectors should be 0
    const dist = cv.mahalanobis(v1, v2, icovar);
    try testing.expect(dist >= 0.0);
}

// ============================================================================
// Point3fVector Tests
// ============================================================================

test "core: Point3fVector init and deinit" {
    var pv = try cv.Point3fVector.init();
    defer pv.deinit();
    try testing.expectEqual(@as(usize, 0), pv.size());
}

test "core: Point3fVector append and access" {
    var pv = try cv.Point3fVector.init();
    defer pv.deinit();

    pv.append(cv.Point3f.init(1.0, 2.0, 3.0));
    pv.append(cv.Point3f.init(4.0, 5.0, 6.0));
    pv.append(cv.Point3f.init(7.0, 8.0, 9.0));

    try testing.expectEqual(@as(usize, 3), pv.size());

    const p0 = pv.at(0);
    try testing.expectEqual(@as(f32, 1.0), p0.x);
    try testing.expectEqual(@as(f32, 2.0), p0.y);
    try testing.expectEqual(@as(f32, 3.0), p0.z);

    const p2 = pv.at(2);
    try testing.expectEqual(@as(f32, 7.0), p2.x);
    try testing.expectEqual(@as(f32, 8.0), p2.y);
    try testing.expectEqual(@as(f32, 9.0), p2.z);
}

test "core: Point3fVector multiple appends" {
    var pv = try cv.Point3fVector.init();
    defer pv.deinit();

    var i: usize = 0;
    while (i < 100) : (i += 1) {
        pv.append(cv.Point3f.init(@floatFromInt(i), @floatFromInt(i * 2), @floatFromInt(i * 3)));
    }

    try testing.expectEqual(@as(usize, 100), pv.size());

    const p50 = pv.at(50);
    try testing.expectEqual(@as(f32, 50.0), p50.x);
    try testing.expectEqual(@as(f32, 100.0), p50.y);
    try testing.expectEqual(@as(f32, 150.0), p50.z);
}
