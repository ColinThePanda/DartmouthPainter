#include "video.h"
#include <opencv2/video.hpp>

extern "C" {

// ============================================================================
// Optical Flow
// ============================================================================

void CalcOpticalFlowPyrLK(Mat *prevImg, Mat *nextImg, Mat *prevPts,
                          Mat *nextPts, Mat *status, Mat *error_out,
                          Size winSize, int maxLevel, int termcrit_type,
                          int termcrit_maxCount, double termcrit_epsilon,
                          int flags, double minEigThreshold) {
  cv::Size win_size(winSize.width, winSize.height);
  cv::TermCriteria criteria(termcrit_type, termcrit_maxCount, termcrit_epsilon);
  cv::calcOpticalFlowPyrLK(*reinterpret_cast<cv::Mat *>(prevImg),
                           *reinterpret_cast<cv::Mat *>(nextImg),
                           *reinterpret_cast<cv::Mat *>(prevPts),
                           *reinterpret_cast<cv::Mat *>(nextPts),
                           *reinterpret_cast<cv::Mat *>(status),
                           *reinterpret_cast<cv::Mat *>(error_out), win_size,
                           maxLevel, criteria, flags, minEigThreshold);
}

void CalcOpticalFlowFarneback(Mat *prev, Mat *next, Mat *flow, double pyr_scale,
                              int levels, int winsize, int iterations,
                              int poly_n, double poly_sigma, int flags) {
  cv::calcOpticalFlowFarneback(
      *reinterpret_cast<cv::Mat *>(prev), *reinterpret_cast<cv::Mat *>(next),
      *reinterpret_cast<cv::Mat *>(flow), pyr_scale, levels, winsize,
      iterations, poly_n, poly_sigma, flags);
}

// ============================================================================
// Background Subtraction - MOG2
// ============================================================================

BackgroundSubtractorMOG2 *BackgroundSubtractorMOG2_Create(int history,
                                                          double varThreshold,
                                                          int detectShadows) {
  cv::Ptr<cv::BackgroundSubtractorMOG2> ptr =
      cv::createBackgroundSubtractorMOG2(history, varThreshold,
                                         detectShadows != 0);
  // We need to keep the Ptr alive, so we allocate it on the heap
  return reinterpret_cast<BackgroundSubtractorMOG2 *>(
      new cv::Ptr<cv::BackgroundSubtractorMOG2>(ptr));
}

void BackgroundSubtractorMOG2_Delete(BackgroundSubtractorMOG2 *b) {
  delete reinterpret_cast<cv::Ptr<cv::BackgroundSubtractorMOG2> *>(b);
}

void BackgroundSubtractorMOG2_Apply(BackgroundSubtractorMOG2 *b, Mat *image,
                                    Mat *fgmask, double learningRate) {
  cv::Ptr<cv::BackgroundSubtractorMOG2> *ptr =
      reinterpret_cast<cv::Ptr<cv::BackgroundSubtractorMOG2> *>(b);
  (*ptr)->apply(*reinterpret_cast<cv::Mat *>(image),
                *reinterpret_cast<cv::Mat *>(fgmask), learningRate);
}

void BackgroundSubtractorMOG2_GetBackgroundImage(BackgroundSubtractorMOG2 *b,
                                                 Mat *backgroundImage) {
  cv::Ptr<cv::BackgroundSubtractorMOG2> *ptr =
      reinterpret_cast<cv::Ptr<cv::BackgroundSubtractorMOG2> *>(b);
  (*ptr)->getBackgroundImage(*reinterpret_cast<cv::Mat *>(backgroundImage));
}

// ============================================================================
// Background Subtraction - KNN
// ============================================================================

BackgroundSubtractorKNN *BackgroundSubtractorKNN_Create(int history,
                                                        double dist2Threshold,
                                                        int detectShadows) {
  cv::Ptr<cv::BackgroundSubtractorKNN> ptr = cv::createBackgroundSubtractorKNN(
      history, dist2Threshold, detectShadows != 0);
  return reinterpret_cast<BackgroundSubtractorKNN *>(
      new cv::Ptr<cv::BackgroundSubtractorKNN>(ptr));
}

void BackgroundSubtractorKNN_Delete(BackgroundSubtractorKNN *b) {
  delete reinterpret_cast<cv::Ptr<cv::BackgroundSubtractorKNN> *>(b);
}

void BackgroundSubtractorKNN_Apply(BackgroundSubtractorKNN *b, Mat *image,
                                   Mat *fgmask, double learningRate) {
  cv::Ptr<cv::BackgroundSubtractorKNN> *ptr =
      reinterpret_cast<cv::Ptr<cv::BackgroundSubtractorKNN> *>(b);
  (*ptr)->apply(*reinterpret_cast<cv::Mat *>(image),
                *reinterpret_cast<cv::Mat *>(fgmask), learningRate);
}

void BackgroundSubtractorKNN_GetBackgroundImage(BackgroundSubtractorKNN *b,
                                                Mat *backgroundImage) {
  cv::Ptr<cv::BackgroundSubtractorKNN> *ptr =
      reinterpret_cast<cv::Ptr<cv::BackgroundSubtractorKNN> *>(b);
  (*ptr)->getBackgroundImage(*reinterpret_cast<cv::Mat *>(backgroundImage));
}

// ============================================================================
// Mean Shift and CamShift
// ============================================================================

int MeanShift(Mat *probImage, Rect *window, int termcrit_type,
              int termcrit_maxCount, double termcrit_epsilon) {
  cv::TermCriteria criteria(termcrit_type, termcrit_maxCount, termcrit_epsilon);
  cv::Rect rect(window->x, window->y, window->width, window->height);

  int result =
      cv::meanShift(*reinterpret_cast<cv::Mat *>(probImage), rect, criteria);

  // Update window
  window->x = rect.x;
  window->y = rect.y;
  window->width = rect.width;
  window->height = rect.height;

  return result;
}

void CamShift(Mat *probImage, Rect *window, int termcrit_type,
              int termcrit_maxCount, double termcrit_epsilon, double *angle,
              Size *size) {
  cv::TermCriteria criteria(termcrit_type, termcrit_maxCount, termcrit_epsilon);
  cv::Rect rect(window->x, window->y, window->width, window->height);

  cv::RotatedRect rotated =
      cv::CamShift(*reinterpret_cast<cv::Mat *>(probImage), rect, criteria);

  // Update window
  window->x = rect.x;
  window->y = rect.y;
  window->width = rect.width;
  window->height = rect.height;

  // Return angle and size
  *angle = rotated.angle;
  size->width = static_cast<int>(rotated.size.width);
  size->height = static_cast<int>(rotated.size.height);
}

// ============================================================================
// KalmanFilter
// ============================================================================

KalmanFilter *KalmanFilter_New(int dynamParams, int measureParams,
                               int controlParams, int type) {
  return reinterpret_cast<KalmanFilter *>(
      new cv::KalmanFilter(dynamParams, measureParams, controlParams, type));
}

void KalmanFilter_Delete(KalmanFilter *kf) {
  delete reinterpret_cast<cv::KalmanFilter *>(kf);
}

void KalmanFilter_Predict(KalmanFilter *kf, Mat *result) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *r = reinterpret_cast<cv::Mat *>(result);
  *r = k->predict();
}

