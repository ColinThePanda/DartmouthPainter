#include "ml.h"
#include <opencv2/ml.hpp>

extern "C" {

// ============================================================================
// SVM (Support Vector Machine)
// ============================================================================

SVM *SVM_Create() {
  cv::Ptr<cv::ml::SVM> ptr = cv::ml::SVM::create();
  return reinterpret_cast<SVM *>(new cv::Ptr<cv::ml::SVM>(ptr));
}

void SVM_Delete(SVM *svm) {
  delete reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
}

void SVM_Train(SVM *svm, Mat *samples, int layout, Mat *responses) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  (*ptr)->train(*reinterpret_cast<cv::Mat *>(samples), layout,
                *reinterpret_cast<cv::Mat *>(responses));
}

float SVM_Predict(SVM *svm, Mat *samples, Mat *results, int flags) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  cv::Mat *res = results ? reinterpret_cast<cv::Mat *>(results) : nullptr;
  cv::Mat dummy_res;
  return (*ptr)->predict(*reinterpret_cast<cv::Mat *>(samples),
                         res ? *res : dummy_res, flags);
}

void SVM_SetType(SVM *svm, int type) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  (*ptr)->setType(type);
}

void SVM_SetKernel(SVM *svm, int kernel) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  (*ptr)->setKernel(kernel);
}

void SVM_SetC(SVM *svm, double c) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  (*ptr)->setC(c);
}

void SVM_SetGamma(SVM *svm, double gamma) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  (*ptr)->setGamma(gamma);
}

int SVM_GetType(SVM *svm) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  return (*ptr)->getType();
}

int SVM_GetKernel(SVM *svm) {
  cv::Ptr<cv::ml::SVM> *ptr = reinterpret_cast<cv::Ptr<cv::ml::SVM> *>(svm);
  return (*ptr)->getKernelType();
}

// ============================================================================
// KNearest (K-Nearest Neighbors)
// ============================================================================

KNearest *KNearest_Create() {
  cv::Ptr<cv::ml::KNearest> ptr = cv::ml::KNearest::create();
  return reinterpret_cast<KNearest *>(new cv::Ptr<cv::ml::KNearest>(ptr));
}

void KNearest_Delete(KNearest *knn) {
  delete reinterpret_cast<cv::Ptr<cv::ml::KNearest> *>(knn);
}

void KNearest_Train(KNearest *knn, Mat *samples, int layout, Mat *responses) {
  cv::Ptr<cv::ml::KNearest> *ptr =
      reinterpret_cast<cv::Ptr<cv::ml::KNearest> *>(knn);
  (*ptr)->train(*reinterpret_cast<cv::Mat *>(samples), layout,
                *reinterpret_cast<cv::Mat *>(responses));
}

float KNearest_Predict(KNearest *knn, Mat *samples, Mat *results,
                       Mat *neighborResponses, Mat *dist) {
  cv::Ptr<cv::ml::KNearest> *ptr =
      reinterpret_cast<cv::Ptr<cv::ml::KNearest> *>(knn);
  cv::Mat *res = results ? reinterpret_cast<cv::Mat *>(results) : nullptr;
  cv::Mat *neighResp = neighborResponses
                           ? reinterpret_cast<cv::Mat *>(neighborResponses)
                           : nullptr;
  cv::Mat *distances = dist ? reinterpret_cast<cv::Mat *>(dist) : nullptr;

  cv::Mat dummy_res, dummy_neigh, dummy_dist;
  return (*ptr)->findNearest(*reinterpret_cast<cv::Mat *>(samples),
                             (*ptr)->getDefaultK(), res ? *res : dummy_res,
                             neighResp ? *neighResp : dummy_neigh,
                             distances ? *distances : dummy_dist);
}

void KNearest_SetDefaultK(KNearest *knn, int k) {
  cv::Ptr<cv::ml::KNearest> *ptr =
      reinterpret_cast<cv::Ptr<cv::ml::KNearest> *>(knn);
  (*ptr)->setDefaultK(k);
}

int KNearest_GetDefaultK(KNearest *knn) {
  cv::Ptr<cv::ml::KNearest> *ptr =
      reinterpret_cast<cv::Ptr<cv::ml::KNearest> *>(knn);
  return (*ptr)->getDefaultK();
}

void KNearest_SetAlgorithmType(KNearest *knn, int alg) {
  cv::Ptr<cv::ml::KNearest> *ptr =
      reinterpret_cast<cv::Ptr<cv::ml::KNearest> *>(knn);
  (*ptr)->setAlgorithmType(alg);
}

} // extern "C"
