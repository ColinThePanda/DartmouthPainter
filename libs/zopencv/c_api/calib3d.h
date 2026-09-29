#ifndef OPENCV_CALIB3D_H
#define OPENCV_CALIB3D_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// ============================================================================
// Camera Calibration
// ============================================================================

/// Finds the camera intrinsic and extrinsic parameters from several views
int CalibrateCamera(Mat *objectPoints, Mat *imagePoints, Size imageSize,
                    Mat *cameraMatrix, Mat *distCoeffs, Mat *rvecs, Mat *tvecs,
                    int flags, int termcrit_type, int termcrit_maxCount,
                    double termcrit_epsilon);

/// Finds an initial camera matrix from 3D-2D point correspondences
void InitCameraMatrix2D(Mat *objectPoints, Mat *imagePoints, Size imageSize,
                        double aspectRatio, Mat *cameraMatrix);

// ============================================================================
// Pose Estimation
// ============================================================================

/// Finds an object pose from 3D-2D point correspondences
int SolvePnP(Mat *objectPoints, Mat *imagePoints, Mat *cameraMatrix,
             Mat *distCoeffs, Mat *rvec, Mat *tvec, int useExtrinsicGuess,
             int flags);

/// Finds an object pose from 3D-2D point correspondences using RANSAC
int SolvePnPRansac(Mat *objectPoints, Mat *imagePoints, Mat *cameraMatrix,
                   Mat *distCoeffs, Mat *rvec, Mat *tvec, int useExtrinsicGuess,
                   int iterationsCount, float reprojectionError,
                   double confidence, Mat *inliers, int flags);

// ============================================================================
// Stereo Vision
// ============================================================================

/// Computes rectification transforms for each head of a calibrated stereo
/// camera
void StereoRectify(Mat *cameraMatrix1, Mat *distCoeffs1, Mat *cameraMatrix2,
                   Mat *distCoeffs2, Size imageSize, Mat *R, Mat *T, Mat *R1,
                   Mat *R2, Mat *P1, Mat *P2, Mat *Q, int flags, double alpha,
                   Size newImageSize, Rect *validPixROI1, Rect *validPixROI2);

/// Calibrates the stereo camera
double StereoCalibrate(Mat *objectPoints, Mat *imagePoints1, Mat *imagePoints2,
                       Mat *cameraMatrix1, Mat *distCoeffs1, Mat *cameraMatrix2,
                       Mat *distCoeffs2, Size imageSize, Mat *R, Mat *T, Mat *E,
                       Mat *F, int flags, int termcrit_type,
                       int termcrit_maxCount, double termcrit_epsilon);

// ============================================================================
// Geometric Transformations
// ============================================================================

/// Converts a rotation matrix to a rotation vector
void Rodrigues(Mat *src, Mat *dst, Mat *jacobian);

/// Computes an optimal affine transformation between two 2D point sets
Mat *EstimateAffine2D(Mat *from, Mat *to, Mat *inliers, int method,
                      double ransacReprojThreshold, int maxIters,
                      double confidence, int refineIters);

/// Calculates a fundamental matrix from the corresponding points in two images
Mat *FindFundamentalMat(Mat *points1, Mat *points2, int method,
                        double ransacReprojThreshold, double confidence,
                        Mat *mask);

/// Calculates an essential matrix from the corresponding points in two images
Mat *FindEssentialMat(Mat *points1, Mat *points2, Mat *cameraMatrix, int method,
                      double prob, double threshold, Mat *mask);

// ============================================================================
// Triangulation
// ============================================================================

/// Reconstructs points by triangulation
void TriangulatePoints(Mat *projMatr1, Mat *projMatr2, Mat *projPoints1,
                       Mat *projPoints2, Mat *points4D);

// ============================================================================
// Undistortion
// ============================================================================

/// Computes the undistortion and rectification transformation map
void InitUndistortRectifyMap(Mat *cameraMatrix, Mat *distCoeffs, Mat *R,
                             Mat *newCameraMatrix, Size size, int m1type,
                             Mat *map1, Mat *map2);

/// Transforms an image to compensate for lens distortion
void Undistort(Mat *src, Mat *dst, Mat *cameraMatrix, Mat *distCoeffs,
               Mat *newCameraMatrix);

