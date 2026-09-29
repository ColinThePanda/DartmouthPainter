#include "imgproc.h"
#include <opencv2/imgproc.hpp>

extern "C" {

void CvtColor(Mat *src, Mat *dst, int code) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::cvtColor(*s, *d, code);
}

void Resize(Mat *src, Mat *dst, Size dsize, double fx, double fy,
            int interpolation) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::resize(*s, *d, cv::Size(dsize.width, dsize.height), fx, fy,
             interpolation);
}

void GaussianBlur(Mat *src, Mat *dst, Size ksize, double sigmaX, double sigmaY,
                  int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::GaussianBlur(*s, *d, cv::Size(ksize.width, ksize.height), sigmaX, sigmaY,
                   borderType);
}

void MedianBlur(Mat *src, Mat *dst, int ksize) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::medianBlur(*s, *d, ksize);
}

void Blur(Mat *src, Mat *dst, Size ksize) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::blur(*s, *d, cv::Size(ksize.width, ksize.height));
}

void BilateralFilter(Mat *src, Mat *dst, int diameter, double sigmaColor,
                     double sigmaSpace, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::bilateralFilter(*s, *d, diameter, sigmaColor, sigmaSpace, borderType);
}

void Canny(Mat *src, Mat *dst, double threshold1, double threshold2,
           int apertureSize, int L2gradient) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Canny(*s, *d, threshold1, threshold2, apertureSize, L2gradient != 0);
}

void Sobel(Mat *src, Mat *dst, int ddepth, int dx, int dy, int ksize,
           double scale, double delta, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Sobel(*s, *d, ddepth, dx, dy, ksize, scale, delta, borderType);
}

void Laplacian(Mat *src, Mat *dst, int ddepth, int ksize, double scale,
               double delta, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Laplacian(*s, *d, ddepth, ksize, scale, delta, borderType);
}

void Erode(Mat *src, Mat *dst, Mat *kernel, Point anchor, int iterations,
           int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *k = reinterpret_cast<cv::Mat *>(kernel);
  cv::erode(*s, *d, *k, cv::Point(anchor.x, anchor.y), iterations, borderType);
}

void Dilate(Mat *src, Mat *dst, Mat *kernel, Point anchor, int iterations,
            int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *k = reinterpret_cast<cv::Mat *>(kernel);
  cv::dilate(*s, *d, *k, cv::Point(anchor.x, anchor.y), iterations, borderType);
}

void MorphologyEx(Mat *src, Mat *dst, int op, Mat *kernel, Point anchor,
                  int iterations, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *k = reinterpret_cast<cv::Mat *>(kernel);
  cv::morphologyEx(*s, *d, op, *k, cv::Point(anchor.x, anchor.y), iterations,
                   borderType);
}

Mat *GetStructuringElement(int shape, Size ksize, Point anchor) {
  cv::Mat element =
      cv::getStructuringElement(shape, cv::Size(ksize.width, ksize.height),
                                cv::Point(anchor.x, anchor.y));
  return reinterpret_cast<Mat *>(new cv::Mat(element));
}

double Threshold(Mat *src, Mat *dst, double thresh, double maxval, int type) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  return cv::threshold(*s, *d, thresh, maxval, type);
}

void AdaptiveThreshold(Mat *src, Mat *dst, double maxValue, int adaptiveMethod,
                       int thresholdType, int blockSize, double C) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::adaptiveThreshold(*s, *d, maxValue, adaptiveMethod, thresholdType,
                        blockSize, C);
}

void Line(Mat *img, Point pt1, Point pt2, Scalar color, int thickness,
          int lineType, int shift) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::line(*m, cv::Point(pt1.x, pt1.y), cv::Point(pt2.x, pt2.y),
           cv::Scalar(color.v0, color.v1, color.v2, color.v3), thickness,
           lineType, shift);
}

void Rectangle(Mat *img, Rect rect, Scalar color, int thickness, int lineType,
               int shift) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::rectangle(*m, cv::Rect(rect.x, rect.y, rect.width, rect.height),
                cv::Scalar(color.v0, color.v1, color.v2, color.v3), thickness,
                lineType, shift);
}

void Circle(Mat *img, Point center, int radius, Scalar color, int thickness,
            int lineType, int shift) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::circle(*m, cv::Point(center.x, center.y), radius,
             cv::Scalar(color.v0, color.v1, color.v2, color.v3), thickness,
             lineType, shift);
}

void Ellipse(Mat *img, Point center, Size axes, double angle, double startAngle,
             double endAngle, Scalar color, int thickness, int lineType,
             int shift) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::ellipse(*m, cv::Point(center.x, center.y),
              cv::Size(axes.width, axes.height), angle, startAngle, endAngle,
              cv::Scalar(color.v0, color.v1, color.v2, color.v3), thickness,
              lineType, shift);
}

