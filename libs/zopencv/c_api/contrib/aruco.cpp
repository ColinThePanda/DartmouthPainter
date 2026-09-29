#include "aruco.h"
#include <opencv2/objdetect/aruco_detector.hpp>

extern "C" {

// ============================================================================
// ArucoDictionary
// ============================================================================

ArucoDictionary *ArucoDictionary_GetPredefined(int dict_type) {
  cv::aruco::PredefinedDictionaryType type =
      static_cast<cv::aruco::PredefinedDictionaryType>(dict_type);
  cv::aruco::Dictionary dict = cv::aruco::getPredefinedDictionary(type);
  return reinterpret_cast<ArucoDictionary *>(new cv::aruco::Dictionary(dict));
}

void ArucoDictionary_Delete(ArucoDictionary *dictionary) {
  delete reinterpret_cast<cv::aruco::Dictionary *>(dictionary);
}

void ArucoDictionary_GenerateImageMarker(ArucoDictionary *dict, int id,
                                         int sidePixels, Mat *img,
                                         int borderBits) {
  cv::aruco::Dictionary *d = reinterpret_cast<cv::aruco::Dictionary *>(dict);
  cv::aruco::generateImageMarker(*d, id, sidePixels,
                                 *reinterpret_cast<cv::Mat *>(img), borderBits);
}

// ============================================================================
// ArucoDetector
// ============================================================================

ArucoDetector *ArucoDetector_Create(ArucoDictionary *dictionary) {
  cv::aruco::Dictionary *dict =
      reinterpret_cast<cv::aruco::Dictionary *>(dictionary);
  cv::aruco::ArucoDetector *detector = new cv::aruco::ArucoDetector(*dict);
  return reinterpret_cast<ArucoDetector *>(detector);
}

void ArucoDetector_Delete(ArucoDetector *detector) {
  delete reinterpret_cast<cv::aruco::ArucoDetector *>(detector);
}

void ArucoDetector_DetectMarkers(ArucoDetector *detector, Mat *image,
                                 Mat *corners, Mat *ids, Mat *rejected) {
  cv::aruco::ArucoDetector *det =
      reinterpret_cast<cv::aruco::ArucoDetector *>(detector);

  std::vector<std::vector<cv::Point2f>> corner_vec;
  std::vector<int> id_vec;
  std::vector<std::vector<cv::Point2f>> rejected_vec;

  det->detectMarkers(*reinterpret_cast<cv::Mat *>(image), corner_vec, id_vec,
                     rejected_vec);

  // Convert corners to Mat (simplified - store as continuous data)
  if (!corner_vec.empty()) {
    int total_points = 0;
    for (const auto &marker : corner_vec) {
      total_points += marker.size();
    }
    cv::Mat corner_mat(total_points, 1, CV_32FC2);
    int idx = 0;
    for (const auto &marker : corner_vec) {
      for (const auto &pt : marker) {
        corner_mat.at<cv::Point2f>(idx++) = pt;
      }
    }
    corner_mat.copyTo(*reinterpret_cast<cv::Mat *>(corners));
  }

  // Convert IDs to Mat
  if (!id_vec.empty()) {
    cv::Mat id_mat(id_vec.size(), 1, CV_32S, id_vec.data());
    id_mat.copyTo(*reinterpret_cast<cv::Mat *>(ids));
  }

  // Convert rejected to Mat
  if (!rejected_vec.empty()) {
    int total_points = 0;
    for (const auto &marker : rejected_vec) {
      total_points += marker.size();
    }
    cv::Mat rejected_mat(total_points, 1, CV_32FC2);
    int idx = 0;
    for (const auto &marker : rejected_vec) {
      for (const auto &pt : marker) {
        rejected_mat.at<cv::Point2f>(idx++) = pt;
      }
    }
    rejected_mat.copyTo(*reinterpret_cast<cv::Mat *>(rejected));
  }
}

} // extern "C"
