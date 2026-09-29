#ifndef OPENCV_TRACKING_H
#define OPENCV_TRACKING_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct Tracker Tracker;

// ============================================================================
// Tracker (Legacy API)
// ============================================================================

/// Create TrackerKCF
Tracker *TrackerKCF_Create();

/// Create TrackerCSRT
Tracker *TrackerCSRT_Create();

/// Create TrackerMIL
Tracker *TrackerMIL_Create();

/// Delete Tracker
void Tracker_Delete(Tracker *tracker);

/// Initialize tracker with bounding box
/// image: Initial frame
/// boundingBox: Initial bounding box (Rect)
/// Returns 1 on success, 0 on failure
int Tracker_Init(Tracker *tracker, Mat *image, Rect boundingBox);

/// Update tracker
/// image: Current frame
/// boundingBox: Output updated bounding box
/// Returns 1 on success, 0 on failure
int Tracker_Update(Tracker *tracker, Mat *image, Rect *boundingBox);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_TRACKING_H
