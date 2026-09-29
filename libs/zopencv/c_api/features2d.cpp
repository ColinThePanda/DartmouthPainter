#include "features2d.h"
#include <opencv2/features2d.hpp>

extern "C" {

// ============================================================================
// Feature2D (Base)
// ============================================================================

void Feature2D_Delete(Feature2D *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::Feature2D> *>(ptr);
  }
}

void Feature2D_Detect(Feature2D *f2d, Mat *image, KeyPointVector *keypoints,
                      Mat *mask) {
  cv::Ptr<cv::Feature2D> *ptr = reinterpret_cast<cv::Ptr<cv::Feature2D> *>(f2d);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*ptr)->detect(*img, *kps, m ? *m : cv::Mat());
}

void Feature2D_Compute(Feature2D *f2d, Mat *image, KeyPointVector *keypoints,
                       Mat *descriptors) {
  cv::Ptr<cv::Feature2D> *ptr = reinterpret_cast<cv::Ptr<cv::Feature2D> *>(f2d);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  (*ptr)->compute(*img, *kps, *desc);
}

void Feature2D_DetectAndCompute(Feature2D *f2d, Mat *image, Mat *mask,
                                KeyPointVector *keypoints, Mat *descriptors) {
  cv::Ptr<cv::Feature2D> *ptr = reinterpret_cast<cv::Ptr<cv::Feature2D> *>(f2d);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*ptr)->detectAndCompute(*img, m ? *m : cv::Mat(), *kps, *desc);
}

// ============================================================================
// KeyPoint functions
KeyPoint *KeyPoint_New(float x, float y, float size, float angle,
                       float response, int octave, int class_id) {
  return reinterpret_cast<KeyPoint *>(new cv::KeyPoint(
      cv::Point2f(x, y), size, angle, response, octave, class_id));
}

void KeyPoint_Delete(KeyPoint *kp) {
  delete reinterpret_cast<cv::KeyPoint *>(kp);
}

struct KeyPointData KeyPoint_GetData(KeyPoint *kp) {
  cv::KeyPoint *k = reinterpret_cast<cv::KeyPoint *>(kp);
  struct KeyPointData data;
  data.pt.x = k->pt.x;
  data.pt.y = k->pt.y;
  data.size = k->size;
  data.angle = k->angle;
  data.response = k->response;
  data.octave = k->octave;
  data.class_id = k->class_id;
  return data;
}

// KeyPointVector functions
KeyPointVector *KeyPointVector_New() {
  return reinterpret_cast<KeyPointVector *>(new std::vector<cv::KeyPoint>());
}

void KeyPointVector_Delete(KeyPointVector *kpv) {
  delete reinterpret_cast<std::vector<cv::KeyPoint> *>(kpv);
}

size_t KeyPointVector_Size(KeyPointVector *kpv) {
  return reinterpret_cast<std::vector<cv::KeyPoint> *>(kpv)->size();
}

struct KeyPointData KeyPointVector_At(KeyPointVector *kpv, size_t index) {
  cv::KeyPoint &k =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(kpv)->at(index);
  struct KeyPointData data;
  data.pt.x = k.pt.x;
  data.pt.y = k.pt.y;
  data.size = k.size;
  data.angle = k.angle;
  data.response = k.response;
  data.octave = k.octave;
  data.class_id = k.class_id;
  return data;
}

// ORB
ORB *ORB_Create(int nfeatures, float scaleFactor, int nlevels,
                int edgeThreshold, int firstLevel, int WTA_K, int scoreType,
                int patchSize, int fastThreshold) {
  auto ptr = cv::ORB::create(
      nfeatures, scaleFactor, nlevels, edgeThreshold, firstLevel, WTA_K,
      static_cast<cv::ORB::ScoreType>(scoreType), patchSize, fastThreshold);
  return reinterpret_cast<ORB *>(new cv::Ptr<cv::ORB>(ptr));
}

void ORB_Delete(ORB *orb) { delete reinterpret_cast<cv::Ptr<cv::ORB> *>(orb); }

void ORB_Detect(ORB *orb, Mat *image, KeyPointVector *keypoints, Mat *mask) {
  cv::Ptr<cv::ORB> *detector_ptr = reinterpret_cast<cv::Ptr<cv::ORB> *>(orb);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*detector_ptr)->detect(*img, *kps, m ? *m : cv::Mat());
}

void ORB_Compute(ORB *orb, Mat *image, KeyPointVector *keypoints,
                 Mat *descriptors) {
  cv::Ptr<cv::ORB> *detector_ptr = reinterpret_cast<cv::Ptr<cv::ORB> *>(orb);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  (*detector_ptr)->compute(*img, *kps, *desc);
}

