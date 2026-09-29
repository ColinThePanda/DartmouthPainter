#ifndef OPENCV_STITCHING_H
#define OPENCV_STITCHING_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer type
typedef struct Stitcher Stitcher;

// Stitching modes
typedef enum { STITCHER_PANORAMA = 0, STITCHER_SCANS = 1 } StitcherMode;

// Stitching status codes
typedef enum {
  STITCHER_OK = 0,
  STITCHER_ERR_NEED_MORE_IMGS = 1,
  STITCHER_ERR_HOMOGRAPHY_EST_FAIL = 2,
  STITCHER_ERR_CAMERA_PARAMS_ADJUST_FAIL = 3
} StitcherStatus;

// ============================================================================
// Stitcher
// ============================================================================

/// Create Stitcher with specified mode
Stitcher *Stitcher_Create(int mode);

/// Delete Stitcher
void Stitcher_Delete(Stitcher *stitcher);

/// Stitch images together
/// images: array of Mat pointers
/// num_images: number of images
/// pano: output panorama Mat
/// Returns StitcherStatus
int Stitcher_Stitch(Stitcher *stitcher, Mat **images, int num_images,
                    Mat *pano);

/// Get registration resolution scale
double Stitcher_GetRegistrationResol(Stitcher *stitcher);

/// Set registration resolution scale
void Stitcher_SetRegistrationResol(Stitcher *stitcher, double resol);

/// Get seam estimation resolution scale
double Stitcher_GetSeamEstimationResol(Stitcher *stitcher);

/// Set seam estimation resolution scale
void Stitcher_SetSeamEstimationResol(Stitcher *stitcher, double resol);

/// Get compositing resolution scale
double Stitcher_GetCompositingResol(Stitcher *stitcher);

/// Set compositing resolution scale
void Stitcher_SetCompositingResol(Stitcher *stitcher, double resol);

/// Get panorama confidence threshold
double Stitcher_GetPanoConfidenceThresh(Stitcher *stitcher);

/// Set panorama confidence threshold
void Stitcher_SetPanoConfidenceThresh(Stitcher *stitcher, double conf_thresh);

/// Get wave correction flag
int Stitcher_GetWaveCorrection(Stitcher *stitcher);

/// Set wave correction flag
void Stitcher_SetWaveCorrection(Stitcher *stitcher, int flag);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_STITCHING_H
