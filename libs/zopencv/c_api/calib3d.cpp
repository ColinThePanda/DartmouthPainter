#include "calib3d.h"
#include <opencv2/calib3d.hpp>

extern "C" {

// ============================================================================
// Camera Calibration
// ============================================================================

int CalibrateCamera(Mat *objectPoints, Mat *imagePoints, Size imageSize,
                    Mat *cameraMatrix, Mat *distCoeffs, Mat *rvecs, Mat *tvecs,
                    int flags, int termcrit_type, int termcrit_maxCount,
                    double termcrit_epsilon) {
  cv::TermCriteria criteria(termcrit_type, termcrit_maxCount, termcrit_epsilon);
  cv::Size img_size(imageSize.width, imageSize.height);

  return static_cast<int>(cv::calibrateCamera(
      *reinterpret_cast<cv::Mat *>(objectPoints),
      *reinterpret_cast<cv::Mat *>(imagePoints), img_size,
      *reinterpret_cast<cv::Mat *>(cameraMatrix),
      *reinterpret_cast<cv::Mat *>(distCoeffs),
      *reinterpret_cast<cv::Mat *>(rvecs), *reinterpret_cast<cv::Mat *>(tvecs),
      flags, criteria));
}

void InitCameraMatrix2D(Mat *objectPoints, Mat *imagePoints, Size imageSize,
                        double aspectRatio, Mat *cameraMatrix) {
  cv::Size img_size(imageSize.width, imageSize.height);
  *reinterpret_cast<cv::Mat *>(cameraMatrix) = cv::initCameraMatrix2D(
      *reinterpret_cast<cv::Mat *>(objectPoints),
      *reinterpret_cast<cv::Mat *>(imagePoints), img_size, aspectRatio);
}

// ============================================================================
// Pose Estimation
// ============================================================================

int SolvePnP(Mat *objectPoints, Mat *imagePoints, Mat *cameraMatrix,
             Mat *distCoeffs, Mat *rvec, Mat *tvec, int useExtrinsicGuess,
             int flags) {
  return static_cast<int>(cv::solvePnP(
      *reinterpret_cast<cv::Mat *>(objectPoints),
      *reinterpret_cast<cv::Mat *>(imagePoints),
      *reinterpret_cast<cv::Mat *>(cameraMatrix),
      *reinterpret_cast<cv::Mat *>(distCoeffs),
      *reinterpret_cast<cv::Mat *>(rvec), *reinterpret_cast<cv::Mat *>(tvec),
      useExtrinsicGuess != 0, flags));
}

int SolvePnPRansac(Mat *objectPoints, Mat *imagePoints, Mat *cameraMatrix,
                   Mat *distCoeffs, Mat *rvec, Mat *tvec, int useExtrinsicGuess,
                   int iterationsCount, float reprojectionError,
                   double confidence, Mat *inliers, int flags) {
  return static_cast<int>(cv::solvePnPRansac(
      *reinterpret_cast<cv::Mat *>(objectPoints),
      *reinterpret_cast<cv::Mat *>(imagePoints),
      *reinterpret_cast<cv::Mat *>(cameraMatrix),
      *reinterpret_cast<cv::Mat *>(distCoeffs),
      *reinterpret_cast<cv::Mat *>(rvec), *reinterpret_cast<cv::Mat *>(tvec),
      useExtrinsicGuess != 0, iterationsCount, reprojectionError, confidence,
      *reinterpret_cast<cv::Mat *>(inliers), flags));
}

// ============================================================================
// Stereo Vision
// ============================================================================

void StereoRectify(Mat *cameraMatrix1, Mat *distCoeffs1, Mat *cameraMatrix2,
                   Mat *distCoeffs2, Size imageSize, Mat *R, Mat *T, Mat *R1,
                   Mat *R2, Mat *P1, Mat *P2, Mat *Q, int flags, double alpha,
                   Size newImageSize, Rect *validPixROI1, Rect *validPixROI2) {
  cv::Size img_size(imageSize.width, imageSize.height);
  cv::Size new_img_size(newImageSize.width, newImageSize.height);
  cv::Rect roi1, roi2;

  cv::stereoRectify(
      *reinterpret_cast<cv::Mat *>(cameraMatrix1),
      *reinterpret_cast<cv::Mat *>(distCoeffs1),
      *reinterpret_cast<cv::Mat *>(cameraMatrix2),
      *reinterpret_cast<cv::Mat *>(distCoeffs2), img_size,
      *reinterpret_cast<cv::Mat *>(R), *reinterpret_cast<cv::Mat *>(T),
      *reinterpret_cast<cv::Mat *>(R1), *reinterpret_cast<cv::Mat *>(R2),
      *reinterpret_cast<cv::Mat *>(P1), *reinterpret_cast<cv::Mat *>(P2),
      *reinterpret_cast<cv::Mat *>(Q), flags, alpha, new_img_size, &roi1,
      &roi2);

  if (validPixROI1) {
    validPixROI1->x = roi1.x;
    validPixROI1->y = roi1.y;
    validPixROI1->width = roi1.width;
    validPixROI1->height = roi1.height;
  }
  if (validPixROI2) {
    validPixROI2->x = roi2.x;
    validPixROI2->y = roi2.y;
    validPixROI2->width = roi2.width;
    validPixROI2->height = roi2.height;
  }
}

double StereoCalibrate(Mat *objectPoints, Mat *imagePoints1, Mat *imagePoints2,
                       Mat *cameraMatrix1, Mat *distCoeffs1, Mat *cameraMatrix2,
                       Mat *distCoeffs2, Size imageSize, Mat *R, Mat *T, Mat *E,
                       Mat *F, int flags, int termcrit_type,
                       int termcrit_maxCount, double termcrit_epsilon) {
  cv::TermCriteria criteria(termcrit_type, termcrit_maxCount, termcrit_epsilon);
  cv::Size img_size(imageSize.width, imageSize.height);

  return cv::stereoCalibrate(*reinterpret_cast<cv::Mat *>(objectPoints),
                             *reinterpret_cast<cv::Mat *>(imagePoints1),
                             *reinterpret_cast<cv::Mat *>(imagePoints2),
                             *reinterpret_cast<cv::Mat *>(cameraMatrix1),
                             *reinterpret_cast<cv::Mat *>(distCoeffs1),
                             *reinterpret_cast<cv::Mat *>(cameraMatrix2),
                             *reinterpret_cast<cv::Mat *>(distCoeffs2),
                             img_size, *reinterpret_cast<cv::Mat *>(R),
                             *reinterpret_cast<cv::Mat *>(T),
                             *reinterpret_cast<cv::Mat *>(E),
                             *reinterpret_cast<cv::Mat *>(F), flags, criteria);
}

// ============================================================================
// Geometric Transformations
// ============================================================================

void Rodrigues(Mat *src, Mat *dst, Mat *jacobian) {
  if (jacobian) {
    cv::Rodrigues(*reinterpret_cast<cv::Mat *>(src),
                  *reinterpret_cast<cv::Mat *>(dst),
                  *reinterpret_cast<cv::Mat *>(jacobian));
  } else {
    cv::Rodrigues(*reinterpret_cast<cv::Mat *>(src),
                  *reinterpret_cast<cv::Mat *>(dst));
  }
}

Mat *EstimateAffine2D(Mat *from, Mat *to, Mat *inliers, int method,
                      double ransacReprojThreshold, int maxIters,
                      double confidence, int refineIters) {
  cv::Mat result = cv::estimateAffine2D(
      *reinterpret_cast<cv::Mat *>(from), *reinterpret_cast<cv::Mat *>(to),
      *reinterpret_cast<cv::Mat *>(inliers), method, ransacReprojThreshold,
      maxIters, confidence, refineIters);
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

Mat *FindFundamentalMat(Mat *points1, Mat *points2, int method,
                        double ransacReprojThreshold, double confidence,
                        Mat *mask) {
  cv::Mat result = cv::findFundamentalMat(
      *reinterpret_cast<cv::Mat *>(points1),
      *reinterpret_cast<cv::Mat *>(points2), method, ransacReprojThreshold,
      confidence, *reinterpret_cast<cv::Mat *>(mask));
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

Mat *FindEssentialMat(Mat *points1, Mat *points2, Mat *cameraMatrix, int method,
                      double prob, double threshold, Mat *mask) {
  cv::Mat result =
      cv::findEssentialMat(*reinterpret_cast<cv::Mat *>(points1),
                           *reinterpret_cast<cv::Mat *>(points2),
                           *reinterpret_cast<cv::Mat *>(cameraMatrix), method,
                           prob, threshold, *reinterpret_cast<cv::Mat *>(mask));
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

// ============================================================================
// Triangulation
// ============================================================================

void TriangulatePoints(Mat *projMatr1, Mat *projMatr2, Mat *projPoints1,
                       Mat *projPoints2, Mat *points4D) {
  cv::triangulatePoints(*reinterpret_cast<cv::Mat *>(projMatr1),
                        *reinterpret_cast<cv::Mat *>(projMatr2),
                        *reinterpret_cast<cv::Mat *>(projPoints1),
                        *reinterpret_cast<cv::Mat *>(projPoints2),
                        *reinterpret_cast<cv::Mat *>(points4D));
}

// ============================================================================
// Undistortion
// ============================================================================

void InitUndistortRectifyMap(Mat *cameraMatrix, Mat *distCoeffs, Mat *R,
                             Mat *newCameraMatrix, Size size, int m1type,
                             Mat *map1, Mat *map2) {
  cv::Size img_size(size.width, size.height);
  cv::initUndistortRectifyMap(
      *reinterpret_cast<cv::Mat *>(cameraMatrix),
      *reinterpret_cast<cv::Mat *>(distCoeffs), *reinterpret_cast<cv::Mat *>(R),
      *reinterpret_cast<cv::Mat *>(newCameraMatrix), img_size, m1type,
      *reinterpret_cast<cv::Mat *>(map1), *reinterpret_cast<cv::Mat *>(map2));
}

void Undistort(Mat *src, Mat *dst, Mat *cameraMatrix, Mat *distCoeffs,
               Mat *newCameraMatrix) {
  if (newCameraMatrix) {
    cv::undistort(*reinterpret_cast<cv::Mat *>(src),
                  *reinterpret_cast<cv::Mat *>(dst),
                  *reinterpret_cast<cv::Mat *>(cameraMatrix),
                  *reinterpret_cast<cv::Mat *>(distCoeffs),
                  *reinterpret_cast<cv::Mat *>(newCameraMatrix));
  } else {
    cv::undistort(*reinterpret_cast<cv::Mat *>(src),
                  *reinterpret_cast<cv::Mat *>(dst),
                  *reinterpret_cast<cv::Mat *>(cameraMatrix),
                  *reinterpret_cast<cv::Mat *>(distCoeffs));
  }
}

// ============================================================================
// Chessboard Detection
// ============================================================================

int FindChessboardCorners(Mat *image, Size patternSize, Mat *corners,
                          int flags) {
  cv::Size pattern(patternSize.width, patternSize.height);
  std::vector<cv::Point2f> cornerVec;
  bool found = cv::findChessboardCorners(*reinterpret_cast<cv::Mat *>(image),
                                         pattern, cornerVec, flags);

  // Convert vector to Mat
  if (!cornerVec.empty()) {
    cv::Mat cornerMat(cornerVec.size(), 1, CV_32FC2);
    for (size_t i = 0; i < cornerVec.size(); i++) {
      cornerMat.at<cv::Point2f>(i) = cornerVec[i];
    }
    *reinterpret_cast<cv::Mat *>(corners) = cornerMat;
  }

  return found ? 1 : 0;
}

int FindChessboardCornersSB(Mat *image, Size patternSize, Mat *corners,
                            int flags) {
  cv::Size pattern(patternSize.width, patternSize.height);
  std::vector<cv::Point2f> cornerVec;
  bool found = cv::findChessboardCornersSB(*reinterpret_cast<cv::Mat *>(image),
                                           pattern, cornerVec, flags);

  if (!cornerVec.empty()) {
    cv::Mat cornerMat(cornerVec.size(), 1, CV_32FC2);
    for (size_t i = 0; i < cornerVec.size(); i++) {
      cornerMat.at<cv::Point2f>(i) = cornerVec[i];
    }
    *reinterpret_cast<cv::Mat *>(corners) = cornerMat;
  }

  return found ? 1 : 0;
}

void DrawChessboardCorners(Mat *image, Size patternSize, Mat *corners,
                           int patternWasFound) {
  cv::Size pattern(patternSize.width, patternSize.height);
  std::vector<cv::Point2f> cornerVec;

  // Convert Mat to vector
  cv::Mat *cornerMat = reinterpret_cast<cv::Mat *>(corners);
  for (int i = 0; i < cornerMat->rows; i++) {
    cornerVec.push_back(cornerMat->at<cv::Point2f>(i));
  }

  cv::drawChessboardCorners(*reinterpret_cast<cv::Mat *>(image), pattern,
                            cornerVec, patternWasFound != 0);
}

Mat *GetOptimalNewCameraMatrix(Mat *cameraMatrix, Mat *distCoeffs,
                               Size imageSize, double alpha, Size newImgSize,
                               Rect validPixROI, int centerPrincipalPoint) {
  cv::Size imgSize(imageSize.width, imageSize.height);
  cv::Size newSize(newImgSize.width, newImgSize.height);
  cv::Rect roi(validPixROI.x, validPixROI.y, validPixROI.width,
               validPixROI.height);

  cv::Mat result = cv::getOptimalNewCameraMatrix(
      *reinterpret_cast<cv::Mat *>(cameraMatrix),
      *reinterpret_cast<cv::Mat *>(distCoeffs), imgSize, alpha, newSize, &roi,
      centerPrincipalPoint != 0);

  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

// ============================================================================
// Homography and Affine Estimation
// ============================================================================

Mat *FindHomography(Mat *srcPoints, Mat *dstPoints, int method,
                    double ransacReprojThreshold, Mat *mask, int maxIters,
                    double confidence) {
  cv::Mat m = cv::findHomography(*(cv::Mat *)srcPoints, *(cv::Mat *)dstPoints,
                                 method, ransacReprojThreshold,
                                 *(cv::Mat *)mask, maxIters, confidence);
  return (Mat *)new cv::Mat(m);
}

Mat *EstimateAffinePartial2D(Mat *from, Mat *to, Mat *inliers, int method,
                             double ransacReprojThreshold, int maxIters,
                             double confidence, int refineIters) {
  cv::Mat m = cv::estimateAffinePartial2D(
      *(cv::Mat *)from, *(cv::Mat *)to, *(cv::Mat *)inliers, method,
      ransacReprojThreshold, (size_t)maxIters, confidence, (size_t)refineIters);
  return (Mat *)new cv::Mat(m);
}

int EstimateAffine3D(Mat *src, Mat *dst, Mat *out, Mat *inliers,
                     double ransacThreshold, double confidence) {
  return cv::estimateAffine3D(*(cv::Mat *)src, *(cv::Mat *)dst, *(cv::Mat *)out,
                              *(cv::Mat *)inliers, ransacThreshold, confidence);
}

// ============================================================================
// Projection and Pose
// ============================================================================

void ProjectPoints(Mat *objectPoints, Mat *rvec, Mat *tvec, Mat *cameraMatrix,
                   Mat *distCoeffs, Mat *imagePoints, Mat *jacobian) {
  cv::projectPoints(*(cv::Mat *)objectPoints, *(cv::Mat *)rvec,
                    *(cv::Mat *)tvec, *(cv::Mat *)cameraMatrix,
                    *(cv::Mat *)distCoeffs, *(cv::Mat *)imagePoints,
                    *(cv::Mat *)jacobian);
}

void ReprojectImageTo3D(Mat *disparity, Mat *_3dImage, Mat *Q,
                        int handleMissingValues, int ddepth) {
  cv::reprojectImageTo3D(*(cv::Mat *)disparity, *(cv::Mat *)_3dImage,
                         *(cv::Mat *)Q, handleMissingValues != 0, ddepth);
}

int RecoverPose(Mat *E, Mat *points1, Mat *points2, Mat *cameraMatrix, Mat *R,
                Mat *t, Mat *mask) {
  return cv::recoverPose(*(cv::Mat *)E, *(cv::Mat *)points1,
                         *(cv::Mat *)points2, *(cv::Mat *)cameraMatrix,
                         *(cv::Mat *)R, *(cv::Mat *)t, *(cv::Mat *)mask);
}

// ============================================================================
// Matrix Decomposition
// ============================================================================

void ComposeRT(Mat *rvec1, Mat *tvec1, Mat *rvec2, Mat *tvec2, Mat *rvec3,
               Mat *tvec3) {
  cv::composeRT(*(cv::Mat *)rvec1, *(cv::Mat *)tvec1, *(cv::Mat *)rvec2,
                *(cv::Mat *)tvec2, *(cv::Mat *)rvec3, *(cv::Mat *)tvec3);
}

void DecomposeProjectionMatrix(Mat *projMatrix, Mat *cameraMatrix,
                               Mat *rotMatrix, Mat *transVect) {
  cv::decomposeProjectionMatrix(*(cv::Mat *)projMatrix,
                                *(cv::Mat *)cameraMatrix, *(cv::Mat *)rotMatrix,
                                *(cv::Mat *)transVect);
}

void DecomposeEssentialMat(Mat *E, Mat *R1, Mat *R2, Mat *t) {
  cv::decomposeEssentialMat(*(cv::Mat *)E, *(cv::Mat *)R1, *(cv::Mat *)R2,
                            *(cv::Mat *)t);
}

// ============================================================================
// Epipolar Geometry
// ============================================================================

void ComputeCorrespondEpilines(Mat *points, int whichImage, Mat *F,
                               Mat *lines) {
  cv::computeCorrespondEpilines(*(cv::Mat *)points, whichImage, *(cv::Mat *)F,
                                *(cv::Mat *)lines);
}

double SampsonDistance(Mat *pt1, Mat *pt2, Mat *F) {
  return cv::sampsonDistance(*(cv::Mat *)pt1, *(cv::Mat *)pt2, *(cv::Mat *)F);
}

// ============================================================================
// Point Conversion
// ============================================================================

void ConvertPointsFromHomogeneous(Mat *src, Mat *dst) {
  cv::convertPointsFromHomogeneous(*(cv::Mat *)src, *(cv::Mat *)dst);
}

void ConvertPointsToHomogeneous(Mat *src, Mat *dst) {
  cv::convertPointsToHomogeneous(*(cv::Mat *)src, *(cv::Mat *)dst);
}

// ============================================================================
// Stereo
// ============================================================================

void FilterSpeckles(Mat *img, double newVal, int maxSpeckleSize, double maxDiff,
                    Mat *buf) {
  cv::filterSpeckles(*(cv::Mat *)img, newVal, maxSpeckleSize, maxDiff,
                     *(cv::Mat *)buf);
}

void ValidateDisparity(Mat *disparity, Mat *cost, int minDisparity,
                       int numberOfDisparities, int disp12MaxDiff) {
  cv::validateDisparity(*(cv::Mat *)disparity, *(cv::Mat *)cost, minDisparity,
                        numberOfDisparities, disp12MaxDiff);
}

// ============================================================================
// Drawing
// ============================================================================

void DrawFrameAxes(Mat *image, Mat *cameraMatrix, Mat *distCoeffs, Mat *rvec,
                   Mat *tvec, float length, int thickness) {
  cv::drawFrameAxes(*(cv::Mat *)image, *(cv::Mat *)cameraMatrix,
                    *(cv::Mat *)distCoeffs, *(cv::Mat *)rvec, *(cv::Mat *)tvec,
                    length, thickness);
}
// ============================================================================
// Additional Calibration Functions
// ============================================================================

int FindCirclesGrid(Mat *image, Size patternSize, Mat *centers, int flags) {
  return cv::findCirclesGrid(*(cv::Mat *)image,
                             cv::Size(patternSize.width, patternSize.height),
                             *(cv::Mat *)centers, flags)
             ? 1
             : 0;
}

int StereoRectifyUncalibrated(Mat *points1, Mat *points2, Mat *F, Size imgSize,
                              Mat *H1, Mat *H2, double threshold) {
  return cv::stereoRectifyUncalibrated(
             *(cv::Mat *)points1, *(cv::Mat *)points2, *(cv::Mat *)F,
             cv::Size(imgSize.width, imgSize.height), *(cv::Mat *)H1,
             *(cv::Mat *)H2, threshold)
             ? 1
             : 0;
}

void CorrectMatches(Mat *F, Mat *points1, Mat *points2, Mat *newPoints1,
                    Mat *newPoints2) {
  cv::correctMatches(*(cv::Mat *)F, *(cv::Mat *)points1, *(cv::Mat *)points2,
                     *(cv::Mat *)newPoints1, *(cv::Mat *)newPoints2);
}

void UndistortPoints(Mat *src, Mat *dst, Mat *cameraMatrix, Mat *distCoeffs,
                     Mat *R, Mat *P) {
  cv::undistortPoints(*(cv::Mat *)src, *(cv::Mat *)dst,
                      *(cv::Mat *)cameraMatrix, *(cv::Mat *)distCoeffs,
                      R ? *(cv::Mat *)R : cv::noArray(),
                      P ? *(cv::Mat *)P : cv::noArray());
}

} // extern "C"
