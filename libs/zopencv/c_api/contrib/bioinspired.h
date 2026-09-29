#ifndef OPENCV_BIOINSPIRED_H
#define OPENCV_BIOINSPIRED_H

#include "../core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Bioinspired - Retina Model
// ============================================================================

/// Opaque pointer for Retina
typedef struct Retina Retina;

/// Create Retina model
Retina *Retina_Create(int width, int height, bool colorMode);

/// Delete Retina model
void Retina_Delete(Retina *ptr);

/// Run retina filter on input image
void Retina_Run(Retina *ptr, Mat *input);

/// Get Parvo (details/color) output
void Retina_GetParvo(Retina *ptr, Mat *output);

/// Get Magno (motion/transient) output
void Retina_GetMagno(Retina *ptr, Mat *output);

/// Clear all retina buffers
void Retina_ClearBuffers(Retina *ptr);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_BIOINSPIRED_H
