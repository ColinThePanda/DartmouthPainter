#ifndef OPENCV_FLANN_H
#define OPENCV_FLANN_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer type
typedef struct FlannIndex FlannIndex;

// Index types
typedef enum {
  FLANN_INDEX_LINEAR = 0,
  FLANN_INDEX_KDTREE = 1,
  FLANN_INDEX_KMEANS = 2,
  FLANN_INDEX_COMPOSITE = 3,
  FLANN_INDEX_AUTOTUNED = 255
} FlannIndexType;

// ============================================================================
// FlannIndex
// ============================================================================

/// Create FLANN index with features and index type
/// features: Mat containing feature vectors (each row is a feature)
/// index_type: Type of index to create
FlannIndex *FlannIndex_Create(Mat *features, int index_type);

/// Create FLANN index with KDTree parameters
/// features: Mat containing feature vectors
/// trees: Number of parallel kd-trees to use
FlannIndex *FlannIndex_CreateKDTree(Mat *features, int trees);

/// Delete FLANN index
void FlannIndex_Delete(FlannIndex *index);

/// Perform K-nearest neighbor search
/// query: Query point(s) Mat
/// indices: Output Mat for indices of nearest neighbors
/// dists: Output Mat for distances to nearest neighbors
/// knn: Number of nearest neighbors to find
/// params: Search parameters (currently unused, pass 0)
void FlannIndex_KnnSearch(FlannIndex *index, Mat *query, Mat *indices,
                          Mat *dists, int knn, int params);

/// Perform radius search
/// query: Query point(s) Mat
/// indices: Output Mat for indices of neighbors within radius
/// dists: Output Mat for distances to neighbors
/// radius: Search radius
/// max_results: Maximum number of results to return
/// params: Search parameters (currently unused, pass 0)
int FlannIndex_RadiusSearch(FlannIndex *index, Mat *query, Mat *indices,
                            Mat *dists, double radius, int max_results,
                            int params);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_FLANN_H
