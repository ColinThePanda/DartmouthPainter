const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Scalar = core.Scalar;
pub const Size = core.Size;
pub const Point = core.Point;
pub const Rect = core.Rect;

/// Color conversion codes
pub const ColorConversionCode = enum(i32) {
    bgr2gray = 6,
    bgr2rgb = 4,
    gray2bgr = 8,
    rgb2gray = 7,
    bgr2hsv = 40,
    hsv2bgr = 54,
};

/// Interpolation flags
pub const InterpolationFlag = enum(i32) {
    nearest = 0,
    linear = 1,
    cubic = 2,
    area = 3,
    lanczos4 = 4,
};

/// Morphological operation types
pub const MorphType = enum(i32) {
    erode = 0,
    dilate = 1,
    open = 2,
    close = 3,
    gradient = 4,
    tophat = 5,
    blackhat = 6,
};

/// Morphological element shapes
pub const MorphShape = enum(i32) {
    rect = 0,
    cross = 1,
    ellipse = 2,
};

/// Threshold types
pub const ThresholdType = enum(i32) {
    binary = 0,
    binary_inv = 1,
    trunc = 2,
    tozero = 3,
    tozero_inv = 4,
    otsu = 8,
};

/// Convert color space
pub fn cvtColor(src: Mat, dst: *Mat, code: ColorConversionCode) void {
    c.CvtColor(src.ptr, dst.ptr, @intFromEnum(code));
}

/// Resize image
pub fn resize(src: Mat, dst: *Mat, dsize: Size, fx: f64, fy: f64, interpolation: InterpolationFlag) void {
    c.Resize(src.ptr, dst.ptr, dsize.toC(), fx, fy, @intFromEnum(interpolation));
}

/// Gaussian blur
pub fn gaussianBlur(src: Mat, dst: *Mat, ksize: Size, sigmaX: f64, sigmaY: f64, borderType: i32) void {
    c.GaussianBlur(src.ptr, dst.ptr, ksize.toC(), sigmaX, sigmaY, borderType);
}

/// Median blur
pub fn medianBlur(src: Mat, dst: *Mat, ksize: i32) void {
    c.MedianBlur(src.ptr, dst.ptr, ksize);
}

/// Box blur
pub fn blur(src: Mat, dst: *Mat, ksize: Size) void {
    c.Blur(src.ptr, dst.ptr, ksize.toC());
}

/// Bilateral filter
pub fn bilateralFilter(src: Mat, dst: *Mat, d: i32, sigmaColor: f64, sigmaSpace: f64, borderType: i32) void {
    c.BilateralFilter(src.ptr, dst.ptr, d, sigmaColor, sigmaSpace, borderType);
}

/// Canny edge detection
pub fn canny(src: Mat, dst: *Mat, threshold1: f64, threshold2: f64, apertureSize: i32, L2gradient: bool) void {
    c.Canny(src.ptr, dst.ptr, threshold1, threshold2, apertureSize, if (L2gradient) 1 else 0);
}

/// Sobel operator
pub fn sobel(src: Mat, dst: *Mat, ddepth: i32, dx: i32, dy: i32, ksize: i32, scale: f64, delta: f64, borderType: i32) void {
    c.Sobel(src.ptr, dst.ptr, ddepth, dx, dy, ksize, scale, delta, borderType);
}

/// Laplacian operator
pub fn laplacian(src: Mat, dst: *Mat, ddepth: i32, ksize: i32, scale: f64, delta: f64, borderType: i32) void {
    c.Laplacian(src.ptr, dst.ptr, ddepth, ksize, scale, delta, borderType);
}

/// Erode image
pub fn erode(src: Mat, dst: *Mat, kernel: Mat, anchor: Point, iterations: i32, borderType: i32) void {
    c.Erode(src.ptr, dst.ptr, kernel.ptr, anchor.toC(), iterations, borderType);
}

/// Dilate image
pub fn dilate(src: Mat, dst: *Mat, kernel: Mat, anchor: Point, iterations: i32, borderType: i32) void {
    c.Dilate(src.ptr, dst.ptr, kernel.ptr, anchor.toC(), iterations, borderType);
}

/// Morphological operation
pub fn morphologyEx(src: Mat, dst: *Mat, op: MorphType, kernel: Mat, anchor: Point, iterations: i32, borderType: i32) void {
    c.MorphologyEx(src.ptr, dst.ptr, @intFromEnum(op), kernel.ptr, anchor.toC(), iterations, borderType);
}

