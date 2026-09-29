# Core Module

Fundamental data structures and operations.

## Mat — Matrix / Image Container

### Creation

```zig
fn init() !Mat;                                              // Empty (0×0)
fn initWithSize(rows: i32, cols: i32, mat_type: i32) !Mat;   // Sized
fn initFromBytes(rows: i32, cols: i32, mat_type: i32, bytes: []u8, step: usize) !Mat;
fn zeros(rows: i32, cols: i32, mat_type: i32) !Mat;
fn ones(rows: i32, cols: i32, mat_type: i32) !Mat;
fn eye(rows: i32, cols: i32, mat_type: i32) !Mat;
fn clone(self: Mat) !Mat;
fn deinit(self: *Mat) void;
```

### Properties

```zig
fn rows(self: Mat) i32;           fn cols(self: Mat) i32;
fn channels(self: Mat) i32;       fn depth(self: Mat) i32;
fn matType(self: Mat) i32;        fn total(self: Mat) usize;
fn elemSize(self: Mat) usize;     fn step(self: Mat) usize;
fn empty(self: Mat) bool;         fn data(self: Mat) [*]u8;
```

### Operations

```zig
fn copyTo(self: Mat, dst: *Mat) void;
fn convertTo(self: Mat, dst: *Mat, rtype: i32, alpha: f64, beta: f64) void;
fn setTo(self: Mat, value: Scalar) void;
fn setToMask(self: Mat, value: Scalar, mask: Mat) void;
fn reshape(self: Mat, cn: i32, rows: i32) !Mat;
fn t(self: Mat) !Mat;                           // Transpose
fn inv(self: Mat, method: i32) !Mat;            // Inverse
fn mul(self: Mat, other: Mat, scale: f64) !Mat; // Element-wise multiply
fn dot(self: Mat, other: Mat) f64;
fn cross(self: Mat, other: Mat) !Mat;
```

### Element Access

```zig
fn getDouble(self: Mat, row: i32, col: i32) f64;
fn getFloat(self: Mat, row: i32, col: i32) f32;
fn getInt(self: Mat, row: i32, col: i32) i32;
fn getUChar(self: Mat, row: i32, col: i32) u8;
fn setDouble(self: Mat, row: i32, col: i32, value: f64) void;
fn setFloat(self: Mat, row: i32, col: i32, value: f32) void;
fn setInt(self: Mat, row: i32, col: i32, value: i32) void;
fn setUChar(self: Mat, row: i32, col: i32, value: u8) void;
```

### Submatrix / ROI

```zig
fn rowAt(self: Mat, y: i32) !Mat;
fn colAt(self: Mat, x: i32) !Mat;
fn rowRange(self: Mat, start: i32, end: i32) !Mat;
fn colRange(self: Mat, start: i32, end: i32) !Mat;
fn submat(self: Mat, roi: Rect) !Mat;
fn submatRanges(self: Mat, row_start: i32, row_end: i32, col_start: i32, col_end: i32) !Mat;
```

## Mat Types

| Type     | Value | Description                           |
| -------- | ----- | ------------------------------------- |
| CV_8UC1  | 0     | 8-bit unsigned, 1 channel (grayscale) |
| CV_8UC3  | 16    | 8-bit unsigned, 3 channels (BGR)      |
| CV_8UC4  | 24    | 8-bit unsigned, 4 channels (BGRA)     |
| CV_32FC1 | 5     | 32-bit float, 1 channel               |
| CV_32FC3 | 21    | 32-bit float, 3 channels              |
| CV_64FC1 | 6     | 64-bit float, 1 channel               |

**Formula:** `base_type + (channels - 1) * 8`

## Basic Types

```zig
const Point = struct { x: i32, y: i32 };
const Point2f = struct { x: f32, y: f32 };
const Point3f = struct { x: f32, y: f32, z: f32 };
const Rect = struct { x: i32, y: i32, width: i32, height: i32 };
const Size = struct { width: i32, height: i32 };
const Scalar = struct { fn init(v0: f64, v1: f64, v2: f64, v3: f64) Scalar; fn all(v: f64) Scalar; };
```

## Container Types

```zig
const Mats = struct { fn init() !Mats; fn deinit(*Mats) void; fn append(*Mats, Mat) void; fn size(Mats) usize; };
const PointVector = struct { /* init, deinit, append, size, at */ };
const Point2fVector = struct { /* init, deinit, append, size, at */ };
const PointsVector = struct { /* init, deinit, append, size, at — vector of PointVector */ };
const RectVector = struct { /* init, deinit, size, at */ };
const TermCriteria = struct { fn init(kind: i32, maxCount: i32, epsilon: f64) TermCriteria; };
const RNG = struct { fn init(state: u64) RNG; fn uniform(min: i32, max: i32) i32; fn gaussian(sigma: f64) f64; };
```

## Example

```zig
const cv = @import("zopencv");

var img = try cv.Mat.initWithSize(480, 640, cv.Mat.MatType.cv8uc3);
defer img.deinit();
img.setTo(cv.Scalar.init(255, 0, 0, 0)); // Fill with blue
```