#include "core.h"
#include <cstring>
#include <opencv2/core.hpp>

// Mat implementation
extern "C" {

// ============================================================================
// Mats — vector of Mat
// ============================================================================

Mats *Mats_New() {
  return reinterpret_cast<Mats *>(new std::vector<cv::Mat>());
}

void Mats_Delete(Mats *mats) {
  delete reinterpret_cast<std::vector<cv::Mat> *>(mats);
}

void Mats_Append(Mats *mats, Mat *mat) {
  auto *vec = reinterpret_cast<std::vector<cv::Mat> *>(mats);
  vec->push_back(*reinterpret_cast<cv::Mat *>(mat));
}

size_t Mats_Size(Mats *mats) {
  return reinterpret_cast<std::vector<cv::Mat> *>(mats)->size();
}

// ============================================================================
// Mat
// ============================================================================

Mat *Mat_New() { return reinterpret_cast<Mat *>(new cv::Mat()); }

Mat *Mat_NewWithSize(int rows, int cols, int type) {
  return reinterpret_cast<Mat *>(new cv::Mat(rows, cols, type));
}

Mat *Mat_NewFromBytes(int rows, int cols, int type, void *data, size_t step) {
  return reinterpret_cast<Mat *>(new cv::Mat(rows, cols, type, data, step));
}

void Mat_Delete(Mat *mat) { delete reinterpret_cast<cv::Mat *>(mat); }

Mat *Mat_Clone(Mat *mat) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat cloned = m->clone();
  return reinterpret_cast<Mat *>(new cv::Mat(cloned));
}

int Mat_Empty(Mat *mat) {
  return reinterpret_cast<cv::Mat *>(mat)->empty() ? 1 : 0;
}

int Mat_Rows(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->rows; }

int Mat_Cols(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->cols; }

int Mat_Type(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->type(); }

int Mat_Channels(Mat *mat) {
  return reinterpret_cast<cv::Mat *>(mat)->channels();
}

int Mat_Depth(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->depth(); }

size_t Mat_Total(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->total(); }

size_t Mat_ElemSize(Mat *mat) {
  return reinterpret_cast<cv::Mat *>(mat)->elemSize();
}

void *Mat_Data(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->data; }

size_t Mat_Step(Mat *mat) { return reinterpret_cast<cv::Mat *>(mat)->step; }

void Mat_CopyTo(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  s->copyTo(*d);
}

void Mat_ConvertTo(Mat *src, Mat *dst, int rtype, double alpha, double beta) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  s->convertTo(*d, rtype, alpha, beta);
}

// Mat element access
double Mat_GetDouble(Mat *mat, int row, int col) {
  return reinterpret_cast<cv::Mat *>(mat)->at<double>(row, col);
}

float Mat_GetFloat(Mat *mat, int row, int col) {
  return reinterpret_cast<cv::Mat *>(mat)->at<float>(row, col);
}

int Mat_GetInt(Mat *mat, int row, int col) {
  return reinterpret_cast<cv::Mat *>(mat)->at<int>(row, col);
}

unsigned char Mat_GetUChar(Mat *mat, int row, int col) {
  return reinterpret_cast<cv::Mat *>(mat)->at<unsigned char>(row, col);
}

void Mat_SetDouble(Mat *mat, int row, int col, double value) {
  reinterpret_cast<cv::Mat *>(mat)->at<double>(row, col) = value;
}

void Mat_SetFloat(Mat *mat, int row, int col, float value) {
  reinterpret_cast<cv::Mat *>(mat)->at<float>(row, col) = value;
}

void Mat_SetInt(Mat *mat, int row, int col, int value) {
  reinterpret_cast<cv::Mat *>(mat)->at<int>(row, col) = value;
}

void Mat_SetUChar(Mat *mat, int row, int col, unsigned char value) {
  reinterpret_cast<cv::Mat *>(mat)->at<unsigned char>(row, col) = value;
}

// Mat static construction methods
Mat *Mat_Zeros(int rows, int cols, int type) {
  cv::Mat m = cv::Mat::zeros(rows, cols, type);
  return reinterpret_cast<Mat *>(new cv::Mat(m));
}

