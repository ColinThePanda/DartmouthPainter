#include "img_hash.h"
#include <opencv2/img_hash.hpp>
#include <opencv2/img_hash/average_hash.hpp>
#include <opencv2/img_hash/block_mean_hash.hpp>
#include <opencv2/img_hash/color_moment_hash.hpp>
#include <opencv2/img_hash/marr_hildreth_hash.hpp>
#include <opencv2/img_hash/phash.hpp>
#include <opencv2/img_hash/radial_variance_hash.hpp>

extern "C" {

// ============================================================================
// Image Hashing Algorithms
// ============================================================================

ImgHashBase *AverageHash_Create() {
  cv::Ptr<cv::img_hash::ImgHashBase> ptr = cv::img_hash::AverageHash::create();
  return reinterpret_cast<ImgHashBase *>(
      new cv::Ptr<cv::img_hash::ImgHashBase>(ptr));
}

ImgHashBase *PHash_Create() {
  cv::Ptr<cv::img_hash::ImgHashBase> ptr = cv::img_hash::PHash::create();
  return reinterpret_cast<ImgHashBase *>(
      new cv::Ptr<cv::img_hash::ImgHashBase>(ptr));
}

ImgHashBase *BlockMeanHash_Create(int mode) {
  cv::Ptr<cv::img_hash::ImgHashBase> ptr =
      cv::img_hash::BlockMeanHash::create(mode);
  return reinterpret_cast<ImgHashBase *>(
      new cv::Ptr<cv::img_hash::ImgHashBase>(ptr));
}

ImgHashBase *MarrHildrethHash_Create(float alpha, float scale) {
  cv::Ptr<cv::img_hash::ImgHashBase> ptr =
      cv::img_hash::MarrHildrethHash::create(alpha, scale);
  return reinterpret_cast<ImgHashBase *>(
      new cv::Ptr<cv::img_hash::ImgHashBase>(ptr));
}

ImgHashBase *RadialVarianceHash_Create(double sigma, int numOfAngleLine) {
  cv::Ptr<cv::img_hash::ImgHashBase> ptr =
      cv::img_hash::RadialVarianceHash::create(sigma, numOfAngleLine);
  return reinterpret_cast<ImgHashBase *>(
      new cv::Ptr<cv::img_hash::ImgHashBase>(ptr));
}

ImgHashBase *ColorMomentHash_Create() {
  cv::Ptr<cv::img_hash::ImgHashBase> ptr =
      cv::img_hash::ColorMomentHash::create();
  return reinterpret_cast<ImgHashBase *>(
      new cv::Ptr<cv::img_hash::ImgHashBase>(ptr));
}

void ImgHashBase_Delete(ImgHashBase *ptr) {
  if (ptr) {
    delete reinterpret_cast<cv::Ptr<cv::img_hash::ImgHashBase> *>(ptr);
  }
}

void ImgHashBase_Compute(ImgHashBase *ptr, Mat *inputArr, Mat *outputArr) {
  cv::Ptr<cv::img_hash::ImgHashBase> *hasher =
      reinterpret_cast<cv::Ptr<cv::img_hash::ImgHashBase> *>(ptr);
  (*hasher)->compute(*reinterpret_cast<cv::Mat *>(inputArr),
                     *reinterpret_cast<cv::Mat *>(outputArr));
}

double ImgHashBase_Compare(ImgHashBase *ptr, Mat *hashOne, Mat *hashTwo) {
  cv::Ptr<cv::img_hash::ImgHashBase> *hasher =
      reinterpret_cast<cv::Ptr<cv::img_hash::ImgHashBase> *>(ptr);
  return (*hasher)->compare(*reinterpret_cast<cv::Mat *>(hashOne),
                            *reinterpret_cast<cv::Mat *>(hashTwo));
}

} // extern "C"