// ============================================================================
// Chessboard Detection
// ============================================================================

/// Finds the positions of internal corners of the chessboard
int FindChessboardCorners(Mat *image, Size patternSize, Mat *corners,
                          int flags);

/// Finds the positions of internal corners of the chessboard using a sector
/// based approach
int FindChessboardCornersSB(Mat *image, Size patternSize, Mat *corners,
                            int flags);

/// Renders the detected chessboard corners
void DrawChessboardCorners(Mat *image, Size patternSize, Mat *corners,
                           int patternWasFound);

/// Returns the new camera intrinsic matrix based on the free scaling parameter
Mat *GetOptimalNewCameraMatrix(Mat *cameraMatrix, Mat *distCoeffs,
                               Size imageSize, double alpha, Size newImgSize,
                               Rect validPixROI, int centerPrincipalPoint);

// ============================================================================
// Homography and Affine Estimation
// ============================================================================

Mat *FindHomography(Mat *srcPoints, Mat *dstPoints, int method,
                    double ransacReprojThreshold, Mat *mask, int maxIters,
                    double confidence);

Mat *EstimateAffinePartial2D(Mat *from, Mat *to, Mat *inliers, int method,
                             double ransacReprojThreshold, int maxIters,
                             double confidence, int refineIters);

int EstimateAffine3D(Mat *src, Mat *dst, Mat *out, Mat *inliers,
                     double ransacThreshold, double confidence);

// ============================================================================
// Projection and Pose
// ============================================================================

void ProjectPoints(Mat *objectPoints, Mat *rvec, Mat *tvec, Mat *cameraMatrix,
                   Mat *distCoeffs, Mat *imagePoints, Mat *jacobian);

void ReprojectImageTo3D(Mat *disparity, Mat *_3dImage, Mat *Q,
                        int handleMissingValues, int ddepth);

int RecoverPose(Mat *E, Mat *points1, Mat *points2, Mat *cameraMatrix, Mat *R,
                Mat *t, Mat *mask);

// ============================================================================
// Matrix Decomposition
// ============================================================================

void ComposeRT(Mat *rvec1, Mat *tvec1, Mat *rvec2, Mat *tvec2, Mat *rvec3,
               Mat *tvec3);

void DecomposeProjectionMatrix(Mat *projMatrix, Mat *cameraMatrix,
                               Mat *rotMatrix, Mat *transVect);

void DecomposeEssentialMat(Mat *E, Mat *R1, Mat *R2, Mat *t);

// ============================================================================
// Epipolar Geometry
// ============================================================================

void ComputeCorrespondEpilines(Mat *points, int whichImage, Mat *F, Mat *lines);

double SampsonDistance(Mat *pt1, Mat *pt2, Mat *F);

// ============================================================================
// Point Conversion
// ============================================================================

void ConvertPointsFromHomogeneous(Mat *src, Mat *dst);
void ConvertPointsToHomogeneous(Mat *src, Mat *dst);

// ============================================================================
// Stereo
// ============================================================================

void FilterSpeckles(Mat *img, double newVal, int maxSpeckleSize, double maxDiff,
                    Mat *buf);

void ValidateDisparity(Mat *disparity, Mat *cost, int minDisparity,
                       int numberOfDisparities, int disp12MaxDiff);

// ============================================================================
// Drawing
// ============================================================================

void DrawFrameAxes(Mat *image, Mat *cameraMatrix, Mat *distCoeffs, Mat *rvec,
                   Mat *tvec, float length, int thickness);

// ============================================================================
// Additional Calibration Functions
// ============================================================================

int FindCirclesGrid(Mat *image, Size patternSize, Mat *centers, int flags);

int StereoRectifyUncalibrated(Mat *points1, Mat *points2, Mat *F, Size imgSize,
                              Mat *H1, Mat *H2, double threshold);

void CorrectMatches(Mat *F, Mat *points1, Mat *points2, Mat *newPoints1,
                    Mat *newPoints2);

void UndistortPoints(Mat *src, Mat *dst, Mat *cameraMatrix, Mat *distCoeffs,
                     Mat *R, Mat *P);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_CALIB3D_H