Mat *Mat_Ones(int rows, int cols, int type) {
  cv::Mat m = cv::Mat::ones(rows, cols, type);
  return reinterpret_cast<Mat *>(new cv::Mat(m));
}

Mat *Mat_Eye(int rows, int cols, int type) {
  cv::Mat m = cv::Mat::eye(rows, cols, type);
  return reinterpret_cast<Mat *>(new cv::Mat(m));
}

// Mat element operations
void Mat_SetTo(Mat *mat, Scalar value) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Scalar s(value.v0, value.v1, value.v2, value.v3);
  m->setTo(s);
}

void Mat_SetToMask(Mat *mat, Scalar value, Mat *mask) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat *msk = reinterpret_cast<cv::Mat *>(mask);
  cv::Scalar s(value.v0, value.v1, value.v2, value.v3);
  m->setTo(s, *msk);
}

Mat *Mat_Reshape(Mat *mat, int cn, int rows) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat reshaped = m->reshape(cn, rows);
  return reinterpret_cast<Mat *>(new cv::Mat(reshaped));
}

Mat *Mat_T(Mat *mat) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat transposed = m->t();
  return reinterpret_cast<Mat *>(new cv::Mat(transposed));
}

Mat *Mat_Inv(Mat *mat, int method) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat inverted = m->inv(method);
  return reinterpret_cast<Mat *>(new cv::Mat(inverted));
}

Mat *Mat_Mul(Mat *mat, Mat *other, double scale) {
  cv::Mat *m1 = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat *m2 = reinterpret_cast<cv::Mat *>(other);
  cv::Mat result = m1->mul(*m2, scale);
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

double Mat_Dot(Mat *mat, Mat *other) {
  cv::Mat *m1 = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat *m2 = reinterpret_cast<cv::Mat *>(other);
  return m1->dot(*m2);
}

Mat *Mat_Cross(Mat *mat, Mat *other) {
  cv::Mat *m1 = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat *m2 = reinterpret_cast<cv::Mat *>(other);
  cv::Mat result = m1->cross(*m2);
  return reinterpret_cast<Mat *>(new cv::Mat(result));
}

// Mat ROI and slicing operations
Mat *Mat_Row(Mat *mat, int y) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat row = m->row(y);
  return reinterpret_cast<Mat *>(new cv::Mat(row));
}

Mat *Mat_Col(Mat *mat, int x) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat col = m->col(x);
  return reinterpret_cast<Mat *>(new cv::Mat(col));
}

Mat *Mat_RowRange(Mat *mat, int startrow, int endrow) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat range = m->rowRange(startrow, endrow);
  return reinterpret_cast<Mat *>(new cv::Mat(range));
}

Mat *Mat_ColRange(Mat *mat, int startcol, int endcol) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat range = m->colRange(startcol, endcol);
  return reinterpret_cast<Mat *>(new cv::Mat(range));
}

Mat *Mat_Submat(Mat *mat, Rect roi) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Rect r(roi.x, roi.y, roi.width, roi.height);
  cv::Mat submat = (*m)(r);
  return reinterpret_cast<Mat *>(new cv::Mat(submat));
}

Mat *Mat_SubmatRanges(Mat *mat, int row_start, int row_end, int col_start,
                      int col_end) {
  cv::Mat *m = reinterpret_cast<cv::Mat *>(mat);
  cv::Mat submat =
      (*m)(cv::Range(row_start, row_end), cv::Range(col_start, col_end));
  return reinterpret_cast<Mat *>(new cv::Mat(submat));
}

// Matrix arithmetic operations
void Mat_Add(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::add(*s1, *s2, *d);
}

void Mat_Subtract(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::subtract(*s1, *s2, *d);
}

void Mat_Multiply(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::multiply(*s1, *s2, *d);
}

void Mat_Divide(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::divide(*s1, *s2, *d);
}

void Mat_BitwiseAnd(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::bitwise_and(*s1, *s2, *d);
}

void Mat_BitwiseOr(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::bitwise_or(*s1, *s2, *d);
}

