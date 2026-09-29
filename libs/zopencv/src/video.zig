const std = @import("std");
const c_import = @import("c.zig");
const c = c_import.c;
const core = @import("core.zig");

pub const Mat = core.Mat;
pub const Point = core.Point;
pub const Rect = core.Rect;
pub const Size = core.Size;
pub const Error = core.Error;

// ============================================================================
// Optical Flow
// ============================================================================

/// Calculate sparse optical flow using Lucas-Kanade method
pub fn calcOpticalFlowPyrLK(
    prevImg: Mat,
    nextImg: Mat,
    prevPts: Mat,
    nextPts: *Mat,
    status: *Mat,
    err: *Mat,
    winSize: Size,
    maxLevel: i32,
    termcrit_type: i32,
    termcrit_maxCount: i32,
    termcrit_epsilon: f64,
    flags: i32,
    minEigThreshold: f64,
) void {
    c.CalcOpticalFlowPyrLK(
        prevImg.ptr,
        nextImg.ptr,
        prevPts.ptr,
        nextPts.ptr,
        status.ptr,
        err.ptr,
        c.Size{ .width = winSize.width, .height = winSize.height },
        maxLevel,
        termcrit_type,
        termcrit_maxCount,
        termcrit_epsilon,
        flags,
        minEigThreshold,
    );
}

/// Calculate dense optical flow using Farneback method
pub fn calcOpticalFlowFarneback(
    prev: Mat,
    next: Mat,
    flow: *Mat,
    pyr_scale: f64,
    levels: i32,
    winsize: i32,
    iterations: i32,
    poly_n: i32,
    poly_sigma: f64,
    flags: i32,
) void {
    c.CalcOpticalFlowFarneback(
        prev.ptr,
        next.ptr,
        flow.ptr,
        pyr_scale,
        levels,
        winsize,
        iterations,
        poly_n,
        poly_sigma,
        flags,
    );
}

// ============================================================================
// Background Subtraction - MOG2
// ============================================================================