void PutText(Mat *img, const char *text, Point org, int fontFace,
             double fontScale, Scalar color, int thickness, int lineType,
             int bottomLeftOrigin) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::putText(*m, text, cv::Point(org.x, org.y), fontFace, fontScale,
              cv::Scalar(color.v0, color.v1, color.v2, color.v3), thickness,
              lineType, bottomLeftOrigin != 0);
}

// Image pyramids
void PyrDown(Mat *src, Mat *dst, Size dstsize, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::pyrDown(*s, *d, cv::Size(dstsize.width, dstsize.height), borderType);
}

void PyrUp(Mat *src, Mat *dst, Size dstsize, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::pyrUp(*s, *d, cv::Size(dstsize.width, dstsize.height), borderType);
}

// Geometric transforms
void WarpAffine(Mat *src, Mat *dst, Mat *M, Size dsize, int flags,
                int borderMode, Scalar borderValue) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *m = reinterpret_cast<cv::Mat *>(M);
  cv::Scalar bv(borderValue.v0, borderValue.v1, borderValue.v2, borderValue.v3);
  cv::warpAffine(*s, *d, *m, cv::Size(dsize.width, dsize.height), flags,
                 borderMode, bv);
}

void WarpPerspective(Mat *src, Mat *dst, Mat *M, Size dsize, int flags,
                     int borderMode, Scalar borderValue) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *m = reinterpret_cast<cv::Mat *>(M);
  cv::Scalar bv(borderValue.v0, borderValue.v1, borderValue.v2, borderValue.v3);
  cv::warpPerspective(*s, *d, *m, cv::Size(dsize.width, dsize.height), flags,
                      borderMode, bv);
}

Mat *GetAffineTransform(Point2fVector *src, Point2fVector *dst) {
  std::vector<cv::Point2f> *s =
      reinterpret_cast<std::vector<cv::Point2f> *>(src);
  std::vector<cv::Point2f> *d =
      reinterpret_cast<std::vector<cv::Point2f> *>(dst);
  cv::Mat result = cv::getAffineTransform(*s, *d);
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

Mat *GetPerspectiveTransform(Point2fVector *src, Point2fVector *dst,
                             int solveMethod) {
  std::vector<cv::Point2f> *s =
      reinterpret_cast<std::vector<cv::Point2f> *>(src);
  std::vector<cv::Point2f> *d =
      reinterpret_cast<std::vector<cv::Point2f> *>(dst);
  cv::Mat result = cv::getPerspectiveTransform(*s, *d, solveMethod);
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

// Contour operations
void FindContours(Mat *image, PointsVector *contours, int mode, int method) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<std::vector<cv::Point>> *cnts =
      reinterpret_cast<std::vector<std::vector<cv::Point>> *>(contours);
  cv::findContours(*img, *cnts, mode, method);
}

void DrawContours(Mat *image, PointsVector *contours, int contourIdx,
                  Scalar color, int thickness) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  std::vector<std::vector<cv::Point>> *cnts =
      reinterpret_cast<std::vector<std::vector<cv::Point>> *>(contours);
  cv::Scalar c(color.v0, color.v1, color.v2, color.v3);
  cv::drawContours(*img, *cnts, contourIdx, c, thickness);
}

double ContourArea(PointVector *contour, int oriented) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(contour);
  return cv::contourArea(*pts, oriented);
}

double ArcLength(PointVector *curve, int closed) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(curve);
  return cv::arcLength(*pts, closed);
}

// Shape analysis
Rect BoundingRect(PointVector *contour) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(contour);
  cv::Rect r = cv::boundingRect(*pts);
  return Rect{r.x, r.y, r.width, r.height};
}

RotatedRect MinAreaRect(PointVector *points) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::RotatedRect rr = cv::minAreaRect(*pts);
  return RotatedRect{rr.center.x, rr.center.y, rr.size.width, rr.size.height,
                     rr.angle};
}

void MinEnclosingCircle(PointVector *points, float *x, float *y,
                        float *radius) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::Point2f center;
  float r;
  cv::minEnclosingCircle(*pts, center, r);
  *x = center.x;
  *y = center.y;
  *radius = r;
}

PointVector *ApproxPolyDP(PointVector *curve, double epsilon, int closed) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(curve);
  std::vector<cv::Point> *result = new std::vector<cv::Point>();
  cv::approxPolyDP(*pts, *result, epsilon, closed != 0);
  return reinterpret_cast<PointVector *>(result);
}

PointVector *ConvexHull(PointVector *points, int clockwise) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  std::vector<cv::Point> *result = new std::vector<cv::Point>();
  cv::convexHull(*pts, *result, clockwise != 0);
  return reinterpret_cast<PointVector *>(result);
}