void Mat_BitwiseXor(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::bitwise_xor(*s1, *s2, *d);
}

void Mat_BitwiseNot(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::bitwise_not(*s, *d);
}

void Mat_Compare(Mat *src1, Mat *src2, Mat *dst, int cmpop) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::compare(*s1, *s2, *d, cmpop);
}

void Mat_InRange(Mat *src, Scalar lowerb, Scalar upperb, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Scalar lower(lowerb.v0, lowerb.v1, lowerb.v2, lowerb.v3);
  cv::Scalar upper(upperb.v0, upperb.v1, upperb.v2, upperb.v3);
  cv::inRange(*s, lower, upper, *d);
}

void Mat_AddWeighted(Mat *src1, double alpha, Mat *src2, double beta,
                     double gamma, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::addWeighted(*s1, alpha, *s2, beta, gamma, *d);
}

void Mat_Absdiff(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::absdiff(*s1, *s2, *d);
}

// Math and reduction operations
double Mat_Norm(Mat *src, int normType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  return cv::norm(*s, normType);
}

void Mat_Normalize(Mat *src, Mat *dst, double alpha, double beta,
                   int normType) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::normalize(*s, *d, alpha, beta, normType);
}

Scalar Mat_Sum(Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Scalar sum = cv::sum(*s);
  return Scalar{sum[0], sum[1], sum[2], sum[3]};
}

Scalar Mat_Mean(Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Scalar mean = cv::mean(*s);
  return Scalar{mean[0], mean[1], mean[2], mean[3]};
}

void Mat_MeanStdDev(Mat *src, Scalar *mean, Scalar *stddev) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Scalar m, sd;
  cv::meanStdDev(*s, m, sd);
  mean->v0 = m[0];
  mean->v1 = m[1];
  mean->v2 = m[2];
  mean->v3 = m[3];
  stddev->v0 = sd[0];
  stddev->v1 = sd[1];
  stddev->v2 = sd[2];
  stddev->v3 = sd[3];
}

void Mat_MinMaxLoc(Mat *src, double *minVal, double *maxVal, Point *minLoc,
                   Point *maxLoc) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Point minP, maxP;
  cv::minMaxLoc(*s, minVal, maxVal, &minP, &maxP);
  if (minLoc) {
    minLoc->x = minP.x;
    minLoc->y = minP.y;
  }
  if (maxLoc) {
    maxLoc->x = maxP.x;
    maxLoc->y = maxP.y;
  }
}

void Mat_Reduce(Mat *src, Mat *dst, int dim, int rtype) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::reduce(*s, *d, dim, rtype);
}

int Mat_CountNonZero(Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  return cv::countNonZero(*s);
}

void Mat_Sqrt(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::sqrt(*s, *d);
}

void Mat_Pow(Mat *src, double power, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::pow(*s, power, *d);
}

void Mat_Exp(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::exp(*s, *d);
}

void Mat_Log(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::log(*s, *d);
}

// Array operations
void Mat_Merge(Mat **mats, int count, Mat *dst) {
  std::vector<cv::Mat> mv;
  for (int i = 0; i < count; i++) {
    mv.push_back(*reinterpret_cast<cv::Mat *>(mats[i]));
  }
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::merge(mv, *d);
}

void Mat_Split(Mat *src, Mat **dsts) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  std::vector<cv::Mat> mv;
  cv::split(*s, mv);
  for (size_t i = 0; i < mv.size(); i++) {
    *reinterpret_cast<cv::Mat *>(dsts[i]) = mv[i];
  }
}

void Mat_Flip(Mat *src, Mat *dst, int flipCode) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::flip(*s, *d, flipCode);
}

void Mat_Rotate(Mat *src, Mat *dst, int rotateCode) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::rotate(*s, *d, rotateCode);
}

// Linear algebra operations
void Mat_Gemm(Mat *src1, Mat *src2, double alpha, Mat *src3, double beta,
              Mat *dst, int flags) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *s3 = reinterpret_cast<cv::Mat *>(src3);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::gemm(*s1, *s2, alpha, *s3, beta, *d, flags);
}

void Mat_Transpose(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::transpose(*s, *d);
}

