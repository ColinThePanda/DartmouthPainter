#include "xphoto.h"
#include <opencv2/xphoto.hpp>

extern "C" {

// ============================================================================
// White Balance
// ============================================================================

WhiteBalancer *WhiteBalancer_CreateSimple() {
  cv::Ptr<cv::xphoto::WhiteBalancer> ptr = cv::xphoto::createSimpleWB();
  return reinterpret_cast<WhiteBalancer *>(
      new cv::Ptr<cv::xphoto::WhiteBalancer>(ptr));
}

WhiteBalancer *WhiteBalancer_CreateGrayWorld() {
  cv::Ptr<cv::xphoto::WhiteBalancer> ptr = cv::xphoto::createGrayworldWB();
  return reinterpret_cast<WhiteBalancer *>(
      new cv::Ptr<cv::xphoto::WhiteBalancer>(ptr));
}

WhiteBalancer *WhiteBalancer_CreateLearningBased() {
  cv::Ptr<cv::xphoto::WhiteBalancer> ptr = cv::xphoto::createLearningBasedWB();
  return reinterpret_cast<WhiteBalancer *>(
      new cv::Ptr<cv::xphoto::WhiteBalancer>(ptr));
}

void WhiteBalancer_Delete(WhiteBalancer *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::xphoto::WhiteBalancer> *>(ptr);
  }
}

void WhiteBalancer_BalanceWhite(WhiteBalancer *ptr, Mat *src, Mat *dst) {
  cv::Ptr<cv::xphoto::WhiteBalancer> *balancer =
      reinterpret_cast<cv::Ptr<cv::xphoto::WhiteBalancer> *>(ptr);
  (*balancer)->balanceWhite(*reinterpret_cast<cv::Mat *>(src),
                            *reinterpret_cast<cv::Mat *>(dst));
}

// ============================================================================
// Denoising
// ============================================================================

void Bm3dDenoising(Mat *src, Mat *dst, float h) {
  cv::xphoto::bm3dDenoising(*reinterpret_cast<cv::Mat *>(src),
                            *reinterpret_cast<cv::Mat *>(dst), h);
}

// ============================================================================
// Inpainting
// ============================================================================

void InpaintFMM(Mat *src, Mat *mask, Mat *dst, int radius) {
  (void)radius; // Suppress unused parameter warning
  cv::xphoto::inpaint(
      *reinterpret_cast<cv::Mat *>(src), *reinterpret_cast<cv::Mat *>(mask),
      *reinterpret_cast<cv::Mat *>(dst), cv::xphoto::INPAINT_SHIFTMAP);
}

// ============================================================================
// Oil Painting Effect
// ============================================================================

void Xphoto_OilPainting(Mat *src, Mat *dst, int size, int dynRatio) {
  cv::xphoto::oilPainting(*reinterpret_cast<cv::Mat *>(src),
                          *reinterpret_cast<cv::Mat *>(dst), size, dynRatio);
}

// ============================================================================
// Channel Gains
// ============================================================================

void Xphoto_ApplyChannelGains(Mat *src, Mat *dst, float gainB, float gainG,
                              float gainR) {
  cv::xphoto::applyChannelGains(*reinterpret_cast<cv::Mat *>(src),
                                *reinterpret_cast<cv::Mat *>(dst), gainB, gainG,
                                gainR);
}

// ============================================================================
// DCT Denoising
// ============================================================================

void Xphoto_DctDenoising(Mat *src, Mat *dst, double sigma, int psize) {
  cv::xphoto::dctDenoising(*reinterpret_cast<cv::Mat *>(src),
                           *reinterpret_cast<cv::Mat *>(dst), sigma, psize);
}

} // extern "C"
