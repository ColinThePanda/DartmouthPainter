#include "xfeatures2d.h"
#include <opencv2/xfeatures2d.hpp>

extern "C" {

// ============================================================================
// SURF
// ============================================================================

Feature2D *SURF_Create(double hessianThreshold, int nOctaves, int nOctaveLayers,
                       bool extended, bool upright) {
  // Note: SURF might throw if nonfree module is not enabled/available
  try {
    cv::Ptr<cv::xfeatures2d::SURF> ptr = cv::xfeatures2d::SURF::create(
        hessianThreshold, nOctaves, nOctaveLayers, extended, upright);
    return reinterpret_cast<Feature2D *>(new cv::Ptr<cv::Feature2D>(ptr));
  } catch (...) {
    return nullptr;
  }
}

// ============================================================================
// FREAK
// ============================================================================

Feature2D *FREAK_Create(bool orientationNormalized, bool scaleNormalized,
                        float patternScale, int nOctaves) {
  cv::Ptr<cv::xfeatures2d::FREAK> ptr = cv::xfeatures2d::FREAK::create(
      orientationNormalized, scaleNormalized, patternScale, nOctaves);
  return reinterpret_cast<Feature2D *>(new cv::Ptr<cv::Feature2D>(ptr));
}

// ============================================================================
// BriefDescriptorExtractor
// ============================================================================

Feature2D *BriefDescriptorExtractor_Create(int bytes, bool use_orientation) {
  cv::Ptr<cv::xfeatures2d::BriefDescriptorExtractor> ptr =
      cv::xfeatures2d::BriefDescriptorExtractor::create(bytes, use_orientation);
  return reinterpret_cast<Feature2D *>(new cv::Ptr<cv::Feature2D>(ptr));
}

} // extern "C"
