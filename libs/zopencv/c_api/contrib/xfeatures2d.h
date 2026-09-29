#ifndef OPENCV_XFEATURES2D_H
#define OPENCV_XFEATURES2D_H

#include "../core.h"
#include "../features2d.h"
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// SURF - Speeded Up Robust Features
// ============================================================================

/// Create SURF detector/descriptor
/// hessianThreshold: Threshold for hessian keypoint detector used in SURF
/// nOctaves: Number of pyramid octaves the keypoint detector will use
/// nOctaveLayers: Number of octave layers within each octave
/// extended: Extended descriptor flag (true - 128-element descriptors; false -
/// 64-element descriptors) upright: Up-right or rotated features flag (true -
/// do not compute orientation of features; false - compute orientation)
Feature2D *SURF_Create(double hessianThreshold, int nOctaves, int nOctaveLayers,
                       bool extended, bool upright);

// ============================================================================
// FREAK - Fast Retina Keypoint
// ============================================================================

/// Create FREAK descriptor ecnrtactor
/// orientationNormalized: Enable orientation normalization
/// scaleNormalized: Enable scale normalization
/// patternScale: Scaling of the description pattern
/// nOctaves: Number of octaves covered by the detected keypoints
Feature2D *FREAK_Create(bool orientationNormalized, bool scaleNormalized,
                        float patternScale, int nOctaves);

// ============================================================================
// BriefDescriptorExtractor
// ============================================================================

/// Create BRIEF descriptor extractor
/// bytes: Layout size of the descriptor in bytes (16, 32, 64)
/// use_orientation: Sample patterns using keypoints orientation
Feature2D *BriefDescriptorExtractor_Create(int bytes, bool use_orientation);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_XFEATURES2D_H
