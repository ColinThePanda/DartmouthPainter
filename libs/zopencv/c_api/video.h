#ifndef OPENCV_VIDEO_H
#define OPENCV_VIDEO_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types for background subtractors
typedef struct BackgroundSubtractorMOG2 BackgroundSubtractorMOG2;
typedef struct BackgroundSubtractorKNN BackgroundSubtractorKNN;

// ============================================================================
// Optical Flow
// ============================================================================

/// Calculates optical flow for a sparse feature set using the iterative
/// Lucas-Kanade method with pyramids
void CalcOpticalFlowPyrLK(Mat *prevImg, Mat *nextImg, Mat *prevPts,
                          Mat *nextPts, Mat *status, Mat *error_out,
                          Size winSize, int maxLevel, int termcrit_type,
                          int termcrit_maxCount, double termcrit_epsilon,
                          int flags, double minEigThreshold);

/// Computes a dense optical flow using the Gunnar Farneback's algorithm
void CalcOpticalFlowFarneback(Mat *prev, Mat *next, Mat *flow, double pyr_scale,
                              int levels, int winsize, int iterations,
                              int poly_n, double poly_sigma, int flags);

// ============================================================================
// Background Subtraction - MOG2
// ============================================================================

/// Create BackgroundSubtractorMOG2
BackgroundSubtractorMOG2 *BackgroundSubtractorMOG2_Create(int history,
                                                          double varThreshold,
                                                          int detectShadows);

/// Delete BackgroundSubtractorMOG2
void BackgroundSubtractorMOG2_Delete(BackgroundSubtractorMOG2 *b);

/// Apply background subtraction
void BackgroundSubtractorMOG2_Apply(BackgroundSubtractorMOG2 *b, Mat *image,
                                    Mat *fgmask, double learningRate);

/// Get background image
void BackgroundSubtractorMOG2_GetBackgroundImage(BackgroundSubtractorMOG2 *b,
                                                 Mat *backgroundImage);

// ============================================================================
// Background Subtraction - KNN
// ============================================================================

/// Create BackgroundSubtractorKNN
BackgroundSubtractorKNN *BackgroundSubtractorKNN_Create(int history,
                                                        double dist2Threshold,
                                                        int detectShadows);

/// Delete BackgroundSubtractorKNN
void BackgroundSubtractorKNN_Delete(BackgroundSubtractorKNN *b);

/// Apply background subtraction
void BackgroundSubtractorKNN_Apply(BackgroundSubtractorKNN *b, Mat *image,
                                   Mat *fgmask, double learningRate);

/// Get background image
void BackgroundSubtractorKNN_GetBackgroundImage(BackgroundSubtractorKNN *b,
                                                Mat *backgroundImage);

// ============================================================================
// Mean Shift and CamShift
// ============================================================================

/// Calculate mean shift
int MeanShift(Mat *probImage, Rect *window, int termcrit_type,
              int termcrit_maxCount, double termcrit_epsilon);

/// Calculate CamShift
void CamShift(Mat *probImage, Rect *window, int termcrit_type,
              int termcrit_maxCount, double termcrit_epsilon, double *angle,
              Size *size);

// ============================================================================
// KalmanFilter
// ============================================================================

typedef struct KalmanFilter KalmanFilter;

KalmanFilter *KalmanFilter_New(int dynamParams, int measureParams,
                               int controlParams, int type);
void KalmanFilter_Delete(KalmanFilter *kf);

/// Predict the next state
void KalmanFilter_Predict(KalmanFilter *kf, Mat *result);

/// Update the state with measurement
void KalmanFilter_Correct(KalmanFilter *kf, Mat *measurement, Mat *result);

/// Get transition matrix (statePre, statePost, transitionMatrix, etc.)
void KalmanFilter_GetTransitionMatrix(KalmanFilter *kf, Mat *result);
void KalmanFilter_SetTransitionMatrix(KalmanFilter *kf, Mat *matrix);
void KalmanFilter_GetMeasurementMatrix(KalmanFilter *kf, Mat *result);
void KalmanFilter_SetMeasurementMatrix(KalmanFilter *kf, Mat *matrix);
void KalmanFilter_GetStatePre(KalmanFilter *kf, Mat *result);
void KalmanFilter_SetStatePre(KalmanFilter *kf, Mat *state);
void KalmanFilter_GetStatePost(KalmanFilter *kf, Mat *result);
void KalmanFilter_SetStatePost(KalmanFilter *kf, Mat *state);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_VIDEO_H