/// Get structuring element
pub fn getStructuringElement(shape: MorphShape, ksize: Size, anchor: Point) core.Error!Mat {
    const ptr = c.GetStructuringElement(@intFromEnum(shape), ksize.toC(), anchor.toC()) orelse return core.Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

/// Threshold
pub fn threshold(src: Mat, dst: *Mat, thresh: f64, maxval: f64, threshType: ThresholdType) f64 {
    return c.Threshold(src.ptr, dst.ptr, thresh, maxval, @intFromEnum(threshType));
}

/// Adaptive threshold
pub fn adaptiveThreshold(src: Mat, dst: *Mat, maxValue: f64, adaptiveMethod: i32, thresholdType: ThresholdType, blockSize: i32, C: f64) void {
    c.AdaptiveThreshold(src.ptr, dst.ptr, maxValue, adaptiveMethod, @intFromEnum(thresholdType), blockSize, C);
}

/// Draw line
pub fn line(img: *Mat, pt1: Point, pt2: Point, color: Scalar, thickness: i32, lineType: i32, shift: i32) void {
    c.Line(img.ptr, pt1.toC(), pt2.toC(), color.toC(), thickness, lineType, shift);
}

/// Draw rectangle
pub fn rectangle(img: *Mat, rect: core.Rect, color: Scalar, thickness: i32, lineType: i32, shift: i32) void {
    c.Rectangle(img.ptr, rect.toC(), color.toC(), thickness, lineType, shift);
}

/// Draw circle
pub fn circle(img: *Mat, center: Point, radius: i32, color: Scalar, thickness: i32, lineType: i32, shift: i32) void {
    c.Circle(img.ptr, center.toC(), radius, color.toC(), thickness, lineType, shift);
}

/// Draw ellipse
pub fn ellipse(img: *Mat, center: Point, axes: Size, angle: f64, startAngle: f64, endAngle: f64, color: Scalar, thickness: i32, lineType: i32, shift: i32) void {
    c.Ellipse(img.ptr, center.toC(), axes.toC(), angle, startAngle, endAngle, color.toC(), thickness, lineType, shift);
}

/// Put text
pub fn putText(img: *Mat, text: []const u8, org: Point, fontFace: i32, fontScale: f64, color: Scalar, thickness: i32, lineType: i32, bottomLeftOrigin: bool) void {
    const text_z = std.mem.sliceTo(text, 0);
    c.PutText(img.ptr, text_z.ptr, org.toC(), fontFace, fontScale, color.toC(), thickness, lineType, if (bottomLeftOrigin) 1 else 0);
}

// Font faces
pub const FONT_HERSHEY_SIMPLEX: i32 = 0;
pub const FONT_HERSHEY_PLAIN: i32 = 1;
pub const FONT_HERSHEY_DUPLEX: i32 = 2;
pub const FONT_HERSHEY_COMPLEX: i32 = 3;
pub const FONT_HERSHEY_TRIPLEX: i32 = 4;
pub const FONT_HERSHEY_COMPLEX_SMALL: i32 = 5;
pub const FONT_HERSHEY_SCRIPT_SIMPLEX: i32 = 6;
pub const FONT_HERSHEY_SCRIPT_COMPLEX: i32 = 7;

// Line types
pub const LINE_4: i32 = 4;
pub const LINE_8: i32 = 8;
pub const LINE_AA: i32 = 16;

// Border types
pub const BORDER_CONSTANT: i32 = 0;
pub const BORDER_REPLICATE: i32 = 1;
pub const BORDER_REFLECT: i32 = 2;
pub const BORDER_WRAP: i32 = 3;
pub const BORDER_REFLECT_101: i32 = 4;
pub const BORDER_DEFAULT: i32 = 4;

// ============================================================================
// Image Pyramids
// ============================================================================

/// Downsample image using Gaussian pyramid
pub fn pyrDown(src: Mat, dst: *Mat, dstsize: Size, borderType: i32) void {
    c.PyrDown(src.ptr, dst.ptr, dstsize.toC(), borderType);
}

/// Upsample image using Gaussian pyramid
pub fn pyrUp(src: Mat, dst: *Mat, dstsize: Size, borderType: i32) void {
    c.PyrUp(src.ptr, dst.ptr, dstsize.toC(), borderType);
}

// ============================================================================
// Geometric Transforms
// ============================================================================

/// Apply affine transformation
pub fn warpAffine(src: Mat, dst: *Mat, M: Mat, dsize: Size, flags: i32, borderMode: i32, borderValue: Scalar) void {
    c.WarpAffine(src.ptr, dst.ptr, M.ptr, dsize.toC(), flags, borderMode, borderValue.toC());
}

/// Apply perspective transformation
pub fn warpPerspective(src: Mat, dst: *Mat, M: Mat, dsize: Size, flags: i32, borderMode: i32, borderValue: Scalar) void {
    c.WarpPerspective(src.ptr, dst.ptr, M.ptr, dsize.toC(), flags, borderMode, borderValue.toC());
}

// ============================================================================
// Transform Matrix Functions
// ============================================================================

/// Get affine transformation matrix from 3 point pairs
pub fn getAffineTransform(src: core.Point2fVector, dst: core.Point2fVector) core.Error!Mat {
    const ptr = c.GetAffineTransform(src.ptr, dst.ptr) orelse return core.Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

/// Get perspective transformation matrix from 4 point pairs
pub fn getPerspectiveTransform(src: core.Point2fVector, dst: core.Point2fVector, solveMethod: i32) core.Error!Mat {
    const ptr = c.GetPerspectiveTransform(src.ptr, dst.ptr, solveMethod) orelse return core.Error.MatCreationFailed;
    return Mat{ .ptr = ptr };
}

// ============================================================================
// Contour Operations
// ============================================================================

/// Find contours in binary image
pub fn findContours(image: Mat, mode: i32, method: i32) core.Error!core.PointsVector {
    const contours = try core.PointsVector.init();
    c.FindContours(image.ptr, contours.ptr, mode, method);
    return contours;
}

/// Draw contours on image
pub fn drawContours(image: *Mat, contours: core.PointsVector, contourIdx: i32, color: Scalar, thickness: i32) void {
    c.DrawContours(image.ptr, contours.ptr, contourIdx, color.toC(), thickness);
}

/// Calculate contour area
pub fn contourArea(contour: core.PointVector, oriented: bool) f64 {
    const oriented_int: c_int = if (oriented) 1 else 0;
    return c.ContourArea(contour.ptr, oriented_int);
}

/// Calculate contour perimeter
pub fn arcLength(curve: core.PointVector, closed: bool) f64 {
    const closed_int: c_int = if (closed) 1 else 0;
    return c.ArcLength(curve.ptr, closed_int);
}

// Contour retrieval modes
pub const RETR_EXTERNAL: i32 = 0;
pub const RETR_LIST: i32 = 1;
pub const RETR_CCOMP: i32 = 2;
pub const RETR_TREE: i32 = 3;

// Contour approximation methods
pub const CHAIN_APPROX_NONE: i32 = 1;
pub const CHAIN_APPROX_SIMPLE: i32 = 2;
pub const CHAIN_APPROX_TC89_L1: i32 = 3;
pub const CHAIN_APPROX_TC89_KCOS: i32 = 4;

// ============================================================================
// RotatedRect type
// ============================================================================

pub const RotatedRect = struct {
    center: core.Point2f,
    size: Size2f,
    angle: f32,

    pub const Size2f = struct {
        width: f32,
        height: f32,
    };
};

// ============================================================================
// Shape Analysis Functions
// ============================================================================

/// Get bounding rectangle of a contour
pub fn boundingRect(contour: core.PointVector) Rect {
    const r = c.BoundingRect(contour.ptr);
    return Rect{ .x = r.x, .y = r.y, .width = r.width, .height = r.height };
}

/// Get minimum area rotated rectangle
pub fn minAreaRect(points: core.PointVector) RotatedRect {
    const rr = c.MinAreaRect(points.ptr);
    return RotatedRect{
        .center = core.Point2f{ .x = rr.center_x, .y = rr.center_y },
        .size = .{ .width = rr.width, .height = rr.height },
        .angle = rr.angle,
    };
}

/// Get minimum enclosing circle
pub fn minEnclosingCircle(points: core.PointVector) struct { center: core.Point2f, radius: f32 } {
    var x: f32 = 0;
    var y: f32 = 0;
    var radius: f32 = 0;
    c.MinEnclosingCircle(points.ptr, &x, &y, &radius);
    return .{
        .center = core.Point2f{ .x = x, .y = y },
        .radius = radius,
    };
}

/// Approximate a polygonal curve with specified precision
pub fn approxPolyDP(curve: core.PointVector, epsilon: f64, closed: bool) core.Error!core.PointVector {
    const closed_int: c_int = if (closed) 1 else 0;
    const ptr = c.ApproxPolyDP(curve.ptr, epsilon, closed_int) orelse return core.Error.NullPointer;
    return core.PointVector{ .ptr = ptr };
}

/// Find convex hull of a point set
pub fn convexHull(points: core.PointVector, clockwise: bool) core.Error!core.PointVector {
    const cw_int: c_int = if (clockwise) 1 else 0;
    const ptr = c.ConvexHull(points.ptr, cw_int) orelse return core.Error.NullPointer;
    return core.PointVector{ .ptr = ptr };
}

// ============================================================================
// Histogram Functions
// ============================================================================

/// Equalize histogram of a grayscale image
pub fn equalizeHist(src: Mat, dst: *Mat) void {
    c.EqualizeHist(src.ptr, dst.ptr);
}

// ============================================================================
// Moments type
// ============================================================================

pub const Moments = struct {
    m00: f64,
    m10: f64,
    m01: f64,
    m20: f64,
    m11: f64,
    m02: f64,
    m30: f64,
    m21: f64,
    m12: f64,
    m03: f64,
    mu20: f64,
    mu11: f64,
    mu02: f64,
    mu30: f64,
    mu21: f64,
    mu12: f64,
    mu03: f64,
    nu20: f64,
    nu11: f64,
    nu02: f64,
    nu30: f64,
    nu21: f64,
    nu12: f64,
    nu03: f64,
};

// ============================================================================
// Feature Detection Functions
// ============================================================================

/// Detect strong corners using Shi-Tomasi method
pub fn goodFeaturesToTrack(image: Mat, corners: *Mat, max_corners: i32, quality_level: f64, min_distance: f64) void {
    c.GoodFeaturesToTrack(image.ptr, corners.ptr, max_corners, quality_level, min_distance);
}

/// Match template in image
pub fn matchTemplate(image: Mat, templ: Mat, result: *Mat, method: i32) void {
    c.MatchTemplate(image.ptr, templ.ptr, result.ptr, method);
}

// ============================================================================
// Hough Transform Functions
// ============================================================================

/// Detect lines using Standard Hough Transform
pub fn houghLines(src: Mat, lines: *Mat, rho: f64, theta: f64, thresh: i32) void {
    c.HoughLines(src.ptr, lines.ptr, rho, theta, thresh);
}

/// Detect circles using Hough Transform
pub fn houghCircles(src: Mat, circles: *Mat, method: i32, dp: f64, min_dist: f64, param1: f64, param2: f64, min_radius: i32, max_radius: i32) void {
    c.HoughCircles(src.ptr, circles.ptr, method, dp, min_dist, param1, param2, min_radius, max_radius);
}

// ============================================================================
// Analysis Functions
// ============================================================================

/// Label connected components in binary image
/// Returns number of labels (including background)
pub fn connectedComponents(image: Mat, labels: *Mat, connectivity: i32) i32 {
    return c.ConnectedComponents(image.ptr, labels.ptr, connectivity);
}

/// Label connected components with statistics
/// Returns number of labels (including background)
/// stats: CV_32S matrix of shape [nLabels x 5], centroids: CV_64F matrix of shape [nLabels x 2]
pub fn connectedComponentsWithStats(image: Mat, labels: *Mat, stats: *Mat, centroids: *Mat, connectivity: i32) i32 {
    return c.ConnectedComponentsWithStats(image.ptr, labels.ptr, stats.ptr, centroids.ptr, connectivity);
}

/// Calculate image moments
pub fn moments(src: Mat, binary_image: bool) Moments {
    const bin: c_int = if (binary_image) 1 else 0;
    const m = c.ImageMoments(src.ptr, bin);
    return Moments{
        .m00 = m.m00,
        .m10 = m.m10,
        .m01 = m.m01,
        .m20 = m.m20,
        .m11 = m.m11,
        .m02 = m.m02,
        .m30 = m.m30,
        .m21 = m.m21,
        .m12 = m.m12,
        .m03 = m.m03,
        .mu20 = m.mu20,
        .mu11 = m.mu11,
        .mu02 = m.mu02,
        .mu30 = m.mu30,
        .mu21 = m.mu21,
        .mu12 = m.mu12,
        .mu03 = m.mu03,
        .nu20 = m.nu20,
        .nu11 = m.nu11,
        .nu02 = m.nu02,
        .nu30 = m.nu30,
        .nu21 = m.nu21,
        .nu12 = m.nu12,
        .nu03 = m.nu03,
    };
}

/// Template matching methods
pub const TemplateMatchMode = struct {
    pub const tm_sqdiff: i32 = 0;
    pub const tm_sqdiff_normed: i32 = 1;
    pub const tm_ccorr: i32 = 2;
    pub const tm_ccorr_normed: i32 = 3;
    pub const tm_ccoeff: i32 = 4;
    pub const tm_ccoeff_normed: i32 = 5;
};

/// Hough circle detection methods
pub const HoughMode = struct {
    pub const hough_gradient: i32 = 3;
    pub const hough_gradient_alt: i32 = 4;
};

// ============================================================================
// Advanced Filtering Functions
// ============================================================================

/// Apply custom convolution filter
pub fn filter2D(src: Mat, dst: *Mat, ddepth: i32, kernel: Mat, anchor: Point, delta: f64, border_type: i32) void {
    c.Filter2D(src.ptr, dst.ptr, ddepth, kernel.ptr, .{ .x = anchor.x, .y = anchor.y }, delta, border_type);
}

/// Calculate image derivatives using Scharr operator
pub fn scharr(src: Mat, dst: *Mat, ddepth: i32, dx: i32, dy: i32, scale: f64, delta: f64, border_type: i32) void {
    c.Scharr(src.ptr, dst.ptr, ddepth, dx, dy, scale, delta, border_type);
}

// ============================================================================
// Shape Matching Functions
// ============================================================================

/// Compare two shapes using Hu moments
pub fn matchShapes(contour1: core.PointVector, contour2: core.PointVector, method: i32, parameter: f64) f64 {
    return c.MatchShapes(contour1.ptr, contour2.ptr, method, parameter);
}

/// Shape match methods
pub const ShapeMatchMethod = struct {
    pub const contours_match_i1: i32 = 1;
    pub const contours_match_i2: i32 = 2;
    pub const contours_match_i3: i32 = 3;
};

// ============================================================================
// Fitting Functions
// ============================================================================

/// Fit a line to 2D points
pub fn fitLine(points: core.PointVector, line_mat: *Mat, dist_type: i32, param: f64, reps: f64, aeps: f64) void {
    c.FitLine(points.ptr, line_mat.ptr, dist_type, param, reps, aeps);
}

/// Fit an ellipse to a set of 2D points (minimum 5 points)
pub fn fitEllipse(points: core.PointVector) RotatedRect {
    const rr = c.FitEllipse(points.ptr);
    return RotatedRect{
        .center = core.Point2f{ .x = rr.center_x, .y = rr.center_y },
        .size = .{ .width = rr.width, .height = rr.height },
        .angle = rr.angle,
    };
}

/// Distance types for fitLine
pub const DistType = struct {
    pub const dist_l1: i32 = 1;
    pub const dist_l2: i32 = 2;
    pub const dist_l12: i32 = 4;
    pub const dist_fair: i32 = 5;
    pub const dist_welsch: i32 = 6;
    pub const dist_huber: i32 = 7;
};

// ============================================================================
// Corner Detection Functions
// ============================================================================

/// Harris corner detector
pub fn cornerHarris(src: Mat, dst: *Mat, block_size: i32, ksize: i32, k: f64, border_type: i32) void {
    c.CornerHarris(src.ptr, dst.ptr, block_size, ksize, k, border_type);
}

// ============================================================================
// Segmentation Functions
// ============================================================================

/// Pyramid mean shift filtering for image segmentation
pub fn pyrMeanShiftFiltering(src: Mat, dst: *Mat, sp: f64, sr: f64) void {
    c.PyrMeanShiftFiltering(src.ptr, dst.ptr, sp, sr);
}

/// Watershed image segmentation
pub fn watershed(image: Mat, markers: *Mat) void {
    c.Watershed(image.ptr, markers.ptr);
}

// ============================================================================
// Transform Functions
// ============================================================================

/// Calculate distance transform of a binary image
pub fn distanceTransform(src: Mat, dst: *Mat, distance_type: i32, mask_size: i32) void {
    c.DistanceTransform(src.ptr, dst.ptr, distance_type, mask_size);
}

/// Calculate integral image
pub fn integral(src: Mat, sum: *Mat, sqsum: *Mat, sdepth: i32) void {
    c.Integral(src.ptr, sum.ptr, sqsum.ptr, sdepth);
}

// ============================================================================
// Border and Pyramid Functions
// ============================================================================

/// Add border around an image
pub fn copyMakeBorder(src: Mat, dst: *Mat, top: i32, bottom: i32, left_b: i32, right_b: i32, border_type: i32, value: Scalar) void {
    c.CopyMakeBorder(src.ptr, dst.ptr, top, bottom, left_b, right_b, border_type, value.toC());
}

// ============================================================================
// GrabCut Foreground Extraction
// ============================================================================

/// GrabCut modes
pub const GrabCutMode = struct {
    pub const gc_init_with_rect: i32 = 0;
    pub const gc_init_with_mask: i32 = 1;
    pub const gc_eval: i32 = 2;
    pub const gc_eval_freeze_model: i32 = 3;
};

/// GrabCut foreground extraction
pub fn grabCut(img: Mat, mask: *Mat, rect: Rect, bgd_model: *Mat, fgd_model: *Mat, iter_count: i32, mode: i32) void {
    c.GrabCut(img.ptr, mask.ptr, .{ .x = rect.x, .y = rect.y, .width = rect.width, .height = rect.height }, bgd_model.ptr, fgd_model.ptr, iter_count, mode);
}

// ============================================================================
// Flood Fill
// ============================================================================

/// Flood fill a connected region
pub fn floodFill(image: *Mat, mask: *Mat, seed_point: Point, new_val: Scalar, rect: ?*Rect, lo_diff: Scalar, up_diff: Scalar, flags: i32) i32 {
    var c_rect: c.Rect = undefined;
    const result = c.FloodFill(image.ptr, mask.ptr, .{ .x = seed_point.x, .y = seed_point.y }, new_val.toC(), &c_rect, lo_diff.toC(), up_diff.toC(), flags);
    if (rect) |r| {
        r.x = c_rect.x;
        r.y = c_rect.y;
        r.width = c_rect.width;
        r.height = c_rect.height;
    }
    return result;
}

// ============================================================================
// CLAHE (Contrast Limited Adaptive Histogram Equalization)
// ============================================================================

/// CLAHE - Contrast Limited Adaptive Histogram Equalization
pub const Clahe = struct {
    ptr: *c.CLAHE,

    const Self = @This();

    /// Create CLAHE with clip limit and tile grid size
    pub fn init(clip_limit: f64, tile_grid_size: Size) core.Error!Self {
        const ptr = c.CLAHE_Create(clip_limit, .{ .width = tile_grid_size.width, .height = tile_grid_size.height }) orelse return core.Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.CLAHE_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Apply CLAHE to an image
    pub fn apply(self: Self, src: Mat, dst: *Mat) void {
        c.CLAHE_Apply(self.ptr, src.ptr, dst.ptr);
    }

    /// Set clip limit
    pub fn setClipLimit(self: Self, clip_limit: f64) void {
        c.CLAHE_SetClipLimit(self.ptr, clip_limit);
    }

    /// Set tile grid size
    pub fn setTilesGridSize(self: Self, size: Size) void {
        c.CLAHE_SetTilesGridSize(self.ptr, .{ .width = size.width, .height = size.height });
    }
};

// ============================================================================
// Text Measurement
// ============================================================================

/// Get the size of text string when rendered
pub fn getTextSize(text: []const u8, font_face: i32, font_scale: f64, thickness: i32) struct { size: Size, base_line: i32 } {
    var buf: [4096]u8 = undefined;
    const text_z: [*:0]const u8 = blk: {
        if (text.len < buf.len) {
            @memcpy(buf[0..text.len], text);
            buf[text.len] = 0;
            break :blk @ptrCast(buf[0..text.len :0]);
        }
        break :blk @ptrCast(text.ptr);
    };
    var base_line: c_int = 0;
    const sz = c.GetTextSize(text_z, font_face, font_scale, thickness, &base_line);
    return .{
        .size = Size.init(sz.width, sz.height),
        .base_line = @intCast(base_line),
    };
}

// ============================================================================
// Rotation Matrix
// ============================================================================

/// Get 2x3 rotation matrix for 2D rotation
pub fn getRotationMatrix2D(center: core.Point2f, angle: f64, scale: f64) core.Error!Mat {
    const ptr = c.GetRotationMatrix2D(.{ .x = center.x, .y = center.y }, angle, scale) orelse return core.Error.NullPointer;
    return Mat{ .ptr = ptr };
}

// ============================================================================
// Probabilistic Hough Lines
// ============================================================================

/// Probabilistic Hough Line Transform
pub fn houghLinesP(src: Mat, lines: *Mat, rho: f64, theta: f64, thresh: i32, min_line_length: f64, max_line_gap: f64) void {
    c.HoughLinesP(src.ptr, lines.ptr, rho, theta, thresh, min_line_length, max_line_gap);
}

// ============================================================================
// Contour Analysis
// ============================================================================

/// Test whether a point is inside, outside, or on the edge of a contour
pub fn pointPolygonTest(contour: core.PointVector, pt: core.Point2f, measure_dist: bool) f64 {
    return c.PointPolygonTest(contour.ptr, .{ .x = pt.x, .y = pt.y }, if (measure_dist) 1 else 0);
}

/// Check if contour is convex
pub fn isContourConvex(contour: core.PointVector) bool {
    return c.IsContourConvex(contour.ptr) != 0;
}

// ============================================================================
// Advanced Filter Functions
// ============================================================================

/// Box filter (unnormalized or normalized)
pub fn boxFilter(src: Mat, dst: *Mat, ddepth: i32, ksize: Size, anchor: Point, do_normalize: bool, border_type: i32) void {
    c.BoxFilter(src.ptr, dst.ptr, ddepth, .{ .width = ksize.width, .height = ksize.height }, .{ .x = anchor.x, .y = anchor.y }, if (do_normalize) 1 else 0, border_type);
}

/// Separable linear filter
pub fn sepFilter2D(src: Mat, dst: *Mat, ddepth: i32, kernel_x: Mat, kernel_y: Mat, anchor: Point, delta: f64, border_type: i32) void {
    c.SepFilter2D(src.ptr, dst.ptr, ddepth, kernel_x.ptr, kernel_y.ptr, .{ .x = anchor.x, .y = anchor.y }, delta, border_type);
}

// ============================================================================
// Geometric Remap
// ============================================================================

/// Apply generic geometric transform using lookup maps
pub fn remap(src: Mat, dst: *Mat, map1: Mat, map2: Mat, interpolation: i32, border_mode: i32, border_value: Scalar) void {
    c.zocv_Remap(src.ptr, dst.ptr, map1.ptr, map2.ptr, interpolation, border_mode, border_value.toC());
}

// ============================================================================
// Conversion
// ============================================================================

/// Scale, compute absolute value, and convert to 8-bit
pub fn convertScaleAbs(src: Mat, dst: *Mat, alpha: f64, beta: f64) void {
    c.ConvertScaleAbs(src.ptr, dst.ptr, alpha, beta);
}

// ============================================================================
// Normalization
// ============================================================================

/// Norm types for normalize
pub const NormType = struct {
    pub const norm_inf: i32 = 1;
    pub const norm_l1: i32 = 2;
    pub const norm_l2: i32 = 4;
    pub const norm_minmax: i32 = 32;
};

/// Normalize array values to a specified range
pub fn normalize(src: Mat, dst: *Mat, alpha: f64, beta: f64, norm_type: i32) void {
    c.NormalizeImg(src.ptr, dst.ptr, alpha, beta, norm_type);
}

// ============================================================================
// Histogram Comparison
// ============================================================================

/// Histogram comparison methods
pub const HistCompMethod = struct {
    pub const correl: i32 = 0;
    pub const chi_sqr: i32 = 1;
    pub const intersect: i32 = 2;
    pub const bhattacharyya: i32 = 3;
};

/// Compare two histograms
pub fn compareHist(h1: Mat, h2: Mat, method: i32) f64 {
    return c.CompareHist(h1.ptr, h2.ptr, method);
}

// ============================================================================
// Phase 1 Batch 1: Accumulation, ColorMap, Drawing
// ============================================================================

/// Adds an image to an accumulator image
pub fn accumulate(src: Mat, dst: *Mat, mask: ?Mat) void {
    c.Accumulate(src.ptr, dst.ptr, if (mask) |m| m.ptr else null);
}

/// Adds the per-element product of two input images to the accumulator image
pub fn accumulateProduct(src1: Mat, src2: Mat, dst: *Mat, mask: ?Mat) void {
    c.AccumulateProduct(src1.ptr, src2.ptr, dst.ptr, if (mask) |m| m.ptr else null);
}

/// Adds the square of a source image to the accumulator image
pub fn accumulateSquare(src: Mat, dst: *Mat, mask: ?Mat) void {
    c.AccumulateSquare(src.ptr, dst.ptr, if (mask) |m| m.ptr else null);
}

/// Updates a running average
pub fn accumulateWeighted(src: Mat, dst: *Mat, alpha: f64, mask: ?Mat) void {
    c.AccumulateWeighted(src.ptr, dst.ptr, alpha, if (mask) |m| m.ptr else null);
}

/// Applies a GNU Octave/MATLAB equivalent colormap
pub fn applyColorMap(src: Mat, dst: *Mat, colormap: i32) void {
    c.ApplyColorMap(src.ptr, dst.ptr, colormap);
}

/// Draws an arrow segment pointing from the first point to the second one
pub fn arrowedLine(img: *Mat, pt1: Point, pt2: Point, color: Scalar, thickness: i32, line_type: i32, shift: i32, tip_length: f64) void {
    c.ArrowedLine(img.ptr, pt1.toC(), pt2.toC(), color.toC(), thickness, line_type, shift, tip_length);
}

/// Performs linear blending of two images
pub fn blendLinear(src1: Mat, src2: Mat, weights1: Mat, weights2: Mat, dst: *Mat) void {
    c.BlendLinear(src1.ptr, src2.ptr, weights1.ptr, weights2.ptr, dst.ptr);
}

/// Draws a marker on a predefined position in an image
pub fn drawMarker(img: *Mat, position: Point, color: Scalar, marker_type: i32, marker_size: i32, thickness: i32, line_type: i32) void {
    c.DrawMarker(img.ptr, position.toC(), color.toC(), marker_type, marker_size, thickness, line_type);
}

/// Marker type constants
pub const MarkerTypes = struct {
    pub const marker_cross: i32 = 0;
    pub const marker_tilted_cross: i32 = 1;
    pub const marker_star: i32 = 2;
    pub const marker_diamond: i32 = 3;
    pub const marker_square: i32 = 4;
    pub const marker_triangle_up: i32 = 5;
    pub const marker_triangle_down: i32 = 6;
};

/// Colormap types
pub const ColormapTypes = struct {
    pub const autumn: i32 = 0;
    pub const bone: i32 = 1;
    pub const jet: i32 = 2;
    pub const winter: i32 = 3;
    pub const rainbow: i32 = 4;
    pub const ocean: i32 = 5;
    pub const summer: i32 = 6;
    pub const spring: i32 = 7;
    pub const cool: i32 = 8;
    pub const hsv: i32 = 9;
    pub const pink: i32 = 10;
    pub const hot: i32 = 11;
    pub const parula: i32 = 12;
    pub const magma: i32 = 13;
    pub const inferno: i32 = 14;
    pub const plasma: i32 = 15;
    pub const viridis: i32 = 16;
    pub const cividis: i32 = 17;
    pub const twilight: i32 = 18;
    pub const twilight_shifted: i32 = 19;
    pub const turbo: i32 = 20;
    pub const deepgreen: i32 = 21;
};

// ============================================================================
// Phase 1 Batch 2: Fill, kernel generation, transforms
// ============================================================================

/// Fills a convex polygon
pub fn fillConvexPoly(img: *Mat, points: core.PointVector, color: Scalar, line_type: i32) void {
    c.FillConvexPoly(img.ptr, points.ptr, color.toC(), line_type);
}

/// Fills the area bounded by one or more polygons
pub fn fillPoly(img: *Mat, pts: core.PointsVector, color: Scalar, line_type: i32) void {
    c.FillPoly(img.ptr, pts.ptr, color.toC(), line_type);
}

/// Finds the four vertices of a rotated rect
pub fn boxPoints(rect: RotatedRect, points: *Mat) void {
    const c_rect = c.RotatedRect{
        .center_x = rect.center.x,
        .center_y = rect.center.y,
        .width = rect.size.width,
        .height = rect.size.height,
        .angle = rect.angle,
    };
    c.BoxPoints(c_rect, points.ptr);
}

/// Creates a Hanning window (used for DFT)
pub fn createHanningWindow(dst: *Mat, win_size: Size, mat_type: i32) void {
    c.CreateHanningWindow(dst.ptr, win_size.toC(), mat_type);
}

/// Returns a Gaussian filter kernel
pub fn getGaussianKernel(ksize: i32, sigma: f64, ktype: i32) core.Error!Mat {
    const p = c.GetGaussianKernel(ksize, sigma, ktype) orelse return core.Error.NullPointer;
    return Mat{ .ptr = p };
}

/// Retrieves a pixel rectangle from an image with sub-pixel accuracy
pub fn getRectSubPix(image: Mat, patch_size: Size, center: core.Point2f, patch: *Mat) void {
    c.GetRectSubPix(image.ptr, patch_size.toC(), center.toC(), patch.ptr);
}

/// Inverts an affine transformation
pub fn invertAffineTransform(m: Mat, im: *Mat) void {
    c.InvertAffineTransform(m.ptr, im.ptr);
}

/// Calculates the first order image derivative in both x and y using a Sobel operator
pub fn spatialGradient(src: Mat, dx: *Mat, dy: *Mat, ksize: i32, border_type: i32) void {
    c.SpatialGradient(src.ptr, dx.ptr, dy.ptr, ksize, border_type);
}

/// Calculates the normalized sum of squares of the pixel values overlapping the filter
pub fn sqrBoxFilter(src: Mat, dst: *Mat, ddepth: i32, ksize: Size, anchor: Point, do_normalize: bool, border_type: i32) void {
    c.SqrBoxFilter(src.ptr, dst.ptr, ddepth, ksize.toC(), anchor.toC(), if (do_normalize) 1 else 0, border_type);
}

/// Applies a stack blur to an image
pub fn stackBlur(src: Mat, dst: *Mat, ksize: Size) void {
    c.StackBlur(src.ptr, dst.ptr, ksize.toC());
}

// ============================================================================
// Phase 1 Batch 3: Polar, clip, ellipse, Hu, corner, misc
// ============================================================================

/// Remaps an image to polar or semilog-polar coordinates space
pub fn warpPolar(src: Mat, dst: *Mat, dsize: Size, center: core.Point2f, max_radius: f64, flags: i32) void {
    c.WarpPolar(src.ptr, dst.ptr, dsize.toC(), center.toC(), max_radius, flags);
}

/// Clips the line against the image rectangle
pub fn clipLine(img_size: Size, pt1: *Point, pt2: *Point) bool {
    var c_pt1 = pt1.toC();
    var c_pt2 = pt2.toC();
    const result = c.ClipLine(img_size.toC(), &c_pt1, &c_pt2) != 0;
    pt1.x = c_pt1.x;
    pt1.y = c_pt1.y;
    pt2.x = c_pt2.x;
    pt2.y = c_pt2.y;
    return result;
}

/// Approximates an elliptic arc with a polyline
pub fn ellipse2Poly(center: Point, axes: Size, angle: i32, arc_start: i32, arc_end: i32, delta: i32, pts: *core.PointVector) void {
    c.Ellipse2Poly(center.toC(), axes.toC(), angle, arc_start, arc_end, delta, pts.ptr);
}

/// Calculates seven Hu invariants from the image moments
pub fn huMoments(src: Mat) [7]f64 {
    var hu: [7]f64 = undefined;
    c.HuMoments(&hu, src.ptr);
    return hu;
}

/// Calculates the font-specific size to use to achieve a given height in pixels
pub fn getFontScaleFromHeight(font_face: i32, pixel_height: i32, thickness: i32) f64 {
    return c.GetFontScaleFromHeight(font_face, pixel_height, thickness);
}

/// Calculates the minimal eigenvalue of gradient matrices for corner detection
pub fn cornerMinEigenVal(src: Mat, dst: *Mat, block_size: i32, ksize: i32, border_type: i32) void {
    c.CornerMinEigenVal(src.ptr, dst.ptr, block_size, ksize, border_type);
}

/// Calculates eigenvalues and eigenvectors of image blocks for corner detection
pub fn cornerEigenValsAndVecs(src: Mat, dst: *Mat, block_size: i32, ksize: i32, border_type: i32) void {
    c.CornerEigenValsAndVecs(src.ptr, dst.ptr, block_size, ksize, border_type);
}

/// Calculates a feature map for corner detection
pub fn preCornerDetect(src: Mat, dst: *Mat, ksize: i32, border_type: i32) void {
    c.PreCornerDetect(src.ptr, dst.ptr, ksize, border_type);
}

/// Converts an image from one color space to another where the source is two planes
pub fn cvtColorTwoPlane(src1: Mat, src2: Mat, dst: *Mat, code: i32) void {
    c.CvtColorTwoPlane(src1.ptr, src2.ptr, dst.ptr, code);
}

/// Converts image transformation maps from one representation to another
pub fn convertMaps(map1: Mat, map2: Mat, dstmap1: *Mat, dstmap2: *Mat, dstmap1type: i32, nn_interpolation: bool) void {
    c.ConvertMaps(map1.ptr, map2.ptr, dstmap1.ptr, dstmap2.ptr, dstmap1type, if (nn_interpolation) 1 else 0);
}

/// Performs the per-element division of the first Fourier spectrum by the second one
pub fn divSpectrums(a: Mat, b: Mat, result: *Mat, flags: i32, conj_b: bool) void {
    c.DivSpectrums(a.ptr, b.ptr, result.ptr, flags, if (conj_b) 1 else 0);
}

// ============================================================================
// Phase 1 Batch 4: Geometry
// ============================================================================

/// Fits an ellipse around a set of 2D points using AMS (Approximate Mean Shift)
pub fn fitEllipseAMS(points: core.PointVector) RotatedRect {
    const rr = c.FitEllipseAMS(points.ptr);
    return RotatedRect{
        .center = core.Point2f{ .x = rr.center_x, .y = rr.center_y },
        .size = .{ .width = rr.width, .height = rr.height },
        .angle = rr.angle,
    };
}

/// Fits an ellipse around a set of 2D points using direct least squares
pub fn fitEllipseDirect(points: core.PointVector) RotatedRect {
    const rr = c.FitEllipseDirect(points.ptr);
    return RotatedRect{
        .center = core.Point2f{ .x = rr.center_x, .y = rr.center_y },
        .size = .{ .width = rr.width, .height = rr.height },
        .angle = rr.angle,
    };
}

/// Finds intersection of the convex hull of two point sets
pub fn intersectConvexConvex(p1: core.PointVector, p2: core.PointVector, p12: *core.PointVector, handle_nested: bool) f64 {
    return c.IntersectConvexConvex(p1.ptr, p2.ptr, p12.ptr, if (handle_nested) 1 else 0);
}

/// Finds a triangle of minimum area enclosing a 2D point set
pub fn minEnclosingTriangle(points: core.PointVector, triangle: *core.PointVector) f64 {
    return c.MinEnclosingTriangle(points.ptr, triangle.ptr);
}

/// Finds intersection type of two rotated rectangles
pub fn rotatedRectangleIntersection(rect1: RotatedRect, rect2: RotatedRect, intersecting_region: *core.PointVector) i32 {
    const c_rect1 = c.RotatedRect{
        .center_x = rect1.center.x,
        .center_y = rect1.center.y,
        .width = rect1.size.width,
        .height = rect1.size.height,
        .angle = rect1.angle,
    };
    const c_rect2 = c.RotatedRect{
        .center_x = rect2.center.x,
        .center_y = rect2.center.y,
        .width = rect2.size.width,
        .height = rect2.size.height,
        .angle = rect2.angle,
    };
    return c.RotatedRectangleIntersection(c_rect1, c_rect2, intersecting_region.ptr);
}

// ============================================================================
// Phase 2: Additional imgproc functions
// ============================================================================

/// Returns a Gabor filter kernel
pub fn getGaborKernel(ksize: Size, sigma: f64, theta: f64, lambd: f64, gamma: f64, psi: f64, ktype: i32) core.Error!Mat {
    const p = c.GetGaborKernel(ksize.toC(), sigma, theta, lambd, gamma, psi, ktype) orelse return core.Error.NullPointer;
    return Mat{ .ptr = p };
}

/// Returns filter coefficients for computing spatial image derivatives
pub fn getDerivKernels(kx: *Mat, ky: *Mat, dx: i32, dy: i32, ksize: i32, do_normalize: bool, ktype: i32) void {
    c.GetDerivKernels(kx.ptr, ky.ptr, dx, dy, ksize, if (do_normalize) 1 else 0, ktype);
}

/// Performs demosaicing (Bayer pattern conversion)
pub fn demosaicing(src: Mat, dst: *Mat, code: i32, dst_cn: i32) void {
    c.Demosaicing(src.ptr, dst.ptr, code, dst_cn);
}

/// Phase correlation result
pub const PhaseCorrelateResult = struct {
    shift: core.Point2f,
    response: f64,
};

/// Detects translational shift using phase correlation
pub fn phaseCorrelate(src1: Mat, src2: Mat, window: ?Mat) PhaseCorrelateResult {
    var shift_x: f64 = 0;
    var shift_y: f64 = 0;
    var response: f64 = 0;
    const win_ptr = if (window) |w| w.ptr else null;
    c.PhaseCorrelate(src1.ptr, src2.ptr, win_ptr, &shift_x, &shift_y, &response);
    return PhaseCorrelateResult{
        .shift = .{ .x = @floatCast(shift_x), .y = @floatCast(shift_y) },
        .response = response,
    };
}

/// Remaps an image to polar coordinates (deprecated, use warpPolar)
pub fn linearPolar(src: Mat, dst: *Mat, center: core.Point2f, max_radius: f64, flags: i32) void {
    c.LinearPolar(src.ptr, dst.ptr, center.toC(), max_radius, flags);
}

/// Remaps an image to semilog-polar coordinates (deprecated, use warpPolar)
pub fn logPolar(src: Mat, dst: *Mat, center: core.Point2f, m: f64, flags: i32) void {
    c.LogPolar(src.ptr, dst.ptr, center.toC(), m, flags);
}

/// Finds the convexity defects of a contour
pub fn convexityDefects(contour: core.PointVector, convexhull: core.PointVector, defects: *Mat) void {
    c.ConvexityDefects(contour.ptr, convexhull.ptr, defects.ptr);
}

/// Approximates a polygon with the specified number of sides
pub fn approxPolyN(curve: core.PointVector, approx_curve: *core.PointVector, nsides: i32, epsilon_percentage: f64, ensure_convex: bool) void {
    c.ApproxPolyN(curve.ptr, approx_curve.ptr, nsides, epsilon_percentage, if (ensure_convex) 1 else 0);
}

// ============================================================================
// Histogram
// ============================================================================

/// Calculate histogram of a set of images.
/// channels: array of channel indices, histSize: array of histogram sizes per dimension,
/// ranges: array of range pairs [min, max] for each dimension (flattened: [min0, max0, min1, max1, ...])
pub fn calcHist(
    images: []const Mat,
    channels: []const i32,
    mask: ?Mat,
    hist: *Mat,
    hist_size: []const i32,
    ranges: []const f32,
    uniform: bool,
    do_accumulate: bool,
) void {
    // Build array of Mat pointers for the C API (expects Mat**)
    const nimages: i32 = @intCast(images.len);
    const dims: i32 = @intCast(channels.len);

    // Build pointer array for images (C API treats first arg as Mat**)
    var img_ptrs: [8]*anyopaque = undefined;
    for (images, 0..) |img, i| {
        if (i >= 8) break;
        img_ptrs[i] = img.ptr;
    }

    // Build range pointer array (one float* per dimension)
    var range_ptrs: [32][*c]const f32 = undefined;
    for (0..@intCast(dims)) |i| {
        range_ptrs[i] = ranges[i * 2 ..].ptr;
    }

    const mask_ptr = if (mask) |m| m.ptr else null;

    c.CalcHist(
        @ptrCast(&img_ptrs[0]),
        nimages,
        @constCast(channels.ptr),
        mask_ptr,
        hist.ptr,
        dims,
        @constCast(hist_size.ptr),
        @ptrCast(&range_ptrs[0]),
        if (uniform) 1 else 0,
        if (do_accumulate) 1 else 0,
    );
}