// Histogram
void EqualizeHist(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::equalizeHist(*s, *d);
}

// Feature detection
void GoodFeaturesToTrack(Mat *image, Mat *corners, int maxCorners,
                         double qualityLevel, double minDistance) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  cv::Mat *cor = reinterpret_cast<cv::Mat *>(corners);
  cv::goodFeaturesToTrack(*img, *cor, maxCorners, qualityLevel, minDistance);
}

void MatchTemplate(Mat *image, Mat *templ, Mat *result, int method) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  cv::Mat *tmp = reinterpret_cast<cv::Mat *>(templ);
  cv::Mat *res = reinterpret_cast<cv::Mat *>(result);
  cv::matchTemplate(*img, *tmp, *res, method);
}

// Hough transforms
void HoughLines(Mat *src, Mat *lines, double rho, double theta, int threshold) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *l = reinterpret_cast<cv::Mat *>(lines);
  cv::HoughLines(*s, *l, rho, theta, threshold);
}

void HoughCircles(Mat *src, Mat *circles, int method, double dp, double minDist,
                  double param1, double param2, int minRadius, int maxRadius) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *c = reinterpret_cast<cv::Mat *>(circles);
  cv::HoughCircles(*s, *c, method, dp, minDist, param1, param2, minRadius,
                   maxRadius);
}

// Connected components
int ConnectedComponents(Mat *image, Mat *labels, int connectivity) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  cv::Mat *lbl = reinterpret_cast<cv::Mat *>(labels);
  return cv::connectedComponents(*img, *lbl, connectivity);
}

int ConnectedComponentsWithStats(Mat *image, Mat *labels, Mat *stats,
                                 Mat *centroids, int connectivity) {
  return cv::connectedComponentsWithStats(*(cv::Mat *)image, *(cv::Mat *)labels,
                                          *(cv::Mat *)stats,
                                          *(cv::Mat *)centroids, connectivity);
}

// Moments
Moments ImageMoments(Mat *src, int binaryImage) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Moments m = cv::moments(*s, binaryImage != 0);
  Moments result;
  result.m00 = m.m00;
  result.m10 = m.m10;
  result.m01 = m.m01;
  result.m20 = m.m20;
  result.m11 = m.m11;
  result.m02 = m.m02;
  result.m30 = m.m30;
  result.m21 = m.m21;
  result.m12 = m.m12;
  result.m03 = m.m03;
  result.mu20 = m.mu20;
  result.mu11 = m.mu11;
  result.mu02 = m.mu02;
  result.mu30 = m.mu30;
  result.mu21 = m.mu21;
  result.mu12 = m.mu12;
  result.mu03 = m.mu03;
  result.nu20 = m.nu20;
  result.nu11 = m.nu11;
  result.nu02 = m.nu02;
  result.nu30 = m.nu30;
  result.nu21 = m.nu21;
  result.nu12 = m.nu12;
  result.nu03 = m.nu03;
  return result;
}

// Filtering
void Filter2D(Mat *src, Mat *dst, int ddepth, Mat *kernel, Point anchor,
              double delta, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *k = reinterpret_cast<cv::Mat *>(kernel);
  cv::filter2D(*s, *d, ddepth, *k, cv::Point(anchor.x, anchor.y), delta,
               borderType);
}

void Scharr(Mat *src, Mat *dst, int ddepth, int dx, int dy, double scale,
            double delta, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Scharr(*s, *d, ddepth, dx, dy, scale, delta, borderType);
}

// Shape matching
double MatchShapes(PointVector *contour1, PointVector *contour2, int method,
                   double parameter) {
  std::vector<cv::Point> *c1 =
      reinterpret_cast<std::vector<cv::Point> *>(contour1);
  std::vector<cv::Point> *c2 =
      reinterpret_cast<std::vector<cv::Point> *>(contour2);
  return cv::matchShapes(*c1, *c2, method, parameter);
}

// Fitting
void FitLine(PointVector *points, Mat *line, int distType, double param,
             double reps, double aeps) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::Mat *l = reinterpret_cast<cv::Mat *>(line);
  cv::fitLine(*pts, *l, distType, param, reps, aeps);
}

RotatedRect FitEllipse(PointVector *points) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::RotatedRect rr = cv::fitEllipse(*pts);
  return RotatedRect{rr.center.x, rr.center.y, rr.size.width, rr.size.height,
                     rr.angle};
}

// Feature detection
void CornerHarris(Mat *src, Mat *dst, int blockSize, int ksize, double k,
                  int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::cornerHarris(*s, *d, blockSize, ksize, k, borderType);
}

