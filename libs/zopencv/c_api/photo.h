#ifndef OPENCV_PHOTO_H
#define OPENCV_PHOTO_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Denoising
// ============================================================================

/// Non-local means denoising
void FastNlMeansDenoising(Mat *src, Mat *dst, float h, int templateWindowSize,
                          int searchWindowSize);

/// Non-local means denoising for colored images
void FastNlMeansDenoisingColored(Mat *src, Mat *dst, float h, float hColor,
                                 int templateWindowSize, int searchWindowSize);

// ============================================================================
// Inpainting
// ============================================================================

/// Inpaint using Navier-Stokes method
void Inpaint(Mat *src, Mat *inpaintMask, Mat *dst, double inpaintRadius,
             int flags);

// Note: Inpainting flags are defined in OpenCV headers:
// cv::INPAINT_NS = 0
// cv::INPAINT_TELEA = 1

// ============================================================================
// Edge-Preserving Filters
// ============================================================================

/// Detail enhancement filter
void DetailEnhance(Mat *src, Mat *dst, float sigma_s, float sigma_r);

/// Edge-preserving filter
void EdgePreservingFilter(Mat *src, Mat *dst, int flags, float sigma_s,
                          float sigma_r);

/// Pencil sketch effect
void PencilSketch(Mat *src, Mat *dst1, Mat *dst2, float sigma_s, float sigma_r,
                  float shade_factor);

/// Stylization filter
void Stylization(Mat *src, Mat *dst, float sigma_s, float sigma_r);

// Note: Edge-preserving filter flags are defined in OpenCV headers:
// cv::RECURS_FILTER = 1
// cv::NORMCONV_FILTER = 2

// ============================================================================
// Seamless Cloning
// ============================================================================

/// Seamless cloning
void SeamlessClone(Mat *src, Mat *dst, Mat *mask, Point p, Mat *blend,
                   int flags);

// Note: Seamless cloning flags are defined in OpenCV headers:
// cv::NORMAL_CLONE = 1
// cv::MIXED_CLONE = 2
// cv::MONOCHROME_TRANSFER = 3

// ============================================================================
// Color Change and Illumination Change
// ============================================================================

/// Color change
void ColorChange(Mat *src, Mat *mask, Mat *dst, float red_mul, float green_mul,
                 float blue_mul);

/// Illumination change
void IlluminationChange(Mat *src, Mat *mask, Mat *dst, float alpha, float beta);

/// Texture flattening
void TextureFlattening(Mat *src, Mat *mask, Mat *dst, float low_threshold,
                       float high_threshold, int kernel_size);

// ============================================================================
// Decolorization
// ============================================================================

/// Decolorization
void Decolorization(Mat *src, Mat *grayscale, Mat *color_boost);

// ============================================================================
// Multi-frame Denoising
// ============================================================================

/// Non-local means denoising for multi-frame
void FastNlMeansDenoisingMulti(Mat **srcImgs, int imgCount, Mat *dst,
                               int imgToDenoiseIndex, int temporalWindowSize,
                               float h, int templateWindowSize,
                               int searchWindowSize);

/// Non-local means denoising colored for multi-frame
void FastNlMeansDenoisingColoredMulti(Mat **srcImgs, int imgCount, Mat *dst,
                                      int imgToDenoiseIndex,
                                      int temporalWindowSize, float h,
                                      float hColor, int templateWindowSize,
                                      int searchWindowSize);

// ============================================================================
// HDR / Tonemap Pipeline
// ============================================================================

/// MergeMertens exposure fusion
typedef void *MergeMertens;
MergeMertens MergeMertens_Create();
MergeMertens MergeMertens_CreateWithParams(float contrast_weight,
                                           float saturation_weight,
                                           float exposure_weight);
void MergeMertens_Process(MergeMertens mm, Mat **srcImgs, int imgCount,
                          Mat *dst);
void MergeMertens_Close(MergeMertens mm);

/// Tonemap
typedef void *TonemapPtr;
TonemapPtr Tonemap_Create(float gamma);
void Tonemap_Process(TonemapPtr t, Mat *src, Mat *dst);
void Tonemap_Close(TonemapPtr t);

/// AlignMTB
typedef void *AlignMTB;
AlignMTB AlignMTB_Create(int max_bits, int exclude_range, int cut);
void AlignMTB_Process(AlignMTB a, Mat **srcImgs, int imgCount, Mat **dstImgs);
void AlignMTB_Close(AlignMTB a);

/// CalibrateDebevec
typedef void *CalibrateDebevec;
CalibrateDebevec CalibrateDebevec_Create(int samples, float lambda, int random);
void CalibrateDebevec_Process(CalibrateDebevec cd, Mat **srcImgs, int imgCount,
                              Mat *dst, Mat *times);
void CalibrateDebevec_Close(CalibrateDebevec cd);

/// MergeDebevec
typedef void *MergeDebevec;
MergeDebevec MergeDebevec_Create();
void MergeDebevec_Process(MergeDebevec md, Mat **srcImgs, int imgCount,
                          Mat *dst, Mat *times, Mat *response);
void MergeDebevec_Close(MergeDebevec md);

/// TonemapDrago
typedef void *TonemapDragoPtr;
TonemapDragoPtr TonemapDrago_Create(float gamma, float saturation, float bias);
void TonemapDrago_Process(TonemapDragoPtr t, Mat *src, Mat *dst);
void TonemapDrago_Close(TonemapDragoPtr t);

/// TonemapReinhard
typedef void *TonemapReinhardPtr;
TonemapReinhardPtr TonemapReinhard_Create(float gamma, float intensity,
                                          float lightAdapt, float colorAdapt);
void TonemapReinhard_Process(TonemapReinhardPtr t, Mat *src, Mat *dst);
void TonemapReinhard_Close(TonemapReinhardPtr t);

/// TonemapMantiuk
typedef void *TonemapMantiukPtr;
TonemapMantiukPtr TonemapMantiuk_Create(float gamma, float scale,
                                        float saturation);
void TonemapMantiuk_Process(TonemapMantiukPtr t, Mat *src, Mat *dst);
void TonemapMantiuk_Close(TonemapMantiukPtr t);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_PHOTO_H