double Mat_Invert(Mat *src, Mat *dst, int method) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  return cv::invert(*s, *d, method);
}

int Mat_Solve(Mat *src1, Mat *src2, Mat *dst, int flags) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  return cv::solve(*s1, *s2, *d, flags) ? 1 : 0;
}

double Mat_Determinant(Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  return cv::determinant(*s);
}

Scalar Mat_Trace(Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Scalar trace = cv::trace(*s);
  return Scalar{trace[0], trace[1], trace[2], trace[3]};
}

// Math operations (Phase 8)
void Mat_Min(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::min(*s1, *s2, *d);
}

void Mat_Max(Mat *src1, Mat *src2, Mat *dst) {
  cv::Mat *s1 = reinterpret_cast<cv::Mat *>(src1);
  cv::Mat *s2 = reinterpret_cast<cv::Mat *>(src2);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::max(*s1, *s2, *d);
}

void Mat_Abs(Mat *src, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  *d = cv::abs(*s);
}

// Channel operations (Phase 9)
void Mat_ExtractChannel(Mat *src, Mat *dst, int coi) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::extractChannel(*s, *d, coi);
}

void Mat_InsertChannel(Mat *src, Mat *dst, int coi) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::insertChannel(*s, *d, coi);
}

void Mat_MixChannels(Mat **src, int nsrcs, Mat **dst, int ndsts, int *fromTo,
                     int npairs) {
  std::vector<cv::Mat> srcVec;
  for (int i = 0; i < nsrcs; i++) {
    srcVec.push_back(*reinterpret_cast<cv::Mat *>(src[i]));
  }

  std::vector<cv::Mat> dstVec;
  for (int i = 0; i < ndsts; i++) {
    dstVec.push_back(*reinterpret_cast<cv::Mat *>(dst[i]));
  }

  cv::mixChannels(srcVec, dstVec, fromTo, npairs);

  // Copy results back
  for (int i = 0; i < ndsts; i++) {
    *reinterpret_cast<cv::Mat *>(dst[i]) = dstVec[i];
  }
}

void Mat_FindNonZero(Mat *src, Mat *idx) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *i = reinterpret_cast<cv::Mat *>(idx);
  cv::findNonZero(*s, *i);
}

// Array concatenation operations (Phase 10)
void Mat_Repeat(Mat *src, int ny, int nx, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::repeat(*s, ny, nx, *d);
}

void Mat_Hconcat(Mat **src, int nsrc, Mat *dst) {
  std::vector<cv::Mat> srcVec;
  for (int i = 0; i < nsrc; i++) {
    srcVec.push_back(*reinterpret_cast<cv::Mat *>(src[i]));
  }
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::hconcat(srcVec, *d);
}

void Mat_Vconcat(Mat **src, int nsrc, Mat *dst) {
  std::vector<cv::Mat> srcVec;
  for (int i = 0; i < nsrc; i++) {
    srcVec.push_back(*reinterpret_cast<cv::Mat *>(src[i]));
  }
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::vconcat(srcVec, *d);
}

// Advanced linear algebra operations (Phase 11)
void Mat_MulTransposed(Mat *src, Mat *dst, int aTa) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::mulTransposed(*s, *d, aTa != 0);
}

int Mat_Eigen(Mat *src, Mat *eigenvalues, Mat *eigenvectors) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *vals = reinterpret_cast<cv::Mat *>(eigenvalues);
  cv::Mat *vecs = reinterpret_cast<cv::Mat *>(eigenvectors);
  return cv::eigen(*s, *vals, *vecs) ? 1 : 0;
}

void Mat_SVDecomp(Mat *src, Mat *w, Mat *u, Mat *vt, int flags) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *wMat = reinterpret_cast<cv::Mat *>(w);
  cv::Mat *uMat = reinterpret_cast<cv::Mat *>(u);
  cv::Mat *vtMat = reinterpret_cast<cv::Mat *>(vt);
  cv::SVDecomp(*s, *wMat, *uMat, *vtMat, flags);
}