/// Background subtractor using Gaussian Mixture Model (MOG2)
pub const BackgroundSubtractorMOG2 = struct {
    ptr: *c.BackgroundSubtractorMOG2,

    const Self = @This();

    /// Create MOG2 background subtractor
    pub fn init() Error!Self {
        return initWithParams(500, 16.0, true);
    }

    /// Create MOG2 with custom parameters
    pub fn initWithParams(history: i32, varThreshold: f64, detectShadows: bool) Error!Self {
        const ptr = c.BackgroundSubtractorMOG2_Create(history, varThreshold, if (detectShadows) 1 else 0) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.BackgroundSubtractorMOG2_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Apply background subtraction
    pub fn apply(self: Self, image: Mat, fgmask: *Mat, learningRate: f64) void {
        c.BackgroundSubtractorMOG2_Apply(self.ptr, image.ptr, fgmask.ptr, learningRate);
    }

    /// Get background image
    pub fn getBackgroundImage(self: Self, backgroundImage: *Mat) void {
        c.BackgroundSubtractorMOG2_GetBackgroundImage(self.ptr, backgroundImage.ptr);
    }
};

// ============================================================================
// Background Subtraction - KNN
// ============================================================================

/// Background subtractor using K-Nearest Neighbors
pub const BackgroundSubtractorKNN = struct {
    ptr: *c.BackgroundSubtractorKNN,

    const Self = @This();

    /// Create KNN background subtractor
    pub fn init() Error!Self {
        return initWithParams(500, 400.0, true);
    }

    /// Create KNN with custom parameters
    pub fn initWithParams(history: i32, dist2Threshold: f64, detectShadows: bool) Error!Self {
        const ptr = c.BackgroundSubtractorKNN_Create(history, dist2Threshold, if (detectShadows) 1 else 0) orelse return Error.NullPointer;
        return Self{ .ptr = ptr };
    }

    /// Release resources
    pub fn deinit(self: *Self) void {
        c.BackgroundSubtractorKNN_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Apply background subtraction
    pub fn apply(self: Self, image: Mat, fgmask: *Mat, learningRate: f64) void {
        c.BackgroundSubtractorKNN_Apply(self.ptr, image.ptr, fgmask.ptr, learningRate);
    }

    /// Get background image
    pub fn getBackgroundImage(self: Self, backgroundImage: *Mat) void {
        c.BackgroundSubtractorKNN_GetBackgroundImage(self.ptr, backgroundImage.ptr);
    }
};

// ============================================================================
// Mean Shift and CamShift
// ============================================================================

/// Calculate mean shift for object tracking
pub fn meanShift(
    probImage: Mat,
    window: *Rect,
    termcrit_type: i32,
    termcrit_maxCount: i32,
    termcrit_epsilon: f64,
) i32 {
    return c.MeanShift(
        probImage.ptr,
        window,
        termcrit_type,
        termcrit_maxCount,
        termcrit_epsilon,
    );
}

/// Calculate CamShift for object tracking
pub fn camShift(
    probImage: Mat,
    window: *Rect,
    termcrit_type: i32,
    termcrit_maxCount: i32,
    termcrit_epsilon: f64,
) struct { angle: f64, size: Size } {
    var angle: f64 = 0;
    var size: Size = Size.init(0, 0);

    c.CamShift(
        probImage.ptr,
        window,
        termcrit_type,
        termcrit_maxCount,
        termcrit_epsilon,
        &angle,
        &size,
    );

    return .{ .angle = angle, .size = size };
}

// ============================================================================
// Constants
// ============================================================================

/// Optical flow flags
pub const OptflowFlag = enum(i32) {
    use_initial_flow = 4,
    lk_get_min_eigenvals = 8,
    farneback_gaussian = 256,
};

/// TermCriteria types
pub const TermCriteriaType = enum(i32) {
    count = 1,
    eps = 2,
    count_eps = 3,
};

// ============================================================================
// KalmanFilter
// ============================================================================

pub const KalmanFilter = struct {
    ptr: *c.KalmanFilter,

    const Self = @This();

    /// Create a new Kalman filter
    /// dynamParams: dimensionality of the state
    /// measureParams: dimensionality of the measurement
    /// controlParams: dimensionality of the control (default 0)
    /// mat_type: type of the created matrices (default CV_32F = 5)
    pub fn init(dynam_params: i32, measure_params: i32) core.Error!Self {
        const p = c.KalmanFilter_New(dynam_params, measure_params, 0, 5) orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn initWithParams(dynam_params: i32, measure_params: i32, control_params: i32, mat_type: i32) core.Error!Self {
        const p = c.KalmanFilter_New(dynam_params, measure_params, control_params, mat_type) orelse return core.Error.NullPointer;
        return Self{ .ptr = p };
    }

    pub fn deinit(self: *Self) void {
        c.KalmanFilter_Delete(self.ptr);
        self.ptr = undefined;
    }

    /// Predict the next state
    pub fn predict(self: Self, result: *core.Mat) void {
        c.KalmanFilter_Predict(self.ptr, result.ptr);
    }

    /// Update the state with measurement
    pub fn correct(self: Self, measurement: core.Mat, result: *core.Mat) void {
        c.KalmanFilter_Correct(self.ptr, measurement.ptr, result.ptr);
    }

    /// Get/set transition matrix
    pub fn getTransitionMatrix(self: Self, result: *core.Mat) void {
        c.KalmanFilter_GetTransitionMatrix(self.ptr, result.ptr);
    }

    pub fn setTransitionMatrix(self: Self, matrix: core.Mat) void {
        c.KalmanFilter_SetTransitionMatrix(self.ptr, matrix.ptr);
    }

    /// Get/set measurement matrix
    pub fn getMeasurementMatrix(self: Self, result: *core.Mat) void {
        c.KalmanFilter_GetMeasurementMatrix(self.ptr, result.ptr);
    }

    pub fn setMeasurementMatrix(self: Self, matrix: core.Mat) void {
        c.KalmanFilter_SetMeasurementMatrix(self.ptr, matrix.ptr);
    }

    /// Get/set state
    pub fn getStatePre(self: Self, result: *core.Mat) void {
        c.KalmanFilter_GetStatePre(self.ptr, result.ptr);
    }

    pub fn setStatePre(self: Self, state: core.Mat) void {
        c.KalmanFilter_SetStatePre(self.ptr, state.ptr);
    }

    pub fn getStatePost(self: Self, result: *core.Mat) void {
        c.KalmanFilter_GetStatePost(self.ptr, result.ptr);
    }

    pub fn setStatePost(self: Self, state: core.Mat) void {
        c.KalmanFilter_SetStatePost(self.ptr, state.ptr);
    }
};