void ORB_DetectAndCompute(ORB *orb, Mat *image, Mat *mask,
                          KeyPointVector *keypoints, Mat *descriptors) {
  cv::Ptr<cv::ORB> *detector_ptr = reinterpret_cast<cv::Ptr<cv::ORB> *>(orb);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*detector_ptr)->detectAndCompute(*img, m ? *m : cv::Mat(), *kps, *desc);
}

// SIFT
SIFT *SIFT_Create(int nfeatures, int nOctaveLayers, double contrastThreshold,
                  double edgeThreshold, double sigma) {
  auto ptr = cv::SIFT::create(nfeatures, nOctaveLayers, contrastThreshold,
                              edgeThreshold, sigma);
  return reinterpret_cast<SIFT *>(new cv::Ptr<cv::SIFT>(ptr));
}

void SIFT_Delete(SIFT *sift) {
  delete reinterpret_cast<cv::Ptr<cv::SIFT> *>(sift);
}

void SIFT_Detect(SIFT *sift, Mat *image, KeyPointVector *keypoints, Mat *mask) {
  cv::Ptr<cv::SIFT> *detector_ptr = reinterpret_cast<cv::Ptr<cv::SIFT> *>(sift);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*detector_ptr)->detect(*img, *kps, m ? *m : cv::Mat());
}

void SIFT_Compute(SIFT *sift, Mat *image, KeyPointVector *keypoints,
                  Mat *descriptors) {
  cv::Ptr<cv::SIFT> *detector_ptr = reinterpret_cast<cv::Ptr<cv::SIFT> *>(sift);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  (*detector_ptr)->compute(*img, *kps, *desc);
}

void SIFT_DetectAndCompute(SIFT *sift, Mat *image, Mat *mask,
                           KeyPointVector *keypoints, Mat *descriptors) {
  cv::Ptr<cv::SIFT> *detector_ptr = reinterpret_cast<cv::Ptr<cv::SIFT> *>(sift);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*detector_ptr)->detectAndCompute(*img, m ? *m : cv::Mat(), *kps, *desc);
}

// AKAZE
AKAZE *AKAZE_Create() {
  auto ptr = cv::AKAZE::create();
  return reinterpret_cast<AKAZE *>(new cv::Ptr<cv::AKAZE>(ptr));
}

void AKAZE_Delete(AKAZE *akaze) {
  delete reinterpret_cast<cv::Ptr<cv::AKAZE> *>(akaze);
}

void AKAZE_Detect(AKAZE *akaze, Mat *image, KeyPointVector *keypoints,
                  Mat *mask) {
  cv::Ptr<cv::AKAZE> *detector_ptr =
      reinterpret_cast<cv::Ptr<cv::AKAZE> *>(akaze);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*detector_ptr)->detect(*img, *kps, m ? *m : cv::Mat());
}

void AKAZE_Compute(AKAZE *akaze, Mat *image, KeyPointVector *keypoints,
                   Mat *descriptors) {
  cv::Ptr<cv::AKAZE> *detector_ptr =
      reinterpret_cast<cv::Ptr<cv::AKAZE> *>(akaze);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  (*detector_ptr)->compute(*img, *kps, *desc);
}

void AKAZE_DetectAndCompute(AKAZE *akaze, Mat *image, Mat *mask,
                            KeyPointVector *keypoints, Mat *descriptors) {
  cv::Ptr<cv::AKAZE> *detector_ptr =
      reinterpret_cast<cv::Ptr<cv::AKAZE> *>(akaze);
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *desc = reinterpret_cast<cv::Mat *>(descriptors);
  cv::Mat *m = mask ? reinterpret_cast<cv::Mat *>(mask) : nullptr;
  (*detector_ptr)->detectAndCompute(*img, m ? *m : cv::Mat(), *kps, *desc);
}

// Drawing
void DrawKeypoints(Mat *image, KeyPointVector *keypoints, Mat *outImage,
                   Scalar color, int flags) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<cv::KeyPoint> *kps =
      reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints);
  cv::Mat *out = reinterpret_cast<cv::Mat *>(outImage);
  cv::drawKeypoints(*img, *kps, *out,
                    cv::Scalar(color.v0, color.v1, color.v2, color.v3),
                    static_cast<cv::DrawMatchesFlags>(flags));
}

// ============================================================================
// DMatch Vector
// ============================================================================

DMatchVector *DMatchVector_New() {
  return reinterpret_cast<DMatchVector *>(new std::vector<cv::DMatch>());
}

void DMatchVector_Delete(DMatchVector *dmv) {
  delete reinterpret_cast<std::vector<cv::DMatch> *>(dmv);
}