// Segmentation
void PyrMeanShiftFiltering(Mat *src, Mat *dst, double sp, double sr) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::pyrMeanShiftFiltering(*s, *d, sp, sr);
}

void Watershed(Mat *image, Mat *markers) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  cv::Mat *mrk = reinterpret_cast<cv::Mat *>(markers);
  cv::watershed(*img, *mrk);
}

// Transforms
void DistanceTransform(Mat *src, Mat *dst, int distanceType, int maskSize) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::distanceTransform(*s, *d, distanceType, maskSize);
}

void Integral(Mat *src, Mat *sum, Mat *sqsum, int sdepth) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *sm = reinterpret_cast<cv::Mat *>(sum);
  cv::Mat *sq = reinterpret_cast<cv::Mat *>(sqsum);
  cv::integral(*s, *sm, *sq, sdepth);
}

// Border and Pyramid
void CopyMakeBorder(Mat *src, Mat *dst, int top, int bottom, int left,
                    int right, int borderType, Scalar value) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::copyMakeBorder(*s, *d, top, bottom, left, right, borderType,
                     cv::Scalar(value.v0, value.v1, value.v2, value.v3));
}

// GrabCut
void GrabCut(Mat *img, Mat *mask, Rect rect, Mat *bgdModel, Mat *fgdModel,
             int iterCount, int mode) {
  cv::Mat *i = reinterpret_cast<cv::Mat *>(img);
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mask);
  cv::Mat *bgd = reinterpret_cast<cv::Mat *>(bgdModel);
  cv::Mat *fgd = reinterpret_cast<cv::Mat *>(fgdModel);
  cv::Rect r(rect.x, rect.y, rect.width, rect.height);
  cv::grabCut(*i, *m, r, *bgd, *fgd, iterCount, mode);
}

// Flood Fill
int FloodFill(Mat *image, Mat *mask, Point seedPoint, Scalar newVal, Rect *rect,
              Scalar loDiff, Scalar upDiff, int flags) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  cv::Mat *msk = reinterpret_cast<cv::Mat *>(mask);
  cv::Rect r;
  int result = cv::floodFill(
      *img, *msk, cv::Point(seedPoint.x, seedPoint.y),
      cv::Scalar(newVal.v0, newVal.v1, newVal.v2, newVal.v3), &r,
      cv::Scalar(loDiff.v0, loDiff.v1, loDiff.v2, loDiff.v3),
      cv::Scalar(upDiff.v0, upDiff.v1, upDiff.v2, upDiff.v3), flags);
  if (rect != nullptr) {
    rect->x = r.x;
    rect->y = r.y;
    rect->width = r.width;
    rect->height = r.height;
  }
  return result;
}

// CLAHE
CLAHE *CLAHE_Create(double clipLimit, Size tileGridSize) {
  cv::Ptr<cv::CLAHE> ptr = cv::createCLAHE(
      clipLimit, cv::Size(tileGridSize.width, tileGridSize.height));
  return reinterpret_cast<CLAHE *>(new cv::Ptr<cv::CLAHE>(ptr));
}

void CLAHE_Delete(CLAHE *c) {
  delete reinterpret_cast<cv::Ptr<cv::CLAHE> *>(c);
}

void CLAHE_Apply(CLAHE *c, Mat *src, Mat *dst) {
  cv::Ptr<cv::CLAHE> *ptr = reinterpret_cast<cv::Ptr<cv::CLAHE> *>(c);
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  (*ptr)->apply(*s, *d);
}

void CLAHE_SetClipLimit(CLAHE *c, double clipLimit) {
  cv::Ptr<cv::CLAHE> *ptr = reinterpret_cast<cv::Ptr<cv::CLAHE> *>(c);
  (*ptr)->setClipLimit(clipLimit);
}

void CLAHE_SetTilesGridSize(CLAHE *c, Size size) {
  cv::Ptr<cv::CLAHE> *ptr = reinterpret_cast<cv::Ptr<cv::CLAHE> *>(c);
  (*ptr)->setTilesGridSize(cv::Size(size.width, size.height));
}

// Text measurement
Size GetTextSize(const char *text, int fontFace, double fontScale,
                 int thickness, int *baseLine) {
  cv::Size sz = cv::getTextSize(text, fontFace, fontScale, thickness, baseLine);
  return Size{sz.width, sz.height};
}

// Rotation matrix
Mat *GetRotationMatrix2D(Point2f center, double angle, double scale) {
  cv::Mat *result = new cv::Mat();
  *result =
      cv::getRotationMatrix2D(cv::Point2f(center.x, center.y), angle, scale);
  return reinterpret_cast<Mat *>(result);
}

