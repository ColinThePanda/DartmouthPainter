#ifndef OPENCV_BGSEGM_H
#define OPENCV_BGSEGM_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Background Subtraction Algorithms
// ============================================================================

/// Opaque pointer for BackgroundSubtractor
typedef struct BackgroundSubtractor BackgroundSubtractor;

// Create Gaussian Mixture-based Background/Foreground Segmentation Algorithm
// (MOG)
BackgroundSubtractor *BackgroundSubtractorMOG_Create(int history, int nmixtures,
                                                     double backgroundRatio,
                                                     double noiseSigma);

// Create Gaussian Mixture-based Background/Foreground Segmentation Algorithm
// (GMG)
BackgroundSubtractor *BackgroundSubtractorGMG_Create(int initializationFrames,
                                                     double decisionThreshold);

// Create Count-based Background/Foreground Segmentation Algorithm (CNT)
BackgroundSubtractor *BackgroundSubtractorCNT_Create(int minPixelStability,
                                                     bool useHistory,
                                                     int maxPixelStability,
                                                     bool isParallel);

// Create GSOC Background/Foreground Segmentation Algorithm
BackgroundSubtractor *BackgroundSubtractorGSOC_Create(
    int mc, int nSamples, float replaceRate, float propagationRate,
    int hitsThreshold, float alpha, float beta, float blinkingSupressionDecay,
    float blinkingSupressionMultiplier, float noiseRemovalThresholdFacBG,
    float noiseRemovalThresholdFacFG);

// Create LSBP Background/Foreground Segmentation Algorithm
BackgroundSubtractor *BackgroundSubtractorLSBP_Create(
    int mc, int nSamples, int LSBPRadius, float Tlower, float Tupper,
    float Tinc, float Tdec, float Rscale, float Rincdec,
    float noiseRemovalThresholdFacBG, float noiseRemovalThresholdFacFG,
    int LSBPthreshold, int minCount);

/// Delete background subtractor
void BackgroundSubtractor_Delete(BackgroundSubtractor *ptr);

/// Apply background subtraction
void BackgroundSubtractor_Apply(BackgroundSubtractor *ptr, Mat *image,
                                Mat *fgmask, double learningRate);

/// Get background image
void BackgroundSubtractor_GetBackgroundImage(BackgroundSubtractor *ptr,
                                             Mat *backgroundImage);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_BGSEGM_H
