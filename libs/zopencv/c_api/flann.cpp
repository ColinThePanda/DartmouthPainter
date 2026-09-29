#include "flann.h"
#include <opencv2/flann.hpp>

extern "C" {

// ============================================================================
// FlannIndex
// ============================================================================

FlannIndex *FlannIndex_Create(Mat *features, int index_type) {
  cv::flann::IndexParams *params;

  switch (index_type) {
  case FLANN_INDEX_LINEAR:
    params = new cv::flann::LinearIndexParams();
    break;
  case FLANN_INDEX_KDTREE:
    params = new cv::flann::KDTreeIndexParams(4); // Default 4 trees
    break;
  case FLANN_INDEX_KMEANS:
    params = new cv::flann::KMeansIndexParams();
    break;
  case FLANN_INDEX_COMPOSITE:
    params = new cv::flann::CompositeIndexParams();
    break;
  case FLANN_INDEX_AUTOTUNED:
    params = new cv::flann::AutotunedIndexParams();
    break;
  default:
    params = new cv::flann::LinearIndexParams();
    break;
  }

  cv::flann::Index *index =
      new cv::flann::Index(*reinterpret_cast<cv::Mat *>(features), *params);
  delete params;

  return reinterpret_cast<FlannIndex *>(index);
}

FlannIndex *FlannIndex_CreateKDTree(Mat *features, int trees) {
  cv::flann::KDTreeIndexParams params(trees);
  cv::flann::Index *index =
      new cv::flann::Index(*reinterpret_cast<cv::Mat *>(features), params);
  return reinterpret_cast<FlannIndex *>(index);
}

void FlannIndex_Delete(FlannIndex *index) {
  delete reinterpret_cast<cv::flann::Index *>(index);
}

void FlannIndex_KnnSearch(FlannIndex *index, Mat *query, Mat *indices,
                          Mat *dists, int knn, int params) {
  cv::flann::Index *idx = reinterpret_cast<cv::flann::Index *>(index);
  cv::flann::SearchParams search_params(params);

  idx->knnSearch(*reinterpret_cast<cv::Mat *>(query),
                 *reinterpret_cast<cv::Mat *>(indices),
                 *reinterpret_cast<cv::Mat *>(dists), knn, search_params);
}

int FlannIndex_RadiusSearch(FlannIndex *index, Mat *query, Mat *indices,
                            Mat *dists, double radius, int max_results,
                            int params) {
  cv::flann::Index *idx = reinterpret_cast<cv::flann::Index *>(index);
  cv::flann::SearchParams search_params(params);

  return idx->radiusSearch(*reinterpret_cast<cv::Mat *>(query),
                           *reinterpret_cast<cv::Mat *>(indices),
                           *reinterpret_cast<cv::Mat *>(dists), radius,
                           max_results, search_params);
}

} // extern "C"
