#ifndef OPENCV_XPHOTO_H
#define OPENCV_XPHOTO_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// White Balance
// ============================================================================

/// Opaque pointer for WhiteBalancer
typedef struct WhiteBalancer WhiteBalancer;

/// Create simple white balancer
WhiteBalancer *WhiteBalancer_CreateSimple();

/// Create gray world white balancer
WhiteBalancer *WhiteBalancer_CreateGrayWorld();

/// Create learning-based white balancer
WhiteBalancer *WhiteBalancer_CreateLearningBased();

/// Delete white balancer
void WhiteBalancer_Delete(WhiteBalancer *ptr);

/// Balance white in image
void WhiteBalancer_BalanceWhite(WhiteBalancer *ptr, Mat *src, Mat *dst);

// ============================================================================
// Denoising
// ============================================================================

/// BM3D denoising
/// src: Input image
/// dst: Output image
/// h: Filter strength
void Bm3dDenoising(Mat *src, Mat *dst, float h);

// ============================================================================
// Inpainting
// ============================================================================

/// Inpaint using Fast Marching Method
/// src: Input image
/// mask: Inpainting mask
/// dst: Output image
/// radius: Radius of circular neighborhood
void InpaintFMM(Mat *src, Mat *mask, Mat *dst, int radius);

// ============================================================================
// Oil Painting Effect
// ============================================================================

/// Apply oil painting effect
/// src: Input 8-bit 3-channel image
/// dst: Output image
/// size: Size of the kernel
/// dynRatio: Dynamic ratio (how many neighbouring pixels to consider)
void Xphoto_OilPainting(Mat *src, Mat *dst, int size, int dynRatio);

// ============================================================================
// Channel Gains
// ============================================================================

/// Apply per-channel gains to image
/// src: Input 3-channel image
/// dst: Output image
/// gainB: Gain for blue channel
/// gainG: Gain for green channel
/// gainR: Gain for red channel
void Xphoto_ApplyChannelGains(Mat *src, Mat *dst, float gainB, float gainG,
                              float gainR);

// ============================================================================
// DCT Denoising
// ============================================================================

/// DCT-based denoising
/// src: Input image (1 or 3 channels, CV_8U or CV_32F)
/// dst: Output image
/// sigma: Expected noise standard deviation
/// psize: Size of block (default 16)
void Xphoto_DctDenoising(Mat *src, Mat *dst, double sigma, int psize);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_XPHOTO_H
