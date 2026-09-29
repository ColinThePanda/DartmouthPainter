#include "bioinspired.h"
#include <opencv2/bioinspired.hpp>

extern "C" {

// ============================================================================
// Bioinspired - Retina Model
// ============================================================================

Retina *Retina_Create(int width, int height, bool colorMode) {
  cv::Ptr<cv::bioinspired::Retina> ptr =
      cv::bioinspired::Retina::create(cv::Size(width, height), colorMode);
  return reinterpret_cast<Retina *>(new cv::Ptr<cv::bioinspired::Retina>(ptr));
}

void Retina_Delete(Retina *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::bioinspired::Retina> *>(ptr);
  }
}

void Retina_Run(Retina *ptr, Mat *input) {
  cv::Ptr<cv::bioinspired::Retina> *retina =
      reinterpret_cast<cv::Ptr<cv::bioinspired::Retina> *>(ptr);
  (*retina)->run(*reinterpret_cast<cv::Mat *>(input));
}

void Retina_GetParvo(Retina *ptr, Mat *output) {
  cv::Ptr<cv::bioinspired::Retina> *retina =
      reinterpret_cast<cv::Ptr<cv::bioinspired::Retina> *>(ptr);
  (*retina)->getParvo(*reinterpret_cast<cv::Mat *>(output));
}

void Retina_GetMagno(Retina *ptr, Mat *output) {
  cv::Ptr<cv::bioinspired::Retina> *retina =
      reinterpret_cast<cv::Ptr<cv::bioinspired::Retina> *>(ptr);
  (*retina)->getMagno(*reinterpret_cast<cv::Mat *>(output));
}

void Retina_ClearBuffers(Retina *ptr) {
  cv::Ptr<cv::bioinspired::Retina> *retina =
      reinterpret_cast<cv::Ptr<cv::bioinspired::Retina> *>(ptr);
  (*retina)->clearBuffers();
}

} // extern "C"
