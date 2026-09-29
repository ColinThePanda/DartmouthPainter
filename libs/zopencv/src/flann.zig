const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// FlannIndex
// ============================================================================

/// FLANN-based index for fast approximate nearest neighbor search
pub const FlannIndex = struct {
    ptr: *c.FlannIndex,

    const Self = @This();

    /// Create FLANN index with features and index type
    pub fn create(features: Mat, index_type: FlannIndexType) Error!Self {
        const ptr = c.FlannIndex_Create(features.ptr, @intFromEnum(index_type)) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Create FLANN index with KDTree algorithm
    pub fn createKDTree(features: Mat, trees: i32) Error!Self {
        const ptr = c.FlannIndex_CreateKDTree(features.ptr, trees) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.FlannIndex_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Perform K-nearest neighbor search
    /// query: Query point(s) Mat
    /// indices: Output Mat for indices (will be resized)
    /// dists: Output Mat for distances (will be resized)
    /// knn: Number of nearest neighbors to find
    pub fn knnSearch(self: Self, query: Mat, indices: *Mat, dists: *Mat, knn: i32) void {
        c.FlannIndex_KnnSearch(self.ptr, query.ptr, indices.ptr, dists.ptr, knn, 32); // 32 = default search params
    }

    /// Perform radius search
    /// Returns number of neighbors found
    pub fn radiusSearch(self: Self, query: Mat, indices: *Mat, dists: *Mat, radius: f64, max_results: i32) i32 {
        return c.FlannIndex_RadiusSearch(self.ptr, query.ptr, indices.ptr, dists.ptr, radius, max_results, 32);
    }
};

// ============================================================================
// Enums
// ============================================================================

/// FLANN index types
pub const FlannIndexType = enum(i32) {
    linear = 0, // Brute-force linear search
    kdtree = 1, // Randomized kd-trees
    kmeans = 2, // Hierarchical k-means tree
    composite = 3, // Composite index (combines multiple algorithms)
    autotuned = 255, // Automatically tuned algorithm selection
};
