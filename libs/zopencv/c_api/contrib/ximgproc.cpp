#include "ximgproc.h"
#include <opencv2/ximgproc.hpp>

extern "C" {

// ============================================================================
// Edge-Preserving Filters
// ============================================================================

void GuidedFilter(Mat *src, Mat *guide, Mat *dst, int radius, double eps) {
  cv::ximgproc::guidedFilter(*reinterpret_cast<cv::Mat *>(src),
                             *reinterpret_cast<cv::Mat *>(guide),
                             *reinterpret_cast<cv::Mat *>(dst), radius, eps);
}

void BilateralTextureFilter(Mat *src, Mat *dst, int fr, int numIter,
                            double sigmaAlpha, double sigmaAvg) {
  cv::ximgproc::bilateralTextureFilter(*reinterpret_cast<cv::Mat *>(src),
                                       *reinterpret_cast<cv::Mat *>(dst), fr,
                                       numIter, sigmaAlpha, sigmaAvg);
}

void AdaptiveManifoldFilter(Mat *src, Mat *dst, double sigma_s, double sigma_r,
                            bool adjust_outliers) {
  cv::ximgproc::amFilter(*reinterpret_cast<cv::Mat *>(src), // joint
                         *reinterpret_cast<cv::Mat *>(src), // src
                         *reinterpret_cast<cv::Mat *>(dst), // dst
                         sigma_s, sigma_r, adjust_outliers);
}

// ============================================================================
// Edge Detection
// ============================================================================

StructuredEdgeDetection *StructuredEdgeDetection_Create(const char *model) {
  cv::Ptr<cv::ximgproc::StructuredEdgeDetection> ptr =
      cv::ximgproc::createStructuredEdgeDetection(model);
  return reinterpret_cast<StructuredEdgeDetection *>(
      new cv::Ptr<cv::ximgproc::StructuredEdgeDetection>(ptr));
}

void StructuredEdgeDetection_Delete(StructuredEdgeDetection *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::ximgproc::StructuredEdgeDetection> *>(
        ptr);
  }
}

void StructuredEdgeDetection_DetectEdges(StructuredEdgeDetection *ptr, Mat *src,
                                         Mat *dst) {
  cv::Ptr<cv::ximgproc::StructuredEdgeDetection> *detector =
      reinterpret_cast<cv::Ptr<cv::ximgproc::StructuredEdgeDetection> *>(ptr);
  (*detector)->detectEdges(*reinterpret_cast<cv::Mat *>(src),
                           *reinterpret_cast<cv::Mat *>(dst));
}

// ============================================================================
// Morphological Operations
// ============================================================================

void Ximgproc_Thinning(Mat *src, Mat *dst, int thinningType) {
  cv::ximgproc::thinning(*reinterpret_cast<cv::Mat *>(src),
                         *reinterpret_cast<cv::Mat *>(dst), thinningType);
}

// ============================================================================
// Thresholding
// ============================================================================

void Ximgproc_NiBlackThreshold(Mat *src, Mat *dst, double maxValue, int type,
                               int blockSize, double k,
                               int binarizationMethod) {
  cv::ximgproc::niBlackThreshold(*reinterpret_cast<cv::Mat *>(src),
                                 *reinterpret_cast<cv::Mat *>(dst), maxValue,
                                 type, blockSize, k, binarizationMethod);
}

// ============================================================================
// Diffusion
// ============================================================================

void Ximgproc_AnisotropicDiffusion(Mat *src, Mat *dst, float alpha, float K,
                                   int niters) {
  cv::ximgproc::anisotropicDiffusion(*reinterpret_cast<cv::Mat *>(src),
                                     *reinterpret_cast<cv::Mat *>(dst), alpha,
                                     K, niters);
}

} // extern "C"
