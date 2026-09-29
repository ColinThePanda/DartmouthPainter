#ifndef OPENCV_OPTFLOW_H
#define OPENCV_OPTFLOW_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct DualTVL1OpticalFlow DualTVL1OpticalFlow;

// ============================================================================
// DualTVL1OpticalFlow — Dense Optical Flow
// ============================================================================

/// Create DualTVL1OpticalFlow with default parameters
DualTVL1OpticalFlow *DualTVL1OpticalFlow_Create();

/// Delete DualTVL1OpticalFlow
void DualTVL1OpticalFlow_Delete(DualTVL1OpticalFlow *flow);

/// Calculate dense optical flow
/// prev: first 8-bit single-channel image
/// next: second image of same size and type
/// dst: computed flow image (CV_32FC2)
void DualTVL1OpticalFlow_Calc(DualTVL1OpticalFlow *flow, Mat *prev, Mat *next,
                              Mat *dst);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_OPTFLOW_H
