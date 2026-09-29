#include "photo.h"
#include <opencv2/photo.hpp>

extern "C" {

// ============================================================================
// Denoising
// ============================================================================

void FastNlMeansDenoising(Mat *src, Mat *dst, float h, int templateWindowSize,
                          int searchWindowSize) {
  cv::fastNlMeansDenoising(*reinterpret_cast<cv::Mat *>(src),
                           *reinterpret_cast<cv::Mat *>(dst), h,
                           templateWindowSize, searchWindowSize);
}

void FastNlMeansDenoisingColored(Mat *src, Mat *dst, float h, float hColor,
                                 int templateWindowSize, int searchWindowSize) {
  cv::fastNlMeansDenoisingColored(*reinterpret_cast<cv::Mat *>(src),
                                  *reinterpret_cast<cv::Mat *>(dst), h, hColor,
                                  templateWindowSize, searchWindowSize);
}

// ============================================================================
// Inpainting
// ============================================================================

void Inpaint(Mat *src, Mat *inpaintMask, Mat *dst, double inpaintRadius,
             int flags) {
  cv::inpaint(*reinterpret_cast<cv::Mat *>(src),
              *reinterpret_cast<cv::Mat *>(inpaintMask),
              *reinterpret_cast<cv::Mat *>(dst), inpaintRadius, flags);
}

// ============================================================================
// Edge-Preserving Filters
// ============================================================================

void DetailEnhance(Mat *src, Mat *dst, float sigma_s, float sigma_r) {
  cv::detailEnhance(*reinterpret_cast<cv::Mat *>(src),
                    *reinterpret_cast<cv::Mat *>(dst), sigma_s, sigma_r);
}

void EdgePreservingFilter(Mat *src, Mat *dst, int flags, float sigma_s,
                          float sigma_r) {
  cv::edgePreservingFilter(*reinterpret_cast<cv::Mat *>(src),
                           *reinterpret_cast<cv::Mat *>(dst), flags, sigma_s,
                           sigma_r);
}

void PencilSketch(Mat *src, Mat *dst1, Mat *dst2, float sigma_s, float sigma_r,
                  float shade_factor) {
  cv::pencilSketch(
      *reinterpret_cast<cv::Mat *>(src), *reinterpret_cast<cv::Mat *>(dst1),
      *reinterpret_cast<cv::Mat *>(dst2), sigma_s, sigma_r, shade_factor);
}

void Stylization(Mat *src, Mat *dst, float sigma_s, float sigma_r) {
  cv::stylization(*reinterpret_cast<cv::Mat *>(src),
                  *reinterpret_cast<cv::Mat *>(dst), sigma_s, sigma_r);
}

// ============================================================================
// Seamless Cloning
// ============================================================================

void SeamlessClone(Mat *src, Mat *dst, Mat *mask, Point p, Mat *blend,
                   int flags) {
  cv::Point center(p.x, p.y);
  cv::seamlessClone(*reinterpret_cast<cv::Mat *>(src),
                    *reinterpret_cast<cv::Mat *>(dst),
                    *reinterpret_cast<cv::Mat *>(mask), center,
                    *reinterpret_cast<cv::Mat *>(blend), flags);
}

// ============================================================================
// Color Change and Illumination Change
// ============================================================================

void ColorChange(Mat *src, Mat *mask, Mat *dst, float red_mul, float green_mul,
                 float blue_mul) {
  cv::colorChange(
      *reinterpret_cast<cv::Mat *>(src), *reinterpret_cast<cv::Mat *>(mask),
      *reinterpret_cast<cv::Mat *>(dst), red_mul, green_mul, blue_mul);
}

void IlluminationChange(Mat *src, Mat *mask, Mat *dst, float alpha,
                        float beta) {
  cv::illuminationChange(*reinterpret_cast<cv::Mat *>(src),
                         *reinterpret_cast<cv::Mat *>(mask),
                         *reinterpret_cast<cv::Mat *>(dst), alpha, beta);
}

void TextureFlattening(Mat *src, Mat *mask, Mat *dst, float low_threshold,
                       float high_threshold, int kernel_size) {
  cv::textureFlattening(*reinterpret_cast<cv::Mat *>(src),
                        *reinterpret_cast<cv::Mat *>(mask),
                        *reinterpret_cast<cv::Mat *>(dst), low_threshold,
                        high_threshold, kernel_size);
}

// ============================================================================
// Decolorization
// ============================================================================

void Decolorization(Mat *src, Mat *grayscale, Mat *color_boost) {
  cv::decolor(*reinterpret_cast<cv::Mat *>(src),
              *reinterpret_cast<cv::Mat *>(grayscale),
              *reinterpret_cast<cv::Mat *>(color_boost));
}

// ============================================================================
// Multi-frame Denoising
// ============================================================================

void FastNlMeansDenoisingMulti(Mat **srcImgs, int imgCount, Mat *dst,
                               int imgToDenoiseIndex, int temporalWindowSize,
                               float h, int templateWindowSize,
                               int searchWindowSize) {
  std::vector<cv::Mat> imgs;
  for (int i = 0; i < imgCount; i++) {
    imgs.push_back(*(cv::Mat *)srcImgs[i]);
  }
  cv::fastNlMeansDenoisingMulti(imgs, *(cv::Mat *)dst, imgToDenoiseIndex,
                                temporalWindowSize, h, templateWindowSize,
                                searchWindowSize);
}

void FastNlMeansDenoisingColoredMulti(Mat **srcImgs, int imgCount, Mat *dst,
                                      int imgToDenoiseIndex,
                                      int temporalWindowSize, float h,
                                      float hColor, int templateWindowSize,
                                      int searchWindowSize) {
  std::vector<cv::Mat> imgs;
  for (int i = 0; i < imgCount; i++) {
    imgs.push_back(*(cv::Mat *)srcImgs[i]);
  }
  cv::fastNlMeansDenoisingColoredMulti(imgs, *(cv::Mat *)dst, imgToDenoiseIndex,
                                       temporalWindowSize, h, hColor,
                                       templateWindowSize, searchWindowSize);
}

// ============================================================================
// HDR / Tonemap Pipeline
// ============================================================================

MergeMertens MergeMertens_Create() {
  return new cv::Ptr<cv::MergeMertens>(cv::createMergeMertens());
}

MergeMertens MergeMertens_CreateWithParams(float contrast_weight,
                                           float saturation_weight,
                                           float exposure_weight) {
  return new cv::Ptr<cv::MergeMertens>(cv::createMergeMertens(
      contrast_weight, saturation_weight, exposure_weight));
}

void MergeMertens_Process(MergeMertens mm, Mat **srcImgs, int imgCount,
                          Mat *dst) {
  auto p = reinterpret_cast<cv::Ptr<cv::MergeMertens> *>(mm);
  std::vector<cv::Mat> imgs;
  for (int i = 0; i < imgCount; i++) {
    imgs.push_back(*(cv::Mat *)srcImgs[i]);
  }
  (*p)->process(imgs, *(cv::Mat *)dst);
}

void MergeMertens_Close(MergeMertens mm) {
  delete reinterpret_cast<cv::Ptr<cv::MergeMertens> *>(mm);
}

TonemapPtr Tonemap_Create(float gamma) {
  return new cv::Ptr<cv::Tonemap>(cv::createTonemap(gamma));
}

void Tonemap_Process(TonemapPtr t, Mat *src, Mat *dst) {
  auto p = reinterpret_cast<cv::Ptr<cv::Tonemap> *>(t);
  (*p)->process(*(cv::Mat *)src, *(cv::Mat *)dst);
}

void Tonemap_Close(TonemapPtr t) {
  delete reinterpret_cast<cv::Ptr<cv::Tonemap> *>(t);
}

AlignMTB AlignMTB_Create(int max_bits, int exclude_range, int cut) {
  return new cv::Ptr<cv::AlignMTB>(
      cv::createAlignMTB(max_bits, exclude_range, cut != 0));
}

void AlignMTB_Process(AlignMTB a, Mat **srcImgs, int imgCount, Mat **dstImgs) {
  auto p = reinterpret_cast<cv::Ptr<cv::AlignMTB> *>(a);
  std::vector<cv::Mat> src, dst;
  for (int i = 0; i < imgCount; i++) {
    src.push_back(*(cv::Mat *)srcImgs[i]);
  }
  (*p)->process(src, dst);
  for (int i = 0; i < imgCount && i < (int)dst.size(); i++) {
    *(cv::Mat *)dstImgs[i] = dst[i];
  }
}

void AlignMTB_Close(AlignMTB a) {
  delete reinterpret_cast<cv::Ptr<cv::AlignMTB> *>(a);
}

CalibrateDebevec CalibrateDebevec_Create(int samples, float lambda,
                                         int random) {
  return new cv::Ptr<cv::CalibrateDebevec>(
      cv::createCalibrateDebevec(samples, lambda, random != 0));
}

void CalibrateDebevec_Process(CalibrateDebevec cd, Mat **srcImgs, int imgCount,
                              Mat *dst, Mat *times) {
  auto p = reinterpret_cast<cv::Ptr<cv::CalibrateDebevec> *>(cd);
  std::vector<cv::Mat> imgs;
  for (int i = 0; i < imgCount; i++) {
    imgs.push_back(*(cv::Mat *)srcImgs[i]);
  }
  (*p)->process(imgs, *(cv::Mat *)dst, *(cv::Mat *)times);
}

void CalibrateDebevec_Close(CalibrateDebevec cd) {
  delete reinterpret_cast<cv::Ptr<cv::CalibrateDebevec> *>(cd);
}

MergeDebevec MergeDebevec_Create() {
  return new cv::Ptr<cv::MergeDebevec>(cv::createMergeDebevec());
}

void MergeDebevec_Process(MergeDebevec md, Mat **srcImgs, int imgCount,
                          Mat *dst, Mat *times, Mat *response) {
  auto p = reinterpret_cast<cv::Ptr<cv::MergeDebevec> *>(md);
  std::vector<cv::Mat> imgs;
  for (int i = 0; i < imgCount; i++) {
    imgs.push_back(*(cv::Mat *)srcImgs[i]);
  }
  (*p)->process(imgs, *(cv::Mat *)dst, *(cv::Mat *)times, *(cv::Mat *)response);
}

void MergeDebevec_Close(MergeDebevec md) {
  delete reinterpret_cast<cv::Ptr<cv::MergeDebevec> *>(md);
}

// ============================================================================
// Tonemap Variants
// ============================================================================

TonemapDragoPtr TonemapDrago_Create(float gamma, float saturation, float bias) {
  cv::Ptr<cv::TonemapDrago> *t = new cv::Ptr<cv::TonemapDrago>(
      cv::createTonemapDrago(gamma, saturation, bias));
  return (TonemapDragoPtr)t;
}

void TonemapDrago_Process(TonemapDragoPtr t, Mat *src, Mat *dst) {
  cv::Ptr<cv::TonemapDrago> *tonemap =
      reinterpret_cast<cv::Ptr<cv::TonemapDrago> *>(t);
  (*tonemap)->process(*(cv::Mat *)src, *(cv::Mat *)dst);
}

void TonemapDrago_Close(TonemapDragoPtr t) {
  delete reinterpret_cast<cv::Ptr<cv::TonemapDrago> *>(t);
}

TonemapReinhardPtr TonemapReinhard_Create(float gamma, float intensity,
                                          float lightAdapt, float colorAdapt) {
  cv::Ptr<cv::TonemapReinhard> *t = new cv::Ptr<cv::TonemapReinhard>(
      cv::createTonemapReinhard(gamma, intensity, lightAdapt, colorAdapt));
  return (TonemapReinhardPtr)t;
}

void TonemapReinhard_Process(TonemapReinhardPtr t, Mat *src, Mat *dst) {
  cv::Ptr<cv::TonemapReinhard> *tonemap =
      reinterpret_cast<cv::Ptr<cv::TonemapReinhard> *>(t);
  (*tonemap)->process(*(cv::Mat *)src, *(cv::Mat *)dst);
}

void TonemapReinhard_Close(TonemapReinhardPtr t) {
  delete reinterpret_cast<cv::Ptr<cv::TonemapReinhard> *>(t);
}

TonemapMantiukPtr TonemapMantiuk_Create(float gamma, float scale,
                                        float saturation) {
  cv::Ptr<cv::TonemapMantiuk> *t = new cv::Ptr<cv::TonemapMantiuk>(
      cv::createTonemapMantiuk(gamma, scale, saturation));
  return (TonemapMantiukPtr)t;
}

void TonemapMantiuk_Process(TonemapMantiukPtr t, Mat *src, Mat *dst) {
  cv::Ptr<cv::TonemapMantiuk> *tonemap =
      reinterpret_cast<cv::Ptr<cv::TonemapMantiuk> *>(t);
  (*tonemap)->process(*(cv::Mat *)src, *(cv::Mat *)dst);
}

void TonemapMantiuk_Close(TonemapMantiukPtr t) {
  delete reinterpret_cast<cv::Ptr<cv::TonemapMantiuk> *>(t);
}

} // extern "C"
