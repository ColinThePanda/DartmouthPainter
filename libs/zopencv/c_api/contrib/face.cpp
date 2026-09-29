#include "face.h"
#include <limits>
#include <opencv2/face.hpp>

extern "C" {

// ============================================================================
// FaceRecognizer
// ============================================================================

FaceRecognizer *FaceRecognizer_CreateEigenfaces(int num_components,
                                                double threshold) {
  cv::Ptr<cv::face::FaceRecognizer> ptr =
      cv::face::EigenFaceRecognizer::create(num_components, threshold);
  return reinterpret_cast<FaceRecognizer *>(
      new cv::Ptr<cv::face::FaceRecognizer>(ptr));
}

FaceRecognizer *FaceRecognizer_CreateFisherfaces(int num_components,
                                                 double threshold) {
  cv::Ptr<cv::face::FaceRecognizer> ptr =
      cv::face::FisherFaceRecognizer::create(num_components, threshold);
  return reinterpret_cast<FaceRecognizer *>(
      new cv::Ptr<cv::face::FaceRecognizer>(ptr));
}

FaceRecognizer *FaceRecognizer_CreateLBPH(int radius, int neighbors, int grid_x,
                                          int grid_y, double threshold) {
  cv::Ptr<cv::face::FaceRecognizer> ptr = cv::face::LBPHFaceRecognizer::create(
      radius, neighbors, grid_x, grid_y, threshold);
  return reinterpret_cast<FaceRecognizer *>(
      new cv::Ptr<cv::face::FaceRecognizer>(ptr));
}

void FaceRecognizer_Delete(FaceRecognizer *recognizer) {
  delete reinterpret_cast<cv::Ptr<cv::face::FaceRecognizer> *>(recognizer);
}

void FaceRecognizer_Train(FaceRecognizer *recognizer, Mats *images,
                          Mat *labels) {
  cv::Ptr<cv::face::FaceRecognizer> *ptr =
      reinterpret_cast<cv::Ptr<cv::face::FaceRecognizer> *>(recognizer);
  std::vector<cv::Mat> *image_vec =
      reinterpret_cast<std::vector<cv::Mat> *>(images);
  (*ptr)->train(*image_vec, *reinterpret_cast<cv::Mat *>(labels));
}

void FaceRecognizer_Predict(FaceRecognizer *recognizer, Mat *image, int *label,
                            double *confidence) {
  cv::Ptr<cv::face::FaceRecognizer> *ptr =
      reinterpret_cast<cv::Ptr<cv::face::FaceRecognizer> *>(recognizer);

  (*ptr)->predict(*reinterpret_cast<cv::Mat *>(image), *label, *confidence);
}

void FaceRecognizer_Save(FaceRecognizer *recognizer, const char *filename) {
  cv::Ptr<cv::face::FaceRecognizer> *ptr =
      reinterpret_cast<cv::Ptr<cv::face::FaceRecognizer> *>(recognizer);
  (*ptr)->save(filename);
}

void FaceRecognizer_Load(FaceRecognizer *recognizer, const char *filename) {
  cv::Ptr<cv::face::FaceRecognizer> *ptr =
      reinterpret_cast<cv::Ptr<cv::face::FaceRecognizer> *>(recognizer);
  (*ptr)->read(filename);
}

} // extern "C"
