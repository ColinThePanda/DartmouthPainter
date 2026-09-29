const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;

/// OpenCV error set
pub const Error = error{
    MatCreationFailed,
    MatIsEmpty,
    InvalidMatType,
    InvalidIndex,
    NullPointer,
    AlgorithmInitializationFailed,
};

/// Mat - OpenCV matrix type
pub const Mat = struct {
    ptr: *c.Mat,

    const Self = @This();

    /// Create a new empty Mat
    pub fn init() Error!Self {
        const ptr = c.Mat_New() orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Create a new Mat with specified size and type
    pub fn initWithSize(num_rows: i32, num_cols: i32, mat_type: i32) Error!Self {
        const ptr = c.Mat_NewWithSize(num_rows, num_cols, mat_type) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Create a Mat from raw bytes
    pub fn initFromBytes(num_rows: i32, num_cols: i32, mat_type: i32, bytes: []u8, step_size: usize) Error!Self {
        const ptr = c.Mat_NewFromBytes(num_rows, num_cols, mat_type, bytes.ptr, step_size) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Create a Mat filled with zeros
    pub fn zeros(num_rows: i32, num_cols: i32, mat_type: i32) Error!Self {
        const ptr = c.Mat_Zeros(num_rows, num_cols, mat_type) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Create a Mat filled with ones
    pub fn ones(num_rows: i32, num_cols: i32, mat_type: i32) Error!Self {
        const ptr = c.Mat_Ones(num_rows, num_cols, mat_type) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Create an identity Mat (eye matrix)
    pub fn eye(num_rows: i32, num_cols: i32, mat_type: i32) Error!Self {
        const ptr = c.Mat_Eye(num_rows, num_cols, mat_type) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Free the Mat
    pub fn deinit(self: *Self) void {
        c.Mat_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Clone the Mat
    pub fn clone(self: Self) Error!Self {
        const ptr = c.Mat_Clone(self.ptr) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Check if Mat is empty
    pub fn empty(self: Self) bool {
        return c.Mat_Empty(self.ptr) != 0;
    }

    /// Get number of rows
    pub fn rows(self: Self) i32 {
        return c.Mat_Rows(self.ptr);
    }

    /// Get number of columns
    pub fn cols(self: Self) i32 {
        return c.Mat_Cols(self.ptr);
    }

    /// Get Mat type
    pub fn matType(self: Self) i32 {
        return c.Mat_Type(self.ptr);
    }

    /// Get number of channels
    pub fn channels(self: Self) i32 {
        return c.Mat_Channels(self.ptr);
    }

    /// Get depth
    pub fn depth(self: Self) i32 {
        return c.Mat_Depth(self.ptr);
    }

    /// Get total number of elements
    pub fn total(self: Self) usize {
        return c.Mat_Total(self.ptr);
    }

    /// Get element size in bytes
    pub fn elemSize(self: Self) usize {
        return c.Mat_ElemSize(self.ptr);
    }

    /// Get raw data pointer
    pub fn data(self: Self) [*]u8 {
        return @as([*]u8, @ptrCast(c.Mat_Data(self.ptr)));
    }

    /// Get step size
    pub fn step(self: Self) usize {
        return c.Mat_Step(self.ptr);
    }

    /// Copy to another Mat
    pub fn copyTo(self: Self, dst: *Self) void {
        c.Mat_CopyTo(self.ptr, dst.ptr);
    }

    /// Convert to another type
    pub fn convertTo(self: Self, dst: *Self, rtype: i32, alpha: f64, beta: f64) void {
        c.Mat_ConvertTo(self.ptr, dst.ptr, rtype, alpha, beta);
    }

    /// Set all elements to a scalar value
    pub fn setTo(self: Self, value: Scalar) void {
        c.Mat_SetTo(self.ptr, value.toC());
    }

    /// Set elements to a scalar value using a mask
    pub fn setToMask(self: Self, value: Scalar, mask: Self) void {
        c.Mat_SetToMask(self.ptr, value.toC(), mask.ptr);
    }

    /// Reshape the Mat to different number of channels/rows
    pub fn reshape(self: Self, cn: i32, num_rows: i32) Error!Self {
        const ptr = c.Mat_Reshape(self.ptr, cn, num_rows) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Transpose the Mat
    pub fn t(self: Self) Error!Self {
        const ptr = c.Mat_T(self.ptr) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Invert the Mat
    pub fn inv(self: Self, method: i32) Error!Self {
        const ptr = c.Mat_Inv(self.ptr, method) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Element-wise multiplication
    pub fn mul(self: Self, other: Self, scale: f64) Error!Self {
        const ptr = c.Mat_Mul(self.ptr, other.ptr, scale) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Dot product
    pub fn dot(self: Self, other: Self) f64 {
        return c.Mat_Dot(self.ptr, other.ptr);
    }

    /// Cross product
    pub fn cross(self: Self, other: Self) Error!Self {
        const ptr = c.Mat_Cross(self.ptr, other.ptr) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get a single row
    pub fn rowAt(self: Self, y: i32) Error!Self {
        const ptr = c.Mat_Row(self.ptr, y) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get a single column
    pub fn colAt(self: Self, x: i32) Error!Self {
        const ptr = c.Mat_Col(self.ptr, x) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get a range of rows
    pub fn rowRange(self: Self, startrow: i32, endrow: i32) Error!Self {
        const ptr = c.Mat_RowRange(self.ptr, startrow, endrow) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get a range of columns
    pub fn colRange(self: Self, startcol: i32, endcol: i32) Error!Self {
        const ptr = c.Mat_ColRange(self.ptr, startcol, endcol) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get a submatrix using a Rect
    pub fn submat(self: Self, roi: Rect) Error!Self {
        const ptr = c.Mat_Submat(self.ptr, roi.toC()) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get a submatrix using row and column ranges
    pub fn submatRanges(self: Self, row_start: i32, row_end: i32, col_start: i32, col_end: i32) Error!Self {
        const ptr = c.Mat_SubmatRanges(self.ptr, row_start, row_end, col_start, col_end) orelse return Error.MatCreationFailed;
        return Self{ .ptr = ptr };
    }

    /// Get element as double
    pub fn getDouble(self: Self, row: i32, col: i32) f64 {
        return c.Mat_GetDouble(self.ptr, row, col);
    }

    /// Get element as float
    pub fn getFloat(self: Self, row: i32, col: i32) f32 {
        return c.Mat_GetFloat(self.ptr, row, col);
    }

    /// Get element as int
    pub fn getInt(self: Self, row: i32, col: i32) i32 {
        return c.Mat_GetInt(self.ptr, row, col);
    }

    /// Get element as unsigned char
    pub fn getUChar(self: Self, row: i32, col: i32) u8 {
        return c.Mat_GetUChar(self.ptr, row, col);
    }

    /// Set element as double
    pub fn setDouble(self: Self, row: i32, col: i32, value: f64) void {
        c.Mat_SetDouble(self.ptr, row, col, value);
    }

    /// Set element as float
    pub fn setFloat(self: Self, row: i32, col: i32, value: f32) void {
        c.Mat_SetFloat(self.ptr, row, col, value);
    }

    /// Set element as int
    pub fn setInt(self: Self, row: i32, col: i32, value: i32) void {
        c.Mat_SetInt(self.ptr, row, col, value);
    }

    /// Set element as unsigned char
    pub fn setUChar(self: Self, row: i32, col: i32, value: u8) void {
        c.Mat_SetUChar(self.ptr, row, col, value);
    }
};

// ============================================================================
// Mats — vector of Mat for passing multiple images
// ============================================================================

pub const Mats = struct {
    ptr: *c.Mats,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.Mats_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.Mats_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn append(self: *Self, mat: Mat) void {
        c.Mats_Append(self.ptr, mat.ptr);
    }

    pub fn size(self: Self) usize {
        return c.Mats_Size(self.ptr);
    }
};

/// Point - 2D point with integer coordinates
pub const Point = struct {
    x: i32,
    y: i32,

    pub fn init(x: i32, y: i32) Point {
        return Point{ .x = x, .y = y };
    }

    pub fn toC(self: Point) c.Point {
        return c.Point{ .x = self.x, .y = self.y };
    }

    pub fn fromC(p: c.Point) Point {
        return Point{ .x = p.x, .y = p.y };
    }
};

/// Point2f - 2D point with float coordinates
pub const Point2f = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Point2f {
        return Point2f{ .x = x, .y = y };
    }

    pub fn toC(self: Point2f) c.Point2f {
        return c.Point2f{ .x = self.x, .y = self.y };
    }

    pub fn fromC(p: c.Point2f) Point2f {
        return Point2f{ .x = p.x, .y = p.y };
    }
};

/// Point3f - 3D point with float coordinates
pub const Point3f = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Point3f {
        return Point3f{ .x = x, .y = y, .z = z };
    }

    pub fn toC(self: Point3f) c.Point3f {
        return c.Point3f{ .x = self.x, .y = self.y, .z = self.z };
    }

    pub fn fromC(p: c.Point3f) Point3f {
        return Point3f{ .x = p.x, .y = p.y, .z = p.z };
    }
};

/// Point3fVector - dynamic array of 3D float points
pub const Point3fVector = struct {
    ptr: *c.Point3fVector,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.Point3fVector_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.Point3fVector_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn size(self: Self) usize {
        return @intCast(c.Point3fVector_Size(self.ptr));
    }

    pub fn at(self: Self, index: usize) Point3f {
        const p = c.Point3fVector_At(self.ptr, @intCast(index));
        return Point3f.fromC(p);
    }

    pub fn append(self: *Self, point: Point3f) void {
        c.Point3fVector_Append(self.ptr, point.toC());
    }
};

/// Rect - Rectangle
pub const Rect = struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,

    pub fn init(x: i32, y: i32, width: i32, height: i32) Rect {
        return Rect{ .x = x, .y = y, .width = width, .height = height };
    }

    pub fn toC(self: Rect) c.Rect {
        return c.Rect{ .x = self.x, .y = self.y, .width = self.width, .height = self.height };
    }

    pub fn fromC(r: c.Rect) Rect {
        return Rect{ .x = r.x, .y = r.y, .width = r.width, .height = r.height };
    }
};

/// Size - 2D size
pub const Size = struct {
    width: i32,
    height: i32,

    pub fn init(width: i32, height: i32) Size {
        return Size{ .width = width, .height = height };
    }

    pub fn toC(self: Size) c.Size {
        return c.Size{ .width = self.width, .height = self.height };
    }

    pub fn fromC(s: c.Size) Size {
        return Size{ .width = s.width, .height = s.height };
    }
};

/// Scalar - 4-element vector
pub const Scalar = struct {
    val1: f64,
    val2: f64,
    val3: f64,
    val4: f64,

    pub fn init(val1: f64, val2: f64, val3: f64, val4: f64) Scalar {
        return Scalar{ .val1 = val1, .val2 = val2, .val3 = val3, .val4 = val4 };
    }

    pub fn all(val: f64) Scalar {
        return Scalar{ .val1 = val, .val2 = val, .val3 = val, .val4 = val };
    }

    /// Convert to C Scalar
    pub fn toC(self: Scalar) c.Scalar {
        return c.Scalar{ .v0 = self.val1, .v1 = self.val2, .v2 = self.val3, .v3 = self.val4 };
    }

    pub fn fromC(s: c.Scalar) Scalar {
        return Scalar{ .val1 = s.v0, .val2 = s.v1, .val3 = s.v2, .val4 = s.v3 };
    }
};

/// Get OpenCV version string
pub fn getVersion() []const u8 {
    return std.mem.span(c.OpenCV_Version());
}

// Mat type constants
pub const CV_8U: i32 = 0;
pub const CV_8S: i32 = 1;
pub const CV_16U: i32 = 2;
pub const CV_16S: i32 = 3;
pub const CV_32S: i32 = 4;
pub const CV_32F: i32 = 5;
pub const CV_64F: i32 = 6;

pub fn CV_MAKETYPE(depth: i32, channels: i32) i32 {
    return (depth & 7) + ((channels - 1) << 3);
}

pub const CV_8UC1: i32 = CV_MAKETYPE(CV_8U, 1);
pub const CV_8UC2: i32 = CV_MAKETYPE(CV_8U, 2);
pub const CV_8UC3: i32 = CV_MAKETYPE(CV_8U, 3);
pub const CV_8UC4: i32 = CV_MAKETYPE(CV_8U, 4);

pub const CV_32FC1: i32 = CV_MAKETYPE(CV_32F, 1);
pub const CV_32FC2: i32 = CV_MAKETYPE(CV_32F, 2);
pub const CV_32FC3: i32 = CV_MAKETYPE(CV_32F, 3);
pub const CV_32FC4: i32 = CV_MAKETYPE(CV_32F, 4);

pub const CV_64FC1: i32 = CV_MAKETYPE(CV_64F, 1);
pub const CV_64FC2: i32 = CV_MAKETYPE(CV_64F, 2);
pub const CV_64FC3: i32 = CV_MAKETYPE(CV_64F, 3);
pub const CV_64FC4: i32 = CV_MAKETYPE(CV_64F, 4);

// ============================================================================
// Matrix Arithmetic Operations (Module-level functions)
// ============================================================================

/// Add two matrices
pub fn add(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Add(src1.ptr, src2.ptr, dst.ptr);
}

/// Subtract two matrices
pub fn subtract(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Subtract(src1.ptr, src2.ptr, dst.ptr);
}

/// Multiply two matrices element-wise
pub fn multiply(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Multiply(src1.ptr, src2.ptr, dst.ptr);
}

/// Divide two matrices element-wise
pub fn divide(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Divide(src1.ptr, src2.ptr, dst.ptr);
}

/// Bitwise AND
pub fn bitwiseAnd(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_BitwiseAnd(src1.ptr, src2.ptr, dst.ptr);
}

/// Bitwise OR
pub fn bitwiseOr(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_BitwiseOr(src1.ptr, src2.ptr, dst.ptr);
}

/// Bitwise XOR
pub fn bitwiseXor(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_BitwiseXor(src1.ptr, src2.ptr, dst.ptr);
}

/// Bitwise NOT
pub fn bitwiseNot(src: Mat, dst: *Mat) void {
    c.Mat_BitwiseNot(src.ptr, dst.ptr);
}

/// Compare two matrices
pub fn compare(src1: Mat, src2: Mat, dst: *Mat, cmpop: i32) void {
    c.Mat_Compare(src1.ptr, src2.ptr, dst.ptr, cmpop);
}

/// Check if elements are within range
pub fn inRange(src: Mat, lowerb: Scalar, upperb: Scalar, dst: *Mat) void {
    c.Mat_InRange(src.ptr, lowerb.toC(), upperb.toC(), dst.ptr);
}

/// Weighted addition of two matrices
pub fn addWeighted(src1: Mat, alpha: f64, src2: Mat, beta: f64, gamma: f64, dst: *Mat) void {
    c.Mat_AddWeighted(src1.ptr, alpha, src2.ptr, beta, gamma, dst.ptr);
}

/// Absolute difference between two matrices
pub fn absdiff(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Absdiff(src1.ptr, src2.ptr, dst.ptr);
}

// ============================================================================
// Math and Reduction Operations (Module-level functions)
// ============================================================================

/// Calculate norm of a matrix
pub fn norm(src: Mat, normType: i32) f64 {
    return c.Mat_Norm(src.ptr, normType);
}

/// Normalize a matrix
pub fn normalize(src: Mat, dst: *Mat, alpha: f64, beta: f64, normType: i32) void {
    c.Mat_Normalize(src.ptr, dst.ptr, alpha, beta, normType);
}

/// Calculate sum of matrix elements
pub fn sum(src: Mat) Scalar {
    const s = c.Mat_Sum(src.ptr);
    return Scalar.fromC(s);
}

/// Calculate mean of matrix elements
pub fn mean(src: Mat) Scalar {
    const m = c.Mat_Mean(src.ptr);
    return Scalar.fromC(m);
}

/// Calculate mean and standard deviation
pub fn meanStdDev(src: Mat, mean_out: *Scalar, stddev_out: *Scalar) void {
    var m: c.Scalar = undefined;
    var sd: c.Scalar = undefined;
    c.Mat_MeanStdDev(src.ptr, &m, &sd);
    mean_out.* = Scalar.fromC(m);
    stddev_out.* = Scalar.fromC(sd);
}

/// Find minimum and maximum values and their locations
pub fn minMaxLoc(src: Mat, minVal: *f64, maxVal: *f64, minLoc: ?*Point, maxLoc: ?*Point) void {
    var minP: c.Point = undefined;
    var maxP: c.Point = undefined;
    c.Mat_MinMaxLoc(src.ptr, minVal, maxVal, if (minLoc != null) &minP else null, if (maxLoc != null) &maxP else null);
    if (minLoc) |p| p.* = Point.fromC(minP);
    if (maxLoc) |p| p.* = Point.fromC(maxP);
}

/// Reduce matrix to a vector
pub fn reduce(src: Mat, dst: *Mat, dim: i32, rtype: i32) void {
    c.Mat_Reduce(src.ptr, dst.ptr, dim, rtype);
}

/// Count non-zero elements
pub fn countNonZero(src: Mat) i32 {
    return c.Mat_CountNonZero(src.ptr);
}

/// Calculate square root
pub fn sqrt(src: Mat, dst: *Mat) void {
    c.Mat_Sqrt(src.ptr, dst.ptr);
}

/// Raise to power
pub fn pow(src: Mat, power: f64, dst: *Mat) void {
    c.Mat_Pow(src.ptr, power, dst.ptr);
}

/// Calculate exponential
pub fn exp(src: Mat, dst: *Mat) void {
    c.Mat_Exp(src.ptr, dst.ptr);
}

/// Calculate natural logarithm
pub fn log(src: Mat, dst: *Mat) void {
    c.Mat_Log(src.ptr, dst.ptr);
}

// ============================================================================
// Array Operations (Module-level functions)
// ============================================================================

/// Merge multiple single-channel matrices into a multi-channel matrix
pub fn merge(mats: []const Mat, dst: *Mat) void {
    const allocator = std.heap.page_allocator;
    var mat_ptrs = allocator.alloc(?*c.Mat, mats.len) catch unreachable;
    defer allocator.free(mat_ptrs);

    for (mats, 0..) |mat, i| {
        mat_ptrs[i] = mat.ptr;
    }

    c.Mat_Merge(@ptrCast(mat_ptrs.ptr), @intCast(mats.len), dst.ptr);
}

/// Split a multi-channel matrix into multiple single-channel matrices
pub fn split(src: Mat, dsts: []Mat) void {
    const allocator = std.heap.page_allocator;
    var mat_ptrs = allocator.alloc(?*c.Mat, dsts.len) catch unreachable;
    defer allocator.free(mat_ptrs);

    for (dsts, 0..) |*dst, i| {
        mat_ptrs[i] = dst.ptr;
    }

    c.Mat_Split(src.ptr, @ptrCast(mat_ptrs.ptr));
}

/// Flip a matrix around vertical, horizontal, or both axes
pub fn flip(src: Mat, dst: *Mat, flipCode: i32) void {
    c.Mat_Flip(src.ptr, dst.ptr, flipCode);
}

/// Rotate a matrix by 90, 180, or 270 degrees
pub fn rotate(src: Mat, dst: *Mat, rotateCode: i32) void {
    c.Mat_Rotate(src.ptr, dst.ptr, rotateCode);
}

// ============================================================================
// Linear Algebra Operations (Module-level functions)
// ============================================================================

/// General matrix multiplication (GEMM)
pub fn gemm(src1: Mat, src2: Mat, alpha: f64, src3: Mat, beta: f64, dst: *Mat, flags: i32) void {
    c.Mat_Gemm(src1.ptr, src2.ptr, alpha, src3.ptr, beta, dst.ptr, flags);
}

/// Transpose a matrix
pub fn transpose(src: Mat, dst: *Mat) void {
    c.Mat_Transpose(src.ptr, dst.ptr);
}

/// Invert a matrix
pub fn invert(src: Mat, dst: *Mat, method: i32) f64 {
    return c.Mat_Invert(src.ptr, dst.ptr, method);
}

/// Solve a linear system
pub fn solve(src1: Mat, src2: Mat, dst: *Mat, flags: i32) bool {
    return c.Mat_Solve(src1.ptr, src2.ptr, dst.ptr, flags) != 0;
}

/// Calculate determinant of a matrix
pub fn determinant(src: Mat) f64 {
    return c.Mat_Determinant(src.ptr);
}

/// Calculate trace of a matrix
pub fn trace(src: Mat) Scalar {
    const t = c.Mat_Trace(src.ptr);
    return Scalar.fromC(t);
}

// ============================================================================
// Math Operations (Module-level functions) - Phase 8
// ============================================================================

/// Element-wise minimum of two matrices
pub fn min(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Min(src1.ptr, src2.ptr, dst.ptr);
}

/// Element-wise maximum of two matrices
pub fn max(src1: Mat, src2: Mat, dst: *Mat) void {
    c.Mat_Max(src1.ptr, src2.ptr, dst.ptr);
}

/// Absolute value of matrix elements
pub fn abs(src: Mat, dst: *Mat) void {
    c.Mat_Abs(src.ptr, dst.ptr);
}

// ============================================================================
// Channel Operations (Module-level functions) - Phase 9
// ============================================================================

/// Extract a single channel from a multi-channel matrix
pub fn extractChannel(src: Mat, dst: *Mat, coi: i32) void {
    c.Mat_ExtractChannel(src.ptr, dst.ptr, coi);
}

/// Insert a single channel into a multi-channel matrix
pub fn insertChannel(src: Mat, dst: *Mat, coi: i32) void {
    c.Mat_InsertChannel(src.ptr, dst.ptr, coi);
}

/// Mix channels from source matrices to destination matrices
pub fn mixChannels(src: []const Mat, dst: []Mat, fromTo: []const i32) void {
    const allocator = std.heap.page_allocator;

    var src_ptrs = allocator.alloc(?*c.Mat, src.len) catch unreachable;
    defer allocator.free(src_ptrs);
    for (src, 0..) |mat, i| {
        src_ptrs[i] = mat.ptr;
    }

    var dst_ptrs = allocator.alloc(?*c.Mat, dst.len) catch unreachable;
    defer allocator.free(dst_ptrs);
    for (dst, 0..) |*mat, i| {
        dst_ptrs[i] = mat.ptr;
    }

    const fromTo_copy = allocator.alloc(i32, fromTo.len) catch unreachable;
    defer allocator.free(fromTo_copy);
    @memcpy(fromTo_copy, fromTo);

    c.Mat_MixChannels(@ptrCast(src_ptrs.ptr), @intCast(src.len), @ptrCast(dst_ptrs.ptr), @intCast(dst.len), fromTo_copy.ptr, @intCast(fromTo.len / 2));
}

/// Find locations of non-zero elements
pub fn findNonZero(src: Mat, idx: *Mat) void {
    c.Mat_FindNonZero(src.ptr, idx.ptr);
}

// ============================================================================
// Array Concatenation Operations (Module-level functions) - Phase 10
// ============================================================================

/// Repeat (tile) a matrix
pub fn repeat(src: Mat, ny: i32, nx: i32, dst: *Mat) void {
    c.Mat_Repeat(src.ptr, ny, nx, dst.ptr);
}

/// Concatenate matrices horizontally
pub fn hconcat(src: []const Mat, dst: *Mat) void {
    const allocator = std.heap.page_allocator;
    var src_ptrs = allocator.alloc(?*c.Mat, src.len) catch unreachable;
    defer allocator.free(src_ptrs);

    for (src, 0..) |mat, i| {
        src_ptrs[i] = mat.ptr;
    }

    c.Mat_Hconcat(@ptrCast(src_ptrs.ptr), @intCast(src.len), dst.ptr);
}

/// Concatenate matrices vertically
pub fn vconcat(src: []const Mat, dst: *Mat) void {
    const allocator = std.heap.page_allocator;
    var src_ptrs = allocator.alloc(?*c.Mat, src.len) catch unreachable;
    defer allocator.free(src_ptrs);

    for (src, 0..) |mat, i| {
        src_ptrs[i] = mat.ptr;
    }

    c.Mat_Vconcat(@ptrCast(src_ptrs.ptr), @intCast(src.len), dst.ptr);
}

// ============================================================================
// Advanced Linear Algebra Operations (Module-level functions) - Phase 11
// ============================================================================

/// Multiply matrix by its transpose (A*A^T or A^T*A)
pub fn mulTransposed(src: Mat, dst: *Mat, aTa: bool) void {
    c.Mat_MulTransposed(src.ptr, dst.ptr, if (aTa) 1 else 0);
}

/// Compute eigenvalues and eigenvectors of a symmetric matrix
pub fn eigen(src: Mat, eigenvalues: *Mat, eigenvectors: *Mat) bool {
    return c.Mat_Eigen(src.ptr, eigenvalues.ptr, eigenvectors.ptr) != 0;
}

/// Singular Value Decomposition (SVD)
pub fn SVDecomp(src: Mat, w: *Mat, u: *Mat, vt: *Mat, flags: i32) void {
    c.Mat_SVDecomp(src.ptr, w.ptr, u.ptr, vt.ptr, flags);
}

// ============================================================================
// Final P1 Utility Functions (Module-level functions) - Phase 12
// ============================================================================

/// Set matrix to identity matrix with optional scaling
pub fn setIdentity(dst: *Mat, s: c.Scalar) void {
    c.Mat_SetIdentity(dst.ptr, s);
}

/// Sort matrix rows or columns
pub fn sort(src: Mat, dst: *Mat, flags: i32) void {
    c.Mat_Sort(src.ptr, dst.ptr, flags);
}

/// Sort matrix and return indices
pub fn sortIdx(src: Mat, dst: *Mat, flags: i32) void {
    c.Mat_SortIdx(src.ptr, dst.ptr, flags);
}

/// Complete symmetric matrix from upper or lower triangle
pub fn completeSymm(dst: *Mat, lowerToUpper: bool) void {
    c.Mat_CompleteSymm(dst.ptr, if (lowerToUpper) 1 else 0);
}

/// Convert, scale, and compute absolute value
pub fn convertScaleAbs(src: Mat, dst: *Mat, alpha: f64, beta: f64) void {
    c.Mat_ConvertScaleAbs(src.ptr, dst.ptr, alpha, beta);
}

/// Lookup table transformation
pub fn LUT(src: Mat, lut: Mat, dst: *Mat) void {
    c.Mat_LUT(src.ptr, lut.ptr, dst.ptr);
}

/// Check if matrix has any non-zero elements
pub fn hasNonZero(src: Mat) bool {
    return c.Mat_HasNonZero(src.ptr) != 0;
}

// ============================================================================
// Final P2 Utility Functions (Module-level functions) - Phase 13
// ============================================================================

/// Check if matrix values are in range
pub fn checkRange(a: Mat, quiet: bool, minVal: f64, maxVal: f64) bool {
    return c.Mat_CheckRange(a.ptr, if (quiet) 1 else 0, minVal, maxVal) != 0;
}

/// Replace NaN values with specified value
pub fn patchNaNs(a: *Mat, val: f64) void {
    c.Mat_PatchNaNs(a.ptr, val);
}

/// Set random number generator seed
pub fn setRNGSeed(seed: i32) void {
    c.SetRNGSeed(seed);
}

// ============================================================================
// Point2fVector - wrapper for std::vector<cv::Point2f>
// ============================================================================

/// Point2fVector - dynamic array of Point2f
pub const Point2fVector = struct {
    ptr: *c.Point2fVector,

    const Self = @This();

    /// Create a new Point2fVector
    pub fn init() Error!Self {
        const ptr = c.Point2fVector_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Delete the Point2fVector
    pub fn deinit(self: *Self) void {
        c.Point2fVector_Delete(self.ptr);
    }

    /// Get the size of the vector
    pub fn size(self: Self) usize {
        return @intCast(c.Point2fVector_Size(self.ptr));
    }

    /// Get element at index
    pub fn at(self: Self, index: usize) Point2f {
        const c_pt = c.Point2fVector_At(self.ptr, @intCast(index));
        return Point2f{ .x = c_pt.x, .y = c_pt.y };
    }

    /// Append a point to the vector
    pub fn append(self: *Self, point: Point2f) !void {
        c.Point2fVector_Append(self.ptr, point.toC());
    }
};

// ============================================================================
// PointsVector - wrapper for std::vector<std::vector<cv::Point>>
// ============================================================================

/// PointsVector - dynamic array of PointVector (contours)
pub const PointsVector = struct {
    ptr: *c.PointsVector,

    const Self = @This();

    /// Create a new PointsVector
    pub fn init() Error!Self {
        const ptr = c.PointsVector_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Delete the PointsVector
    pub fn deinit(self: *Self) void {
        c.PointsVector_Delete(self.ptr);
    }

    /// Get the size of the vector
    pub fn size(self: Self) usize {
        return @intCast(c.PointsVector_Size(self.ptr));
    }

    /// Get element at index (returns a new PointVector that must be freed)
    pub fn at(self: Self, index: usize) Error!PointVector {
        const ptr = c.PointsVector_At(self.ptr, @intCast(index)) orelse return Error.NullPointer;
        return PointVector{ .ptr = ptr };
    }

    /// Append a PointVector to the collection
    pub fn append(self: *Self, points: PointVector) !void {
        c.PointsVector_Append(self.ptr, points.ptr);
    }
};

// ============================================================================
// PointVector - wrapper for std::vector<cv::Point>
// ============================================================================

/// PointVector - dynamic array of Point
pub const PointVector = struct {
    ptr: *c.PointVector,

    const Self = @This();

    /// Create a new PointVector
    pub fn init() Error!Self {
        const ptr = c.PointVector_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Delete the PointVector
    pub fn deinit(self: *Self) void {
        c.PointVector_Delete(self.ptr);
    }

    /// Get the size of the vector
    pub fn size(self: Self) usize {
        return @intCast(c.PointVector_Size(self.ptr));
    }

    /// Get element at index
    pub fn at(self: Self, index: usize) Point {
        const c_pt = c.PointVector_At(self.ptr, @intCast(index));
        return Point{ .x = c_pt.x, .y = c_pt.y };
    }

    /// Append a point to the vector
    pub fn append(self: *Self, point: Point) !void {
        c.PointVector_Append(self.ptr, point.toC());
    }
};

// ============================================================================
// DFT / Frequency domain functions
// ============================================================================

/// DFT flags
pub const DftFlags = struct {
    pub const inverse: i32 = 1;
    pub const scale: i32 = 2;
    pub const rows: i32 = 4;
    pub const complex_output: i32 = 16;
    pub const real_output: i32 = 32;
    pub const complex_input: i32 = 64;
};

/// Performs a forward or inverse discrete Fourier transform
pub fn dft(src: Mat, dst: *Mat, flags: i32, nonzero_rows: i32) void {
    c.Mat_DFT(src.ptr, dst.ptr, flags, nonzero_rows);
}

/// Performs an inverse discrete Fourier transform
pub fn idft(src: Mat, dst: *Mat, flags: i32, nonzero_rows: i32) void {
    c.Mat_IDFT(src.ptr, dst.ptr, flags, nonzero_rows);
}

/// Performs a forward or inverse discrete cosine transform
pub fn dct(src: Mat, dst: *Mat, flags: i32) void {
    c.Mat_DCT(src.ptr, dst.ptr, flags);
}

/// Performs an inverse discrete cosine transform
pub fn idct(src: Mat, dst: *Mat, flags: i32) void {
    c.Mat_IDCT(src.ptr, dst.ptr, flags);
}

/// Returns the optimal DFT size for a given vector size
pub fn getOptimalDFTSize(vecsize: i32) i32 {
    return c.Mat_GetOptimalDFTSize(vecsize);
}

/// Performs element-by-element multiplication of two Fourier spectrums
pub fn mulSpectrums(a: Mat, b: Mat, result: *Mat, flags: i32, conj_b: bool) void {
    c.Mat_MulSpectrums(a.ptr, b.ptr, result.ptr, flags, if (conj_b) 1 else 0);
}

// ============================================================================
// Math / Transform functions
// ============================================================================

/// Performs matrix transformation of every array element
pub fn transform(src: Mat, dst: *Mat, m: Mat) void {
    c.Mat_Transform(src.ptr, dst.ptr, m.ptr);
}

/// Performs perspective matrix transformation of vectors
pub fn perspectiveTransform(src: Mat, dst: *Mat, m: Mat) void {
    c.Mat_PerspectiveTransform(src.ptr, dst.ptr, m.ptr);
}

/// Calculates the rotation angle of 2D vectors
pub fn phase(x: Mat, y: Mat, angle: *Mat, angle_in_degrees: bool) void {
    c.Mat_Phase(x.ptr, y.ptr, angle.ptr, if (angle_in_degrees) 1 else 0);
}

/// Calculates the magnitude of 2D vectors
pub fn computeMagnitude(x: Mat, y: Mat, mag: *Mat) void {
    c.Mat_Magnitude(x.ptr, y.ptr, mag.ptr);
}

/// Converts polar coordinates to Cartesian
pub fn polarToCart(mag: Mat, angle: Mat, x: *Mat, y: *Mat, angle_in_degrees: bool) void {
    c.Mat_PolarToCart(mag.ptr, angle.ptr, x.ptr, y.ptr, if (angle_in_degrees) 1 else 0);
}

/// Converts Cartesian coordinates to polar
pub fn cartToPolar(x: Mat, y: Mat, mag: *Mat, angle: *Mat, angle_in_degrees: bool) void {
    c.Mat_CartToPolar(x.ptr, y.ptr, mag.ptr, angle.ptr, if (angle_in_degrees) 1 else 0);
}

// ============================================================================
// Random number generation
// ============================================================================

/// Generates uniformly distributed random numbers
pub fn randu(mat: *Mat, low: Scalar, high: Scalar) void {
    c.Mat_Randu(mat.ptr, low.toC(), high.toC());
}

/// Generates normally distributed random numbers
pub fn randn(mat: *Mat, mean_val: Scalar, stddev: Scalar) void {
    c.Mat_Randn(mat.ptr, mean_val.toC(), stddev.toC());
}

/// Shuffles the array elements randomly
pub fn randShuffle(mat: *Mat) void {
    c.Mat_RandShuffle(mat.ptr);
}

// ============================================================================
// Clustering
// ============================================================================

/// KMeans flags
pub const KMeansFlags = struct {
    pub const random_centers: i32 = 0;
    pub const pp_centers: i32 = 2;
    pub const use_initial_labels: i32 = 1;
};

/// Finds centers of clusters and groups input samples around them
pub fn kmeans(data: Mat, k: i32, best_labels: *Mat, max_iter: i32, epsilon: f64, attempts: i32, flags: i32, centers: *Mat) f64 {
    return c.Mat_KMeans(data.ptr, k, best_labels.ptr, max_iter, epsilon, attempts, flags, centers.ptr);
}

// ============================================================================
// PCA (Principal Component Analysis)
// ============================================================================

pub const PCA = struct {
    const Self = @This();
    ptr: ?*anyopaque,

    /// PCA flags
    pub const Flags = struct {
        pub const data_as_row: i32 = 0;
        pub const data_as_col: i32 = 1;
    };

    /// Create a PCA object
    pub fn init(data: Mat, mean_val: Mat, flags: i32, maxComponents: i32) Self {
        return .{ .ptr = c.PCA_Create(data.ptr, mean_val.ptr, flags, maxComponents) };
    }

    /// Project vectors into the principal component subspace
    pub fn project(self: Self, vec: Mat, result: *Mat) void {
        c.PCA_Project(self.ptr, vec.ptr, result.ptr);
    }

    /// Reconstruct vectors from the principal component subspace
    pub fn backProject(self: Self, vec: Mat, result: *Mat) void {
        c.PCA_BackProject(self.ptr, vec.ptr, result.ptr);
    }

    /// Get eigenvalues
    pub fn getEigenvalues(self: Self) !Mat {
        const ptr = c.PCA_GetEigenvalues(self.ptr) orelse return Error.MatCreationFailed;
        return Mat{ .ptr = ptr };
    }

    /// Get eigenvectors
    pub fn getEigenvectors(self: Self) !Mat {
        const ptr = c.PCA_GetEigenvectors(self.ptr) orelse return Error.MatCreationFailed;
        return Mat{ .ptr = ptr };
    }

    /// Get mean vector
    pub fn getMean(self: Self) !Mat {
        const ptr = c.PCA_GetMean(self.ptr) orelse return Error.MatCreationFailed;
        return Mat{ .ptr = ptr };
    }

    /// Destroy the PCA object
    pub fn deinit(self: Self) void {
        c.PCA_Close(self.ptr);
    }
};

// ============================================================================
// Additional Utility Functions
// ============================================================================

/// Forms a border around an image
pub fn copyMakeBorder(src: Mat, dst: *Mat, top: i32, bottom: i32, left: i32, right: i32, borderType: i32, value: Scalar) void {
    c.Mat_CopyMakeBorder(src.ptr, dst.ptr, top, bottom, left, right, borderType, value.toC());
}

/// Computes the source location of an extrapolated pixel
pub fn borderInterpolate(p: i32, len: i32, borderType: i32) i32 {
    return c.Mat_BorderInterpolate(p, len, borderType);
}

// ============================================================================
// Linear Algebra Functions
// ============================================================================

/// Calculates the covariance matrix of a set of vectors
pub fn calcCovarMatrix(samples: Mat, covar: *Mat, mean_val: *Mat, flags: i32, ctype: i32) void {
    c.Mat_CalcCovarMatrix(samples.ptr, covar.ptr, mean_val.ptr, flags, ctype);
}

/// Calculates the Mahalanobis distance between two vectors
pub fn mahalanobis(v1: Mat, v2: Mat, icovar: Mat) f64 {
    return c.Mat_Mahalanobis(v1.ptr, v2.ptr, icovar.ptr);
}