size_t DMatchVector_Size(DMatchVector *dmv) {
  return reinterpret_cast<std::vector<cv::DMatch> *>(dmv)->size();
}

struct DMatchData DMatchVector_At(DMatchVector *dmv, size_t index) {
  auto *v = reinterpret_cast<std::vector<cv::DMatch> *>(dmv);
  cv::DMatch m = (*v)[index];
  return DMatchData{m.queryIdx, m.trainIdx, m.imgIdx, m.distance};
}

// ============================================================================
// BFMatcher
// ============================================================================

BFMatcher *BFMatcher_Create(int normType, int crossCheck) {
  return reinterpret_cast<BFMatcher *>(
      new cv::BFMatcher(normType, crossCheck != 0));
}

void BFMatcher_Delete(BFMatcher *bfm) {
  delete reinterpret_cast<cv::BFMatcher *>(bfm);
}

void BFMatcher_Match(BFMatcher *bfm, Mat *queryDescriptors,
                     Mat *trainDescriptors, DMatchVector *matches) {
  cv::BFMatcher *m = reinterpret_cast<cv::BFMatcher *>(bfm);
  cv::Mat *q = reinterpret_cast<cv::Mat *>(queryDescriptors);
  cv::Mat *t = reinterpret_cast<cv::Mat *>(trainDescriptors);
  auto *out = reinterpret_cast<std::vector<cv::DMatch> *>(matches);
  m->match(*q, *t, *out);
}

void BFMatcher_KnnMatch(BFMatcher *bfm, Mat *queryDescriptors,
                        Mat *trainDescriptors, DMatchVector **matches,
                        int *matchCounts, int k) {
  cv::BFMatcher *m = reinterpret_cast<cv::BFMatcher *>(bfm);
  cv::Mat *q = reinterpret_cast<cv::Mat *>(queryDescriptors);
  cv::Mat *t = reinterpret_cast<cv::Mat *>(trainDescriptors);
  std::vector<std::vector<cv::DMatch>> knnMatches;
  m->knnMatch(*q, *t, knnMatches, k);
  // Copy first match of each knn group into the single output vector
  auto *out = reinterpret_cast<std::vector<cv::DMatch> *>(matches[0]);
  for (size_t i = 0; i < knnMatches.size(); i++) {
    if (!knnMatches[i].empty()) {
      out->push_back(knnMatches[i][0]);
    }
  }
  if (matchCounts) {
    *matchCounts = static_cast<int>(out->size());
  }
}

// ============================================================================
// FlannBasedMatcher
// ============================================================================

FlannBasedMatcher *FlannBasedMatcher_Create() {
  return reinterpret_cast<FlannBasedMatcher *>(new cv::FlannBasedMatcher());
}

void FlannBasedMatcher_Delete(FlannBasedMatcher *fbm) {
  delete reinterpret_cast<cv::FlannBasedMatcher *>(fbm);
}

void FlannBasedMatcher_Match(FlannBasedMatcher *fbm, Mat *queryDescriptors,
                             Mat *trainDescriptors, DMatchVector *matches) {
  cv::FlannBasedMatcher *m = reinterpret_cast<cv::FlannBasedMatcher *>(fbm);
  cv::Mat *q = reinterpret_cast<cv::Mat *>(queryDescriptors);
  cv::Mat *t = reinterpret_cast<cv::Mat *>(trainDescriptors);
  auto *out = reinterpret_cast<std::vector<cv::DMatch> *>(matches);
  m->match(*q, *t, *out);
}

// ============================================================================
// Draw Matches
// ============================================================================

void DrawMatches(Mat *img1, KeyPointVector *keypoints1, Mat *img2,
                 KeyPointVector *keypoints2, DMatchVector *matches, Mat *outImg,
                 Scalar matchColor, Scalar singlePointColor, int flags) {
  cv::Mat *i1 = reinterpret_cast<cv::Mat *>(img1);
  auto *kp1 = reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints1);
  cv::Mat *i2 = reinterpret_cast<cv::Mat *>(img2);
  auto *kp2 = reinterpret_cast<std::vector<cv::KeyPoint> *>(keypoints2);
  auto *m = reinterpret_cast<std::vector<cv::DMatch> *>(matches);
  cv::Mat *out = reinterpret_cast<cv::Mat *>(outImg);
  cv::drawMatches(
      *i1, *kp1, *i2, *kp2, *m, *out,
      cv::Scalar(matchColor.v0, matchColor.v1, matchColor.v2, matchColor.v3),
      cv::Scalar(singlePointColor.v0, singlePointColor.v1, singlePointColor.v2,
                 singlePointColor.v3),
      std::vector<char>(), static_cast<cv::DrawMatchesFlags>(flags));
}

} // extern "C"
