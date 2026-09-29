#include "saliency.h"
#include <opencv2/saliency.hpp>

extern "C" {

// ============================================================================
// Static Saliency
// ============================================================================

StaticSaliency *StaticSaliencySpectralResidual_Create() {
  cv::Ptr<cv::saliency::StaticSaliencySpectralResidual> ptr =
      cv::saliency::StaticSaliencySpectralResidual::create();
  return reinterpret_cast<StaticSaliency *>(
      new cv::Ptr<cv::saliency::Saliency>(ptr));
}

StaticSaliency *StaticSaliencyFineGrained_Create() {
  cv::Ptr<cv::saliency::StaticSaliencyFineGrained> ptr =
      cv::saliency::StaticSaliencyFineGrained::create();
  return reinterpret_cast<StaticSaliency *>(
      new cv::Ptr<cv::saliency::Saliency>(ptr));
}

void StaticSaliency_Delete(StaticSaliency *saliency) {
  delete reinterpret_cast<cv::Ptr<cv::saliency::Saliency> *>(saliency);
}

int StaticSaliency_ComputeSaliency(StaticSaliency *saliency, Mat *image,
                                   Mat *saliencyMap) {
  cv::Ptr<cv::saliency::Saliency> *ptr =
      reinterpret_cast<cv::Ptr<cv::saliency::Saliency> *>(saliency);
  cv::Mat map;
  bool result =
      (*ptr)->computeSaliency(*reinterpret_cast<cv::Mat *>(image), map);
  if (result) {
    *reinterpret_cast<cv::Mat *>(saliencyMap) = map;
  }
  return result ? 1 : 0;
}

} // extern "C"
