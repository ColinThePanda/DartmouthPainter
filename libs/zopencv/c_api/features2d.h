#ifndef OPENCV_WRAPPER_FEATURES2D_H
#define OPENCV_WRAPPER_FEATURES2D_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer types
typedef struct KeyPoint KeyPoint;
typedef struct KeyPointVector KeyPointVector;
typedef struct ORB ORB;
typedef struct SIFT SIFT;
typedef struct AKAZE AKAZE;
typedef struct Feature2D Feature2D;

// Feature2D functions
void Feature2D_Delete(Feature2D *ptr);
void Feature2D_Detect(Feature2D *f2d, Mat *image, KeyPointVector *keypoints,
                      Mat *mask);
void Feature2D_Compute(Feature2D *f2d, Mat *image, KeyPointVector *keypoints,
                       Mat *descriptors);
void Feature2D_DetectAndCompute(Feature2D *f2d, Mat *image, Mat *mask,
                                KeyPointVector *keypoints, Mat *descriptors);

// KeyPoint structure
struct KeyPointData {
  Point2f pt;
  float size;
  float angle;
  float response;
  int octave;
  int class_id;
};

// KeyPoint functions
KeyPoint *KeyPoint_New(float x, float y, float size, float angle,
                       float response, int octave, int class_id);
void KeyPoint_Delete(KeyPoint *kp);
struct KeyPointData KeyPoint_GetData(KeyPoint *kp);

// KeyPointVector functions
KeyPointVector *KeyPointVector_New();
void KeyPointVector_Delete(KeyPointVector *kpv);
size_t KeyPointVector_Size(KeyPointVector *kpv);
struct KeyPointData KeyPointVector_At(KeyPointVector *kpv, size_t index);

// ORB detector/descriptor
ORB *ORB_Create(int nfeatures, float scaleFactor, int nlevels,
                int edgeThreshold, int firstLevel, int WTA_K, int scoreType,
                int patchSize, int fastThreshold);
void ORB_Delete(ORB *orb);
void ORB_Detect(ORB *orb, Mat *image, KeyPointVector *keypoints, Mat *mask);
void ORB_Compute(ORB *orb, Mat *image, KeyPointVector *keypoints,
                 Mat *descriptors);
void ORB_DetectAndCompute(ORB *orb, Mat *image, Mat *mask,
                          KeyPointVector *keypoints, Mat *descriptors);

// SIFT detector/descriptor
SIFT *SIFT_Create(int nfeatures, int nOctaveLayers, double contrastThreshold,
                  double edgeThreshold, double sigma);
void SIFT_Delete(SIFT *sift);
void SIFT_Detect(SIFT *sift, Mat *image, KeyPointVector *keypoints, Mat *mask);
void SIFT_Compute(SIFT *sift, Mat *image, KeyPointVector *keypoints,
                  Mat *descriptors);
void SIFT_DetectAndCompute(SIFT *sift, Mat *image, Mat *mask,
                           KeyPointVector *keypoints, Mat *descriptors);

// AKAZE detector/descriptor
AKAZE *AKAZE_Create();
void AKAZE_Delete(AKAZE *akaze);
void AKAZE_Detect(AKAZE *akaze, Mat *image, KeyPointVector *keypoints,
                  Mat *mask);
void AKAZE_Compute(AKAZE *akaze, Mat *image, KeyPointVector *keypoints,
                   Mat *descriptors);
void AKAZE_DetectAndCompute(AKAZE *akaze, Mat *image, Mat *mask,
                            KeyPointVector *keypoints, Mat *descriptors);

// Drawing functions
void DrawKeypoints(Mat *image, KeyPointVector *keypoints, Mat *outImage,
                   Scalar color, int flags);

// ============================================================================
// DMatch
// ============================================================================

struct DMatchData {
  int queryIdx;
  int trainIdx;
  int imgIdx;
  float distance;
};

typedef struct DMatchVector DMatchVector;

DMatchVector *DMatchVector_New();
void DMatchVector_Delete(DMatchVector *dmv);
size_t DMatchVector_Size(DMatchVector *dmv);
struct DMatchData DMatchVector_At(DMatchVector *dmv, size_t index);

// ============================================================================
// BFMatcher
// ============================================================================

typedef struct BFMatcher BFMatcher;

BFMatcher *BFMatcher_Create(int normType, int crossCheck);
void BFMatcher_Delete(BFMatcher *bfm);
void BFMatcher_Match(BFMatcher *bfm, Mat *queryDescriptors,
                     Mat *trainDescriptors, DMatchVector *matches);
void BFMatcher_KnnMatch(BFMatcher *bfm, Mat *queryDescriptors,
                        Mat *trainDescriptors, DMatchVector **matches,
                        int *matchCounts, int k);

// ============================================================================
// FlannBasedMatcher
// ============================================================================

typedef struct FlannBasedMatcher FlannBasedMatcher;

FlannBasedMatcher *FlannBasedMatcher_Create();
void FlannBasedMatcher_Delete(FlannBasedMatcher *fbm);
void FlannBasedMatcher_Match(FlannBasedMatcher *fbm, Mat *queryDescriptors,
                             Mat *trainDescriptors, DMatchVector *matches);

// ============================================================================
// DrawMatches
// ============================================================================

void DrawMatches(Mat *img1, KeyPointVector *keypoints1, Mat *img2,
                 KeyPointVector *keypoints2, DMatchVector *matches, Mat *outImg,
                 Scalar matchColor, Scalar singlePointColor, int flags);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_FEATURES2D_H