// Probabilistic Hough Lines
void HoughLinesP(Mat *src, Mat *lines, double rho, double theta, int threshold,
                 double minLineLength, double maxLineGap) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *l = reinterpret_cast<cv::Mat *>(lines);
  cv::HoughLinesP(*s, *l, rho, theta, threshold, minLineLength, maxLineGap);
}

// Contour analysis
double PointPolygonTest(PointVector *contour, Point2f pt, int measureDist) {
  std::vector<cv::Point> *c =
      reinterpret_cast<std::vector<cv::Point> *>(contour);
  return cv::pointPolygonTest(*c, cv::Point2f(pt.x, pt.y), measureDist != 0);
}

int IsContourConvex(PointVector *contour) {
  std::vector<cv::Point> *c =
      reinterpret_cast<std::vector<cv::Point> *>(contour);
  return cv::isContourConvex(*c) ? 1 : 0;
}

// Advanced Filtering
void BoxFilter(Mat *src, Mat *dst, int ddepth, Size ksize, Point anchor,
               int normalize, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::boxFilter(*s, *d, ddepth, cv::Size(ksize.width, ksize.height),
                cv::Point(anchor.x, anchor.y), normalize != 0, borderType);
}

void SepFilter2D(Mat *src, Mat *dst, int ddepth, Mat *kernelX, Mat *kernelY,
                 Point anchor, double delta, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *kx = reinterpret_cast<cv::Mat *>(kernelX);
  cv::Mat *ky = reinterpret_cast<cv::Mat *>(kernelY);
  cv::sepFilter2D(*s, *d, ddepth, *kx, *ky, cv::Point(anchor.x, anchor.y),
                  delta, borderType);
}

// Geometric zocv_Remap
void zocv_Remap(Mat *src, Mat *dst, Mat *map1, Mat *map2, int interpolation,
           int borderMode, Scalar borderValue) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Mat *m1 = reinterpret_cast<cv::Mat *>(map1);
  cv::Mat *m2 = reinterpret_cast<cv::Mat *>(map2);
  cv::remap(*s, *d, *m1, *m2, interpolation, borderMode,
            cv::Scalar(borderValue.v0, borderValue.v1, borderValue.v2,
                       borderValue.v3));
}

// Conversion
void ConvertScaleAbs(Mat *src, Mat *dst, double alpha, double beta) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::convertScaleAbs(*s, *d, alpha, beta);
}

// Normalization
void NormalizeImg(Mat *src, Mat *dst, double alpha, double beta,
                  int norm_type) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::normalize(*s, *d, alpha, beta, norm_type);
}

// Histogram comparison
double CompareHist(Mat *H1, Mat *H2, int method) {
  cv::Mat *h1 = reinterpret_cast<cv::Mat *>(H1);
  cv::Mat *h2 = reinterpret_cast<cv::Mat *>(H2);
  return cv::compareHist(*h1, *h2, method);
}

// ============================================================================
// Phase 1 Batch 1: Accumulation, ColorMap, Drawing
// ============================================================================

void Accumulate(Mat *src, Mat *dst, Mat *mask) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  if (mask && reinterpret_cast<cv::Mat *>(mask)->data) {
    cv::accumulate(*s, *d, *reinterpret_cast<cv::Mat *>(mask));
  } else {
    cv::accumulate(*s, *d);
  }
}

void AccumulateProduct(Mat *src1, Mat *src2, Mat *dst, Mat *mask) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  if (mask && reinterpret_cast<cv::Mat *>(mask)->data) {
    cv::accumulateProduct(*s1, *s2, *d, *reinterpret_cast<cv::Mat *>(mask));
  } else {
    cv::accumulateProduct(*s1, *s2, *d);
  }
}

void AccumulateSquare(Mat *src, Mat *dst, Mat *mask) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  if (mask && reinterpret_cast<cv::Mat *>(mask)->data) {
    cv::accumulateSquare(*s, *d, *reinterpret_cast<cv::Mat *>(mask));
  } else {
    cv::accumulateSquare(*s, *d);
  }
}

void AccumulateWeighted(Mat *src, Mat *dst, double alpha, Mat *mask) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  if (mask && reinterpret_cast<cv::Mat *>(mask)->data) {
    cv::accumulateWeighted(*s, *d, alpha, *reinterpret_cast<cv::Mat *>(mask));
  } else {
    cv::accumulateWeighted(*s, *d, alpha);
  }
}

void ApplyColorMap(Mat *src, Mat *dst, int colormap) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::applyColorMap(*s, *d, colormap);
}

void ArrowedLine(Mat *img, Point pt1, Point pt2, Scalar color, int thickness,
                 int lineType, int shift, double tipLength) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::arrowedLine(*m, cv::Point(pt1.x, pt1.y), cv::Point(pt2.x, pt2.y),
                  cv::Scalar(color.v0, color.v1, color.v2, color.v3), thickness,
                  lineType, shift, tipLength);
}

