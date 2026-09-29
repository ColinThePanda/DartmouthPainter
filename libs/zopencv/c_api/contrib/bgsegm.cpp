#include "bgsegm.h"
#include <opencv2/bgsegm.hpp>

extern "C" {

// ============================================================================
// Background Subtraction Algorithms
// ============================================================================

BackgroundSubtractor *BackgroundSubtractorMOG_Create(int history, int nmixtures,
                                                     double backgroundRatio,
                                                     double noiseSigma) {
  cv::Ptr<cv::BackgroundSubtractor> ptr =
      cv::bgsegm::createBackgroundSubtractorMOG(history, nmixtures,
                                                backgroundRatio, noiseSigma);
  return reinterpret_cast<BackgroundSubtractor *>(
      new cv::Ptr<cv::BackgroundSubtractor>(ptr));
}

BackgroundSubtractor *BackgroundSubtractorGMG_Create(int initializationFrames,
                                                     double decisionThreshold) {
  cv::Ptr<cv::BackgroundSubtractor> ptr =
      cv::bgsegm::createBackgroundSubtractorGMG(initializationFrames,
                                                decisionThreshold);
  return reinterpret_cast<BackgroundSubtractor *>(
      new cv::Ptr<cv::BackgroundSubtractor>(ptr));
}

BackgroundSubtractor *BackgroundSubtractorCNT_Create(int minPixelStability,
                                                     bool useHistory,
                                                     int maxPixelStability,
                                                     bool isParallel) {
  cv::Ptr<cv::BackgroundSubtractor> ptr =
      cv::bgsegm::createBackgroundSubtractorCNT(minPixelStability, useHistory,
                                                maxPixelStability, isParallel);
  return reinterpret_cast<BackgroundSubtractor *>(
      new cv::Ptr<cv::BackgroundSubtractor>(ptr));
}

BackgroundSubtractor *BackgroundSubtractorGSOC_Create(
    int mc, int nSamples, float replaceRate, float propagationRate,
    int hitsThreshold, float alpha, float beta, float blinkingSupressionDecay,
    float blinkingSupressionMultiplier, float noiseRemovalThresholdFacBG,
    float noiseRemovalThresholdFacFG) {
  cv::Ptr<cv::BackgroundSubtractor> ptr =
      cv::bgsegm::createBackgroundSubtractorGSOC(
          mc, nSamples, replaceRate, propagationRate, hitsThreshold, alpha,
          beta, blinkingSupressionDecay, blinkingSupressionMultiplier,
          noiseRemovalThresholdFacBG, noiseRemovalThresholdFacFG);
  return reinterpret_cast<BackgroundSubtractor *>(
      new cv::Ptr<cv::BackgroundSubtractor>(ptr));
}

BackgroundSubtractor *BackgroundSubtractorLSBP_Create(
    int mc, int nSamples, int LSBPRadius, float Tlower, float Tupper,
    float Tinc, float Tdec, float Rscale, float Rincdec,
    float noiseRemovalThresholdFacBG, float noiseRemovalThresholdFacFG,
    int LSBPthreshold, int minCount) {
  cv::Ptr<cv::BackgroundSubtractor> ptr =
      cv::bgsegm::createBackgroundSubtractorLSBP(
          mc, nSamples, LSBPRadius, Tlower, Tupper, Tinc, Tdec, Rscale, Rincdec,
          noiseRemovalThresholdFacBG, noiseRemovalThresholdFacFG, LSBPthreshold,
          minCount);
  return reinterpret_cast<BackgroundSubtractor *>(
      new cv::Ptr<cv::BackgroundSubtractor>(ptr));
}

void BackgroundSubtractor_Delete(BackgroundSubtractor *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::BackgroundSubtractor> *>(ptr);
  }
}

void BackgroundSubtractor_Apply(BackgroundSubtractor *ptr, Mat *image,
                                Mat *fgmask, double learningRate) {
  cv::Ptr<cv::BackgroundSubtractor> *subtractor =
      reinterpret_cast<cv::Ptr<cv::BackgroundSubtractor> *>(ptr);
  (*subtractor)
      ->apply(*reinterpret_cast<cv::Mat *>(image),
              *reinterpret_cast<cv::Mat *>(fgmask), learningRate);
}

void BackgroundSubtractor_GetBackgroundImage(BackgroundSubtractor *ptr,
                                             Mat *backgroundImage) {
  cv::Ptr<cv::BackgroundSubtractor> *subtractor =
      reinterpret_cast<cv::Ptr<cv::BackgroundSubtractor> *>(ptr);
  (*subtractor)
      ->getBackgroundImage(*reinterpret_cast<cv::Mat *>(backgroundImage));
}

} // extern "C"
