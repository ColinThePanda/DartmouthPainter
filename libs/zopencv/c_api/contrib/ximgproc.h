#ifndef OPENCV_XIMGPROC_H
#define OPENCV_XIMGPROC_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Edge-Preserving Filters
// ============================================================================

/// Guided filter - edge-preserving smoothing filter
/// src: Input image
/// guide: Guidance image (can be same as src)
/// dst: Output image
/// radius: Radius of filter
/// eps: Regularization term
void GuidedFilter(Mat *src, Mat *guide, Mat *dst, int radius, double eps);

/// Bilateral texture filter
/// src: Input image
/// dst: Output image
/// fr: Radius of kernel (must be positive)
/// numIter: Number of iterations
/// sigmaAlpha: Controls sharpness
/// sigmaAvg: Range sigma
void BilateralTextureFilter(Mat *src, Mat *dst, int fr, int numIter,
                            double sigmaAlpha, double sigmaAvg);

/// Adaptive manifold filter
/// src: Input image
/// dst: Output image
/// sigma_s: Spatial standard deviation
/// sigma_r: Color space standard deviation
/// adjust_outliers: Whether to adjust outliers
void AdaptiveManifoldFilter(Mat *src, Mat *dst, double sigma_s, double sigma_r,
                            bool adjust_outliers);

// ============================================================================
// Edge Detection
// ============================================================================

/// Opaque pointer for StructuredEdgeDetection
typedef struct StructuredEdgeDetection StructuredEdgeDetection;

/// Create StructuredEdgeDetection
/// model: Path to model file
StructuredEdgeDetection *StructuredEdgeDetection_Create(const char *model);

/// Delete StructuredEdgeDetection
void StructuredEdgeDetection_Delete(StructuredEdgeDetection *ptr);

/// Detect edges
/// src: Input image (must be RGB, float32)
/// dst: Output edge map
void StructuredEdgeDetection_DetectEdges(StructuredEdgeDetection *ptr, Mat *src,
                                         Mat *dst);

// ============================================================================
// Morphological Operations
// ============================================================================

/// Thinning (skeletonization) of a binary image
/// src: Input binary image (CV_8UC1)
/// dst: Output thinned image
/// thinningType: 0=THINNING_ZHANGSUEN, 1=THINNING_GUOHALL
void Ximgproc_Thinning(Mat *src, Mat *dst, int thinningType);

// ============================================================================
// Thresholding
// ============================================================================

/// niBlack thresholding
/// src: Input grayscale image (CV_8UC1)
/// dst: Output binary image
/// maxValue: Non-zero value assigned to the pixels for which the condition is
/// satisfied type: Thresholding type (THRESH_BINARY, THRESH_BINARY_INV)
/// blockSize: Size of a pixel neighborhood (must be odd, >= 3)
/// k: The user-adjustable parameter
/// binarizationMethod: Binarization method (0=NIBLACK, 1=SAUVOLA, 2=WOLF,
/// 3=NICK)
void Ximgproc_NiBlackThreshold(Mat *src, Mat *dst, double maxValue, int type,
                               int blockSize, double k, int binarizationMethod);

// ============================================================================
// Diffusion
// ============================================================================

/// Anisotropic diffusion
/// src: Input 8-bit 3-channel image
/// dst: Output image
/// alpha: The amount of time to step forward by on each iteration (normally <=
/// 0.25) K: Sensitivity to the edges niters: Number of iterations
void Ximgproc_AnisotropicDiffusion(Mat *src, Mat *dst, float alpha, float K,
                                   int niters);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_XIMGPROC_H