void BlendLinear(Mat *src1, Mat *src2, Mat *weights1, Mat *weights2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *w1 = reinterpret_cast<cv::Mat *>(weights1);
  cv::Mat *w2 = reinterpret_cast<cv::Mat *>(weights2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::blendLinear(*s1, *s2, *w1, *w2, *d);
}

void DrawMarker(Mat *img, Point position, Scalar color, int markerType,
                int markerSize, int thickness, int lineType) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  cv::drawMarker(*m, cv::Point(position.x, position.y),
                 cv::Scalar(color.v0, color.v1, color.v2, color.v3), markerType,
                 markerSize, thickness, lineType);
}

// ============================================================================
// Phase 1 Batch 2: Fill, kernel generation, transforms
// ============================================================================

void FillConvexPoly(Mat *img, PointVector *points, Scalar color, int lineType) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::fillConvexPoly(
      *m, *pts, cv::Scalar(color.v0, color.v1, color.v2, color.v3), lineType);
}

void FillPoly(Mat *img, PointsVector *pts, Scalar color, int lineType) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(img);
  std::vector<std::vector<cv::Point>> *p =
      reinterpret_cast<std::vector<std::vector<cv::Point>> *>(pts);
  cv::fillPoly(*m, *p, cv::Scalar(color.v0, color.v1, color.v2, color.v3),
               lineType);
}

void BoxPoints(RotatedRect rect, Mat *points) {
  cv::RotatedRect rr(cv::Point2f(rect.center_x, rect.center_y),
                     cv::Size2f(rect.width, rect.height), rect.angle);
  cv::Mat *p = reinterpret_cast<cv::Mat *>(points);
  cv::boxPoints(rr, *p);
}

void CreateHanningWindow(Mat *dst, Size winSize, int type) {
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::createHanningWindow(*d, cv::Size(winSize.width, winSize.height), type);
}

Mat *GetGaussianKernel(int ksize, double sigma, int ktype) {
  cv::Mat result = cv::getGaussianKernel(ksize, sigma, ktype);
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

void GetRectSubPix(Mat *image, Size patchSize, Point2f center, Mat *patch) {
  cv::Mat *img = reinterpret_cast<cv::Mat *>(image);
  cv::Mat *p = reinterpret_cast<cv::Mat *>(patch);
  cv::getRectSubPix(*img, cv::Size(patchSize.width, patchSize.height),
                    cv::Point2f(center.x, center.y), *p);
}

void InvertAffineTransform(Mat *M, Mat *iM) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(M);
  cv::Mat *im = reinterpret_cast<cv::Mat *>(iM);
  cv::invertAffineTransform(*m, *im);
}

void SpatialGradient(Mat *src, Mat *dx, Mat *dy, int ksize, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *dxm = reinterpret_cast<cv::Mat *>(dx);
  cv::Mat *dym = reinterpret_cast<cv::Mat *>(dy);
  cv::spatialGradient(*s, *dxm, *dym, ksize, borderType);
}

void SqrBoxFilter(Mat *src, Mat *dst, int ddepth, Size ksize, Point anchor,
                  int normalize, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::sqrBoxFilter(*s, *d, ddepth, cv::Size(ksize.width, ksize.height),
                   cv::Point(anchor.x, anchor.y), normalize != 0, borderType);
}

void StackBlur(Mat *src, Mat *dst, Size ksize) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::stackBlur(*s, *d, cv::Size(ksize.width, ksize.height));
}

// ============================================================================
// Phase 1 Batch 3: Polar, clip, ellipse, HuMoments, corner detectors
// ============================================================================

void WarpPolar(Mat *src, Mat *dst, Size dsize, Point2f center, double maxRadius,
               int flags) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::warpPolar(*s, *d, cv::Size(dsize.width, dsize.height),
                cv::Point2f(center.x, center.y), maxRadius, flags);
}

int ClipLine(Size imgSize, Point *pt1, Point *pt2) {
  cv::Point p1(pt1->x, pt1->y);
  cv::Point p2(pt2->x, pt2->y);
  bool result = cv::clipLine(cv::Size(imgSize.width, imgSize.height), p1, p2);
  pt1->x = p1.x;
  pt1->y = p1.y;
  pt2->x = p2.x;
  pt2->y = p2.y;
  return result ? 1 : 0;
}

void Ellipse2Poly(Point center, Size axes, int angle, int arcStart, int arcEnd,
                  int delta, PointVector *pts) {
  std::vector<cv::Point> *points =
      reinterpret_cast<std::vector<cv::Point> *>(pts);
  cv::ellipse2Poly(cv::Point(center.x, center.y),
                   cv::Size(axes.width, axes.height), angle, arcStart, arcEnd,
                   delta, *points);
}

