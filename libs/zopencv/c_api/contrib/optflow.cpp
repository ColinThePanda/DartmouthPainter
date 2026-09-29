#include "optflow.h"
#include <opencv2/optflow.hpp>

extern "C" {

// ============================================================================
// DualTVL1OpticalFlow
// ============================================================================

DualTVL1OpticalFlow *DualTVL1OpticalFlow_Create() {
  cv::Ptr<cv::optflow::DualTVL1OpticalFlow> ptr =
      cv::optflow::DualTVL1OpticalFlow::create();
  return reinterpret_cast<DualTVL1OpticalFlow *>(
      new cv::Ptr<cv::optflow::DualTVL1OpticalFlow>(ptr));
}

void DualTVL1OpticalFlow_Delete(DualTVL1OpticalFlow *flow) {
  delete reinterpret_cast<cv::Ptr<cv::optflow::DualTVL1OpticalFlow> *>(flow);
}

void DualTVL1OpticalFlow_Calc(DualTVL1OpticalFlow *flow, Mat *prev, Mat *next,
                              Mat *dst) {
  cv::Ptr<cv::optflow::DualTVL1OpticalFlow> *ptr =
      reinterpret_cast<cv::Ptr<cv::optflow::DualTVL1OpticalFlow> *>(flow);
  (*ptr)->calc(*reinterpret_cast<cv::Mat *>(prev),
               *reinterpret_cast<cv::Mat *>(next),
               *reinterpret_cast<cv::Mat *>(dst));
}

} // extern "C"
