const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Error = core.Error;

// ============================================================================
// SVM (Support Vector Machine)
// ============================================================================

/// Support Vector Machine classifier
pub const SVM = struct {
    ptr: *c.SVM,

    const Self = @This();

    /// Create SVM model
    pub fn init() Error!Self {
        const ptr = c.SVM_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.SVM_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Train SVM model
    /// layout: 0 = ROW_SAMPLE, 1 = COL_SAMPLE
    pub fn train(self: Self, samples: Mat, layout: i32, responses: Mat) void {
        c.SVM_Train(self.ptr, samples.ptr, layout, responses.ptr);
    }

    /// Predict using SVM
    pub fn predict(self: Self, samples: Mat, results: ?*Mat, flags: i32) f32 {
        const res_ptr = if (results) |r| r.ptr else null;
        return c.SVM_Predict(self.ptr, samples.ptr, res_ptr, flags);
    }

    /// Set SVM type
    pub fn setType(self: Self, svm_type: SVMType) void {
        c.SVM_SetType(self.ptr, @intFromEnum(svm_type));
    }

    /// Set kernel type
    pub fn setKernel(self: Self, kernel: SVMKernel) void {
        c.SVM_SetKernel(self.ptr, @intFromEnum(kernel));
    }

    /// Set C parameter (regularization)
    pub fn setC(self: Self, value: f64) void {
        c.SVM_SetC(self.ptr, value);
    }

    /// Set gamma parameter (kernel coefficient)
    pub fn setGamma(self: Self, value: f64) void {
        c.SVM_SetGamma(self.ptr, value);
    }

    /// Get SVM type
    pub fn getType(self: Self) SVMType {
        return @enumFromInt(c.SVM_GetType(self.ptr));
    }

    /// Get kernel type
    pub fn getKernel(self: Self) SVMKernel {
        return @enumFromInt(c.SVM_GetKernel(self.ptr));
    }
};

// ============================================================================
// KNearest (K-Nearest Neighbors)
// ============================================================================

/// K-Nearest Neighbors classifier
pub const KNearest = struct {
    ptr: *c.KNearest,

    const Self = @This();

    /// Create KNearest model
    pub fn init() Error!Self {
        const ptr = c.KNearest_Create() orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.KNearest_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Train KNearest model
    pub fn train(self: Self, samples: Mat, layout: i32, responses: Mat) void {
        c.KNearest_Train(self.ptr, samples.ptr, layout, responses.ptr);
    }

    /// Predict using KNearest
    pub fn predict(self: Self, samples: Mat, results: ?*Mat, neighborResponses: ?*Mat, dist: ?*Mat) f32 {
        const res_ptr = if (results) |r| r.ptr else null;
        const neigh_ptr = if (neighborResponses) |n| n.ptr else null;
        const dist_ptr = if (dist) |d| d.ptr else null;
        return c.KNearest_Predict(self.ptr, samples.ptr, res_ptr, neigh_ptr, dist_ptr);
    }

    /// Set default K value
    pub fn setDefaultK(self: Self, k: i32) void {
        c.KNearest_SetDefaultK(self.ptr, k);
    }

    /// Get default K value
    pub fn getDefaultK(self: Self) i32 {
        return c.KNearest_GetDefaultK(self.ptr);
    }

    /// Set algorithm type
    pub fn setAlgorithmType(self: Self, alg: KNearestAlgorithm) void {
        c.KNearest_SetAlgorithmType(self.ptr, @intFromEnum(alg));
    }
};

// ============================================================================
// Enums and Constants
// ============================================================================

/// SVM types
pub const SVMType = enum(i32) {
    c_svc = 100, // C-Support Vector Classification
    nu_svc = 101, // Nu-Support Vector Classification
    one_class = 102, // One-class SVM
    eps_svr = 103, // Epsilon-Support Vector Regression
    nu_svr = 104, // Nu-Support Vector Regression
};

/// SVM kernel types
pub const SVMKernel = enum(i32) {
    custom = -1, // Custom kernel
    linear = 0, // Linear kernel
    poly = 1, // Polynomial kernel
    rbf = 2, // Radial Basis Function (RBF) kernel
    sigmoid = 3, // Sigmoid kernel
    chi2 = 4, // Chi-squared kernel
    inter = 5, // Intersection kernel
};

/// KNearest algorithm types
pub const KNearestAlgorithm = enum(i32) {
    brute_force = 1, // Brute force search
    kdtree = 2, // KD-tree based search
};

/// Sample layout types
pub const SampleLayout = enum(i32) {
    row_sample = 0, // Each training sample is a row of samples
    col_sample = 1, // Each training sample is a column of samples
};
