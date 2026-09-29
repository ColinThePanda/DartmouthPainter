#include "stitching.h"
#include <opencv2/stitching.hpp>

extern "C" {

// ============================================================================
// Stitcher
// ============================================================================

Stitcher *Stitcher_Create(int mode) {
  cv::Ptr<cv::Stitcher> ptr =
      cv::Stitcher::create(static_cast<cv::Stitcher::Mode>(mode));
  return reinterpret_cast<Stitcher *>(new cv::Ptr<cv::Stitcher>(ptr));
}

void Stitcher_Delete(Stitcher *stitcher) {
  delete reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
}

int Stitcher_Stitch(Stitcher *stitcher, Mat **images, int num_images,
                    Mat *pano) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);

  // Convert Mat** to vector<Mat>
  std::vector<cv::Mat> imgs;
  imgs.reserve(num_images);
  for (int i = 0; i < num_images; i++) {
    imgs.push_back(*reinterpret_cast<cv::Mat *>(images[i]));
  }

  cv::Mat result;
  cv::Stitcher::Status status = (*ptr)->stitch(imgs, result);

  // Copy result to output Mat
  if (status == cv::Stitcher::OK) {
    result.copyTo(*reinterpret_cast<cv::Mat *>(pano));
  }

  return static_cast<int>(status);
}

double Stitcher_GetRegistrationResol(Stitcher *stitcher) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  return (*ptr)->registrationResol();
}

void Stitcher_SetRegistrationResol(Stitcher *stitcher, double resol) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  (*ptr)->setRegistrationResol(resol);
}

double Stitcher_GetSeamEstimationResol(Stitcher *stitcher) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  return (*ptr)->seamEstimationResol();
}

void Stitcher_SetSeamEstimationResol(Stitcher *stitcher, double resol) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  (*ptr)->setSeamEstimationResol(resol);
}

double Stitcher_GetCompositingResol(Stitcher *stitcher) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  return (*ptr)->compositingResol();
}

void Stitcher_SetCompositingResol(Stitcher *stitcher, double resol) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  (*ptr)->setCompositingResol(resol);
}

double Stitcher_GetPanoConfidenceThresh(Stitcher *stitcher) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  return (*ptr)->panoConfidenceThresh();
}

void Stitcher_SetPanoConfidenceThresh(Stitcher *stitcher, double conf_thresh) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  (*ptr)->setPanoConfidenceThresh(conf_thresh);
}

int Stitcher_GetWaveCorrection(Stitcher *stitcher) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  return (*ptr)->waveCorrection() ? 1 : 0;
}

void Stitcher_SetWaveCorrection(Stitcher *stitcher, int flag) {
  cv::Ptr<cv::Stitcher> *ptr =
      reinterpret_cast<cv::Ptr<cv::Stitcher> *>(stitcher);
  (*ptr)->setWaveCorrection(flag != 0);
}

} // extern "C"