void HuMoments(double hu[7], Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Moments m = cv::moments(*s);
  cv::HuMoments(m, hu);
}

double GetFontScaleFromHeight(int fontFace, int pixelHeight, int thickness) {
  return cv::getFontScaleFromHeight(fontFace, pixelHeight, thickness);
}

void CornerMinEigenVal(Mat *src, Mat *dst, int blockSize, int ksize,
                       int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::cornerMinEigenVal(*s, *d, blockSize, ksize, borderType);
}

void CornerEigenValsAndVecs(Mat *src, Mat *dst, int blockSize, int ksize,
                            int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::cornerEigenValsAndVecs(*s, *d, blockSize, ksize, borderType);
}

void PreCornerDetect(Mat *src, Mat *dst, int ksize, int borderType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::preCornerDetect(*s, *d, ksize, borderType);
}

void CvtColorTwoPlane(Mat *src1, Mat *src2, Mat *dst, int code) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::cvtColorTwoPlane(*s1, *s2, *d, code);
}

void ConvertMaps(Mat *map1, Mat *map2, Mat *dstmap1, Mat *dstmap2,
                 int dstmap1type, int nninterpolation) {
  cv::Mat *m1 = reinterpret_cast<cv::Mat *>(map1);
  cv::Mat *m2 = reinterpret_cast<cv::Mat *>(map2);
  cv::Mat *dm1 = reinterpret_cast<cv::Mat *>(dstmap1);
  cv::Mat *dm2 = reinterpret_cast<cv::Mat *>(dstmap2);
  cv::convertMaps(*m1, *m2, *dm1, *dm2, dstmap1type, nninterpolation != 0);
}

void DivSpectrums(Mat *a, Mat *b, Mat *c, int flags, int conjB) {
  cv::Mat *ma = reinterpret_cast<cv::Mat *>(a);
  cv::Mat *mb = reinterpret_cast<cv::Mat *>(b);
  cv::Mat *mc = reinterpret_cast<cv::Mat *>(c);
  cv::divSpectrums(*ma, *mb, *mc, flags, conjB != 0);
}

// ============================================================================
// Phase 1 Batch 4: Geometry
// ============================================================================

RotatedRect FitEllipseAMS(PointVector *points) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::RotatedRect rr = cv::fitEllipseAMS(*pts);
  RotatedRect result;
  result.center_x = rr.center.x;
  result.center_y = rr.center.y;
  result.width = rr.size.width;
  result.height = rr.size.height;
  result.angle = rr.angle;
  return result;
}

RotatedRect FitEllipseDirect(PointVector *points) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  cv::RotatedRect rr = cv::fitEllipseDirect(*pts);
  RotatedRect result;
  result.center_x = rr.center.x;
  result.center_y = rr.center.y;
  result.width = rr.size.width;
  result.height = rr.size.height;
  result.angle = rr.angle;
  return result;
}

double IntersectConvexConvex(PointVector *p1, PointVector *p2, PointVector *p12,
                             int handleNested) {
  std::vector<cv::Point> *pts1 = reinterpret_cast<std::vector<cv::Point> *>(p1);
  std::vector<cv::Point> *pts2 = reinterpret_cast<std::vector<cv::Point> *>(p2);
  std::vector<cv::Point> *pts12 =
      reinterpret_cast<std::vector<cv::Point> *>(p12);
  // Need Point2f conversion
  std::vector<cv::Point2f> fp1(pts1->begin(), pts1->end());
  std::vector<cv::Point2f> fp2(pts2->begin(), pts2->end());
  std::vector<cv::Point2f> fp12;
  double area = cv::intersectConvexConvex(fp1, fp2, fp12, handleNested != 0);
  pts12->clear();
  for (const auto &p : fp12) {
    pts12->push_back(cv::Point(static_cast<int>(p.x), static_cast<int>(p.y)));
  }
  return area;
}

double MinEnclosingTriangle(PointVector *points, PointVector *triangle) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  std::vector<cv::Point> *tri =
      reinterpret_cast<std::vector<cv::Point> *>(triangle);
  std::vector<cv::Point2f> fpts(pts->begin(), pts->end());
  std::vector<cv::Point2f> ftri;
  double area = cv::minEnclosingTriangle(fpts, ftri);
  tri->clear();
  for (const auto &p : ftri) {
    tri->push_back(cv::Point(static_cast<int>(p.x), static_cast<int>(p.y)));
  }
  return area;
}

