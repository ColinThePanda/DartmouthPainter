const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Point2f = core.Point2f;
pub const Scalar = core.Scalar;
pub const Error = core.Error;

/// Feature2D abstract base class wrapper
pub const Feature2D = struct {
    ptr: *c.Feature2D,

    const Self = @This();

    pub fn deinit(self: *Self) void {
        c.Feature2D_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn detect(self: Self, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void {
        c.Feature2D_Detect(self.ptr, image.ptr, keypoints.ptr, if (mask) |m| m.ptr else null);
    }

    pub fn compute(self: Self, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        c.Feature2D_Compute(self.ptr, image.ptr, keypoints.ptr, descriptors.ptr);
    }

    pub fn detectAndCompute(self: Self, image: Mat, mask: ?Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        c.Feature2D_DetectAndCompute(self.ptr, image.ptr, if (mask) |m| m.ptr else null, keypoints.ptr, descriptors.ptr);
    }
};

/// KeyPoint data structure
pub const KeyPointData = struct {
    pt: Point2f,
    size: f32,
    angle: f32,
    response: f32,
    octave: i32,
    class_id: i32,
};

/// KeyPoint vector for storing multiple keypoints
pub const KeyPointVector = struct {
    ptr: *c.KeyPointVector,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.KeyPointVector_New() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.KeyPointVector_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn size(self: Self) usize {
        return c.KeyPointVector_Size(self.ptr);
    }

    pub fn at(self: Self, index: usize) KeyPointData {
        const c_kp = c.KeyPointVector_At(self.ptr, index);
        return KeyPointData{
            .pt = Point2f{ .x = c_kp.pt.x, .y = c_kp.pt.y },
            .size = c_kp.size,
            .angle = c_kp.angle,
            .response = c_kp.response,
            .octave = c_kp.octave,
            .class_id = c_kp.class_id,
        };
    }
};

/// ORB feature detector and descriptor
pub const ORB = struct {
    ptr: *c.ORB,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.ORB_Create(500, 1.2, 8, 31, 0, 2, 0, 31, 20) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn initWithParams(
        nfeatures: i32,
        scale_factor: f32,
        nlevels: i32,
        edge_threshold: i32,
        first_level: i32,
        wta_k: i32,
        score_type: i32,
        patch_size: i32,
        fast_threshold: i32,
    ) Error!Self {
        const ptr = c.ORB_Create(
            nfeatures,
            scale_factor,
            nlevels,
            edge_threshold,
            first_level,
            wta_k,
            score_type,
            patch_size,
            fast_threshold,
        ) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.ORB_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn detect(self: Self, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void {
        const mask_ptr = if (mask) |m| m.ptr else null;
        c.ORB_Detect(self.ptr, image.ptr, keypoints.ptr, mask_ptr);
    }

    pub fn compute(self: Self, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        c.ORB_Compute(self.ptr, image.ptr, keypoints.ptr, descriptors.ptr);
    }

    pub fn detectAndCompute(self: Self, image: Mat, mask: ?Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        const mask_ptr = if (mask) |m| m.ptr else null;
        c.ORB_DetectAndCompute(self.ptr, image.ptr, mask_ptr, keypoints.ptr, descriptors.ptr);
    }
};

/// SIFT feature detector and descriptor
pub const SIFT = struct {
    ptr: *c.SIFT,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.SIFT_Create(0, 3, 0.04, 10, 1.6) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn initWithParams(
        nfeatures: i32,
        n_octave_layers: i32,
        contrast_threshold: f64,
        edge_threshold: f64,
        sigma: f64,
    ) Error!Self {
        const ptr = c.SIFT_Create(
            nfeatures,
            n_octave_layers,
            contrast_threshold,
            edge_threshold,
            sigma,
        ) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.SIFT_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn detect(self: Self, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void {
        const mask_ptr = if (mask) |m| m.ptr else null;
        c.SIFT_Detect(self.ptr, image.ptr, keypoints.ptr, mask_ptr);
    }

    pub fn compute(self: Self, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        c.SIFT_Compute(self.ptr, image.ptr, keypoints.ptr, descriptors.ptr);
    }

    pub fn detectAndCompute(self: Self, image: Mat, mask: ?Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        const mask_ptr = if (mask) |m| m.ptr else null;
        c.SIFT_DetectAndCompute(self.ptr, image.ptr, mask_ptr, keypoints.ptr, descriptors.ptr);
    }
};

/// AKAZE feature detector and descriptor
pub const AKAZE = struct {
    ptr: *c.AKAZE,

    const Self = @This();

    pub fn init() Error!Self {
        const ptr = c.AKAZE_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    pub fn deinit(self: *Self) void {
        c.AKAZE_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn detect(self: Self, image: Mat, keypoints: *KeyPointVector, mask: ?Mat) void {
        const mask_ptr = if (mask) |m| m.ptr else null;
        c.AKAZE_Detect(self.ptr, image.ptr, keypoints.ptr, mask_ptr);
    }

    pub fn compute(self: Self, image: Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        c.AKAZE_Compute(self.ptr, image.ptr, keypoints.ptr, descriptors.ptr);
    }

    pub fn detectAndCompute(self: Self, image: Mat, mask: ?Mat, keypoints: *KeyPointVector, descriptors: *Mat) void {
        const mask_ptr = if (mask) |m| m.ptr else null;
        c.AKAZE_DetectAndCompute(self.ptr, image.ptr, mask_ptr, keypoints.ptr, descriptors.ptr);
    }
};

/// Draw keypoints on image
pub fn drawKeypoints(image: Mat, keypoints: KeyPointVector, out_image: *Mat, color: Scalar, flags: i32) void {
    c.DrawKeypoints(image.ptr, keypoints.ptr, out_image.ptr, color.toC(), flags);
}

// ============================================================================
// DMatch
// ============================================================================

pub const DMatchData = struct {
    query_idx: i32,
    train_idx: i32,
    img_idx: i32,
    distance: f32,
};

/// Vector of DMatch results
pub const DMatchVector = struct {
    ptr: *c.DMatchVector,

    const Self = @This();

    pub fn init() core.Error!Self {
        const p = c.DMatchVector_New() orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn deinit(self: *Self) void {
        c.DMatchVector_Delete(self.ptr);
        self.ptr = undefined;
    }

    pub fn size(self: Self) usize {
        return c.DMatchVector_Size(self.ptr);
    }

    pub fn at(self: Self, index: usize) DMatchData {
        const d = c.DMatchVector_At(self.ptr, index);
        return DMatchData{
            .query_idx = d.queryIdx,
            .train_idx = d.trainIdx,
            .img_idx = d.imgIdx,
            .distance = d.distance,
        };
    }
};

// ============================================================================
// BFMatcher (Brute-Force)
// ============================================================================

/// Norm types for BFMatcher
pub const NormTypes = struct {
    pub const norm_l1: i32 = 2;
    pub const norm_l2: i32 = 4;
    pub const norm_hamming: i32 = 6;
    pub const norm_hamming2: i32 = 7;
};

pub const BFMatcher = struct {
    ptr: *c.BFMatcher,

    const Self = @This();

    pub fn init(norm_type: i32, cross_check: bool) core.Error!Self {
        const p = c.BFMatcher_Create(norm_type, if (cross_check) 1 else 0) orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn deinit(self: *Self) void {
        c.BFMatcher_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Match query descriptors against train descriptors
    pub fn match(self: Self, query: Mat, train: Mat, matches: *DMatchVector) void {
        c.BFMatcher_Match(self.ptr, query.ptr, train.ptr, matches.ptr);
    }

    /// K-nearest neighbor matching
    /// Finds the k best matches for each descriptor from a query set.
    /// Results are flattened into the output DMatchVector (best match per query).
    pub fn knnMatch(self: Self, query: Mat, train: Mat, matches: *DMatchVector, k: i32) void {
        var match_counts: c_int = 0;
        c.BFMatcher_KnnMatch(self.ptr, query.ptr, train.ptr, @ptrCast(&matches.ptr), &match_counts, k);
    }
};

// ============================================================================
// Individual KeyPoint
// ============================================================================

/// Individual KeyPoint (for manual creation)
pub const KeyPoint = struct {
    ptr: *c.KeyPoint,

    const Self = @This();

    /// Create a new keypoint. All float params match OpenCV's float type.
    pub fn init(x: f32, y: f32, kp_size: f32, angle: f32, response: f32, octave: i32, class_id: i32) core.Error!Self {
        const p = c.KeyPoint_New(x, y, kp_size, angle, response, octave, class_id) orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn deinit(self: *Self) void {
        c.KeyPoint_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Get the keypoint data (position, size, angle, etc.)
    pub fn getData(self: Self) KeyPointData {
        const d = c.KeyPoint_GetData(self.ptr);
        return KeyPointData{
            .pt = Point2f{ .x = d.pt.x, .y = d.pt.y },
            .size = d.size,
            .angle = d.angle,
            .response = d.response,
            .octave = d.octave,
            .class_id = d.class_id,
        };
    }
};

// ============================================================================
// FlannBasedMatcher
// ============================================================================

pub const FlannBasedMatcher = struct {
    ptr: *c.FlannBasedMatcher,

    const Self = @This();

    pub fn init() core.Error!Self {
        const p = c.FlannBasedMatcher_Create() orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn deinit(self: *Self) void {
        c.FlannBasedMatcher_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Match query descriptors against train descriptors
    pub fn match(self: Self, query: Mat, train: Mat, matches: *DMatchVector) void {
        c.FlannBasedMatcher_Match(self.ptr, query.ptr, train.ptr, matches.ptr);
    }
};

// ============================================================================
// Draw Matches
// ============================================================================

/// Draw matched features between two images
pub fn drawMatches(
    img1: Mat,
    keypoints1: KeyPointVector,
    img2: Mat,
    keypoints2: KeyPointVector,
    matches: DMatchVector,
    out_img: *Mat,
    match_color: Scalar,
    single_point_color: Scalar,
    flags: i32,
) void {
    c.DrawMatches(img1.ptr, keypoints1.ptr, img2.ptr, keypoints2.ptr, matches.ptr, out_img.ptr, match_color.toC(), single_point_color.toC(), flags);
}
