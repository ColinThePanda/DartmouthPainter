#include "dnn_superres.h"
#include <opencv2/dnn_superres.hpp>
#include <string>

extern "C" {

// ============================================================================
// DNN Super Resolution
// ============================================================================

DnnSuperResImpl *DnnSuperResImpl_Create() {
  cv::Ptr<cv::dnn_superres::DnnSuperResImpl> ptr =
      cv::dnn_superres::DnnSuperResImpl::create();
  return reinterpret_cast<DnnSuperResImpl *>(
      new cv::Ptr<cv::dnn_superres::DnnSuperResImpl>(ptr));
}

void DnnSuperResImpl_Delete(DnnSuperResImpl *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *>(ptr);
  }
}

void DnnSuperResImpl_ReadModel(DnnSuperResImpl *ptr, const char *path) {
  cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *sr =
      reinterpret_cast<cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *>(ptr);
  (*sr)->readModel(std::string(path));
}

void DnnSuperResImpl_SetModel(DnnSuperResImpl *ptr, const char *algo,
                              int scale) {
  cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *sr =
      reinterpret_cast<cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *>(ptr);
  (*sr)->setModel(std::string(algo), scale);
}

void DnnSuperResImpl_Upsample(DnnSuperResImpl *ptr, Mat *img, Mat *result) {
  cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *sr =
      reinterpret_cast<cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *>(ptr);
  (*sr)->upsample(*reinterpret_cast<cv::Mat *>(img),
                  *reinterpret_cast<cv::Mat *>(result));
}

int DnnSuperResImpl_GetScale(DnnSuperResImpl *ptr) {
  cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *sr =
      reinterpret_cast<cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *>(ptr);
  return (*sr)->getScale();
}

const char *DnnSuperResImpl_GetAlgorithm(DnnSuperResImpl *ptr) {
  cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *sr =
      reinterpret_cast<cv::Ptr<cv::dnn_superres::DnnSuperResImpl> *>(ptr);
  static std::string algo;
  algo = (*sr)->getAlgorithm();
  return algo.c_str();
}

} // extern "C"