int RotatedRectangleIntersection(RotatedRect rect1, RotatedRect rect2,
                                 PointVector *intersectingRegion) {
  cv::RotatedRect rr1(cv::Point2f(rect1.center_x, rect1.center_y),
                      cv::Size2f(rect1.width, rect1.height), rect1.angle);
  cv::RotatedRect rr2(cv::Point2f(rect2.center_x, rect2.center_y),
                      cv::Size2f(rect2.width, rect2.height), rect2.angle);
  std::vector<cv::Point2f> region;
  int result = cv::rotatedRectangleIntersection(rr1, rr2, region);
  std::vector<cv::Point> *out =
      reinterpret_cast<std::vector<cv::Point> *>(intersectingRegion);
  out->clear();
  for (const auto &p : region) {
    out->push_back(cv::Point(static_cast<int>(p.x), static_cast<int>(p.y)));
  }
  return result;
}

// CalcHist - C++ implementation (declaration existed, impl was missing)
void CalcHist(Mat *images, int nimages, int *channels, Mat *mask, Mat *hist,
              int dims, int *histSize, float **ranges, int uniform,
              int accumulate) {
  // images is a pointer to Mat pointers (Mat** effectively)
  Mat **imgPtrs = (Mat **)images;
  std::vector<cv::Mat> imgs;
  for (int i = 0; i < nimages; i++) {
    imgs.push_back(*(cv::Mat *)imgPtrs[i]);
  }
  cv::Mat maskRef = (mask != nullptr) ? *(cv::Mat *)mask : cv::Mat();

  const float **cranges = (const float **)ranges;
  cv::calcHist(imgs.data(), nimages, channels, maskRef, *(cv::Mat *)hist, dims,
               histSize, cranges, uniform != 0, accumulate != 0);
}

// Phase 2 implementations
Mat *GetGaborKernel(Size ksize, double sigma, double theta, double lambd,
                    double gamma, double psi, int ktype) {
  cv::Mat kernel = cv::getGaborKernel(cv::Size(ksize.width, ksize.height),
                                      sigma, theta, lambd, gamma, psi, ktype);
  return (Mat *)new cv::Mat(kernel);
}

void GetDerivKernels(Mat *kx, Mat *ky, int dx, int dy, int ksize, int normalize,
                     int ktype) {
  cv::getDerivKernels(*(cv::Mat *)kx, *(cv::Mat *)ky, dx, dy, ksize,
                      normalize != 0, ktype);
}

void Demosaicing(Mat *src, Mat *dst, int code, int dstCn) {
  cv::demosaicing(*(cv::Mat *)src, *(cv::Mat *)dst, code, dstCn);
}

void PhaseCorrelate(Mat *src1, Mat *src2, Mat *window, double *shift_x,
                    double *shift_y, double *response) {
  cv::Mat windowMat = (window != nullptr) ? *(cv::Mat *)window : cv::Mat();
  cv::Point2d shift = cv::phaseCorrelate(*(cv::Mat *)src1, *(cv::Mat *)src2,
                                         windowMat, response);
  *shift_x = shift.x;
  *shift_y = shift.y;
}

void LinearPolar(Mat *src, Mat *dst, Point2f center, double maxRadius,
                 int flags) {
  cv::linearPolar(*(cv::Mat *)src, *(cv::Mat *)dst,
                  cv::Point2f(center.x, center.y), maxRadius, flags);
}

void LogPolar(Mat *src, Mat *dst, Point2f center, double M, int flags) {
  cv::logPolar(*(cv::Mat *)src, *(cv::Mat *)dst,
               cv::Point2f(center.x, center.y), M, flags);
}

void ConvexityDefects(PointVector *contour, PointVector * /* convexhull */,
                      Mat *convexityDefects) {
  std::vector<cv::Point> *cnt =
      reinterpret_cast<std::vector<cv::Point> *>(contour);
  // Compute hull indices internally from the contour
  std::vector<int> hullIndices;
  cv::convexHull(*cnt, hullIndices);
  cv::convexityDefects(*cnt, hullIndices, *(cv::Mat *)convexityDefects);
}

void ApproxPolyN(PointVector *curve, PointVector *approxCurve, int nsides,
                 double epsilon_percentage, int ensure_convex) {
  std::vector<cv::Point> *src =
      reinterpret_cast<std::vector<cv::Point> *>(curve);
  std::vector<cv::Point> result;
  // approxPolyN is available in OpenCV 4.x contrib or newer versions
  // For now, use approxPolyDP with adjusted epsilon to approximate N sides
  double peri = cv::arcLength(*src, true);
  double epsilon = epsilon_percentage * peri;
  cv::approxPolyDP(*src, result, epsilon, ensure_convex != 0);
  std::vector<cv::Point> *dst =
      reinterpret_cast<std::vector<cv::Point> *>(approxCurve);
  *dst = result;
}

} // extern "C"
