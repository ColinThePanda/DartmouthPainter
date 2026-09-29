#ifndef OPENCV_SALIENCY_H
#define OPENCV_SALIENCY_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct StaticSaliency StaticSaliency;

// ============================================================================
// Static Saliency
// ============================================================================

/// Create StaticSaliencySpectralResidual
StaticSaliency *StaticSaliencySpectralResidual_Create();

/// Create StaticSaliencyFineGrained
StaticSaliency *StaticSaliencyFineGrained_Create();

/// Delete StaticSaliency
void StaticSaliency_Delete(StaticSaliency *saliency);

/// Compute saliency map
/// image: input image
/// saliencyMap: output saliency map
/// Returns 1 on success, 0 on failure
int StaticSaliency_ComputeSaliency(StaticSaliency *saliency, Mat *image,
                                   Mat *saliencyMap);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_SALIENCY_H