// Final P1 utility functions (Phase 12)
void Mat_SetIdentity(Mat *dst, Scalar s) {
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::Scalar scalarVal(s.v0, s.v1, s.v2, s.v3);
  cv::setIdentity(*d, scalarVal);
}

void Mat_Sort(Mat *src, Mat *dst, int flags) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::sort(*s, *d, flags);
}

void Mat_SortIdx(Mat *src, Mat *dst, int flags) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::sortIdx(*s, *d, flags);
}

void Mat_CompleteSymm(Mat *dst, int lowerToUpper) {
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::completeSymm(*d, lowerToUpper != 0);
}

void Mat_ConvertScaleAbs(Mat *src, Mat *dst, double alpha, double beta) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::convertScaleAbs(*s, *d, alpha, beta);
}

void Mat_LUT(Mat *src, Mat *lut, Mat *dst) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  cv::Mat *l = reinterpret_cast<cv::Mat *>(lut);
  cv::Mat *d = reinterpret_cast<cv::Mat *>(dst);
  cv::LUT(*s, *l, *d);
}

int Mat_HasNonZero(Mat *src) {
  cv::Mat *s = reinterpret_cast<cv::Mat *>(src);
  return cv::hasNonZero(*s) ? 1 : 0;
}

// Final P2 utility functions (Phase 13)
int Mat_CheckRange(Mat *a, int quiet, double minVal, double maxVal) {
  cv::Mat *mat = reinterpret_cast<cv::Mat *>(a);
  return cv::checkRange(*mat, quiet != 0, nullptr, minVal, maxVal) ? 1 : 0;
}

void Mat_PatchNaNs(Mat *a, double val) {
  cv::Mat *mat = reinterpret_cast<cv::Mat *>(a);
  cv::patchNaNs(*mat, val);
}

void SetRNGSeed(int seed) { cv::setRNGSeed(seed); }

// Point vector implementation
PointVector *PointVector_New() {
  return reinterpret_cast<PointVector *>(new std::vector<cv::Point>());
}

void PointVector_Delete(PointVector *pv) {
  delete reinterpret_cast<std::vector<cv::Point> *>(pv);
}

int PointVector_Size(PointVector *pv) {
  return static_cast<int>(
      reinterpret_cast<std::vector<cv::Point> *>(pv)->size());
}

Point PointVector_At(PointVector *pv, int idx) {
  cv::Point p = reinterpret_cast<std::vector<cv::Point> *>(pv)->at(idx);
  return Point{p.x, p.y};
}

void PointVector_Append(PointVector *pv, Point p) {
  reinterpret_cast<std::vector<cv::Point> *>(pv)->push_back(
      cv::Point(p.x, p.y));
}

// Point2f vector implementation
Point2fVector *Point2fVector_New() {
  return reinterpret_cast<Point2fVector *>(new std::vector<cv::Point2f>());
}

void Point2fVector_Delete(Point2fVector *pv) {
  delete reinterpret_cast<std::vector<cv::Point2f> *>(pv);
}

int Point2fVector_Size(Point2fVector *pv) {
  return static_cast<int>(
      reinterpret_cast<std::vector<cv::Point2f> *>(pv)->size());
}

Point2f Point2fVector_At(Point2fVector *pv, int idx) {
  cv::Point2f p = reinterpret_cast<std::vector<cv::Point2f> *>(pv)->at(idx);
  return Point2f{p.x, p.y};
}

void Point2fVector_Append(Point2fVector *pv, Point2f p) {
  reinterpret_cast<std::vector<cv::Point2f> *>(pv)->push_back(
      cv::Point2f(p.x, p.y));
}

// Point3f vector implementation
Point3fVector *Point3fVector_New() {
  return reinterpret_cast<Point3fVector *>(new std::vector<cv::Point3f>());
}

void Point3fVector_Delete(Point3fVector *pv) {
  delete reinterpret_cast<std::vector<cv::Point3f> *>(pv);
}

int Point3fVector_Size(Point3fVector *pv) {
  return static_cast<int>(
      reinterpret_cast<std::vector<cv::Point3f> *>(pv)->size());
}