void KalmanFilter_Correct(KalmanFilter *kf, Mat *measurement, Mat *result) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *m = reinterpret_cast<cv::Mat *>(measurement);
  cv::Mat *r = reinterpret_cast<cv::Mat *>(result);
  *r = k->correct(*m);
}

void KalmanFilter_GetTransitionMatrix(KalmanFilter *kf, Mat *result) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *r = reinterpret_cast<cv::Mat *>(result);
  *r = k->transitionMatrix;
}

void KalmanFilter_SetTransitionMatrix(KalmanFilter *kf, Mat *matrix) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *m = reinterpret_cast<cv::Mat *>(matrix);
  k->transitionMatrix = m->clone();
}

void KalmanFilter_GetMeasurementMatrix(KalmanFilter *kf, Mat *result) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *r = reinterpret_cast<cv::Mat *>(result);
  *r = k->measurementMatrix;
}

void KalmanFilter_SetMeasurementMatrix(KalmanFilter *kf, Mat *matrix) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *m = reinterpret_cast<cv::Mat *>(matrix);
  k->measurementMatrix = m->clone();
}

void KalmanFilter_GetStatePre(KalmanFilter *kf, Mat *result) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *r = reinterpret_cast<cv::Mat *>(result);
  *r = k->statePre;
}

void KalmanFilter_SetStatePre(KalmanFilter *kf, Mat *state) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *s = reinterpret_cast<cv::Mat *>(state);
  k->statePre = s->clone();
}

void KalmanFilter_GetStatePost(KalmanFilter *kf, Mat *result) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *r = reinterpret_cast<cv::Mat *>(result);
  *r = k->statePost;
}

void KalmanFilter_SetStatePost(KalmanFilter *kf, Mat *state) {
  cv::KalmanFilter *k = reinterpret_cast<cv::KalmanFilter *>(kf);
  cv::Mat *s = reinterpret_cast<cv::Mat *>(state);
  k->statePost = s->clone();
}

} // extern "C"
