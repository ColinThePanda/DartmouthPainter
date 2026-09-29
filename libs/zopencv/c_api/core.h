#ifndef OPENCV_WRAPPER_CORE_H
#define OPENCV_WRAPPER_CORE_H

#include <stddef.h>

#ifdef __cplusplus
#include <opencv2/core.hpp>
extern "C" {
#endif

// Opaque pointer types
typedef struct Mat Mat;
typedef struct PointVector PointVector;
typedef struct Point2fVector Point2fVector;
typedef struct Point3fVector Point3fVector;
typedef struct PointsVector PointsVector;
typedef struct Mats Mats;

// ============================================================================
// Mats — vector of Mat for passing multiple images
// ============================================================================

Mats *Mats_New();
void Mats_Delete(Mats *mats);
void Mats_Append(Mats *mats, Mat *mat);
size_t Mats_Size(Mats *mats);

// Simple value types
typedef struct {
  int x;
  int y;
} Point;

typedef struct {
  float x;
  float y;
} Point2f;

typedef struct {
  float x;
  float y;
  float z;
} Point3f;

typedef struct {
  int x;
  int y;
  int width;
  int height;
} Rect;

typedef struct {
  int width;
  int height;
} Size;

typedef struct {
  double v0;
  double v1;
  double v2;
  double v3;
} Scalar;

// Mat functions
Mat *Mat_New();
Mat *Mat_NewWithSize(int rows, int cols, int type);
Mat *Mat_NewFromBytes(int rows, int cols, int type, void *data, size_t step);
void Mat_Delete(Mat *mat);
Mat *Mat_Clone(Mat *mat);
int Mat_Empty(Mat *mat);
int Mat_Rows(Mat *mat);
int Mat_Cols(Mat *mat);
int Mat_Type(Mat *mat);
int Mat_Channels(Mat *mat);
int Mat_Depth(Mat *mat);
size_t Mat_Total(Mat *mat);
size_t Mat_ElemSize(Mat *mat);
void *Mat_Data(Mat *mat);
size_t Mat_Step(Mat *mat);
void Mat_CopyTo(Mat *src, Mat *dst);
void Mat_ConvertTo(Mat *src, Mat *dst, int rtype, double alpha, double beta);

// Mat element access
double Mat_GetDouble(Mat *mat, int row, int col);
float Mat_GetFloat(Mat *mat, int row, int col);
int Mat_GetInt(Mat *mat, int row, int col);
unsigned char Mat_GetUChar(Mat *mat, int row, int col);
void Mat_SetDouble(Mat *mat, int row, int col, double value);
void Mat_SetFloat(Mat *mat, int row, int col, float value);
void Mat_SetInt(Mat *mat, int row, int col, int value);
void Mat_SetUChar(Mat *mat, int row, int col, unsigned char value);

// Mat static construction methods
Mat *Mat_Zeros(int rows, int cols, int type);
Mat *Mat_Ones(int rows, int cols, int type);
Mat *Mat_Eye(int rows, int cols, int type);

// Mat element operations
void Mat_SetTo(Mat *mat, Scalar value);
void Mat_SetToMask(Mat *mat, Scalar value, Mat *mask);
Mat *Mat_Reshape(Mat *mat, int cn, int rows);
Mat *Mat_T(Mat *mat);
Mat *Mat_Inv(Mat *mat, int method);
Mat *Mat_Mul(Mat *mat, Mat *other, double scale);
double Mat_Dot(Mat *mat, Mat *other);
Mat *Mat_Cross(Mat *mat, Mat *other);

// Mat ROI and slicing operations
Mat *Mat_Row(Mat *mat, int y);
Mat *Mat_Col(Mat *mat, int x);
Mat *Mat_RowRange(Mat *mat, int startrow, int endrow);
Mat *Mat_ColRange(Mat *mat, int startcol, int endcol);
Mat *Mat_Submat(Mat *mat, Rect roi);
Mat *Mat_SubmatRanges(Mat *mat, int row_start, int row_end, int col_start,
                      int col_end);

// Matrix arithmetic operations
void Mat_Add(Mat *src1, Mat *src2, Mat *dst);
void Mat_Subtract(Mat *src1, Mat *src2, Mat *dst);
void Mat_Multiply(Mat *src1, Mat *src2, Mat *dst);
void Mat_Divide(Mat *src1, Mat *src2, Mat *dst);
void Mat_BitwiseAnd(Mat *src1, Mat *src2, Mat *dst);
void Mat_BitwiseOr(Mat *src1, Mat *src2, Mat *dst);
void Mat_BitwiseXor(Mat *src1, Mat *src2, Mat *dst);
void Mat_BitwiseNot(Mat *src, Mat *dst);
void Mat_Compare(Mat *src1, Mat *src2, Mat *dst, int cmpop);
void Mat_InRange(Mat *src, Scalar lowerb, Scalar upperb, Mat *dst);
void Mat_AddWeighted(Mat *src1, double alpha, Mat *src2, double beta,
                     double gamma, Mat *dst);
void Mat_Absdiff(Mat *src1, Mat *src2, Mat *dst);

// Math and reduction operations
double Mat_Norm(Mat *src, int normType);
void Mat_Normalize(Mat *src, Mat *dst, double alpha, double beta, int normType);
Scalar Mat_Sum(Mat *src);
Scalar Mat_Mean(Mat *src);
void Mat_MeanStdDev(Mat *src, Scalar *mean, Scalar *stddev);
void Mat_MinMaxLoc(Mat *src, double *minVal, double *maxVal, Point *minLoc,
                   Point *maxLoc);
void Mat_Reduce(Mat *src, Mat *dst, int dim, int rtype);
int Mat_CountNonZero(Mat *src);
void Mat_Sqrt(Mat *src, Mat *dst);
void Mat_Pow(Mat *src, double power, Mat *dst);
void Mat_Exp(Mat *src, Mat *dst);
void Mat_Log(Mat *src, Mat *dst);

// Array operations
void Mat_Merge(Mat **mats, int count, Mat *dst);
void Mat_Split(Mat *src, Mat **dsts);
void Mat_Flip(Mat *src, Mat *dst, int flipCode);
void Mat_Rotate(Mat *src, Mat *dst, int rotateCode);

// Linear algebra operations
void Mat_Gemm(Mat *src1, Mat *src2, double alpha, Mat *src3, double beta,
              Mat *dst, int flags);
void Mat_Transpose(Mat *src, Mat *dst);
double Mat_Invert(Mat *src, Mat *dst, int method);
int Mat_Solve(Mat *src1, Mat *src2, Mat *dst, int flags);
double Mat_Determinant(Mat *src);
Scalar Mat_Trace(Mat *src);

// Math operations (Phase 8)
void Mat_Min(Mat *src1, Mat *src2, Mat *dst);
void Mat_Max(Mat *src1, Mat *src2, Mat *dst);
void Mat_Abs(Mat *src, Mat *dst);

// Channel operations (Phase 9)
void Mat_ExtractChannel(Mat *src, Mat *dst, int coi);
void Mat_InsertChannel(Mat *src, Mat *dst, int coi);
void Mat_MixChannels(Mat **src, int nsrcs, Mat **dst, int ndsts, int *fromTo,
                     int npairs);
void Mat_FindNonZero(Mat *src, Mat *idx);

// Array concatenation operations (Phase 10)
void Mat_Repeat(Mat *src, int ny, int nx, Mat *dst);
void Mat_Hconcat(Mat **src, int nsrc, Mat *dst);
void Mat_Vconcat(Mat **src, int nsrc, Mat *dst);

// Advanced linear algebra operations (Phase 11)
void Mat_MulTransposed(Mat *src, Mat *dst, int aTa);
int Mat_Eigen(Mat *src, Mat *eigenvalues, Mat *eigenvectors);
void Mat_SVDecomp(Mat *src, Mat *w, Mat *u, Mat *vt, int flags);

// Final P1 utility functions (Phase 12)
void Mat_SetIdentity(Mat *dst, Scalar s);
void Mat_Sort(Mat *src, Mat *dst, int flags);
void Mat_SortIdx(Mat *src, Mat *dst, int flags);
void Mat_CompleteSymm(Mat *dst, int lowerToUpper);
void Mat_ConvertScaleAbs(Mat *src, Mat *dst, double alpha, double beta);
void Mat_LUT(Mat *src, Mat *lut, Mat *dst);
int Mat_HasNonZero(Mat *src);

// Final P2 utility functions (Phase 13)
int Mat_CheckRange(Mat *a, int quiet, double minVal, double maxVal);
void Mat_PatchNaNs(Mat *a, double val);
void SetRNGSeed(int seed);

// Point vector functions
PointVector *PointVector_New();
void PointVector_Delete(PointVector *pv);
int PointVector_Size(PointVector *pv);
Point PointVector_At(PointVector *pv, int idx);
void PointVector_Append(PointVector *pv, Point p);

// Point2f vector functions
Point2fVector *Point2fVector_New();
void Point2fVector_Delete(Point2fVector *pv);
int Point2fVector_Size(Point2fVector *pv);
Point2f Point2fVector_At(Point2fVector *pv, int idx);
void Point2fVector_Append(Point2fVector *pv, Point2f p);

// Point3f vector functions
Point3fVector *Point3fVector_New();
void Point3fVector_Delete(Point3fVector *pv);
int Point3fVector_Size(Point3fVector *pv);
Point3f Point3fVector_At(Point3fVector *pv, int idx);
void Point3fVector_Append(Point3fVector *pv, Point3f p);

// PointsVector functions (std::vector<std::vector<cv::Point>>)
PointsVector *PointsVector_New();
void PointsVector_Delete(PointsVector *pv);
int PointsVector_Size(PointsVector *pv);
PointVector *PointsVector_At(PointsVector *pv, int idx);
void PointsVector_Append(PointsVector *pv, PointVector *points);

// OpenCV version
const char *OpenCV_Version();

// DFT / Frequency domain
void Mat_DFT(Mat *src, Mat *dst, int flags, int nonzeroRows);
void Mat_IDFT(Mat *src, Mat *dst, int flags, int nonzeroRows);
void Mat_DCT(Mat *src, Mat *dst, int flags);
void Mat_IDCT(Mat *src, Mat *dst, int flags);
int Mat_GetOptimalDFTSize(int vecsize);
void Mat_MulSpectrums(Mat *a, Mat *b, Mat *c, int flags, int conjB);

// Math / transform functions
void Mat_Transform(Mat *src, Mat *dst, Mat *m);
void Mat_PerspectiveTransform(Mat *src, Mat *dst, Mat *m);
void Mat_Phase(Mat *x, Mat *y, Mat *angle, int angleInDegrees);
void Mat_Magnitude(Mat *x, Mat *y, Mat *magnitude);
void Mat_PolarToCart(Mat *magnitude, Mat *angle, Mat *x, Mat *y,
                     int angleInDegrees);
void Mat_CartToPolar(Mat *x, Mat *y, Mat *magnitude, Mat *angle,
                     int angleInDegrees);

// Random number generation
void Mat_Randu(Mat *mat, Scalar low, Scalar high);
void Mat_Randn(Mat *mat, Scalar mean, Scalar stddev);
void Mat_RandShuffle(Mat *mat);

// Clustering
double Mat_KMeans(Mat *data, int K, Mat *bestLabels, int maxIter,
                  double epsilon, int attempts, int flags, Mat *centers);

// ============================================================================
// PCA (Principal Component Analysis)
// ============================================================================

typedef void *PCAPtr;
PCAPtr PCA_Create(Mat *data, Mat *mean, int flags, int maxComponents);
void PCA_Project(PCAPtr pca, Mat *vec, Mat *result);
void PCA_BackProject(PCAPtr pca, Mat *vec, Mat *result);
Mat *PCA_GetEigenvalues(PCAPtr pca);
Mat *PCA_GetEigenvectors(PCAPtr pca);
Mat *PCA_GetMean(PCAPtr pca);
void PCA_Close(PCAPtr pca);

// ============================================================================
// Additional Utility Functions
// ============================================================================

void Mat_CopyMakeBorder(Mat *src, Mat *dst, int top, int bottom, int left,
                        int right, int borderType, Scalar value);
int Mat_BorderInterpolate(int p, int len, int borderType);

// ============================================================================
// Linear Algebra Functions
// ============================================================================

void Mat_CalcCovarMatrix(Mat *samples, Mat *covar, Mat *mean, int flags,
                         int ctype);
double Mat_Mahalanobis(Mat *v1, Mat *v2, Mat *icovar);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_CORE_H