Point3f Point3fVector_At(Point3fVector *pv, int idx) {
  cv::Point3f p = reinterpret_cast<std::vector<cv::Point3f> *>(pv)->at(idx);
  return Point3f{p.x, p.y, p.z};
}

void Point3fVector_Append(Point3fVector *pv, Point3f p) {
  reinterpret_cast<std::vector<cv::Point3f> *>(pv)->push_back(
      cv::Point3f(p.x, p.y, p.z));
}

// OpenCV version
const char *OpenCV_Version() { return CV_VERSION; }

// PointsVector implementation (std::vector<std::vector<cv::Point>>)
PointsVector *PointsVector_New() {
  return reinterpret_cast<PointsVector *>(
      new std::vector<std::vector<cv::Point>>());
}

void PointsVector_Delete(PointsVector *pv) {
  delete reinterpret_cast<std::vector<std::vector<cv::Point>> *>(pv);
}

int PointsVector_Size(PointsVector *pv) {
  return static_cast<int>(
      reinterpret_cast<std::vector<std::vector<cv::Point>> *>(pv)->size());
}

PointVector *PointsVector_At(PointsVector *pv, int idx) {
  std::vector<cv::Point> *vec = new std::vector<cv::Point>(
      reinterpret_cast<std::vector<std::vector<cv::Point>> *>(pv)->at(idx));
  return reinterpret_cast<PointVector *>(vec);
}

void PointsVector_Append(PointsVector *pv, PointVector *points) {
  std::vector<cv::Point> *pts =
      reinterpret_cast<std::vector<cv::Point> *>(points);
  reinterpret_cast<std::vector<std::vector<cv::Point>> *>(pv)->push_back(*pts);

  // DFT / Frequency domain
}

void Mat_DFT(Mat *src, Mat *dst, int flags, int nonzeroRows) {
  cv::dft(*(cv::Mat *)src, *(cv::Mat *)dst, flags, nonzeroRows);
}

void Mat_IDFT(Mat *src, Mat *dst, int flags, int nonzeroRows) {
  cv::idft(*(cv::Mat *)src, *(cv::Mat *)dst, flags, nonzeroRows);
}

void Mat_DCT(Mat *src, Mat *dst, int flags) {
  cv::dct(*(cv::Mat *)src, *(cv::Mat *)dst, flags);
}

void Mat_IDCT(Mat *src, Mat *dst, int flags) {
  cv::idct(*(cv::Mat *)src, *(cv::Mat *)dst, flags);
}

int Mat_GetOptimalDFTSize(int vecsize) {
  return cv::getOptimalDFTSize(vecsize);
}

void Mat_MulSpectrums(Mat *a, Mat *b, Mat *c, int flags, int conjB) {
  cv::mulSpectrums(*(cv::Mat *)a, *(cv::Mat *)b, *(cv::Mat *)c, flags,
                   conjB != 0);
}

// Math / transform functions
void Mat_Transform(Mat *src, Mat *dst, Mat *m) {
  cv::transform(*(cv::Mat *)src, *(cv::Mat *)dst, *(cv::Mat *)m);
}

void Mat_PerspectiveTransform(Mat *src, Mat *dst, Mat *m) {
  cv::perspectiveTransform(*(cv::Mat *)src, *(cv::Mat *)dst, *(cv::Mat *)m);
}

void Mat_Phase(Mat *x, Mat *y, Mat *angle, int angleInDegrees) {
  cv::phase(*(cv::Mat *)x, *(cv::Mat *)y, *(cv::Mat *)angle,
            angleInDegrees != 0);
}

void Mat_Magnitude(Mat *x, Mat *y, Mat *magnitude) {
  cv::magnitude(*(cv::Mat *)x, *(cv::Mat *)y, *(cv::Mat *)magnitude);
}

void Mat_PolarToCart(Mat *magnitude, Mat *angle, Mat *x, Mat *y,
                     int angleInDegrees) {
  cv::polarToCart(*(cv::Mat *)magnitude, *(cv::Mat *)angle, *(cv::Mat *)x,
                  *(cv::Mat *)y, angleInDegrees != 0);
}

