#ifndef OPENCV_ARUCO_H
#define OPENCV_ARUCO_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct ArucoDetector ArucoDetector;
typedef struct ArucoDictionary ArucoDictionary;

// Predefined dictionary types
typedef enum {
  DICT_4X4_50 = 0,
  DICT_4X4_100 = 1,
  DICT_4X4_250 = 2,
  DICT_4X4_1000 = 3,
  DICT_5X5_50 = 4,
  DICT_5X5_100 = 5,
  DICT_5X5_250 = 6,
  DICT_5X5_1000 = 7,
  DICT_6X6_50 = 8,
  DICT_6X6_100 = 9,
  DICT_6X6_250 = 10,
  DICT_6X6_1000 = 11,
  DICT_7X7_50 = 12,
  DICT_7X7_100 = 13,
  DICT_7X7_250 = 14,
  DICT_7X7_1000 = 15,
  DICT_ARUCO_ORIGINAL = 16
} PredefinedDictionaryType;

// ============================================================================
// ArucoDictionary
// ============================================================================

/// Get predefined ArUco dictionary
ArucoDictionary *ArucoDictionary_GetPredefined(int dict_type);

/// Delete ArucoDictionary
void ArucoDictionary_Delete(ArucoDictionary *dictionary);

/// Generate ArUco marker image
/// dict: Dictionary to use
/// id: Marker ID (must be valid for the dictionary)
/// sidePixels: Size of the marker image in pixels
/// img: Output marker image
/// borderBits: Width of the marker border (default 1)
void ArucoDictionary_GenerateImageMarker(ArucoDictionary *dict, int id,
                                         int sidePixels, Mat *img,
                                         int borderBits);

// ============================================================================
// ArucoDetector
// ============================================================================

/// Create ArucoDetector with dictionary
ArucoDetector *ArucoDetector_Create(ArucoDictionary *dictionary);

/// Delete ArucoDetector
void ArucoDetector_Delete(ArucoDetector *detector);

/// Detect ArUco markers in image
/// image: Input image
/// corners: Output vector of marker corners (vector of vector of Point2f)
/// ids: Output vector of marker IDs
/// rejected: Output vector of rejected candidates
void ArucoDetector_DetectMarkers(ArucoDetector *detector, Mat *image,
                                 Mat *corners, Mat *ids, Mat *rejected);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_ARUCO_H
