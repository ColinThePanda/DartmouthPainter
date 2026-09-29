#ifndef OPENCV_WRAPPER_IMGPROC_H
#define OPENCV_WRAPPER_IMGPROC_H

#include "core.h"

#ifdef __cplusplus
extern "C" {
#endif

// Color conversion codes
enum ColorConversionCode {
  COLOR_BGR2GRAY = 6,
  COLOR_BGR2RGB = 4,
  COLOR_GRAY2BGR = 8,
  COLOR_RGB2GRAY = 7,
  COLOR_BGR2HSV = 40,
  COLOR_HSV2BGR = 54,
};

// Interpolation flags
enum InterpolationFlags {
  INTER_NEAREST = 0,
  INTER_LINEAR = 1,
  INTER_CUBIC = 2,
  INTER_AREA = 3,
  INTER_LANCZOS4 = 4,
};

// Morphological operation types
enum MorphTypes {
  MORPH_ERODE = 0,
  MORPH_DILATE = 1,
  MORPH_OPEN = 2,
  MORPH_CLOSE = 3,
  MORPH_GRADIENT = 4,
  MORPH_TOPHAT = 5,
  MORPH_BLACKHAT = 6,
};

// Morphological element shapes
enum MorphShapes {
  MORPH_RECT = 0,
  MORPH_CROSS = 1,
  MORPH_ELLIPSE = 2,
};

// Threshold types
enum ThresholdTypes {
  THRESH_BINARY = 0,
  THRESH_BINARY_INV = 1,
  THRESH_TRUNC = 2,
  THRESH_TOZERO = 3,
  THRESH_TOZERO_INV = 4,
  THRESH_OTSU = 8,
};

// Image processing functions
void CvtColor(Mat *src, Mat *dst, int code);
void Resize(Mat *src, Mat *dst, Size dsize, double fx, double fy,
            int interpolation);
void GaussianBlur(Mat *src, Mat *dst, Size ksize, double sigmaX, double sigmaY,
                  int borderType);
void MedianBlur(Mat *src, Mat *dst, int ksize);
void Blur(Mat *src, Mat *dst, Size ksize);
void BilateralFilter(Mat *src, Mat *dst, int d, double sigmaColor,
                     double sigmaSpace, int borderType);

// Edge detection
void Canny(Mat *src, Mat *dst, double threshold1, double threshold2,
           int apertureSize, int L2gradient);
void Sobel(Mat *src, Mat *dst, int ddepth, int dx, int dy, int ksize,
           double scale, double delta, int borderType);
void Laplacian(Mat *src, Mat *dst, int ddepth, int ksize, double scale,
               double delta, int borderType);

// Morphological operations
void Erode(Mat *src, Mat *dst, Mat *kernel, Point anchor, int iterations,
           int borderType);
void Dilate(Mat *src, Mat *dst, Mat *kernel, Point anchor, int iterations,
            int borderType);
void MorphologyEx(Mat *src, Mat *dst, int op, Mat *kernel, Point anchor,
                  int iterations, int borderType);
Mat *GetStructuringElement(int shape, Size ksize, Point anchor);

// Thresholding
double Threshold(Mat *src, Mat *dst, double thresh, double maxval, int type);
void AdaptiveThreshold(Mat *src, Mat *dst, double maxValue, int adaptiveMethod,
                       int thresholdType, int blockSize, double C);

// Drawing functions
void Line(Mat *img, Point pt1, Point pt2, Scalar color, int thickness,
          int lineType, int shift);
void Rectangle(Mat *img, Rect rect, Scalar color, int thickness, int lineType,
               int shift);
void Circle(Mat *img, Point center, int radius, Scalar color, int thickness,
            int lineType, int shift);
void Ellipse(Mat *img, Point center, Size axes, double angle, double startAngle,
             double endAngle, Scalar color, int thickness, int lineType,
             int shift);
void PutText(Mat *img, const char *text, Point org, int fontFace,
             double fontScale, Scalar color, int thickness, int lineType,
             int bottomLeftOrigin);

// Image pyramids
void PyrDown(Mat *src, Mat *dst, Size dstsize, int borderType);
void PyrUp(Mat *src, Mat *dst, Size dstsize, int borderType);

// Geometric transforms
void WarpAffine(Mat *src, Mat *dst, Mat *M, Size dsize, int flags,
                int borderMode, Scalar borderValue);
void WarpPerspective(Mat *src, Mat *dst, Mat *M, Size dsize, int flags,
                     int borderMode, Scalar borderValue);
Mat *GetAffineTransform(Point2fVector *src, Point2fVector *dst);
Mat *GetPerspectiveTransform(Point2fVector *src, Point2fVector *dst,
                             int solveMethod);

// Contour operations
void FindContours(Mat *image, PointsVector *contours, int mode, int method);
void DrawContours(Mat *image, PointsVector *contours, int contourIdx,
                  Scalar color, int thickness);
double ContourArea(PointVector *contour, int oriented);
double ArcLength(PointVector *curve, int closed);

// Shape analysis
typedef struct {
  float center_x;
  float center_y;
  float width;
  float height;
  float angle;
} RotatedRect;

Rect BoundingRect(PointVector *contour);
RotatedRect MinAreaRect(PointVector *points);
void MinEnclosingCircle(PointVector *points, float *x, float *y, float *radius);
PointVector *ApproxPolyDP(PointVector *curve, double epsilon, int closed);
PointVector *ConvexHull(PointVector *points, int clockwise);

// Histogram
void EqualizeHist(Mat *src, Mat *dst);

// Feature detection
void GoodFeaturesToTrack(Mat *image, Mat *corners, int maxCorners,
                         double qualityLevel, double minDistance);
void MatchTemplate(Mat *image, Mat *templ, Mat *result, int method);

// Hough transforms
void HoughLines(Mat *src, Mat *lines, double rho, double theta, int threshold);
void HoughCircles(Mat *src, Mat *circles, int method, double dp, double minDist,
                  double param1, double param2, int minRadius, int maxRadius);

// Connected components
int ConnectedComponents(Mat *image, Mat *labels, int connectivity);
int ConnectedComponentsWithStats(Mat *image, Mat *labels, Mat *stats,
                                 Mat *centroids, int connectivity);

// Moments
typedef struct {
  double m00, m10, m01, m20, m11, m02, m30, m21, m12, m03;
  double mu20, mu11, mu02, mu30, mu21, mu12, mu03;
  double nu20, nu11, nu02, nu30, nu21, nu12, nu03;
} Moments;

Moments ImageMoments(Mat *src, int binaryImage);

// Filtering
void Filter2D(Mat *src, Mat *dst, int ddepth, Mat *kernel, Point anchor,
              double delta, int borderType);
void Scharr(Mat *src, Mat *dst, int ddepth, int dx, int dy, double scale,
            double delta, int borderType);

// Histogram
void CalcHist(Mat *images, int nimages, int *channels, Mat *mask, Mat *hist,
              int dims, int *histSize, float **ranges, int uniform,
              int accumulate);

// Shape matching
double MatchShapes(PointVector *contour1, PointVector *contour2, int method,
                   double parameter);

// Fitting
void FitLine(PointVector *points, Mat *line, int distType, double param,
             double reps, double aeps);
RotatedRect FitEllipse(PointVector *points);

// Feature detection
void CornerHarris(Mat *src, Mat *dst, int blockSize, int ksize, double k,
                  int borderType);

// Segmentation
void PyrMeanShiftFiltering(Mat *src, Mat *dst, double sp, double sr);
void Watershed(Mat *image, Mat *markers);

// Transforms
void DistanceTransform(Mat *src, Mat *dst, int distanceType, int maskSize);
void Integral(Mat *src, Mat *sum, Mat *sqsum, int sdepth);

// Border
void CopyMakeBorder(Mat *src, Mat *dst, int top, int bottom, int left,
                    int right, int borderType, Scalar value);

// GrabCut foreground extraction
void GrabCut(Mat *img, Mat *mask, Rect rect, Mat *bgdModel, Mat *fgdModel,
             int iterCount, int mode);

// Flood Fill
int FloodFill(Mat *image, Mat *mask, Point seedPoint, Scalar newVal, Rect *rect,
              Scalar loDiff, Scalar upDiff, int flags);

// CLAHE
typedef struct CLAHE CLAHE;
CLAHE *CLAHE_Create(double clipLimit, Size tileGridSize);
void CLAHE_Delete(CLAHE *c);
void CLAHE_Apply(CLAHE *c, Mat *src, Mat *dst);
void CLAHE_SetClipLimit(CLAHE *c, double clipLimit);
void CLAHE_SetTilesGridSize(CLAHE *c, Size size);

// Text measurement
Size GetTextSize(const char *text, int fontFace, double fontScale,
                 int thickness, int *baseLine);

// Rotation matrix
Mat *GetRotationMatrix2D(Point2f center, double angle, double scale);

// Probabilistic Hough Lines
void HoughLinesP(Mat *src, Mat *lines, double rho, double theta, int threshold,
                 double minLineLength, double maxLineGap);

// Contour analysis
double PointPolygonTest(PointVector *contour, Point2f pt, int measureDist);
int IsContourConvex(PointVector *contour);

// Advanced Filtering
void BoxFilter(Mat *src, Mat *dst, int ddepth, Size ksize, Point anchor,
               int normalize, int borderType);
void SepFilter2D(Mat *src, Mat *dst, int ddepth, Mat *kernelX, Mat *kernelY,
                 Point anchor, double delta, int borderType);

// Geometric zocv_Remap
void zocv_Remap(Mat *src, Mat *dst, Mat *map1, Mat *map2, int interpolation,
           int borderMode, Scalar borderValue);

// Conversion
void ConvertScaleAbs(Mat *src, Mat *dst, double alpha, double beta);

// Normalization
void NormalizeImg(Mat *src, Mat *dst, double alpha, double beta, int norm_type);

// Histogram comparison
double CompareHist(Mat *H1, Mat *H2, int method);

// ============================================================================
// Phase 1 Batch 1: Accumulation, ColorMap, Drawing
// ============================================================================

void Accumulate(Mat *src, Mat *dst, Mat *mask);
void AccumulateProduct(Mat *src1, Mat *src2, Mat *dst, Mat *mask);
void AccumulateSquare(Mat *src, Mat *dst, Mat *mask);
void AccumulateWeighted(Mat *src, Mat *dst, double alpha, Mat *mask);
void ApplyColorMap(Mat *src, Mat *dst, int colormap);
void ArrowedLine(Mat *img, Point pt1, Point pt2, Scalar color, int thickness,
                 int lineType, int shift, double tipLength);
void BlendLinear(Mat *src1, Mat *src2, Mat *weights1, Mat *weights2, Mat *dst);
void DrawMarker(Mat *img, Point position, Scalar color, int markerType,
                int markerSize, int thickness, int lineType);

// Phase 1 Batch 2: Fill, kernel generation, transforms
void FillConvexPoly(Mat *img, PointVector *points, Scalar color, int lineType);
void FillPoly(Mat *img, PointsVector *pts, Scalar color, int lineType);
void BoxPoints(RotatedRect rect, Mat *points);
void CreateHanningWindow(Mat *dst, Size winSize, int type);
Mat *GetGaussianKernel(int ksize, double sigma, int ktype);
void GetRectSubPix(Mat *image, Size patchSize, Point2f center, Mat *patch);
void InvertAffineTransform(Mat *M, Mat *iM);
void SpatialGradient(Mat *src, Mat *dx, Mat *dy, int ksize, int borderType);
void SqrBoxFilter(Mat *src, Mat *dst, int ddepth, Size ksize, Point anchor,
                  int normalize, int borderType);
void StackBlur(Mat *src, Mat *dst, Size ksize);

// Phase 1 Batch 3: Polar transforms, clip, ellipse, HuMoments
void WarpPolar(Mat *src, Mat *dst, Size dsize, Point2f center, double maxRadius,
               int flags);
int ClipLine(Size imgSize, Point *pt1, Point *pt2);
void Ellipse2Poly(Point center, Size axes, int angle, int arcStart, int arcEnd,
                  int delta, PointVector *pts);
void HuMoments(double hu[7], Mat *src);
double GetFontScaleFromHeight(int fontFace, int pixelHeight, int thickness);
void CornerMinEigenVal(Mat *src, Mat *dst, int blockSize, int ksize,
                       int borderType);
void CornerEigenValsAndVecs(Mat *src, Mat *dst, int blockSize, int ksize,
                            int borderType);
void PreCornerDetect(Mat *src, Mat *dst, int ksize, int borderType);
void CvtColorTwoPlane(Mat *src1, Mat *src2, Mat *dst, int code);
void ConvertMaps(Mat *map1, Mat *map2, Mat *dstmap1, Mat *dstmap2,
                 int dstmap1type, int nninterpolation);
void DivSpectrums(Mat *a, Mat *b, Mat *c, int flags, int conjB);

// Phase 1 Batch 4: Hough, geometry
RotatedRect FitEllipseAMS(PointVector *points);
RotatedRect FitEllipseDirect(PointVector *points);
double IntersectConvexConvex(PointVector *p1, PointVector *p2, PointVector *p12,
                             int handleNested);
double MinEnclosingTriangle(PointVector *points, PointVector *triangle);
int RotatedRectangleIntersection(RotatedRect rect1, RotatedRect rect2,
                                 PointVector *intersectingRegion);

// Phase 2: Additional imgproc functions
Mat *GetGaborKernel(Size ksize, double sigma, double theta, double lambd,
                    double gamma, double psi, int ktype);
void GetDerivKernels(Mat *kx, Mat *ky, int dx, int dy, int ksize, int normalize,
                     int ktype);
void Demosaicing(Mat *src, Mat *dst, int code, int dstCn);
void PhaseCorrelate(Mat *src1, Mat *src2, Mat *window, double *shift_x,
                    double *shift_y, double *response);
void LinearPolar(Mat *src, Mat *dst, Point2f center, double maxRadius,
                 int flags);
void LogPolar(Mat *src, Mat *dst, Point2f center, double M, int flags);
void ConvexityDefects(PointVector *contour, PointVector *convexhull,
                      Mat *convexityDefects);
void ApproxPolyN(PointVector *curve, PointVector *approxCurve, int nsides,
                 double epsilon_percentage, int ensure_convex);

#ifdef __cplusplus
}
#endif

#endif // OPENCV_WRAPPER_IMGPROC_H