void Mat_CartToPolar(Mat *x, Mat *y, Mat *magnitude, Mat *angle,
                     int angleInDegrees) {
  cv::cartToPolar(*(cv::Mat *)x, *(cv::Mat *)y, *(cv::Mat *)magnitude,
                  *(cv::Mat *)angle, angleInDegrees != 0);
}

// Random number generation
void Mat_Randu(Mat *mat, Scalar low, Scalar high) {
  cv::randu(*(cv::Mat *)mat, cv::Scalar(low.v0, low.v1, low.v2, low.v3),
            cv::Scalar(high.v0, high.v1, high.v2, high.v3));
}

void Mat_Randn(Mat *mat, Scalar mean, Scalar stddev) {
  cv::randn(*(cv::Mat *)mat, cv::Scalar(mean.v0, mean.v1, mean.v2, mean.v3),
            cv::Scalar(stddev.v0, stddev.v1, stddev.v2, stddev.v3));
}

void Mat_RandShuffle(Mat *mat) { cv::randShuffle(*(cv::Mat *)mat); }

// Clustering
double Mat_KMeans(Mat *data, int K, Mat *bestLabels, int maxIter,
                  double epsilon, int attempts, int flags, Mat *centers) {
  cv::TermCriteria tc(cv::TermCriteria::EPS + cv::TermCriteria::COUNT, maxIter,
                      epsilon);
  return cv::kmeans(*(cv::Mat *)data, K, *(cv::Mat *)bestLabels, tc, attempts,
                    flags, *(cv::Mat *)centers);
}

// ============================================================================
// PCA (Principal Component Analysis)
// ============================================================================

PCAPtr PCA_Create(Mat *data, Mat *mean, int flags, int maxComponents) {
  cv::PCA *pca =
      new cv::PCA(*(cv::Mat *)data, *(cv::Mat *)mean, flags, maxComponents);
  return (PCAPtr)pca;
}

void PCA_Project(PCAPtr pca, Mat *vec, Mat *result) {
  cv::PCA *p = (cv::PCA *)pca;
  *(cv::Mat *)result = p->project(*(cv::Mat *)vec);
}

void PCA_BackProject(PCAPtr pca, Mat *vec, Mat *result) {
  cv::PCA *p = (cv::PCA *)pca;
  *(cv::Mat *)result = p->backProject(*(cv::Mat *)vec);
}

Mat *PCA_GetEigenvalues(PCAPtr pca) {
  cv::PCA *p = (cv::PCA *)pca;
  return (Mat *)new cv::Mat(p->eigenvalues);
}

Mat *PCA_GetEigenvectors(PCAPtr pca) {
  cv::PCA *p = (cv::PCA *)pca;
  return (Mat *)new cv::Mat(p->eigenvectors);
}

Mat *PCA_GetMean(PCAPtr pca) {
  cv::PCA *p = (cv::PCA *)pca;
  return (Mat *)new cv::Mat(p->mean);
}

void PCA_Close(PCAPtr pca) { delete (cv::PCA *)pca; }

// ============================================================================
// Additional Utility Functions
// ============================================================================

void Mat_CopyMakeBorder(Mat *src, Mat *dst, int top, int bottom, int left,
                        int right, int borderType, Scalar value) {
  cv::Scalar s(value.v0, value.v1, value.v2, value.v3);
  cv::copyMakeBorder(*(cv::Mat *)src, *(cv::Mat *)dst, top, bottom, left, right,
                     borderType, s);
}

int Mat_BorderInterpolate(int p, int len, int borderType) {
  return cv::borderInterpolate(p, len, borderType);
}

// ============================================================================
// Linear Algebra Functions
// ============================================================================

void Mat_CalcCovarMatrix(Mat *samples, Mat *covar, Mat *mean, int flags,
                         int ctype) {
  cv::calcCovarMatrix(*(cv::Mat *)samples, *(cv::Mat *)covar, *(cv::Mat *)mean,
                      flags, ctype);
}

double Mat_Mahalanobis(Mat *v1, Mat *v2, Mat *icovar) {
  return cv::Mahalanobis(*(cv::Mat *)v1, *(cv::Mat *)v2, *(cv::Mat *)icovar);
}

} // extern "C"
