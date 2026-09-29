#ifndef OPENCV_DNN_SUPERRES_H
#define OPENCV_DNN_SUPERRES_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// DNN Super Resolution
// ============================================================================

/// Opaque pointer for DnnSuperResImpl
typedef struct DnnSuperResImpl DnnSuperResImpl;

/// Create DNN super resolution object
DnnSuperResImpl *DnnSuperResImpl_Create();

/// Delete DNN super resolution object
void DnnSuperResImpl_Delete(DnnSuperResImpl *ptr);

/// Read and set the model
void DnnSuperResImpl_ReadModel(DnnSuperResImpl *ptr, const char *path);

/// Set the model and scale
void DnnSuperResImpl_SetModel(DnnSuperResImpl *ptr, const char *algo,
                              int scale);

/// Upsample image
void DnnSuperResImpl_Upsample(DnnSuperResImpl *ptr, Mat *img, Mat *result);

/// Get the scale factor
int DnnSuperResImpl_GetScale(DnnSuperResImpl *ptr);

/// Get the algorithm name
const char *DnnSuperResImpl_GetAlgorithm(DnnSuperResImpl *ptr);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_DNN_SUPERRES_H
